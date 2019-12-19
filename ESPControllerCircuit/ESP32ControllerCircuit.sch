EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "ESP32 diyBMS Controller"
Date "2019-12-19"
Rev "1.1"
Comp "Derek Jennings"
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L device:LED D2
U 1 1 5CD4CF59
P 6975 5375
F 0 "D2" H 6975 5285 50  0000 C CNN
F 1 "COMMS" H 6965 5465 50  0000 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 6975 5375 50  0001 C CNN
F 3 "~" H 6975 5375 50  0001 C CNN
	1    6975 5375
	0    -1   -1   0   
$EndComp
$Comp
L device:R R9
U 1 1 5CD4DABA
P 6975 4850
F 0 "R9" V 6895 4850 50  0000 C CNN
F 1 "470R" V 7055 4850 50  0000 C CNN
F 2 "Resistor_SMD:R_1206_3216Metric_Pad1.42x1.75mm_HandSolder" V 6905 4850 50  0001 C CNN
F 3 "~" H 6975 4850 50  0001 C CNN
	1    6975 4850
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR014
U 1 1 5CD4F11B
P 6975 5525
F 0 "#PWR014" H 6975 5275 50  0001 C CNN
F 1 "GND" H 6980 5352 50  0000 C CNN
F 2 "" H 6975 5525 50  0001 C CNN
F 3 "" H 6975 5525 50  0001 C CNN
	1    6975 5525
	1    0    0    -1  
$EndComp
$Comp
L wemos:Wemos_LoLin32_Lite U3
U 1 1 5DE0A393
P 7850 4500
F 0 "U3" H 8000 5909 60  0000 C CNN
F 1 "Wemos_LoLin32_Lite" H 8000 5803 60  0000 C CNN
F 2 "Module:Lolin32_Lite" H 8000 5697 60  0000 C CNN
F 3 "http://www.wemos.cc/Products/d1_mini.html" H 8300 3975 60  0000 C CNN
	1    7850 4500
	1    0    0    -1  
$EndComp
Text GLabel 7350 4550 0    50   Input ~ 0
SDA
Text GLabel 7350 4450 0    50   Input ~ 0
SCL
Text GLabel 6975 4250 0    50   Input ~ 0
TX1
Wire Wire Line
	8875 4150 8650 4150
Text GLabel 7200 4350 0    50   Input ~ 0
RX1
Wire Wire Line
	6975 4250 7350 4250
Wire Wire Line
	7200 4350 7350 4350
$Comp
L power:+3.3V #PWR020
U 1 1 5DE3070E
P 8650 3550
F 0 "#PWR020" H 8650 3400 50  0001 C CNN
F 1 "+3.3V" H 8665 3723 50  0000 C CNN
F 2 "" H 8650 3550 50  0001 C CNN
F 3 "" H 8650 3550 50  0001 C CNN
	1    8650 3550
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR016
U 1 1 5DE321F1
P 7350 4750
F 0 "#PWR016" H 7350 4500 50  0001 C CNN
F 1 "GND" H 7355 4577 50  0000 C CNN
F 2 "" H 7350 4750 50  0001 C CNN
F 3 "" H 7350 4750 50  0001 C CNN
	1    7350 4750
	1    0    0    -1  
$EndComp
Wire Wire Line
	6975 5000 6975 5225
Wire Wire Line
	6975 4650 6975 4700
Wire Wire Line
	6975 4650 7350 4650
$Comp
L device:R R12
U 1 1 5DEF20FC
P 9025 4150
F 0 "R12" V 8818 4150 50  0000 C CNN
F 1 "220R" V 8909 4150 50  0000 C CNN
F 2 "Resistor_SMD:R_1206_3216Metric_Pad1.42x1.75mm_HandSolder" V 8955 4150 50  0001 C CNN
F 3 "~" H 9025 4150 50  0001 C CNN
	1    9025 4150
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR023
U 1 1 5DEFF249
P 9175 4350
F 0 "#PWR023" H 9175 4100 50  0001 C CNN
F 1 "GND" H 9180 4177 50  0000 C CNN
F 2 "" H 9175 4350 50  0001 C CNN
F 3 "" H 9175 4350 50  0001 C CNN
	1    9175 4350
	1    0    0    -1  
$EndComp
$Comp
L opto:PC817 U4
U 1 1 5DEF614E
P 9475 4250
F 0 "U4" H 9475 4575 50  0000 C CNN
F 1 "HMHA2801" H 9475 4484 50  0000 C CNN
F 2 "Package_SO:SO-4_4.4x2.3mm_P1.27mm" H 9275 4050 50  0001 L CIN
F 3 "https://uk.farnell.com/on-semiconductor/hmha2801/optocoupler-single-channel/dp/1652504" H 9475 4250 50  0001 L CNN
	1    9475 4250
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x02_Male TX1
U 1 1 5DF113F5
P 10150 4250
F 0 "TX1" H 10122 4132 50  0000 R CNN
F 1 "Transmit" H 10122 4223 50  0000 R CNN
F 2 "Connector_JST:JST_PH_S2B-PH-K_1x02_P2.00mm_Horizontal" H 10150 4250 50  0001 C CNN
F 3 "http://www.farnell.com/datasheets/2057211.pdf" H 10150 4250 50  0001 C CNN
	1    10150 4250
	-1   0    0    1   
$EndComp
Wire Wire Line
	9950 4150 9775 4150
Wire Wire Line
	9775 4350 9850 4350
Wire Wire Line
	9850 4350 9850 4250
Wire Wire Line
	9850 4250 9950 4250
$Comp
L Connector:Conn_01x02_Male RX1
U 1 1 5DF1C063
P 10175 4675
F 0 "RX1" H 9985 4555 50  0000 L CNN
F 1 "Receive" H 9865 4675 50  0000 L CNN
F 2 "Connector_JST:JST_PH_S2B-PH-K_1x02_P2.00mm_Horizontal" H 10175 4675 50  0001 C CNN
F 3 "http://www.farnell.com/datasheets/2057211.pdf" H 10175 4675 50  0001 C CNN
	1    10175 4675
	-1   0    0    1   
$EndComp
$Comp
L device:R R14
U 1 1 5DF1D4D0
P 9975 4825
F 0 "R14" V 9768 4825 50  0000 C CNN
F 1 "4K7" V 9859 4825 50  0000 C CNN
F 2 "Resistor_SMD:R_1206_3216Metric_Pad1.42x1.75mm_HandSolder" V 9905 4825 50  0001 C CNN
F 3 "~" H 9975 4825 50  0001 C CNN
	1    9975 4825
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR027
U 1 1 5DF1E244
P 9975 4975
F 0 "#PWR027" H 9975 4725 50  0001 C CNN
F 1 "GND" H 9980 4802 50  0000 C CNN
F 2 "" H 9975 4975 50  0001 C CNN
F 3 "" H 9975 4975 50  0001 C CNN
	1    9975 4975
	1    0    0    -1  
$EndComp
Wire Wire Line
	8650 4250 9050 4250
Wire Wire Line
	9050 4250 9050 4575
Text Notes 8875 4225 2    50   ~ 0
UART2
$Comp
L Connector:Conn_01x04_Male J1
U 1 1 5DE05CFC
P 3475 1525
F 0 "J1" V 3537 1669 50  0000 L CNN
F 1 "I2C" V 3350 1425 50  0000 L CNN
F 2 "Connector_JST:JST_PH_S4B-PH-K_1x04_P2.00mm_Horizontal" H 3475 1525 50  0001 C CNN
F 3 "~" H 3475 1525 50  0001 C CNN
	1    3475 1525
	0    1    1    0   
$EndComp
$Comp
L power:+3.3V #PWR06
U 1 1 5DE072FB
P 3875 1725
F 0 "#PWR06" H 3875 1575 50  0001 C CNN
F 1 "+3.3V" H 3890 1898 50  0000 C CNN
F 2 "" H 3875 1725 50  0001 C CNN
F 3 "" H 3875 1725 50  0001 C CNN
	1    3875 1725
	1    0    0    -1  
$EndComp
Wire Wire Line
	3575 1725 3650 1725
$Comp
L power:GND #PWR04
U 1 1 5DE08F39
P 3275 1725
F 0 "#PWR04" H 3275 1475 50  0001 C CNN
F 1 "GND" H 3280 1552 50  0000 C CNN
F 2 "" H 3275 1725 50  0001 C CNN
F 3 "" H 3275 1725 50  0001 C CNN
	1    3275 1725
	1    0    0    -1  
$EndComp
Text GLabel 2950 2150 0    50   Input ~ 0
SCL
Text GLabel 4025 2325 2    50   Input ~ 0
SDA
$Comp
L device:R R4
U 1 1 5DE0B6CB
P 3875 1875
F 0 "R4" H 3945 1921 50  0000 L CNN
F 1 "1K" H 3945 1830 50  0000 L CNN
F 2 "Resistor_SMD:R_1206_3216Metric_Pad1.42x1.75mm_HandSolder" V 3805 1875 50  0001 C CNN
F 3 "" H 3875 1875 50  0001 C CNN
	1    3875 1875
	1    0    0    -1  
$EndComp
Connection ~ 3875 1725
Wire Wire Line
	4025 2325 3875 2325
Connection ~ 3875 2325
Wire Wire Line
	3875 2325 3475 2325
$Comp
L device:R R3
U 1 1 5DE0D826
P 3025 1875
F 0 "R3" H 3095 1921 50  0000 L CNN
F 1 "1K" H 3095 1830 50  0000 L CNN
F 2 "Resistor_SMD:R_1206_3216Metric_Pad1.42x1.75mm_HandSolder" V 2955 1875 50  0001 C CNN
F 3 "" H 3025 1875 50  0001 C CNN
	1    3025 1875
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR03
U 1 1 5DE0E24A
P 3025 1725
F 0 "#PWR03" H 3025 1575 50  0001 C CNN
F 1 "+3.3V" H 3040 1898 50  0000 C CNN
F 2 "" H 3025 1725 50  0001 C CNN
F 3 "" H 3025 1725 50  0001 C CNN
	1    3025 1725
	1    0    0    -1  
$EndComp
Wire Wire Line
	3375 1725 3375 2150
Wire Wire Line
	2950 2150 3025 2150
Wire Wire Line
	3025 2025 3025 2150
Connection ~ 3025 2150
Wire Wire Line
	3025 2150 3375 2150
$Comp
L Connector:Conn_01x04_Male J2
U 1 1 5DE0FA04
P 5550 1550
F 0 "J2" V 5612 1694 50  0000 L CNN
F 1 "Battery Sense" V 5400 1300 50  0000 L CNN
F 2 "Connector_JST:JST_PH_S4B-PH-K_1x04_P2.00mm_Horizontal" H 5550 1550 50  0001 C CNN
F 3 "~" H 5550 1550 50  0001 C CNN
	1    5550 1550
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR08
U 1 1 5DE11B9E
P 5350 1750
F 0 "#PWR08" H 5350 1500 50  0001 C CNN
F 1 "GND" H 5355 1577 50  0000 C CNN
F 2 "" H 5350 1750 50  0001 C CNN
F 3 "" H 5350 1750 50  0001 C CNN
	1    5350 1750
	1    0    0    -1  
$EndComp
$Comp
L device:Polyfuse F1
U 1 1 5DE12611
P 5650 1900
F 0 "F1" H 5738 1946 50  0000 L CNN
F 1 "85mA" H 5738 1855 50  0000 L CNN
F 2 "Resistor_SMD:R_2816_7142Metric_Pad3.20x4.45mm_HandSolder" H 5700 1700 50  0001 L CNN
F 3 "" H 5650 1900 50  0001 C CNN
	1    5650 1900
	1    0    0    -1  
$EndComp
$Comp
L device:R R7
U 1 1 5DE131BE
P 5650 2200
F 0 "R7" H 5720 2246 50  0000 L CNN
F 1 "100K" H 5720 2155 50  0000 L CNN
F 2 "Resistor_SMD:R_1206_3216Metric_Pad1.42x1.75mm_HandSolder" V 5580 2200 50  0001 C CNN
F 3 "" H 5650 2200 50  0001 C CNN
	1    5650 2200
	1    0    0    -1  
$EndComp
$Comp
L device:R R8
U 1 1 5DE13A02
P 5650 2500
F 0 "R8" H 5720 2546 50  0000 L CNN
F 1 "100K" H 5720 2455 50  0000 L CNN
F 2 "Resistor_SMD:R_1206_3216Metric_Pad1.42x1.75mm_HandSolder" V 5580 2500 50  0001 C CNN
F 3 "" H 5650 2500 50  0001 C CNN
	1    5650 2500
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR09
U 1 1 5DE13FF2
P 5650 2650
F 0 "#PWR09" H 5650 2400 50  0001 C CNN
F 1 "GND" H 5655 2477 50  0000 C CNN
F 2 "" H 5650 2650 50  0001 C CNN
F 3 "" H 5650 2650 50  0001 C CNN
	1    5650 2650
	1    0    0    -1  
$EndComp
Text GLabel 6075 2350 2    50   Input ~ 0
VBUS
Wire Wire Line
	6075 2350 5650 2350
Connection ~ 5650 2350
$Comp
L device:R R5
U 1 1 5DE1545E
P 5025 2200
F 0 "R5" H 5095 2246 50  0000 L CNN
F 1 "10R" H 5095 2155 50  0000 L CNN
F 2 "Resistor_SMD:R_1206_3216Metric_Pad1.42x1.75mm_HandSolder" V 4955 2200 50  0001 C CNN
F 3 "" H 5025 2200 50  0001 C CNN
	1    5025 2200
	1    0    0    -1  
$EndComp
$Comp
L device:R R6
U 1 1 5DE16370
P 5325 2200
F 0 "R6" H 5395 2246 50  0000 L CNN
F 1 "10R" H 5395 2155 50  0000 L CNN
F 2 "Resistor_SMD:R_1206_3216Metric_Pad1.42x1.75mm_HandSolder" V 5255 2200 50  0001 C CNN
F 3 "" H 5325 2200 50  0001 C CNN
	1    5325 2200
	1    0    0    -1  
$EndComp
Wire Wire Line
	5025 2050 5025 1975
Wire Wire Line
	5025 1975 5450 1975
Wire Wire Line
	5450 1975 5450 1750
Wire Wire Line
	5550 1750 5550 2025
Wire Wire Line
	5550 2025 5325 2025
Wire Wire Line
	5325 2025 5325 2050
$Comp
L device:C C7
U 1 1 5DE17D78
P 5025 2525
F 0 "C7" H 5140 2571 50  0000 L CNN
F 1 "100nF" H 5140 2480 50  0000 L CNN
F 2 "Capacitor_SMD:C_1206_3216Metric_Pad1.42x1.75mm_HandSolder" H 5063 2375 50  0001 C CNN
F 3 "" H 5025 2525 50  0001 C CNN
	1    5025 2525
	1    0    0    -1  
$EndComp
Text GLabel 4900 2375 0    50   Input ~ 0
SHUNT-
Text GLabel 4900 2700 0    50   Input ~ 0
SHUNT+
Wire Wire Line
	5025 2375 4900 2375
Wire Wire Line
	4900 2700 5025 2700
Wire Wire Line
	5025 2375 5025 2350
Connection ~ 5025 2375
Wire Wire Line
	5025 2675 5025 2700
Connection ~ 5025 2700
Wire Wire Line
	5025 2700 5325 2700
Wire Wire Line
	5325 2350 5325 2700
$Comp
L device:C C5
U 1 1 5DE1FE0C
P 3650 1875
F 0 "C5" H 3675 1975 50  0000 L CNN
F 1 "100nF" H 3550 1750 50  0000 L CNN
F 2 "Capacitor_SMD:C_1206_3216Metric_Pad1.42x1.75mm_HandSolder" H 3688 1725 50  0001 C CNN
F 3 "" H 3650 1875 50  0001 C CNN
	1    3650 1875
	1    0    0    -1  
$EndComp
Connection ~ 3650 1725
Wire Wire Line
	3650 1725 3875 1725
$Comp
L power:GND #PWR05
U 1 1 5DE22D5F
P 3650 2025
F 0 "#PWR05" H 3650 1775 50  0001 C CNN
F 1 "GND" H 3655 1852 50  0000 C CNN
F 2 "" H 3650 2025 50  0001 C CNN
F 3 "" H 3650 2025 50  0001 C CNN
	1    3650 2025
	1    0    0    -1  
$EndComp
Wire Wire Line
	3475 1725 3475 2325
Wire Wire Line
	3875 2025 3875 2325
$Comp
L power:GND #PWR018
U 1 1 5DE25DC2
P 8200 6125
F 0 "#PWR018" H 8200 5875 50  0001 C CNN
F 1 "GND" H 8205 5952 50  0000 C CNN
F 2 "" H 8200 6125 50  0001 C CNN
F 3 "" H 8200 6125 50  0001 C CNN
	1    8200 6125
	1    0    0    -1  
$EndComp
$Comp
L device:C C8
U 1 1 5DE264A1
P 8200 5975
F 0 "C8" H 8315 6021 50  0000 L CNN
F 1 "100nF" H 8315 5930 50  0000 L CNN
F 2 "Capacitor_SMD:C_1206_3216Metric_Pad1.42x1.75mm_HandSolder" H 8238 5825 50  0001 C CNN
F 3 "" H 8200 5975 50  0001 C CNN
	1    8200 5975
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR017
U 1 1 5DE26E44
P 8200 5825
F 0 "#PWR017" H 8200 5675 50  0001 C CNN
F 1 "+3.3V" H 8215 5998 50  0000 C CNN
F 2 "" H 8200 5825 50  0001 C CNN
F 3 "" H 8200 5825 50  0001 C CNN
	1    8200 5825
	1    0    0    -1  
$EndComp
$Comp
L power:+BATT #PWR012
U 1 1 5DE2ABE7
P 6300 2000
F 0 "#PWR012" H 6300 1850 50  0001 C CNN
F 1 "+BATT" H 6315 2173 50  0000 C CNN
F 2 "" H 6300 2000 50  0001 C CNN
F 3 "" H 6300 2000 50  0001 C CNN
	1    6300 2000
	1    0    0    -1  
$EndComp
Wire Wire Line
	5650 2050 6300 2050
Wire Wire Line
	6300 2050 6300 2000
Connection ~ 5650 2050
$Comp
L Connector:Conn_01x03_Male J5
U 1 1 5DE2BFAF
P 9900 1425
F 0 "J5" H 9872 1449 50  0000 R CNN
F 1 "BST900 Serial" H 9872 1358 50  0000 R CNN
F 2 "Connector_JST:JST_PH_S3B-PH-K_1x03_P2.00mm_Horizontal" H 9900 1425 50  0001 C CNN
F 3 "~" H 9900 1425 50  0001 C CNN
	1    9900 1425
	-1   0    0    -1  
$EndComp
$Comp
L power:GND #PWR026
U 1 1 5DE2D5EF
P 9700 1525
F 0 "#PWR026" H 9700 1275 50  0001 C CNN
F 1 "GND" H 9705 1352 50  0000 C CNN
F 2 "" H 9700 1525 50  0001 C CNN
F 3 "" H 9700 1525 50  0001 C CNN
	1    9700 1525
	1    0    0    -1  
$EndComp
Text GLabel 9325 1325 0    50   Input ~ 0
TX1
Text GLabel 9525 1425 0    50   Input ~ 0
RX1
Wire Wire Line
	9325 1325 9700 1325
Wire Wire Line
	9525 1425 9700 1425
$Comp
L Connector:Conn_01x04_Male J3
U 1 1 5DE32B01
P 7925 1550
F 0 "J3" V 7987 1694 50  0000 L CNN
F 1 "Inverter/Charger SS Relays" V 7800 1450 50  0000 L CNN
F 2 "Connector_JST:JST_PH_S4B-PH-K_1x04_P2.00mm_Horizontal" H 7925 1550 50  0001 C CNN
F 3 "~" H 7925 1550 50  0001 C CNN
	1    7925 1550
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR015
U 1 1 5DE35D9B
P 7275 1750
F 0 "#PWR015" H 7275 1500 50  0001 C CNN
F 1 "GND" H 7280 1577 50  0000 C CNN
F 2 "" H 7275 1750 50  0001 C CNN
F 3 "" H 7275 1750 50  0001 C CNN
	1    7275 1750
	1    0    0    -1  
$EndComp
Wire Wire Line
	7725 1750 7275 1750
$Comp
L power:+3.3V #PWR019
U 1 1 5DE37607
P 8500 1750
F 0 "#PWR019" H 8500 1600 50  0001 C CNN
F 1 "+3.3V" H 8515 1923 50  0000 C CNN
F 2 "" H 8500 1750 50  0001 C CNN
F 3 "" H 8500 1750 50  0001 C CNN
	1    8500 1750
	1    0    0    -1  
$EndComp
Wire Wire Line
	8025 1750 8500 1750
Text GLabel 8825 4750 2    50   Input ~ 0
INVERTER
Wire Wire Line
	8825 4750 8650 4750
Text GLabel 8500 2050 2    50   Input ~ 0
INVERTER
$Comp
L device:R R11
U 1 1 5DE3CC9C
P 8350 2050
F 0 "R11" V 8143 2050 50  0000 C CNN
F 1 "0R" V 8234 2050 50  0000 C CNN
F 2 "Resistor_SMD:R_1206_3216Metric_Pad1.42x1.75mm_HandSolder" V 8280 2050 50  0001 C CNN
F 3 "" H 8350 2050 50  0001 C CNN
	1    8350 2050
	0    1    1    0   
$EndComp
Wire Wire Line
	8200 2050 7925 2050
Wire Wire Line
	7925 2050 7925 1750
Text GLabel 8475 2350 2    50   Input ~ 0
CHARGER
$Comp
L device:R R10
U 1 1 5DE3F6C8
P 8325 2350
F 0 "R10" V 8118 2350 50  0000 C CNN
F 1 "0R" V 8209 2350 50  0000 C CNN
F 2 "Resistor_SMD:R_1206_3216Metric_Pad1.42x1.75mm_HandSolder" V 8255 2350 50  0001 C CNN
F 3 "" H 8325 2350 50  0001 C CNN
	1    8325 2350
	0    1    1    0   
$EndComp
Wire Wire Line
	7825 2350 7825 1750
Wire Wire Line
	7825 2350 8175 2350
Text GLabel 9400 4750 2    50   Input ~ 0
CHARGER
Wire Wire Line
	9400 4750 9375 4750
Wire Wire Line
	9375 4750 9375 4625
Wire Wire Line
	9375 4625 9000 4625
Wire Wire Line
	9000 4625 9000 4350
Wire Wire Line
	9000 4350 8650 4350
Text GLabel 9325 3800 2    50   Input ~ 0
InverterPWM
Wire Wire Line
	8650 3950 8950 3950
Wire Wire Line
	8950 3950 8950 3800
Wire Wire Line
	8950 3800 9150 3800
$Comp
L Connector:Conn_01x03_Male J4
U 1 1 5DE4B385
P 9875 2425
F 0 "J4" H 9847 2449 50  0000 R CNN
F 1 "Inverter PWM Control" H 9847 2358 50  0000 R CNN
F 2 "Connector_JST:JST_PH_S3B-PH-K_1x03_P2.00mm_Horizontal" H 9875 2425 50  0001 C CNN
F 3 "~" H 9875 2425 50  0001 C CNN
	1    9875 2425
	-1   0    0    -1  
$EndComp
$Comp
L power:GND #PWR025
U 1 1 5DE4EFE1
P 9675 2525
F 0 "#PWR025" H 9675 2275 50  0001 C CNN
F 1 "GND" H 9680 2352 50  0000 C CNN
F 2 "" H 9675 2525 50  0001 C CNN
F 3 "" H 9675 2525 50  0001 C CNN
	1    9675 2525
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR024
U 1 1 5DE4F766
P 9675 2325
F 0 "#PWR024" H 9675 2175 50  0001 C CNN
F 1 "+3.3V" H 9690 2498 50  0000 C CNN
F 2 "" H 9675 2325 50  0001 C CNN
F 3 "" H 9675 2325 50  0001 C CNN
	1    9675 2325
	1    0    0    -1  
$EndComp
$Comp
L device:R R13
U 1 1 5DE502AF
P 9300 2425
F 0 "R13" V 9093 2425 50  0000 C CNN
F 1 "390R" V 9184 2425 50  0000 C CNN
F 2 "Resistor_SMD:R_1206_3216Metric_Pad1.42x1.75mm_HandSolder" V 9230 2425 50  0001 C CNN
F 3 "" H 9300 2425 50  0001 C CNN
	1    9300 2425
	0    1    1    0   
$EndComp
Wire Wire Line
	9450 2425 9675 2425
Wire Wire Line
	9150 2425 9150 3800
Connection ~ 9150 3800
Wire Wire Line
	9150 3800 9325 3800
NoConn ~ 7350 3550
NoConn ~ 7350 3650
NoConn ~ 7350 3750
NoConn ~ 8650 3650
NoConn ~ 8650 4050
NoConn ~ 8650 4450
NoConn ~ 8650 4550
NoConn ~ 8650 4650
$Comp
L power:GND #PWR022
U 1 1 5DE7112A
P 8850 6100
F 0 "#PWR022" H 8850 5850 50  0001 C CNN
F 1 "GND" H 8855 5927 50  0000 C CNN
F 2 "" H 8850 6100 50  0001 C CNN
F 3 "" H 8850 6100 50  0001 C CNN
	1    8850 6100
	1    0    0    -1  
$EndComp
$Comp
L device:C C9
U 1 1 5DE71134
P 8850 5950
F 0 "C9" H 8965 5996 50  0000 L CNN
F 1 "100nF" H 8965 5905 50  0000 L CNN
F 2 "Capacitor_SMD:C_1206_3216Metric_Pad1.42x1.75mm_HandSolder" H 8888 5800 50  0001 C CNN
F 3 "" H 8850 5950 50  0001 C CNN
	1    8850 5950
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR021
U 1 1 5DE7113E
P 8850 5800
F 0 "#PWR021" H 8850 5650 50  0001 C CNN
F 1 "+3.3V" H 8865 5973 50  0000 C CNN
F 2 "" H 8850 5800 50  0001 C CNN
F 3 "" H 8850 5800 50  0001 C CNN
	1    8850 5800
	1    0    0    -1  
$EndComp
$Comp
L home_battery:INA226 U2
U 1 1 5DE1282C
P 5575 5200
F 0 "U2" H 5600 4503 60  0000 C CNN
F 1 "INA226" H 5600 4397 60  0000 C CNN
F 2 "Package_SO:TSSOP-10_3x3mm_P0.5mm" H 5575 5200 60  0001 C CNN
F 3 "" H 5575 5200 60  0001 C CNN
	1    5575 5200
	1    0    0    -1  
$EndComp
Text GLabel 4875 5000 0    50   Input ~ 0
SHUNT+
Text GLabel 4875 5150 0    50   Input ~ 0
SHUNT-
Text GLabel 4875 5300 0    50   Input ~ 0
SDA
Text GLabel 4875 5400 0    50   Input ~ 0
SCL
Text GLabel 4875 4850 0    50   Input ~ 0
VBUS
$Comp
L power:GND #PWR011
U 1 1 5DE14C6B
P 5975 5800
F 0 "#PWR011" H 5975 5550 50  0001 C CNN
F 1 "GND" H 5980 5627 50  0000 C CNN
F 2 "" H 5975 5800 50  0001 C CNN
F 3 "" H 5975 5800 50  0001 C CNN
	1    5975 5800
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR010
U 1 1 5DE15D35
P 5950 4475
F 0 "#PWR010" H 5950 4225 50  0001 C CNN
F 1 "GND" H 5955 4302 50  0000 C CNN
F 2 "" H 5950 4475 50  0001 C CNN
F 3 "" H 5950 4475 50  0001 C CNN
	1    5950 4475
	1    0    0    -1  
$EndComp
Wire Wire Line
	5475 4550 5675 4550
Wire Wire Line
	5675 4550 5675 4475
Wire Wire Line
	5675 4475 5950 4475
Connection ~ 5675 4550
NoConn ~ 6325 5050
$Comp
L power:+3.3V #PWR013
U 1 1 5DE1B27D
P 6325 4850
F 0 "#PWR013" H 6325 4700 50  0001 C CNN
F 1 "+3.3V" H 6340 5023 50  0000 C CNN
F 2 "" H 6325 4850 50  0001 C CNN
F 3 "" H 6325 4850 50  0001 C CNN
	1    6325 4850
	1    0    0    -1  
$EndComp
$Comp
L home_battery:MAX5033AASA U1
U 1 1 5DE29CA5
P 2975 6100
F 0 "U1" H 2950 6537 60  0000 C CNN
F 1 "MAX5033AASA" H 2950 6431 60  0000 C CNN
F 2 "Package_SO:SOIC-8_3.9x4.9mm_P1.27mm" H 2925 6250 60  0001 C CNN
F 3 "" H 2925 6250 60  0001 C CNN
	1    2975 6100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR02
U 1 1 5DE2A460
P 2775 6700
F 0 "#PWR02" H 2775 6450 50  0001 C CNN
F 1 "GND" H 2780 6527 50  0000 C CNN
F 2 "" H 2775 6700 50  0001 C CNN
F 3 "" H 2775 6700 50  0001 C CNN
	1    2775 6700
	1    0    0    -1  
$EndComp
$Comp
L device:C C3
U 1 1 5DE2AC6B
P 3475 6450
F 0 "C3" H 3590 6496 50  0000 L CNN
F 1 "100nF" H 3590 6405 50  0000 L CNN
F 2 "Capacitor_SMD:C_1206_3216Metric_Pad1.42x1.75mm_HandSolder" H 3513 6300 50  0001 C CNN
F 3 "" H 3475 6450 50  0001 C CNN
	1    3475 6450
	1    0    0    -1  
$EndComp
Wire Wire Line
	2775 6550 2775 6675
Wire Wire Line
	2775 6675 3025 6675
Wire Wire Line
	3475 6675 3475 6600
Connection ~ 2775 6675
Wire Wire Line
	2775 6675 2775 6700
Wire Wire Line
	3025 6550 3025 6675
Connection ~ 3025 6675
Wire Wire Line
	3025 6675 3475 6675
Wire Wire Line
	3475 6200 4125 6200
$Comp
L device:CP1 C6
U 1 1 5DE33CED
P 4125 6350
F 0 "C6" H 4240 6396 50  0000 L CNN
F 1 "47uF Vishay TR3D476K016CO200" H 4240 6305 50  0000 L CNN
F 2 "Capacitor_Tantalum_SMD:CP_EIA-3528-12_Kemet-T_Pad1.50x2.35mm_HandSolder" H 4125 6350 50  0001 C CNN
F 3 "" H 4125 6350 50  0001 C CNN
	1    4125 6350
	1    0    0    -1  
$EndComp
Wire Wire Line
	4125 6500 4125 6675
Wire Wire Line
	4125 6675 3900 6675
Connection ~ 3475 6675
$Comp
L device:C C4
U 1 1 5DE36D1E
P 3625 6000
F 0 "C4" H 3425 6050 50  0000 L CNN
F 1 "100nF" H 3300 5925 50  0000 L CNN
F 2 "Capacitor_SMD:C_1206_3216Metric_Pad1.42x1.75mm_HandSolder" H 3663 5850 50  0001 C CNN
F 3 "" H 3625 6000 50  0001 C CNN
	1    3625 6000
	0    1    1    0   
$EndComp
Wire Wire Line
	3475 6100 3775 6100
Wire Wire Line
	3775 6100 3775 6000
$Comp
L device:L_Core_Ferrite L1
U 1 1 5DE3ACE8
P 4125 6000
F 0 "L1" V 4350 6000 50  0000 C CNN
F 1 "150uH" V 4259 6000 50  0000 C CNN
F 2 "Inductor_SMD:L_Bourns_SRN6045TA" H 4125 6000 50  0001 C CNN
F 3 "" H 4125 6000 50  0001 C CNN
	1    4125 6000
	0    -1   -1   0   
$EndComp
Connection ~ 3775 6000
Wire Wire Line
	4125 6200 4275 6200
Wire Wire Line
	4275 6200 4275 6000
Connection ~ 4125 6200
$Comp
L device:Jumper_NC_Small JP1
U 1 1 5DE44001
P 4375 6000
F 0 "JP1" H 4450 6200 50  0000 C CNN
F 1 "Battery Power" H 4700 6100 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" H 4375 6000 50  0001 C CNN
F 3 "" H 4375 6000 50  0001 C CNN
	1    4375 6000
	1    0    0    -1  
$EndComp
Connection ~ 4275 6000
$Comp
L power:+3.3V #PWR07
U 1 1 5DE48C26
P 5150 5975
F 0 "#PWR07" H 5150 5825 50  0001 C CNN
F 1 "+3.3V" H 5165 6148 50  0000 C CNN
F 2 "" H 5150 5975 50  0001 C CNN
F 3 "" H 5150 5975 50  0001 C CNN
	1    5150 5975
	1    0    0    -1  
$EndComp
Wire Wire Line
	4475 6000 5150 6000
Wire Wire Line
	5150 6000 5150 5975
$Comp
L device:R R2
U 1 1 5DE4B7C4
P 2100 6425
F 0 "R2" V 2020 6425 50  0000 C CNN
F 1 "390K" V 2180 6425 50  0000 C CNN
F 2 "Resistor_SMD:R_1206_3216Metric_Pad1.42x1.75mm_HandSolder" V 2030 6425 50  0001 C CNN
F 3 "~" H 2100 6425 50  0001 C CNN
	1    2100 6425
	-1   0    0    1   
$EndComp
Wire Wire Line
	2775 6675 2100 6675
Wire Wire Line
	2100 6675 2100 6575
$Comp
L device:R R1
U 1 1 5DE4F209
P 2100 6050
F 0 "R1" V 2020 6050 50  0000 C CNN
F 1 "1M" V 2180 6050 50  0000 C CNN
F 2 "Resistor_SMD:R_1206_3216Metric_Pad1.42x1.75mm_HandSolder" V 2030 6050 50  0001 C CNN
F 3 "~" H 2100 6050 50  0001 C CNN
	1    2100 6050
	-1   0    0    1   
$EndComp
Wire Wire Line
	2100 6275 2100 6250
Wire Wire Line
	2100 6250 2425 6250
Wire Wire Line
	2425 6250 2425 6100
Connection ~ 2100 6250
Wire Wire Line
	2100 6250 2100 6200
Wire Wire Line
	2425 5950 2425 5875
Wire Wire Line
	2425 5875 2100 5875
Wire Wire Line
	2100 5875 2100 5900
$Comp
L power:+BATT #PWR01
U 1 1 5DE5830E
P 2100 5875
F 0 "#PWR01" H 2100 5725 50  0001 C CNN
F 1 "+BATT" H 2115 6048 50  0000 C CNN
F 2 "" H 2100 5875 50  0001 C CNN
F 3 "" H 2100 5875 50  0001 C CNN
	1    2100 5875
	1    0    0    -1  
$EndComp
Connection ~ 2100 5875
$Comp
L device:CP1 C2
U 1 1 5DE598A6
P 1650 6150
F 0 "C2" H 1765 6196 50  0000 L CNN
F 1 "47uF" H 1765 6105 50  0000 L CNN
F 2 "Capacitor_THT:CP_Radial_D7.5mm_P2.50mm" H 1650 6150 50  0001 C CNN
F 3 "" H 1650 6150 50  0001 C CNN
	1    1650 6150
	1    0    0    -1  
$EndComp
$Comp
L device:C C1
U 1 1 5DE5A79F
P 1175 6150
F 0 "C1" H 1290 6196 50  0000 L CNN
F 1 "100nF" H 1290 6105 50  0000 L CNN
F 2 "Capacitor_SMD:C_1206_3216Metric_Pad1.42x1.75mm_HandSolder" H 1213 6000 50  0001 C CNN
F 3 "" H 1175 6150 50  0001 C CNN
	1    1175 6150
	1    0    0    -1  
$EndComp
Wire Wire Line
	1175 6000 1175 5875
Wire Wire Line
	1175 5875 1650 5875
Wire Wire Line
	1650 6000 1650 5875
Connection ~ 1650 5875
Wire Wire Line
	1650 5875 2100 5875
Wire Wire Line
	1175 6300 1175 6675
Wire Wire Line
	1175 6675 1650 6675
Connection ~ 2100 6675
Wire Wire Line
	1650 6300 1650 6675
Connection ~ 1650 6675
Wire Wire Line
	1650 6675 2100 6675
$Comp
L device:D_Schottky D1
U 1 1 5DE688D4
P 3900 6525
F 0 "D1" V 3854 6604 50  0000 L CNN
F 1 "CD214A-B360LF" V 4250 6275 50  0000 L CNN
F 2 "Diode_SMD:D_SMB" H 3900 6525 50  0001 C CNN
F 3 "" H 3900 6525 50  0001 C CNN
	1    3900 6525
	0    1    1    0   
$EndComp
Connection ~ 3900 6675
Wire Wire Line
	3900 6675 3475 6675
Wire Wire Line
	3900 6375 3900 6000
Wire Wire Line
	3775 6000 3900 6000
Connection ~ 3900 6000
Wire Wire Line
	3900 6000 3975 6000
$Comp
L power:+3.3V #PWR030
U 1 1 5DE1BBAC
P 9975 4575
F 0 "#PWR030" H 9975 4425 50  0001 C CNN
F 1 "+3.3V" H 9990 4748 50  0000 C CNN
F 2 "" H 9975 4575 50  0001 C CNN
F 3 "" H 9975 4575 50  0001 C CNN
	1    9975 4575
	1    0    0    -1  
$EndComp
Wire Wire Line
	9050 4575 9875 4575
Wire Wire Line
	9875 4575 9875 4675
Wire Wire Line
	9875 4675 9975 4675
Connection ~ 9975 4675
$Comp
L Connector:Conn_02x03_Odd_Even J6
U 1 1 5DE1B1F2
P 2575 3675
F 0 "J6" H 2625 3992 50  0000 C CNN
F 1 "I/O" H 2625 3901 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_2x03_P2.54mm_Vertical" H 2575 3675 50  0001 C CNN
F 3 "~" H 2575 3675 50  0001 C CNN
	1    2575 3675
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR029
U 1 1 5DE1C4E1
P 2875 3775
F 0 "#PWR029" H 2875 3525 50  0001 C CNN
F 1 "GND" H 2880 3602 50  0000 C CNN
F 2 "" H 2875 3775 50  0001 C CNN
F 3 "" H 2875 3775 50  0001 C CNN
	1    2875 3775
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR028
U 1 1 5DE1CF9A
P 2875 3575
F 0 "#PWR028" H 2875 3425 50  0001 C CNN
F 1 "+3.3V" H 2890 3748 50  0000 C CNN
F 2 "" H 2875 3575 50  0001 C CNN
F 3 "" H 2875 3575 50  0001 C CNN
	1    2875 3575
	1    0    0    -1  
$EndComp
Text GLabel 8800 3300 1    50   Input ~ 0
GPIO19
Text GLabel 8900 3425 1    50   Input ~ 0
GPIO23
Wire Wire Line
	8650 3750 8800 3750
Wire Wire Line
	8800 3750 8800 3300
Wire Wire Line
	8650 3850 8900 3850
Wire Wire Line
	8900 3850 8900 3425
Text GLabel 2375 3450 1    50   Input ~ 0
GPIO19
Text GLabel 2200 3500 1    50   Input ~ 0
GPIO23
Wire Wire Line
	2375 3575 2375 3450
Wire Wire Line
	2200 3675 2375 3675
Wire Wire Line
	2200 3500 2200 3675
Text GLabel 7075 3850 0    50   Input ~ 0
GPIO34
Text GLabel 7250 3950 0    50   Input ~ 0
GPIO35
Wire Wire Line
	7250 3950 7350 3950
Wire Wire Line
	7075 3850 7350 3850
Text GLabel 2125 3775 0    50   Input ~ 0
GPIO34
Text GLabel 3000 3675 2    50   Input ~ 0
GPIO35
Wire Wire Line
	2125 3775 2375 3775
Wire Wire Line
	2875 3675 3000 3675
NoConn ~ 7350 4150
NoConn ~ 7350 4050
$EndSCHEMATC
