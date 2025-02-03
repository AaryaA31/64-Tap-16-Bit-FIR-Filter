###################################################################### 
## Timing setup for logic synthesis
## The unit for time is ns as defined in the IBM delay-power library
## The unit for wireload is pF as defined in the IBM delay-power library
## MS 2015
###################################################################### 

# Setting variables 
set rclk_period 1000.00
set wclk_period 100000.00
set clk_uncertainty 0
set clk_transition 0.010
set typical_input_delay 0.05
set typical_output_delay 0.05
set typical_wire_load 0.005


#Create real clock if clock port is found

if {[sizeof_collection [get_ports rclk]] > 0} {
  #set clk_name "clk"
  #set clk_port "clk"
  #If no waveform is specified, 50% duty cycle is assumed
  create_clock -name rclk -period $rclk_period [get_ports rclk]
  set_drive 0 [get_clocks rclk]
  create_clock -name wclk -period $wclk_period [get_ports wclk]
  set_drive 0 [get_clocks wclk]
}


#Set clock uncertainty
set_clock_uncertainty $clk_uncertainty [get_clocks rclk]
#Propagated clock used for gated clocks only
set_clock_transition $clk_transition [get_clocks rclk]

# Set input and output delays
set_driving_cell -lib_cell INVX1TS [all_inputs]
set_input_delay $typical_input_delay [all_inputs] -clock rclk
remove_input_delay -clock rclk [find port rclk]
set_input_delay $typical_input_delay [all_inputs] -clock wclk
remove_input_delay -clock wclk [find port wclk]
set_output_delay $typical_output_delay [all_outputs] -clock rclk



# Set loading of outputs 
set_load 0.005 [all_outputs] 
