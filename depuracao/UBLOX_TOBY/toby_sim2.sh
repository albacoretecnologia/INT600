#!/bin/bash

# U-Blox TOBY enable 

# Enable U-Blox TOBY module.
#
# To do so, it is needed:

# - Turn on and off TOBY power On signal.
#   TOBY_PWR_ON signal is connected to SD3_DAT3 pin of the module.
#   From module data sheet, we can find that it is connected to PAD F24, and is defined as ALT5: GPIO7_IO07
#   So, GPIO bank 7, Pin 7

# - Turn on and off TOBY Reset signal.
#   TOBY_RESET signal is connected to SD3_RST pin of the module.
#   From module data sheet, we can find that it is connected to PAD D22, and is defined as ALT5: GPIO7_IO08
#   So, GPIO bank 7, Pin 8

# - Turn on and off TOBY, enabling the TOBY power supply enable pin
#   TOBY_VCC_EN signal is connected to NANDF_RB0 pin of the module.
#   From module data sheet, we can find that it is connected to PAD M24, and is defined as ALT5: GPIO6_IO10
#   So, GPIO bank 6, Pin 10

#
# The correct expected sequency to start Toby is (As per Toby Data Sheet page 12 - Section 2.3.1 Module power-on):
#
# - Turn off PWR_ON signal (Turn on the TOBY_PWR_ON signal) 
# - Turn off RESET_N signal (Turn on the TOBY_RESET signal) 
# - Turn on the Toby Power Supply (Turn of the TOBY_VCC_EN signal)
# - Turn on PWR_ON signal (Turn off the TOBY_PWR_ON signal)
# - Turn on RESET_N signal (Turn off the TOBY_RESET signal)
#

# -- General Settings

 identificator='gpio'

# -- Toby Power ON signal
 echo " "
 echo " TOBY_PWR_ON signal control - TOBY Power ON signal "

 toby_pwr_on_bank=7
 toby_pwr_on_io=7
 toby_pwr_on_ionum=$(( (($toby_pwr_on_bank - 1 ) * 32) + $toby_pwr_on_io ))
 toby_pwr_on_ioid="$identificator$toby_pwr_on_ionum"

 echo -n " Bank : $toby_pwr_on_bank "
 echo -n " IO : $toby_pwr_on_io "
 echo -n " IO Number : $toby_pwr_on_ionum "
 echo " TOBY_PWR_ON IO ID : $toby_pwr_on_ioid"

# -- Toby Reset signal
 echo " "
 echo " TOBY_RESET signal control - TOBY RESET signal"

 toby_reset_bank=7
 toby_reset_io=8
 toby_reset_ionum=$(( (($toby_reset_bank - 1 ) * 32) + $toby_reset_io ))
 toby_reset_ioid="$identificator$toby_reset_ionum"

 echo -n " Bank : $toby_reset_bank "
 echo -n " IO : $toby_reset_io "
 echo -n " IO Number : $toby_reset_ionum "
 echo " TOBY_RESET IO ID : $toby_reset_ioid"

# -- Toby VCC enable signal
 echo " "
 echo " TOBY_VCC_ENA signal control - Enable TOBY VCC LDO"

 toby_vcc_en_bank=6
 toby_vcc_en_io=10
 toby_vcc_en_ionum=$(( (($toby_vcc_en_bank - 1 ) * 32) + $toby_vcc_en_io ))
 toby_vcc_en_ioid="$identificator$toby_vcc_en_ionum"

 echo -n " Bank : $toby_vcc_en_bank "
 echo -n " IO : $toby_vcc_en_io "
 echo -n " IO Number : $toby_vcc_en_ionum "
 echo " TOBY_VCC_EN IO ID : $toby_vcc_en_ioid"
 
 # -- Toby Select SIM 2
 echo " "
 echo " TOBY_SIM1 - Enable SIM 1"

 toby_sim1_en_bank=3
 toby_sim1_en_io=29
 toby_sim1_en_ionum=$(( (($toby_sim1_en_bank - 1 ) * 32) + $toby_sim1_en_io ))
 toby_sim1_en_ioid="$identificator$toby_sim1_en_ionum"

 echo -n " Bank : $toby_sim1_en_bank "
 echo -n " IO : $toby_sim1_en_io "
 echo -n " Enabling SIM 1 "

 # Functional part of the script - Run when platform is only ConnectCore6
 #
 # Set all the control signals as output
 #
 
 # Set TOBY_PWR_ON as output
 echo " "
 echo "Set TOBY_PWR_ON as output"
 echo $toby_pwr_on_ionum > /sys/class/gpio/export
 sleep 1
 echo out > /sys/class/gpio/$toby_pwr_on_ioid/direction
 sleep 1
 
 # Set TOBY_RESET as output
 echo " "
 echo "Set TOBY_RESET as output"
 echo $toby_reset_ionum > /sys/class/gpio/export
 sleep 1
 echo out > /sys/class/gpio/$toby_reset_ioid/direction
 sleep 1

 # Set TOBY_VCC_EN as output
 echo " "
 echo "Set TOBY_VCC_EN as output"
 echo $toby_vcc_en_ionum > /sys/class/gpio/export
 sleep 1
 echo out > /sys/class/gpio/$toby_vcc_en_ioid/direction
 sleep 1
 
 # Set TOBY_SIM_SEL as output
 echo " "
 echo "Set TOBY_SIM_SEL as output"
 echo $toby_sim1_en_ionum > /sys/class/gpio/export
 sleep 1
 echo out > /sys/class/gpio/$toby_sim1_en_ioid/direction
 sleep 1

 #
 # Start the control signals to enable correctly the power up sequency
 # 
 
 echo " "
 echo " "
 echo " Disable TOBY_VCC_EN and turn TOBY_PWR_ON off and enbale TOBY_RESET"
 echo " "
 echo 1 > /sys/class/gpio/$toby_vcc_en_ioid/value 
 echo 1 > /sys/class/gpio/$toby_pwr_on_ioid/value 
 echo 1 > /sys/class/gpio/$toby_reset_ioid/value 
 sleep 1
 
 echo " "
 echo " Enable TOBY_VCC_EN keeping TOBY_PWR_ON off and TOBY_RESET enbale"
 echo " "

 echo 0 > /sys/class/gpio/$toby_vcc_en_ioid/value 
 sleep 1

 echo " "
 echo " With TOBY_VCC_EN enabled, turn TOBY_PWR_ON on and disable TOBY_RESET"
 echo " "
 echo 0 > /sys/class/gpio/$toby_pwr_on_ioid/value 
 echo 0 > /sys/class/gpio/$toby_reset_ioid/value 
 sleep 1
 
 echo " "
 echo " Enable TOBY_SIM1"
 echo " "
 echo 1 > /sys/class/gpio/$toby_sim1_en_ioid/value 
 sleep 1

 echo " "
 echo " Keep the module enabled after leaving the script."
 echo " If the LDO temperature rise, rest the system."
 echo " Sould be used only in final module and after the module capacitor C35 has been inverted."
 echo " "
 
 sleep 1
 
 echo " "
 echo " Leaving the script with module enabled"
 echo " "

