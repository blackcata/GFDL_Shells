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
# export file_type="ocean_cobalt_omip_sfc.nc"    # The simulation result including variables
# export file_type="ocean_cobalt_omip_2d.nc"    # The simulation result including variables
#export file_type="ocean_cobalt_sfc.nc"    # The simulation result including variables
# export file_type="ocean_cobalt_fluxes_int.nc"
export file_type="ocean_cobalt_omip_tracers_month_z.nc"    # The simulation result including variables

#export var=("tos" "sos" "mlotst")
# export var=("chlos" "dissicos" "no3os" "dfeos")                   # Variable names 
#export var=("limpdiat" "limpdiaz" "limppico" "limpmisc" "limndiat" "limndiaz" "limnpico" "limnmisc" "limfediat" "limfediaz" "limfepico" "limfemisc" "intbfe" "epfe100" "fsfe" "frfe" "epc100" "fgco2" "spco2" "intpp" "intppdiat" "intppdiaz" "intppmisc" "intpppico")                   # Variable names 
#export var=("sfc_def_fe_di" "sfc_def_fe_lgp" "sfc_def_fe_smp" "sfc_felim_di" "sfc_felim_lgp" "sfc_felim_smp" "sfc_irrlim_di" "sfc_irrlim_lgp" "sfc_irrlim_smp" "sfc_no3lim_lgp" "sfc_no3lim_smp" "sfc_po4lim_di" "sfc_po4lim_lgp" "sfc_po4lim_smp")
# export var=("jfe_fert_100")
export var=("jfe_fert")
#export var=("chl" "dfe" "dissic")                   # Variable names 


export var=("intpp" "epc100" "fgco2" "spco2")


export yr_strt=1988                  # Start year of regrdding
export yr_end=1988                  # End year of regridding

export date="0101"	             # Month & Day of simulation results

# export exp="JRA55do1.5_COBALT_abio_csf_mle200_dFe_control"  # The name of simulation
export exp="JRA55do1.5_COBALT_abio_csf_mle200_dFe_fert"  # The name of simulation

export model="OM4p125"                                   # The name of model
export dir="/archive/xnl/fre/3P/OceanOnly/JRA55/"

export input_path=$dir$model"_"$exp"/gfdl.ncrc5-intel22-prod/history/extracted_files/"
export output_path="/work/Kyungmin.Noh/DATA/GFDL_ESM4/1.IRON_FERTILIZATION/HIGH_RES_8DEG/IF/"

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
