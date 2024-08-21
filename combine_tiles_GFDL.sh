#!/bin/bash

#------------------------------------------------------------------------------------#
#					 				                                                 #      
#	      SCRIPT FOR COMBINING and REGRIDDING CUBED SPHERE TILES to ONE FILE		 #
#								                                  BY   : KM.Noh      #
#				 				                                  DATE : 2024.07.17  #      
#								                                                     #      
#------------------------------------------------------------------------------------#

#
# Set specific varibles, years, file type
# 	1. Just change the upper setting part only and don't change below codes

#export var=("co2_surf_dvmr" "co2_flux" "co2_mol_flux" "XCO2" "co2_atm_dvmr")
export var=("co2_mol_flux")

export nlon=720                              # Number of longitude
export nlat=360                              # Number of latitude
export yr_strt=2015                         # Start year of regrdding
export yr_end=2100                           # End year of regridding

export date="0101"	                         # Month & Day of simulation results
export exp="esm-ssp585_D1_control"    # The name of simulation
export file_type="atmos_co2_month"

export model="ESM4"    # The name of simulation
export dir="/archive/Kyungmin.Noh/CMIP6/ESM4/C4MIP_IF/"
export input_path=$dir$model"_"$exp"/gfdl.ncrc5-intel22-prod-openmp/history/extracted_files/"
export output_path="/archive/Kyungmin.Noh/DATA/GFDL_ESM4/2.PERSISTENCE_OIF/2.SSP585/1.CTRL/"

export mosaic_path="/home/Kyungmin.Noh/Shell/GFDL_Shells/mosaic/"
export mosaic_file="C96_mosaic.nc"

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
    
    export var_name=${var[$ivar]}
    export regrid_file=$var_name"."$yr_strt"-"$yr_end"yr."$model"_"$exp".nc"

    echo ""
    echo "######################  SYSTEM ALRET  #####################"
    echo "             STARTING CALCULATING "${var[$ivar]}"       "
    echo "###########################################################"
    echo ""
    echo "Regid file name : " $regrid_file
    echo "Start   Year : "  $yr_strt
    echo "End     Year : "  $yr_end
    echo ""

    for iyear in $(seq $yr_strt $yr_end); do
        export year=$iyear
        export input_file_name=$year"0101."$file_type".nc"
        export output_file_name=$var_name"."$year"yr."$model"_"$exp".nc"

        echo "input file    : " $input_file_name
        echo "input path    : " $input_path$input_file_name
        echo "output path   : " $output_path$output_file_name
        echo "mosaic path   : " $mosaic_path$mosaic_file

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
        echo "        COMBINING AND REGRIDDING FILES           "
        echo "#################################################"
        echo ""

        echo fregrid --input_mosaic $mosaic_path$mosaic_file --input_dir $input_path --output_dir $output_path --input_file $input_file_name --output_file $output_file_name --scalar_field $var_name --nlon $nlon --nlat $nlat
        fregrid --input_mosaic $mosaic_path$mosaic_file --output_mosaic $mosaic_path"ocean_mosaic.nc" --input_dir $input_path --output_dir $output_path --input_file $input_file_name --output_file $output_file_name --scalar_field $var_name
        echo ""

    done

  export file_name=$var_name".????yr."$model"_"$exp".nc"
  ncrcat -h -O $output_path$file_name $output_path$regrid_file
  rm -f $output_path$file_name

done
