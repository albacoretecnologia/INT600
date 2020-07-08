#!/bin/bash

# Test the LEDs on the board.

# To see the correspondent PAD and GPIO configuration of each pin, see the document ConectCore6 IMX6 Hardware Reference Manual - ConectoCore6_IMX6_Hardware_reference_Manual_90001394.pdf

# LED 0 is connected to pin NANDF_D2
# From module data sheet, we can find that it is connected to PAD G21, and is defined as ALT5: GPIO2_IO02
# So, GPIO bank 2, Pin 2
# The same applies to LED 1 and LED 2, connected to pins 3 and 4, respectively 

# During this test, each board LED should blink 10 times, one at a time

led_bank=2
identificator='gpio'

for (( led_io=2; led_io<=4; led_io++ ))
 do  

 led_number=$(( led_io - 2 ))
 	 
 led_ionum=$(( (($led_bank - 1 ) * 32) + $led_io ))

 echo " Bank : $led_bank "
 echo " IO : $led_io "

 echo " IO Number : $led_ionum "

 led_ioid="$identificator$led_ionum"

 echo " LED IO ID : $led_ioid"

 # Functional part of the script - Run when platform is only ConnectCore6

 echo $led_ionum > /sys/class/gpio/export
 sleep 1

 echo out > /sys/class/gpio/$led_ioid/direction
 sleep 1

  for (( c=1; c<=4; c++ ))
   do  
    echo "LED $led_number turned ON"
    echo 1 > /sys/class/gpio/$led_ioid/value 
    # Wait for 1 second
    sleep 1

    echo "LED  $led_number turned OFF"
    echo 0 > /sys/class/gpio/$led_ioid/value 
    # Wait for 1 second
    sleep 1
   done

 done

# End of script