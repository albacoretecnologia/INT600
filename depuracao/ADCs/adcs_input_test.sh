#!/bin/bash

# Test ADCs Inputs from the power board.

# Note : Only ADC Pins PMIC_ADC1 and PMIC_ADC2 are conected. Pin PMIC_ADC3 is left floating on Power board.

# PMIC_ADC1 is connected to pin PMIC_ADC1 and connected to connector J3 pin 3 - Singal ADC_IN0
# PMIC_ADC2 is connected to pin PMIC_ADC2 and connected to connector J3 pin 4 - Singal ADC_IN1
# PMIC_ADC3 is connected to pin PMIC_ADC3 and left unconnected

# To see how to access ADC output values in user space, see: http://cms.digi.com/resources/documentation/digidocs/embedded/dey/2.4/cc6/yocto-bsp_r_adc_cc6cc6qp

declare -a input_adc_label=()
declare -a input_adc_input=()

# Initial number of port to test (Valid values from 0 to 7)
input_init_port=0

# Final number of port to test (Valid values from 0 to 7)
input_final_port=5

input_adc_label=("in0_label" "in1_label" "in2_label" "in3_label" "in4_label" "temp1_label")
input_adc_input=("in0_input" "in1_input" "in2_input" "in3_input" "in4_input" "temp1_input")
adc_access_directory="/sys/class/hwmon/hwmon0/device/"

for (( adc_input=$input_init_port; adc_input<=$input_final_port; adc_input++ ))
 do  
      
 echo " ADC Iinput [ $adc_input ] - Lable : ${input_adc_label[$adc_input]} - Input : ${input_adc_input[$adc_input]} - Command :  $adc_access_directory${input_adc_label[$adc_input]} $adc_access_directory${input_adc_input[$adc_input]}"


 # Functional part of the script - Run when platform is only ConnectCore6

  # Reads 10 times the input IO pin. Presse the equivalent input button in test board to see the value change
  # The time read interval is 1 second per read.
  echo "Input $adc_input value read : "
  
  cat $adc_access_directory${input_adc_label[$adc_input]}
  
  for (( c=1; c<=10; c++ ))
   do  
    cat $adc_access_directory${input_adc_input[$adc_input]}  

    # Wait for 1 second
    sleep 1    
   done

 done

# End of script