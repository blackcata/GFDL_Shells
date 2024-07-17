#!/bin/bash

#------------------------------------------------------------------------------------#
#					 				             #      
#	      SCRIPT FOR EXTRACTING & REGRIDDING & CHOOSING VARIABLES		     #
#								   BY   : KM.Noh     #
#				 				   DATE : 2018.12.20 #      
#								                     #      
#------------------------------------------------------------------------------------#

#
# Set specific varibles, years, file type
# 	1. Just change the upper setting part only and don't change below codes
# 	2. Basically, input.nml.org file has to exist on the same folder 
#   3. File type has to be fit with variables, it is included in one of five categories
#		ex) fed   ->   ocean_topaz_month
#			sst   ->   ocean_month
#			wind  ->   atmos_month
#			CN    ->   ice_month
#			water ->   land_month
#  4. You can change the regrid grid with changing regrid_type
#  5. Before running this script, regrid.x excutable file has to be set on the same folder
#

#export file_type="ocean_month.nc"    # The simulation result including variables
#export var=("tos" "sos" "mlotst")
#
#export file_type="ocean_month_z.nc"    # The simulation result including variables
#export var=("thetao" "so")
#
#export file_type="ocean_cobalt_omip_sfc.nc"    # The simulation result including variables
#export var=("chlos" "dissicos" "dfeos" "phos" "no3os" "po4os" "sios" "talkos")                   # Variable names 
##
export file_type="ocean_cobalt_omip_2d.nc"    # The simulation result including variables
#export var=("epfe100" "intpn2" "fsfe" "frfe" "epc100" "fgco2" "spco2" "intpp" "limpdiat" "limpdiaz" "limppico" "limpmisc" "limndiat" "limndiaz" "limnpico" "limnmisc" "limfediat" "limfediaz" "limfepico" "limfemisc" "intbfe" "intppdiat" "intppdiaz" "intppmisc" "intpppico")                   # Variable names 
export var=("intppdiat" "intppdiaz" "intppmisc" "intpppico")
#
#export file_type="ocean_cobalt_sfc.nc"    # The simulation result including variables
#export var=("sfc_def_fe_di" "sfc_def_fe_lgp" "sfc_def_fe_smp" "sfc_felim_di" "sfc_felim_lgp" "sfc_felim_smp" "sfc_irrlim_di" "sfc_irrlim_lgp" "sfc_irrlim_smp" "sfc_no3lim_lgp" "sfc_no3lim_smp" "sfc_po4lim_di" "sfc_po4lim_lgp" "sfc_po4lim_smp")
##
#export file_type="ocean_cobalt_fluxes_int.nc"
#export var=("wc_vert_int_jno3denit" "wc_vert_int_jnitrif" "wc_vert_int_nfix" "wc_vert_int_juptake_nh4" "wc_vert_int_jptake_no3" "jfe_fert_100" "jfe_ads_100")
##
##
#export file_type="ocean_cobalt_tracers_int.nc"
#export var=("wc_vert_int_fe")

#export file_type="ocean_cobalt_omip_tracers_month_z.nc"    # The simulation result including variables
#export var=("chl" "dfe" "dissic" "no3" "o2" "ph") ### ocean_cobalt_omip_tracers_month_z                  
#export var=("talk")

# export file_type="ocean_cobalt_omip_rates_year_z.nc"    # The simulation result including variables
# export var=("pp" "pnitrate" "expc" "remoc")

#
# export var=("intpn2" "epfe100" "intpp" "epc100" "fgco2" "spco2") ## ocean_cobalt_omip_2d
# export var=("wc_vert_int_jnitrif")  ### ocean_cobalt_fluxes_int
# export var=("chl" "dfe" "dissic" "no3" "o2" "ph" "pp") ### ocean_cobalt_omip_tracers_month_z                  



export yr_strt=1990                 # Start year of regrdding
export yr_end=1992                  # End year of regridding

export date="0101"	             # Month & Day of simulation results
#export exp="esm-ssp585_D1_dfe_fert_GLOBAL_1x"
export exp="historical_D1_c5_control_B01"

export model="ESM4"    # The name of simulation
export dir="/archive/Kyungmin.Noh/CMIP6/ESM4/DECK/"

export input_path=$dir$model"_"$exp"/gfdl.ncrc5-intel22-prod-openmp/history/extracted_files/"
export output_path="/work/Kyungmin.Noh/DATA/GFDL_ESM4/1.IRON_FERTILIZATION/SENSITIVITY_TEST/CTRL/"

echo "Input PATH    : " $input_path
echo "Output PATH   : " $output_path
export num_var=${#var[@]}    	     # the number of variables
echo $num_var

# Initialize the log file
if [ -e log.out ] ; then 
	rm -f log.out 
fi
#touch log.out

let "num_var -= 1"
for ivar in $(seq 0 $num_var); do
	export regrid_file=${var[$ivar]}"."$yr_strt"-"$yr_end"yr."$model"_"$exp".nc"


	if [ -e  $regrid_file ]; then
		echo ""
		echo "#################  SYSTEM ALRET  ################"
		echo "#    REGRID FILE EXISTS, CHECK ONE MORE TIME    #"
		echo "#################################################"
		echo ""
	else
		echo ""
		echo "#################  SYSTEM ALRET  ################"
		echo "            STARTING REGRIDDING "${var[$ivar]}"             "
		echo "#################################################"
		echo ""
		echo "Regid file name : " $regrid_file
		echo "Start   Year : "  $yr_strt
		echo "End     Year : "  $yr_end
		echo ""

		# Regridding Process	
		for yr in $(seq -f "%04g" $yr_strt $yr_end); do 
			echo "Present Year  : "  $yr

			# Regridding - change input.nml
			export input_file_name=$yr$date"."$file_type
			export output_file_name=$yr"."${var[$ivar]}".nc"
			export var_name=${var[$ivar]}

			echo "variable name : " $var_name
			echo "input file    : " $input_file_name
			echo "output file   : " $output_file_name
			echo $input_path/$input_file_name

			# Extract variables from original files
        	ncks -O -v $var_name  $input_path$input_file_name $output_path$output_file_name

			# Regridding - excute regrid
			echo ""

		done 

		# Combine the regridded files
		export file_name="????."${var[$ivar]}".nc"
		ncrcat -h -O $output_path$file_name $output_path$regrid_file
		rm -f $output_path$file_name

	fi
done
