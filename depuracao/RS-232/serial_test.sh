#!/bin/bash

# Test the board external UART.


# To run this script, in PC, use the commmand:
#
# > sudo scp ./serial_test.sh   root@192.168.20.111:/home/root/scripts/
# To run this script, the following settings are considered:
#  - IP Board Address : 192.168.20.111
#  - On the device file system, ther is a /home/root/scripts/ 
#  - The root user will run this script on iMX6 board
#
# To run the script on the board, run, using SSH or the terminal, the command:
# > source ./serial_test.sh
# To run this command, first issue the command:
# cd /home/root/scripts
#

# This script tests the board UARTs

# The board UARTs are connected as defined bellow:
# /dev/ttymxc0 -> 
# /dev/ttymxc1 -> Does not respond.
# /dev/ttymxc2 -> External RS-232 interface, connected to pins 7 to 10 of external main connector J3 in RS-232 standard (-12 to +12 V) - If using an external serial <=> USB converter, use a real RS-232 converter.
# /dev/ttymxc3 -> Connected to the USB converter - Used as default TTY serial interface.

# During this test, a Linux built-in command will be used, the setserial command.
# See : https://www.systutorials.com/docs/linux/man/8-setserial/ 

# The command:
# > echo <Serial device> 
# may be used to send text to the serials


# The command:
# > cat <Serial device>
# may be used to listen to the serials. In this mode, cable external loopback does not work

# For this test, 03 different windows should be used:
# 1) A window running Putty connected to the correct computer TTY interface (Usually /dev/ttyusbX, with X being a number), and configured as a serial interface with 115200,8,N,1
# 2) Two different terminals running SSH (Open two SSH sessions, in differnt windows, called here Terminal 1 and Terminal 2, initialized as > ssh root@<Board address>).
#
# To test the /dev/ttymxc3, run the commands:
#
# In Terminal 1:
#  > cat /dev/ttymxc3
#  Type anything in Putty terminal, and the typed value should be shown in Terminal 1
#
# In Terminal 2:
#  > echo "Test Serial" > /dev/ttymxc3
#  In Putty, the text "Test Serial" should appear.
#

# To test external UART, consider that the MAX3243EIPW must be enabled to work properly, else all pins will be left in tri-state.
# See MAX3243E data sheet "3-V TO 5.5-V MULTICHANNEL RS-232 LINE DRIVER/RECEIVER WITH Â±15-kV IEC ESD PROTECTION" - max3243e.pdf file
#
# =================================================
#              VERY IMPORTANT !!!!!!!
# =================================================
# Check that resistor R43 0R resistor IS NOT SOLDERED on the board in order to the external RS-232 interface to work.
# By default, in the first release of the board, this resistor has been set to be mounted on the board.
# After page 3 of MAX3243E data sheet, if pin FORCEOFF# is set to "L", the device will be in tri-state independent of other signals values.
# Since in the first version of the board this resistor was mounted, the device was never enabled.
#
#
# The UART_PWR_EN is an GPIO singnal from the processor that must be enabled (Set to one) before using the serial interface.
#
# To control this pin, consider the information bellow:
#
# To see the correspondent PAD and GPIO configuration of each pin, see the document ConectCore6 IMX6 Hardware Reference Manual - ConectoCore6_IMX6_Hardware_reference_Manual_90001394.pdf
#
# UART_PWR_EN is connected to pin EIM_RW - PAD W15,  and is defined as ALT5: GPIO2_IO26 - GPIO Bank 2, Pin 6
#

# -- General Settings

 identificator='gpio'

# -- UART VCC enable signal

 uart_pwr_en_bank=2
 uart_pwr_en_io=26
 uart_pwr_en_ionum=$(( (($uart_pwr_en_bank - 1 ) * 32) + $uart_pwr_en_io ))

 echo " UART_PWR_EN signal control - Enable external RS-232 converter MAX3243EIPW "
 echo " Bank : $uart_pwr_en_bank "
 echo " IO : $uart_pwr_en_io "
 echo " IO Number : $uart_pwr_en_ionum "

 uart_pwr_en_ioid="$identificator$uart_pwr_en_ionum"

 echo " UART_PWR_EN IO ID : $uart_pwr_en_ioid"

 # Functional part of the script - Run only when platform is ConnectCore6

 echo $uart_pwr_en_ionum > /sys/class/gpio/export
 sleep 1
 
 echo out > /sys/class/gpio/$uart_pwr_en_ioid/direction
 sleep 1

 echo " UART Power Enable - Set the output pin to high to enable the RS-232 converter MAX3243EIPW"
 echo 1 > /sys/class/gpio/$uart_pwr_en_ioid/value 

echo "Iniciando a configuração da serial UART3 ..." > /dev/ttymxc2
sleep 1
cat /dev/ttymxc2 >> ./echotest.txt &
#
# End of script
#