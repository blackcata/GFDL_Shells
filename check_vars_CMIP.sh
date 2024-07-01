#!/bin/bash

#------------------------------------------------------------------------------------#
#					 				             #      
#	      SCRIPT FOR CHECKING VARIABLES IN CMIMP ARCHIVES		     #
#								   BY   : KM.Noh     #
#				 				   DATE : 2024.05.01 #      
#								                     #      
#------------------------------------------------------------------------------------#


export file_type="ocean_cobalt_fluxes_int.nc"
export ins_total=("AS-RCEC" "AWI" "AWI" "BCC" "BCC" "CAMS" "CAS" "CAS" "CAS" "CCCma" "CCCma" "CCCma" "CCCR-IITM" "CMCC" "CMCC" "CMCC" "CNRM-CERFACS" "CNRM-CERFACS" "CNRM-CERFACS" "CSIRO" "CSIRO-ARCCSS" "E3SM-Project" "E3SM-Project" "E3SM-Project" "E3SM-Project" "E3SM-Project" "EC-Earth-Consortium" "EC-Earth-Consortium" "EC-Earth-Consortium" "EC-Earth-Consortium" "EC-Earth-Consortium" "EC-Earth-Consortium" "FIO-QLNM" "HAMMOZ-Consortium" "INM" "INM" "IPSL" "IPSL" "IPSL" "IPSL" "KIOST" "MIROC" "MIROC" "MIROC" "MOHC" "MOHC" "MOHC" "MOHC" "MPI-M" "MPI-M" "MPI-M" "MRI" "NASA-GISS" "NASA-GISS" "NASA-GISS" "NASA-GISS" "NASA-GISS" "NASA-GISS" "NCAR" "NCAR" "NCAR" "NCAR" "NCC" "NCC" "NCC" "NCC" "NIMS-KMA" "NOAA-GFDL" "NOAA-GFDL" "NOAA-GFDL" "NUIST" "SNU" "THU" "UA")
export mod_total=("TaiESM1" "AWI-CM-1-1-MR" "AWI-ESM-1-1-LR" "BCC-CSM2-MR" "BCC-ESM1" "CAMS-CSM1-0" "CAS-ESM2-0" "FGOALS-f3-L" "FGOALS-g3" "CanESM5" "CanESM5-1" "CanESM5-CanOE" "IITM-ESM" "CMCC-CM2-HR4" "CMCC-CM2-SR5" "CMCC-ESM2" "CNRM-CM6-1" "CNRM-CM6-1-HR" "CNRM-ESM2-1" "ACCESS-ESM1-5" "ACCESS-CM2" "E3SM-1-0" "E3SM-1-01" "E3SM-1-0-ECA" "E3SM-2-0" "E3SM-2-0-NARRM" "EC-Earth3" "EC-Earth3-AerChem" "EC-Earth3-CC" "EC-Earth3-LR" "EC-Earth3-Veg" "EC-Earth3-Veg-LR" "FIO-ESM-2-0" "MPI-ESM-1-2-HAM" "INM-CM4-8" "INM-CM5-0" "IPSL-CM5A2-INCA" "IPSL-CM6A-LR" "IPSL-CM6A-LR-INCA" "IPSL-CM6A-MR1" "KIOST-ESM" "MIROC6" "MIROC-ES2H" "MIROC-ES2L" "HadGEM3-GC31-LL" "HadGEM3-GC31-MM" "UKESM1-0-LL" "UKESM1-1-LL" "ICON-ESM-LR" "MPI-ESM1-2-HR" "MPI-ESM1-2-LR" "MRI-ESM2-0" "GISS-E2-1-G" "GISS-E2-1-G-CC" "GISS-E2-1-H" "GISS-E2-2-G" "GISS-E2-2-H" "GISS-E3-G" "CESM2" "CESM2-FV2" "CESM2-WACCM" "CESM2-WACCM-FV2" "NorCPM1" "NorESM1-F" "NorESM2-LM" "NorESM2-MM" "KACE-1-0-G" "GFDL-AM4" "GFDL-CM4" "GFDL-ESM4" "NESM3" "SAM0-UNICON" "CIESM" "MCM-UA-1-0")

variant_total=("r1i1p1f1" "r2i1p1f1" "r1i1p1f2")

export CMIP_TYPE="ScenarioMIP" ## [CMIP, ScenarioMIP]
export scenario="ssp585" ## [1pctCO2, piControl, historical, abrupt-4xCO2], [ssp126, ssp245, ssp370, ssp585]
export tableID="Omon"
export var="fgco2"

export num_var=${#mod_total[@]}
export num_variant=${#variant_total[@]}

echo ""
for ivariant in $(seq 0 $num_variant); do
    echo $var" : "$CMIP_TYPE"-"$scenario"-"${variant_total[$ivariant]}
    mod_num_total=0
    for ivar in $(seq 0 $num_var); do
        export institute=${ins_total[$ivar]}
        export model=${mod_total[$ivar]}
        export variant=${variant_total[$ivariant]}

        export dir_org_path="/archive/uda/CMIP6/"$CMIP_TYPE
        export dir_mod_path=$institute"/"$model"/"$scenario"/"$variant"/"$tableID"/"$var
        export FILE=$dir_org_path"/"$dir_mod_path

        if [ -d $FILE ]; then
            echo $model
            export mod_num_total=$((mod_num_total+1))
        fi
    done
            echo $dir_org_path
    echo "Total Number of Model : "$mod_num_total
    echo ""
done
