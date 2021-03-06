/*

 ____  ____  _  _  ____  __  __  ___    _  _  __
(  _ \(_  _)( \/ )(  _ \(  \/  )/ __)  ( \/ )/. |
 )(_) )_)(_  \  /  ) _ < )    ( \__ \   \  /(_  _)
(____/(____) (__) (____/(_/\/\_)(___/    \/   (_)

  (c) 2017/18/19 Stuart Pittaway

  This is the code for the controller - it talks to the V4 cell modules over isolated serial bus

  This code runs on ESP-8266-12E (NODE MCU 1.0) and compiles with Arduino 1.8.5 environment
  Modified by Derek Jennings to run on ESP32 compiled on platformio


   PINS
   GREEN_LED  = ESP32 GPIO 12
   i2c SDA   = ESP32 GPIO 32
   i2c SCL   = ESP32 GPIO 33
   switch to ground (reset WIFI configuration on power up) = ESP32 GPIO 34
   Interrupt in from PCF8574  = ESP32 GPIO 35
   PWM output to inverter = ESP32 GPIO 18
   ESP32_RELAY1 (CHARGER) 4       //GPIO PINS of ESP32 Relay outputs
   ESP32_RELAY2 (INVERTER) 13
   ESP32_RELAY3 19      //On expansion header
   Serial 0 DEBUG
   Serial 1  Charger Controller
   Serial 2   To Cell Modules


   DIAGRAM
   https://www.hackster.io/Aritro/getting-started-with-esp-nodemcu-using-arduinoide-aa7267
*/


#include <Arduino.h>
//#include <ESP8266WiFi.h>
#include <WiFi.h>
//#include <ESP8266mDNS.h>
#include <ESPmDNS.h>
#include <Hash.h>
#include <ESPAsyncWebServer.h>
#include <AsyncMqttClient.h>
#include <PacketSerial.h>
#include <cppQueue.h>
#include <Ticker.h>
#include <pcf8574_esp.h>
#include <Wire.h>
#include <ArduinoOTA.h>
#include "mqtt.h"

//Debug flags for ntpclientlib
#define DBG_PORT Serial
#define DEBUG_NTPCLIENT

#include <TimeLib.h>
#include <NtpClientLib.h>

#include "defines.h"

bool PCF8574Enabled;
volatile bool emergencyStop=false;
bool rule_outcome[RELAY_RULES];

uint16_t ConfigHasChanged=0;
diybms_eeprom_settings mysettings;

AsyncWebServer server(80);

bool server_running=false;
bool wifiFirstConnected = false;
bool NTPsyncEventTriggered = false; // True if a time even has been triggered
NTPSyncEvent_t ntpEvent; // Last triggered event

uint8_t packetType=0;
uint8_t previousRelayState[RELAY_TOTAL];
bool previousRelayPulse[RELAY_TOTAL];

//PCF8574P has an i2c address of 0x38 instead of the normal 0x20
PCF857x pcf8574(0x38, &Wire);

//Map GPIO pins to relays
uint8_t ESP32_relays[RELAY_TOTAL] = {ESP32_RELAY1, ESP32_RELAY2, ESP32_RELAY3};
volatile bool PCFInterruptFlag = false;

void ICACHE_RAM_ATTR PCFInterrupt() {
  if ((pcf8574.read8() & B00010000)==0) {
      //Emergency Stop (J1) has triggered
      emergencyStop=true;
  }
}

//This large array holds all the information about the modules
//up to 4x16
CellModuleInfo cmi[maximum_bank_of_modules][maximum_cell_modules];
uint8_t numberOfModules[maximum_bank_of_modules];



#include "crc16.h"

#include "settings.h"
#include "SoftAP.h"
#include "DIYBMSServer.h"
#include "PacketRequestGenerator.h"
#include "PacketReceiveProcessor.h"

// Instantiate queue to hold packets ready for transmission
Queue	requestQueue(sizeof(packet), 16, FIFO);

PacketRequestGenerator prg=PacketRequestGenerator(&requestQueue);

PacketReceiveProcessor receiveProc=PacketReceiveProcessor();

#define framingmarker (uint8_t)0x00

PacketSerial_<COBS, framingmarker, 128> myPacketSerial;

mqttProc mqt;

volatile bool waitingForReply=false;

//WiFiEventHandler wifiConnectHandler;
//WiFiEventHandler wifiDisconnectHandler;

Ticker myTimerRelay;

Ticker myTimer;
Ticker myTransmitTimer;
Ticker wifiReconnectTimer;
Ticker mqttReconnectTimer;
Ticker myTimerSendMqttPacket;
Ticker myTimerSendInfluxdbPacket;

Ticker myTimerSwitchPulsedRelay;
Ticker mqttTimeout;         //Times out if mqtt communication lost with node-red

uint16_t sequence=0;

AsyncMqttClient mqttClient;

void dumpPacketToDebug(packet *buffer) {
  Serial.print(buffer->address,HEX);
  Serial.print('/');
  Serial.print(buffer->command,HEX);
  Serial.print('/');
  Serial.print(buffer->sequence,HEX);
  Serial.print('=');
  for (size_t i = 0; i < maximum_cell_modules; i++)
  {
    Serial.print(buffer->moduledata[i],HEX);
    Serial.print(" ");
  }
  Serial.print(" =");
  Serial.print(buffer->crc,HEX);
}

uint16_t minutesSinceMidnight() {
  return (hour() * 60) + minute();
}

void processSyncEvent (NTPSyncEvent_t ntpEvent) {
    if (ntpEvent < 0) {
        Serial.printf ("Time Sync error: %d\n", ntpEvent);
        if (ntpEvent == noResponse)
            Serial.println ("NTP server not reachable");
        else if (ntpEvent == invalidAddress)
            Serial.println ("Invalid NTP server address");
        else if (ntpEvent == errorSending)
            Serial.println ("Error sending request");
        else if (ntpEvent == responseError)
            Serial.println ("NTP response error");
    } else {
        if (ntpEvent == timeSyncd) {
            Serial.print ("Got NTP time: ");
            Serial.println (NTP.getTimeDateString (NTP.getLastNTPSync()));
        }
    }
}

void mqtlostcomms() {   //callback when mqtt timeout timer expires
  mqt.lostcomms();
}

void onPacketReceived(const uint8_t* receivebuffer, size_t len)
{
  //Note that this function gets called frequently with zero length packets
  //due to the way the modules operate

  if (len==sizeof(packet)) {
    // Process decoded incoming packet
    Serial.print("R:");
    dumpPacketToDebug((packet*)receivebuffer);

    if (!receiveProc.ProcessReply(receivebuffer,sequence)) {
      Serial.println("** FAILED PROCESS REPLY **");
    }

    //We received a packet (although may have been an error)
    waitingForReply=false;

    Serial.println();
  }
}

void timerTransmitCallback() {
  //Don't send another message until we have received reply from the last one
  //this slows the transmit process down a lot so potentially need to look at a better
  //way to do this and also keep track of missing messages replies for error tracking
  if (waitingForReply) {
    //Serial.print('E');Serial.print(receiveProc.commsError);

    //Increment the counter to watch for complete comms failures
    receiveProc.commsError++;

    //After 5 attempts give up and send another packet
    if (receiveProc.commsError>10) {
      waitingForReply=false;
      receiveProc.totalMissedPacketCount++;
    } else {
        return;
    }
  }

  //Called every second to transmit anything that remains in the transmit queue
  if (!requestQueue.isEmpty()) {
    packet transmitBuffer;

    GREEN_LED_ON;

    //Wake up the connected cell module from sleep
    Serial2.write(framingmarker);
    delay(10);

    requestQueue.pop(&transmitBuffer);
    sequence++;
    transmitBuffer.sequence=sequence;
    transmitBuffer.crc=CRC16::CalculateArray((uint8_t*)&transmitBuffer, sizeof(packet) - 2);
    myPacketSerial.send((byte*)&transmitBuffer, sizeof(transmitBuffer));

    waitingForReply=true;

    Serial.print("S:");
    dumpPacketToDebug(&transmitBuffer);

    Serial.print("/Q:");
    Serial.print(requestQueue.getCount());
    Serial.print(" # ");

    GREEN_LED_OFF;
  }
}

void ProcessRules() {

//Runs the rules and populates rule_outcome array with true/false for each rule

  uint32_t packvoltage[4];

  packvoltage[0]=0;
  packvoltage[1]=0;
  packvoltage[2]=0;
  packvoltage[3]=0;

  for (int8_t r = 0; r < RELAY_RULES; r++)
  {
    rule_outcome[r]=false;
  }

  //If we have a communications error
  if (emergencyStop) {
    rule_outcome[0]=true;
  }

  //If we have a communications error
  if (receiveProc.commsError > 2) {
    rule_outcome[1]=true;
  }

  //Loop through cells
  for (int8_t bank = 0; bank < mysettings.totalNumberOfBanks; bank++)
  {
    for (int8_t i = 0; i < numberOfModules[bank]; i++) {

      packvoltage[bank]+=cmi[bank][i].voltagemV;

      if (cmi[bank][i].voltagemV > mysettings.rulevalue[2]) {
          //Rule 2 - Individual cell over voltage
          rule_outcome[2]=true;
      }

      if (cmi[bank][i].voltagemV < mysettings.rulevalue[3]) {
          //Rule 3 - Individual cell under voltage (mV)
          rule_outcome[3]=true;
      }

      if ((cmi[bank][i].externalTemp!=-40) && (cmi[bank][i].externalTemp > mysettings.rulevalue[4])) {
          //Rule 4 - Individual cell over temperature (external probe)
          rule_outcome[4]=true;
      }
    }
  }

  //Combine the voltages if we need to
  if (mysettings.combinationParallel==false) {
    packvoltage[0]+=packvoltage[1]+packvoltage[2]+packvoltage[3];
    packvoltage[1]=0;
    packvoltage[2]=0;
    packvoltage[3]=0;
  }

  for (int8_t bank = 0; bank < mysettings.totalNumberOfBanks; bank++)
  {
    if (packvoltage[bank] > mysettings.rulevalue[5]) {
      //Rule 5 - Pack over voltage (mV)
      rule_outcome[5]=true;
    }

    if (packvoltage[bank] < mysettings.rulevalue[6]) {
      //Rule 6 - Pack under voltage (mV)
      rule_outcome[6]=true;
    }
  }

  rule_outcome[7]= mqt.mqttRelayControl;          //Status of MQTT control
  if(mqt.active) {
    mqttTimeout.detach();
    mqttTimeout.attach(120, mqtlostcomms);      //Reset the timeout
    mqt.active=false;   //clear the flag. It will be set again when another command arrives
  }

  //Time based rules 8 and 9 (Rule 7 is MQTT)
  if (minutesSinceMidnight() >= mysettings.rulevalue[8]) {
    rule_outcome[8]=true;
  }
  if (minutesSinceMidnight() >= mysettings.rulevalue[9]) {
    rule_outcome[9]=true;
  }

}

void timerSwitchPulsedRelay() {
  //Set defaults based on configuration
  for (int8_t y = 0; y<RELAY_TOTAL; y++)
  {
    if (previousRelayPulse[y]) {
        //We now need to rapidly turn off the relay after a fixed period of time (pulse mode)
        //However we leave the relay and previousRelayState looking like the relay has triggered (it has!)
        //to prevent multiple pulses being sent on each rule refresh
        if(PCF8574Enabled) pcf8574.write(y, previousRelayState[y]==HIGH ? LOW:HIGH);
          else digitalWrite(ESP32_relays[y], previousRelayState[y]==HIGH ? LOW:HIGH);

      previousRelayPulse[y]=false;
    }
  }

  //This only fires once
  myTimerSwitchPulsedRelay.detach();
}


void timerProcessRules() {

  //Run the rules
  ProcessRules();

  // DO NOTE: When you write LOW to a pin on a PCF8574 it becomes an OUTPUT.
  // It wouldn't generate an interrupt if you were to connect a button to it that pulls it HIGH when you press the button.
  // Any pin you wish to use as input must be written HIGH and be pulled LOW to generate an interrupt.

  Serial.print("Rules:");
  for (int8_t r = 0; r < RELAY_RULES; r++)
  {
    Serial.print(rule_outcome[r]);
  }
  Serial.print(" = ");

  uint8_t relay[RELAY_TOTAL];

  //Set defaults based on configuration
  for (int8_t y = 0; y<RELAY_TOTAL; y++)
  {
    if(PCF8574Enabled) relay[y]=  mysettings.rulerelaydefault[y]==RELAY_ON ? LOW:HIGH;    //Inverse logic
    else relay[y]=  mysettings.rulerelaydefault[y]==RELAY_ON ? HIGH:LOW;
  }

  //Test the rules (in reverse order)
  for (int8_t n = RELAY_RULES-1; n>=0; n--)
  {

    if (rule_outcome[n]==true) {

      for (int8_t y = 0; y<RELAY_TOTAL; y++)
      {
        if (n==7) {         //MQTT rule
          relay[y] = mqt.mqttRelay[y];      //Set relays
          continue;
        }
        //Dont change relay if its set to ignore/X
        if (mysettings.rulerelaystate[n][y]!=RELAY_X) {
            //Logic is inverted on the PCF chip
            if (mysettings.rulerelaystate[n][y]==RELAY_ON) {
              relay[y]=(PCF8574Enabled) ? LOW : HIGH;     //Inverse logic if PCF8574 is fitted
            } else {
              relay[y]=(PCF8574Enabled) ? HIGH : LOW;
            }
        }
      }
    }
  }

  for (int8_t n = 0; n<RELAY_TOTAL; n++) {  //1st pass disable relays   (bit of a kludge)
    if (relay[n] == 0 ) digitalWrite(ESP32_relays[n], relay[n]);    //Ensure relays are never on at sane time
  }
  delay(100);
  char M;
  char changestatus[3] = {' ', ' ', ' '};
  char value[64];
  for (int8_t n = 0; n<RELAY_TOTAL; n++)    //2nd pass enable relays
  {
    M = (mqt.mqttRelayControl) ? 'M' : ' ';        //Indicate MQTT has control
    if (previousRelayState[n]!=relay[n]) {
      //Would be better here to use the WRITE8 to lower i2c traffic
      changestatus[n] = 'C';
      //Set the relay
      if (PCF8574Enabled) pcf8574.write(n, relay[n]);
        else {    //If PFC8574 not fitted use ESP32 pins instead
          digitalWrite(ESP32_relays[n], relay[n]);
        }
      previousRelayState[n]=relay[n];

      if (mysettings.relaytype[n]==RELAY_PULSE) {
        //If its a pulsed relay, invert the output quickly via a one time only timer
        previousRelayPulse[n]=true;
        myTimerSwitchPulsedRelay.attach(0.1, timerSwitchPulsedRelay);
      }
    }
  }
  sprintf(value, "Relay 0 %c = %d %c   Relay 1 %c = %d %c  Relay 2 %c = %d %c", \
    M, relay[0], changestatus[0], M, relay[1], changestatus[1],  M, relay[2], changestatus[2] );
  //mqttClient.publish("diybmsdebug", 0, true, value, strlen(value));
  Serial.println(value);
}

uint8_t counter=0;

void timerEnqueueCallback() {
  //this is called regularly on a timer, it determines what request to make to the modules (via the request queue)
  for (uint8_t b = 0; b < mysettings.totalNumberOfBanks; b++)
  {
    prg.sendCellVoltageRequest(b);
    prg.sendCellTemperatureRequest(b);

    //Every 50 loops also ask for bad packet count (saves battery power if we dont ask for this all the time)
    if (counter % 50==0) {
      prg.sendReadBadPacketCounter(b);
    }
  }

  //Its an unsigned byte, let it overflow to reset
  counter++;
}


void connectToWifi() {
  Serial.println("Connecting to Wi-Fi...");
  WiFi.mode(WIFI_STA);
  WiFi.begin(DIYBMSSoftAP::WifiSSID(), DIYBMSSoftAP::WifiPassword());
}


void connectToMqtt() {
  Serial.println("Connecting to MQTT...");
  mqttClient.connect();
}

static AsyncClient * aClient = NULL;

void setupInfluxClient()
{

    if (aClient) //client already exists
        return;

    aClient = new AsyncClient();
    if (!aClient) //could not allocate client
        return;

    aClient->onError([](void* arg, AsyncClient* client, err_t error) {
        Serial.println("Connect Error");
        aClient = NULL;
        delete client;
    }, NULL);

    aClient->onConnect([](void* arg, AsyncClient* client) {
        Serial.println("Connected");

        //Send the packet here

        aClient->onError(NULL, NULL);

        client->onDisconnect([](void* arg, AsyncClient* c) {
            Serial.println("Disconnected");
            aClient = NULL;
            delete c;
        }, NULL);

        client->onData([](void* arg, AsyncClient* c, void* data, size_t len) {
            //Data received
            Serial.print("\r\nData: ");Serial.println(len);
            //uint8_t* d = (uint8_t*)data;
            //for (size_t i = 0; i < len; i++) {Serial.write(d[i]);}
        }, NULL);

        //send the request

        //Construct URL for the influxdb
        //See API at https://docs.influxdata.com/influxdb/v1.7/tools/api/#write-http-endpoint

        String poststring;

        for (uint8_t bank = 0; bank < 4; bank++) {
         //TODO: We should send a request per bank not just a single POST as we are likely to exceed capabilities of ESP
          for (uint8_t i = 0; i < numberOfModules[bank]; i++) {

            //Data in LINE PROTOCOL format https://docs.influxdata.com/influxdb/v1.7/write_protocols/line_protocol_tutorial/
            poststring = poststring
                + "cells,"
                +"cell=" + String(bank+1)+"_"+String(i+1)
                + " v=" + String((float)cmi[bank][i].voltagemV/1000.0,3)
                + ",i=" + String(cmi[bank][i].internalTemp)+"i"
                + ",e=" + String(cmi[bank][i].externalTemp)+"i"
                + ",b=" + (cmi[bank][i].inBypass ? String("true"):String("false"))
                + "\n";
          }
        }

        //TODO: Need to URLEncode these values
        //+ String(mysettings.influxdb_host) + ":" + String(mysettings.influxdb_httpPort)
        String url = "/write?db=" + String(mysettings.influxdb_database)
            +"&u=" + String(mysettings.influxdb_user)
            +"&p=" + String(mysettings.influxdb_password);

        String header="POST "+url+" HTTP/1.1\r\n"
        +"Host: "+String(mysettings.influxdb_host)+"\r\n"
        +"Connection: close\r\n"
        +"Content-Length: "+poststring.length()+"\r\n"
        +"Content-Type: text/plain\r\n"
        +"\r\n";

        Serial.println(header.c_str());
        Serial.println(poststring.c_str());

        client->write(header.c_str());
        client->write(poststring.c_str());

    }, NULL);
}

void SendInfluxdbPacket() {
  if (!mysettings.influxdb_enabled) return;

  Serial.println("SendInfluxdbPacket");

  setupInfluxClient();

  if(!aClient->connect(mysettings.influxdb_host, mysettings.influxdb_httpPort )){
    Serial.println("Influxdb connect fail");
    AsyncClient * client = aClient;
    aClient = NULL;
    delete client;
  }
}


void startTimerToInfluxdb() {
  myTimerSendInfluxdbPacket.attach(30, SendInfluxdbPacket);
}

void onWifiConnect(WiFiEvent_t event, WiFiEventInfo_t info) {     // for esp32

  wifiFirstConnected = true;
  Serial.println("Connected to Wi-Fi.");
  Serial.print(F(". Connected IP:"));
  Serial.println(WiFi.localIP());

  if (!server_running)
  {
    DIYBMSServer::StartServer(&server);
    server_running=true;
  }

  if (mysettings.mqtt_enabled) {
    connectToMqtt();
  }

  if (mysettings.influxdb_enabled) {
    startTimerToInfluxdb();
  }

  MDNS.begin(HOSTNAME);          //Start mDNS
  MDNS.addService("http", "tcp", 80);
}


void onWifiDisconnect(WiFiEvent_t event, WiFiEventInfo_t info) {    // for esp32
  Serial.println("Disconnected from Wi-Fi.");

  // ensure we don't reconnect to MQTT while reconnecting to Wi-Fi
  mqttReconnectTimer.detach();
  myTimerSendMqttPacket.detach();
  myTimerSendInfluxdbPacket.detach();

  wifiReconnectTimer.once(2, connectToWifi);

  //DIYBMSServer::StopServer(&server);
  //server_running=false;
}

void onMqttDisconnect(AsyncMqttClientDisconnectReason reason) {
  Serial.println("Disconnected from MQTT.");

  myTimerSendMqttPacket.detach();

  if (WiFi.isConnected()) {
    mqttReconnectTimer.once(2, connectToMqtt);
  }
}

void sendMqttPacket() {
  if (!mysettings.mqtt_enabled) return;

  Serial.println("Sending MQTT");
  for (uint8_t bank = 0; bank < 4; bank++) {
    for (uint8_t i = 0; i < numberOfModules[bank]; i++) {
      mqt.sendModuleStatus(bank, i);
    }
  }
  mqt.updatebus();    //Send Bus voltage/current
}

void onMqttConnect(bool sessionPresent) {
  Serial.println("Connected to MQTT.");
  mqttClient.subscribe("diybms_command", 0);
  myTimerSendMqttPacket.attach(20, sendMqttPacket);
}

void onMqttMessage(char* topic, char* payload, AsyncMqttClientMessageProperties properties, size_t len, size_t index, size_t total) {
  mqt.processCommand(payload,len);
}

void LoadConfiguration() {

  if (Settings::ReadConfigFromPreferences((char*)&mysettings, sizeof(mysettings), "myprefs")) return;

    Serial.println("Apply default config");

    mysettings.totalNumberOfBanks=1;
    mysettings.combinationParallel=true;

    //EEPROM settings are invalid so default configuration
    mysettings.mqtt_enabled=true;
    mysettings.mqtt_port=1883;

    //Default to EMONPI default MQTT settings
    strcpy(mysettings.mqtt_server,"192.168.1.4");
    strcpy(mysettings.mqtt_username,"emonpi");
    strcpy(mysettings.mqtt_password,"emonpimqtt2016");

    mysettings.influxdb_enabled=false;
    mysettings.influxdb_httpPort=8086;

    strcpy(mysettings.influxdb_host,"myinfluxserver");
    strcpy(mysettings.influxdb_database,"database");
    strcpy(mysettings.influxdb_user,"user");
    strcpy(mysettings.influxdb_password,"");

    mysettings.timeZone= 0;
    mysettings.minutesTimeZone= 0;
    mysettings.daylight=false;
    strcpy(mysettings.ntpServer,"time.google.com");

    for (size_t x = 0; x < RELAY_TOTAL; x++) {
      mysettings.rulerelaydefault[x]=RELAY_OFF;
    }


    int index=0;
    //1. Emergency stop
    mysettings.rulevalue[index++]=0;
    //2. Communications error
    mysettings.rulevalue[index++]=0;
    //3. Individual cell over voltage
    mysettings.rulevalue[index++]=4150;
    //4. Individual cell under voltage
    mysettings.rulevalue[index++]=3000;
    //5. Individual cell over temperature (external probe)
    mysettings.rulevalue[index++]=40;
    //6. Pack over voltage (mV)
    mysettings.rulevalue[index++]=44000;
    //7. Pack under voltage (mV)
    mysettings.rulevalue[index++]=12000;
    //8. MQTT Control - Null value
    mysettings.rulevalue[index++]=0;
    //9. Minutes after 2
    mysettings.rulevalue[index++]=60*9; //9am
    //10. Minutes after 1
    mysettings.rulevalue[index++]=60*17;  //5pm

    //Set all relays to OFF
    for (size_t i = 0; i < RELAY_RULES; i++) {
      for (size_t x = 0; x < RELAY_TOTAL; x++) {
        mysettings.rulerelaystate[i][x]=RELAY_X;
        mysettings.rulerelaystate[i][x]=RELAY_X;
        mysettings.rulerelaystate[i][x]=RELAY_X;
      }
    }
}

void setup() {
  //Serial2 is used for communication to modules, Serial is for debug output
  //Serial1 is for BST900 Control
  pinMode(GREEN_LED, OUTPUT);
  //GPIO 23 is used to reset access point WIFI details on boot up
  pinMode(CLEARAPSETTINGS,INPUT_PULLUP);
  //GPIO 35 is interrupt pin from PCF8574
  pinMode(35,INPUT_PULLUP);
  mqt.begin();    //Initialise mtqq variables
  //Fix for issue 5, delay for 3 seconds on power up with green LED lit so
  //people get chance to jump WIFI reset pin (d3)
  GREEN_LED_ON;
  delay(3000);
  //This is normally pulled high, GPIO23 is used to reset WIFI details
  uint8_t clearAPSettings=digitalRead(CLEARAPSETTINGS);
  GREEN_LED_OFF;

  //We generate a unique number which is used in all following JSON requests
  //we use this as a simple method to avoid cross site scripting attacks
  DIYBMSServer::generateUUID();

  numberOfModules[0]=0;
  numberOfModules[1]=0;
  numberOfModules[2]=0;
  numberOfModules[3]=0;

  //Pre configure the array
  for (size_t i = 0; i < maximum_cell_modules; i++)
  {
    cmi[0][i].voltagemVMax=0;
    cmi[0][i].voltagemVMin=6000;
    cmi[1][i].voltagemVMax=0;
    cmi[1][i].voltagemVMin=6000;
    cmi[2][i].voltagemVMax=0;
    cmi[2][i].voltagemVMin=6000;
    cmi[3][i].voltagemVMax=0;
    cmi[3][i].voltagemVMin=6000;
  }

  Serial2.begin(4800, SERIAL_8N1);           // Serial for comms to modules


  myPacketSerial.setStream(&Serial2);           // start serial for output
  myPacketSerial.setPacketHandler(&onPacketReceived);

  //Debug serial output
  Serial.begin(115200, SERIAL_8N1);
  Serial.setDebugOutput(true);

  //BST900 serial interface
  Serial1.begin(38400, SERIAL_8N1, 26,25);  

  LoadConfiguration();

  //SDA / SCL
  //I'm sure this should be 4,5 !
  //Wire.begin(5,4);
  Wire.begin(SDA,SCL);    // For ESP32
  Wire.setClock(100000L);

  //Make PINs 4-7 INPUTs - the interrupt fires when triggered
  pcf8574.begin();

  //We test to see if the i2c expander is actually fitted
  pcf8574.read8();

  if (pcf8574.lastError()==0) {
    Serial.println("Found pcf8574");
    pcf8574.write(4, HIGH);
    pcf8574.write(5, HIGH);
    pcf8574.write(6, HIGH);
    pcf8574.write(7, HIGH);

    PCF8574Enabled=true;
  } else {
    //Not fitted
    Serial.println("pcf8574 not fitted");
    PCF8574Enabled=false;
  }
  //Set relay defaults
  for (int8_t y = 0; y<RELAY_TOTAL; y++)
  {
      if(PCF8574Enabled) {
        previousRelayState[y]= mysettings.rulerelaydefault[y]==RELAY_ON ? LOW:HIGH;
        pcf8574.write(y,previousRelayState[y]);
      } else {
        previousRelayState[y]= mysettings.rulerelaydefault[y]==RELAY_ON ? HIGH:LOW;
        digitalWrite(ESP32_relays[y],previousRelayState[y]);
      }
  }

  //internal pullup-resistor on the interrupt line via ESP32
  if(PCF8574Enabled) {
    pcf8574.resetInterruptPin();
    attachInterrupt(digitalPinToInterrupt(27), PCFInterrupt, FALLING);    // for esp32
  }

  mqt.initINA();         //Search for INA226 devices
  //Ensure we service the cell modules every 4 seconds
  myTimer.attach(4, timerEnqueueCallback);

  //Process rules every 5 seconds (this prevents the relays from clattering on and off)
  myTimerRelay.attach(5, timerProcessRules);

  //We process the transmit queue every 0.5 seconds (this needs to be lower delay than the queue fills)
  myTransmitTimer.attach(0.5, timerTransmitCallback);

  //Temporarly force WIFI settings
  //wifi_eeprom_settings xxxx;
  //strcpy(xxxx.wifi_ssid,"XXXXXXXXXXXXXXXXX");
  //strcpy(xxxx.wifi_passphrase,"XXXXXXXXXXXXXX");
  //Settings::WriteWiFiConfigToPreferences((char*)&xxxx, sizeof(xxxx));

  if (!DIYBMSSoftAP::LoadConfigFromEEPROM() || clearAPSettings==0) {
      Serial.print("Clear AP settings");
      Serial.println(clearAPSettings);
      Serial.println("Setup Access Point");
      //We are in initial power on mode (factory reset)
      DIYBMSSoftAP::SetupAccessPoint(&server);
  } else {

    //Config NTP
      NTP.onNTPSyncEvent ([](NTPSyncEvent_t event) {
         ntpEvent = event;
         NTPsyncEventTriggered = true;
     });

      Serial.println("Connecting to WIFI");

    /* Explicitly set the ESP32 to be a WiFi-client, otherwise by default,
      would try to act as both a client and an access-point */

      // For ESP32
      WiFi.onEvent(onWifiConnect, SYSTEM_EVENT_STA_GOT_IP);
      WiFi.onEvent(onWifiDisconnect, SYSTEM_EVENT_STA_DISCONNECTED);

      mqttClient.onConnect(onMqttConnect);
      mqttClient.onDisconnect(onMqttDisconnect);
      mqttClient.onMessage(onMqttMessage);

      if (mysettings.mqtt_enabled) {
        Serial.println("MQTT Enabled");
        mqttClient.setServer(mysettings.mqtt_server, mysettings.mqtt_port);
        mqttClient.setCredentials(mysettings.mqtt_username,mysettings.mqtt_password);
        mqttClient.setMaxTopicLength(256);
      }

      connectToWifi();
  }

//ESP32 Over the Air updates
  ArduinoOTA
    .onStart([]() {
      String type;
      if (ArduinoOTA.getCommand() == U_FLASH)
        type = "sketch";
      else // U_SPIFFS
        type = "filesystem";

      // NOTE: if updating SPIFFS this would be the place to unmount SPIFFS using SPIFFS.end()
      Serial.println("Start updating " + type);
    })
    .onEnd([]() {
      Serial.println("\nEnd");
    })
    .onProgress([](unsigned int progress, unsigned int total) {
      Serial.printf("Progress: %u%%\r", (progress / (total / 100)));
    })
    .onError([](ota_error_t error) {
      Serial.printf("Error[%u]: ", error);
      if (error == OTA_AUTH_ERROR) Serial.println("Auth Failed");
      else if (error == OTA_BEGIN_ERROR) Serial.println("Begin Failed");
      else if (error == OTA_CONNECT_ERROR) Serial.println("Connect Failed");
      else if (error == OTA_RECEIVE_ERROR) Serial.println("Receive Failed");
      else if (error == OTA_END_ERROR) Serial.println("End Failed");
    });

  ArduinoOTA.begin();

}

void loop() {
  ArduinoOTA.handle();

  // Call update to receive, decode and process incoming packets.
  if (Serial2.available()) {
    myPacketSerial.update();
  }

  if (Serial1.available()) mqt.bst_process();    //Data has arrived on serial interface from boost converter

  if (ConfigHasChanged>0) {
      //Auto reboot if needed (after changing MQTT or INFLUX settings)
      //Ideally we wouldn't need to reboot if the code could sort itself out!
      ConfigHasChanged--;
      if (ConfigHasChanged==0) {
        Serial.println("RESTART AFTER CONFIG CHANGE");
        //Stop networking
        if (mqttClient.connected()) {
          mqttClient.disconnect(true);
        }
        WiFi.disconnect();
        ESP.restart();
      }
      delay(1);
  }

  //if (emergencyStop) {    Serial.println("EMERGENCY STOP");  }

  if (wifiFirstConnected) {
      Serial.print("Requesting NTP from ");
      Serial.println(mysettings.ntpServer);
      wifiFirstConnected = false;
      //Update time every 10 minutes
      NTP.setInterval (600);
      NTP.setNTPTimeout (NTP_TIMEOUT);
      // String ntpServerName, int8_t timeZone, bool daylight, int8_t minutes, AsyncUDP* udp_conn
      NTP.begin (mysettings.ntpServer, mysettings.timeZone, mysettings.daylight, mysettings.minutesTimeZone);
  }

  if (NTPsyncEventTriggered) {
      processSyncEvent (ntpEvent);
      NTPsyncEventTriggered = false;
  }
}
