#
# Copyright 2014 Ettus Research
#

# ---------------------------------------
# Gather all external parameters
# ---------------------------------------
set xci_file $env(XCI_FILE)                         ;# Absolute path to XCI file from src dir
set part_name $env(PART_NAME)                       ;# Full Xilinx part name
set gen_example_proj $env(GEN_EXAMPLE)              ;# Generate an example project
set ip_name [file rootname [file tail $xci_file]]   ;# Extract IP name

# ---------------------------------------
# Vivado Commands
# ---------------------------------------
create_project -part $part_name -in_memory -ip
set_property target_simulator XSim [current_project]
add_files -norecurse -force $xci_file
reset_target all [get_files $xci_file]
puts "BUILDER: Generating and Synthesizing IP Target..."
generate_target all [get_files $xci_file]
synth_ip [get_ips $ip_name]
if [string match $gen_example_proj "1"] {
    puts "BUILDER: Generating Example Design..."
    open_example_project -force -dir . [get_ips $ip_name]
}
close_project