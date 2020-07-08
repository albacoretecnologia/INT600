#!/bin/bash

# Test GPIO Inputs from the power board.

# To see the correspondent PAD and GPIO configuration of each pin, see the document ConectCore6 IMX6 Hardware Reference Manual - ConectoCore6_IMX6_Hardware_reference_Manual_90001394.pdf

# Note : Only GPIO Pins EXP_GPIO_[5..0] are conected. Pins 6 and 7 are left float on Power board.

# EXP_GPIO_0 is connected to pin NANDF_D5 - PAD L24,  and is defined as ALT5: GPIO2_IO05 - GPIO Bank 2, Pin 5
# EXP_GPIO_1 is connected to pin NANDF_D6 - PAD G22,  and is defined as ALT5: GPIO2_IO06 - GPIO Bank 2, Pin 6
# EXP_GPIO_2 is connected to pin NANDF_D7 - PAD H23,  and is defined as ALT5: GPIO2_IO07 - GPIO Bank 2, Pin 7
# EXP_GPIO_3 is connected to pin EIM_CS1  - PAD AC15, and is defined as ALT5: GPIO2_IO24 - GPIO Bank 2, Pin 24
# EXP_GPIO_4 is connected to pin EIM_EB0  - PAD Y14,  and is defined as ALT5: GPIO2_IO28 - GPIO Bank 2, Pin 28
# EXP_GPIO_5 is connected to pin EIM_EB1  - PAD V16,  and is defined as ALT5: GPIO2_IO29 - GPIO Bank 2, Pin 29 
# EXP_GPIO_6 is connected to pin GPIO18   - PAD N2,   and is defined as ALT5: GPIO7_IO13 - GPIO Bank 7, Pin 13
# EXP_GPIO_7 is connected to pin GPIO19   - PAD M2,   and is defined as ALT5: GPIO4_IO05 - GPIO Bank 4, Pin 5 

declare -a input_bank=()
declare -a input_pin=()
declare -a input_ionum=()
declare -a input_ioid=()

# Initial number of port to test (Valid values from 0 to 7)
input_init_port=0

# Final number of port to test (Valid values from 0 to 7)
input_final_port=5

input_bank=(2 2 2 2 2 2 7 4)
input_pin=(5 6 7 24 28 29 13 5)
identificator='gpio'

for (( input_io=$input_init_port; input_io<=$input_final_port; input_io++ ))
 do  

 input_ionum[$input_io]=$(( ((${input_bank[$input_io]} - 1 ) * 32) + ${input_pin[$input_io]} ))

 input_ioid[$input_io]="$identificator${input_ionum[$input_io]}"

 echo " Input IO [ $input_io ] - Bank : ${input_bank[$input_io]} - IO : ${input_pin[$input_io]} - IO Number : ${input_ionum[$input_io]} - Input IO ID : ${input_ioid[$input_io]} "

 # Functional part of the script - Run when platform is only ConnectCore6

 echo " Set IO number in /sys/class/gpio/export - Takes 3 seconds ..."
 echo ${input_ionum[$input_io]} > /sys/class/gpio/export
 sleep 3

 echo " Set IO direction as input  - Takes 3 seconds ..."
 echo in > /sys/class/gpio/${input_ioid[$input_io]}/direction
 sleep 2

  # Reads 10 times the input IO pin. Presse the equivalent input button in test board to see the value change
  # The time read interval is 1 second per read.
  echo "Input $input_io value read : "
  for (( c=1; c<=10; c++ ))
   do  
    cat /sys/class/gpio/${input_ioid[$input_io]}/value 

    # Wait for 1 second
    sleep 1
    
   done

 done

# End of script