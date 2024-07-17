#!/bin/bash
#------------------------------------------------------------------------------------#
#					 				             #      
#	                    SCRIPT FOR REGRIDDING VARIABLES		             #
#								   BY   : KM.NOH     #
#				 				   DATE : 2024.01.25 #      
#								                     #      
#------------------------------------------------------------------------------------#

export N_lat=720 	   # The number of latitude direction mesh
export N_lon=360	   # The numer of longitude direction mesh 

export regrid="remapbil"   # Regridding method - bilinear
export var=""           # The name of variable to regrid

#export var=("epc100" "fgco2" "spco2" "intpp" "chlos" "dissicos" "no3os" "dfeos")
#export var=("intpp")
export var=("lim_fe" "lim_n")
echo "Remapping variable : "$var
echo "Remapping lat/lon : "$N_lat"x"$N_lon
echo "Remapping Method : "$regrid
echo " "
export path_static="/home/Kyungmin.Noh/Python/3.NITRIFICATION/DATA/MASKS/"
export file_static="ocean_static.nc"

export path_input="/home/Kyungmin.Noh/Python/1.IRON_FERTILIZATION/DATA/"
export path_output="/home/Kyungmin.Noh/Python/1.IRON_FERTILIZATION/DATA/"
export exp="ESM4_historical_D1_c5_control_B01"
export list=$(ls ${path_input})
export num_var=${#var[@]}

if [ ! -d $path_output ] ; then
    mkdir $path_output
fi

# Start regrid process 
let "num_var -= 1"
for ivar in $(seq 0 $num_var); do
    export var_name=${var[$ivar]}
    #export input=$var_name".1990-2014yr."$exp".nc"
    export input="PFTs_Limitation_CTRL.nc"

	# Set input & output files for regridding
	export file_input=$path_input$input
	export file_tmp=$path_input"tmp_"$input
	export file_output=$path_output"regrid_"$N_lat"x"$N_lon"_"$input

	echo ""
    echo "!-----------------------------------------------------------------------!"
	echo "INPUT : "$file_input
	echo "OUTPUT : "$file_output
	echo ""

	# Add grid attributes to varible file by using NCO commands
    ncatted -O -a coordinates,$var_name,c,c,\"geolat geolon\" $file_input $file_tmp

	# Add grid information from static file to varible file by using NCO commands
    ncks -h -A -v geolat,geolon $path_static$file_static $file_tmp

	# Excute the regridding by using CDO commands
    cdo -L $regrid,r$N_lat"x"$N_lon -selname,$var_name $file_input $file_output
    rm -f $file_tmp

	echo "REMAPPING COMPLETED "
	echo "!-----------------------------------------------------------------------!"
	echo ""
done
