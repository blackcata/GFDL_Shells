#!/bin/bash

#------------------------------------------------------------------------------------#
#					 				             #      
#	      SCRIPT FOR CONVERTING MONTHLY DATA TO ANNUAL DATA		     #
#								   BY   : KM.Noh     #
#				 				   DATE : 2024.05.19 #      
#								                     #      
#------------------------------------------------------------------------------------#

#
# Set specific varibles, years, file type
# 	1. Just change the upper setting part only and don't change below codes

# export var=("chlos" "dfeos" "dissicos" "no3os" "intpp" "fgco2" "epc100" "spco2")
# export var=("chl" "dfe" "dissic" "no3" "o2" "ph" "pp") ### ocean_cobalt_omip_tracers_month_z                  
# export var=("limpdiat" "limpdiaz" "limppico" "limpmisc" "limndiat" "limndiaz" "limnpico" "limnmisc" "limfediat" "limfediaz" "limfepico" "limfemisc" "intbfe" "intppdiat" "intppdiaz" "intppmisc" "intpppico")
export var=("talk")
export yr_strt=2015                  # Start year of regrdding
export yr_end=2100                  # End year of regridding

export date="0101"	             # Month & Day of simulation results
export exp="esm-ssp585_D1_dfe_fert_GLOBAL"

export model="ESM4"    # The name of simulation
export input_path="/work/Kyungmin.Noh/DATA/GFDL_ESM4/1.IRON_FERTILIZATION/SSP585/FERT/GLOBAL/"
export output_path=$input_path


echo "#################################################################"
echo "                        BASIC INFORMATIONS                       "
echo "#################################################################"
echo "Input PATH    : " $input_path
echo "Output PATH   : " $output_path
export num_var=${#var[@]}    	     # the number of variables
echo "Output Files  : " $num_var

# Initialize the log file
if [ ! -d $output_path ] ; then 
	mkdir $output_path 
fi

let "num_var -= 1"
for ivar in $(seq 0 $num_var); do

    echo ""
    echo "######################  SYSTEM ALRET  #####################"
    echo "      STARTING CONVERTING "${var[$ivar]}"             "
    echo "###########################################################"
    echo ""
    echo "Regid file name : " $regrid_file
    echo "Start   Year : "  $yr_strt
    echo "End     Year : "  $yr_end
    echo ""

    export var_name=${var[$ivar]}
    export input_file_name=$var_name"."$yr_strt$"-"$yr_end"yr."$model"_"$exp".nc"
    export output_file_name="ann."$input_file_name

    echo "input file    : " $input_file_name
    echo "input path    : " $input_path$input_file_name
    echo "output path   : " $output_path$output_file_name

    if [ -f  $output_file_name ]; then
        echo ""
        echo "#################  SYSTEM ALRET  ################"
        echo "        FILE EXISTS, CHECK ONE MORE TIME         "
        echo "#################################################"
        echo ""
        continue
    fi

    ncra --mro -O -d time,1,,12 $input_path$input_file_name $output_path$output_file_name
    echo ""

done
