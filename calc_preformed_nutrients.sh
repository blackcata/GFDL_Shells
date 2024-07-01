#!/bin/bash

#------------------------------------------------------------------------------------#
#					 				             #      
#	      SCRIPT FOR CALCULATING PREFORMED NUTRIENTS		     #
#								   BY   : KM.Noh     #
#				 				   DATE : 2024.06.22 #      
#								                     #      
#------------------------------------------------------------------------------------#

#
# Set specific varibles, years, file type
# 	1. Just change the upper setting part only and don't change below codes

export var1=("po4")
export var2=("AOU")
export out_var=("preformed_po4")

export long_name="Preformed PO4"
export standard_name="mole_concentration_of_preformed_phosphate_in_sea_water"

export yr_strt=1990                  # Start year of regrdding
export yr_end=2014                  # End year of regridding

export date="0101"	             # Month & Day of simulation results
export exp="historical_D1_c5_dfe_fert_GLOBAL"
#export exp="esm-ssp585_D1_dfe_fert_GLOBAL_1x_STOP"

export model="ESM4"    # The name of simulation
export input_path="/work/Kyungmin.Noh/DATA/GFDL_ESM4/1.IRON_FERTILIZATION/LARGE_SCALE/GLOBAL/"
#export input_path="/work/Kyungmin.Noh/DATA/GFDL_ESM4/1.IRON_FERTILIZATION/SSP585/STOP/GLOBAL/STOP_30Y/"
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
    export R_P_O2=0.005882353  # 1/170

    cdo expr,'preformed_po4=po4-'$R_P_O2'*AOU;' -merge $input_path$input_file_name1 $input_path$input_file_name2 $output_path$output_file_name
    #cdo expr,'remineralized_po4=po4-preformed_po4;' -merge $input_path$input_file_name1 $input_path$input_file_name2 $output_path$output_file_name
    echo ""

done
