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

export var1=("o2sat")
export var2=("o2")
export out_var=("AOU")

export long_name="Apparent Oxygen Utilization (AOU)"
export standard_name="mole_concentration_of_apparent_oxygen_utilization_in_sea_water"

export yr_strt=1990                  # Start year of regrdding
export yr_end=2014                  # End year of regridding

export date="0101"	             # Month & Day of simulation results
export exp="historical_D1_c5_dfe_fert_LS_SO_S"
#export exp="esm-ssp585_D1_Control"

export model="ESM4"    # The name of simulation
export input_path="/work/Kyungmin.Noh/DATA/GFDL_ESM4/1.IRON_FERTILIZATION/LARGE_SCALE/SO_S/"
#export input_path="/work/Kyungmin.Noh/DATA/GFDL_ESM4/1.IRON_FERTILIZATION/SSP585/CTRL/"
export output_path=$input_path


echo "#################################################################"
echo "                        BASIC INFORMATIONS                       "
echo "#################################################################"
echo "Input PATH    : " $input_path
echo "Output PATH   : " $output_path
export num_var=${#var1[@]}    	     # the number of variables
echo "Output Files  : " $num_var

# Initialize the log file
if [ ! -d $output_path ] ; then 
	mkdir $output_path 
fi

let "num_var -= 1"
for ivar in $(seq 0 $num_var); do

    echo ""
    echo "######################  SYSTEM ALRET  #####################"
    echo "             STARTING CALCULATING "${out_var[$ivar]}"       "
    echo "###########################################################"
    echo ""
    echo "Regid file name : " $regrid_file
    echo "Start   Year : "  $yr_strt
    echo "End     Year : "  $yr_end
    echo ""

    export var_name1=${var1[$ivar]}
    export var_name2=${var2[$ivar]}
    export out_var_name=${out_var[$ivar]}
    export input_file_name1="ann."$var_name1"."$yr_strt$"-"$yr_end"yr."$model"_"$exp".nc"
    export input_file_name2="ann."$var_name2"."$yr_strt$"-"$yr_end"yr."$model"_"$exp".nc"
    export output_file_name="ann."$out_var_name"."$yr_strt$"-"$yr_end"yr."$model"_"$exp".nc"

    echo "input file    : " $input_file_name1
    echo "input1 path    : " $input_path$input_file_name1
    echo "input2 path    : " $input_path$input_file_name2
    echo "output path   : " $output_path$output_file_name

    if [ -f  $output_file_name ]; then
        echo ""
        echo "#################  SYSTEM ALRET  ################"
        echo "        FILE EXISTS, CHECK ONE MORE TIME         "
        echo "#################################################"
        echo ""
        continue
    fi

    echo ""
    echo "#################################################"
    echo "        SUBTRACTING VAR1 to VAR2         "
    echo "#################################################"
    echo ""
    cdo sub $input_path$input_file_name1 $input_path$input_file_name2 $output_path"tmp1"$output_file_name

    echo "#################################################"
    echo "        MODIFYING OUTPUT VAR PROPERTIES         "
    echo "#################################################"
    echo ""
    cdo -chvar,$var_name1,$out_var_name $output_path"tmp1"$output_file_name $output_path"tmp2"$output_file_name
    cdo setattribute,$out_var_name@long_name="$long_name" $output_path"tmp2"$output_file_name $output_path"tmp3"$output_file_name
    cdo setattribute,$out_var_name@standard_name="$standard_name" $output_path"tmp3"$output_file_name $output_path$output_file_name

    rm $output_path"tmp1"$output_file_name
    rm $output_path"tmp2"$output_file_name
    rm $output_path"tmp3"$output_file_name
    echo ""

done
