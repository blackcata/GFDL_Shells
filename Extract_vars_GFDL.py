import os
import sys
from nco import Nco

exp_list = [
             "esm-hist_D1",                         "esm-hist_D1_dfe_fert_GLOBAL_1x",
             "esm-hist_D1_dfe_fert_LS_NP",          "esm-hist_D1_dfe_fert_LS_EP",
             "esm-hist_D1_dfe_fert_LS_SO_N",        "esm-hist_D1_dfe_fert_LS_SO_S",
             "esm-ssp585_D1_control",               "esm-ssp585_D1_dfe_fert_GLOBAL_1x",
             "esm-ssp585_D1_dfe_fert_LS_NP",        "esm-ssp585_D1_dfe_fert_LS_EP",
             "esm-ssp585_D1_dfe_fert_LS_SO_N",      "esm-ssp585_D1_dfe_fert_LS_SO_S",
                                                    "esm-ssp585_D1_dfe_fert_GLOBAL_1x_STOP",
             "esm-ssp585_D1_dfe_fert_LS_NP_STOP",   "esm-ssp585_D1_dfe_fert_LS_EP_STOP",
             "esm-ssp585_D1_dfe_fert_LS_SO_N_STOP", "esm-ssp585_D1_dfe_fert_LS_SO_S_STOP",           
           ]

output_path_list = [    
                        "1.HIST/1.CTRL/",            "1.HIST/2.FERT/1.GLOBAL/",
                        "1.HIST/2.FERT/2.NP/",      "1.HIST/2.FERT/3.EP/",
                        "1.HIST/2.FERT/4.SO_N/",    "1.HIST/2.FERT/5.SO_S/",
                        "2.SSP585/1.CTRL/",          "2.SSP585/2.FERT/1.GLOBAL/",
                        "2.SSP585/2.FERT/2.NP/",    "2.SSP585/2.FERT/3.EP/",
                        "2.SSP585/2.FERT/4.SO_N/",  "2.SSP585/2.FERT/5.SO_S/",                    
                                                    "2.SSP585/3.STOP/1.GLOBAL/",
                        "2.SSP585/3.STOP/2.NP/",    "2.SSP585/3.STOP/3.EP/",
                        "2.SSP585/3.STOP/4.SO_N/",  "2.SSP585/3.STOP/5.SO_S/",                                        
                   ]

file_list  = [
                "ocean_month.nc", 
                "ocean_month_z.nc",
                "ocean_cobalt_sfc.nc", 
                "ocean_cobalt_omip_sfc.nc",
                "ocean_cobalt_omip_2d.nc",
                "ocean_cobalt_btm.nc",
                "ocean_cobalt_tracers_int.nc", 
                "ocean_cobalt_fluxes_int.nc",
                "ocean_cobalt_omip_tracers_month_z.nc", 
                "ocean_cobalt_omip_rates_year_z.nc",
                "ocean_cobalt_tracers_year_z.nc"
             ] 


var_list  = [ ## [0] ocean_month.nc 
              ["tos", "sos", "mlotst", "tauuo", "tauvo"]\
             ,## [1] ocean_month_z.nc
              ["thetao", "so", "uo", "vo", "rhopot0", "rhopot2"]\
             ,## [2] ocean_cobalt_sfc.nc
              ["dep_dry_fed",    "dep_wet_fed",    "ffe_iceberg",    "runoff_flux_fed",
               "sfc_def_fe_di",  "sfc_def_fe_lgp", "sfc_def_fe_smp", "sfc_felim_di",
               "sfc_felim_lgp",  "sfc_felim_smp",  "sfc_irrlim_di",  "sfc_irrlim_lgp",
               "sfc_irrlim_smp", "sfc_no3lim_lgp", "sfc_no3lim_smp", "sfc_po4lim_di",
               "sfc_po4lim_lgp", "sfc_po4lim_smp"]\
             ,## [3] ocean_cobalt_omip_sfc.nc
              ["chlos", "dissicos", "dfeos", "phos", 
               "no3os", "po4os", "sios", "talkos",       "o2os", 
               "phydiatos", "phydiazos",   "phypicoos",  "phymiscos"]\
             ,## [4] ocean_cobalt_omip_2d.nc
              ["fgco2",      "epfe100",    "intpp",      "spco2", 
               "intpn2",     "intdic",     "intdoc",     "intpoc", "intbfe", 
               "fsfe",       "frfe",       "epp100",     "epn100", 
               "limpdiat",   "limpdiaz",   "limppico",   "limpmisc", 
               "limndiat",   "limndiaz",   "limnpico",   "limnmisc", 
               "limfediat",  "limfediaz",  "limfepico",  "limfemisc", 
               "limirrdiat", "limirrdiaz", "limirrpico", "limirrmisc", 
               "intppdiat",  "intppdiaz",  "intppmisc",  "intpppico"]\
             ,## [5] ocean_cobalt_btm.nc
              ["ffedet_btm", "ffe_sed", "ffe_geotherm"]\
             ,## [6] ocean_cobalt_tracers_int.nc
              ["wc_vert_int_c",   "wc_vert_int_dic", "wc_vert_int_doc", 
               "wc_vert_int_poc", "wc_vert_int_n",   "wc_vert_int_p", "wc_vert_int_fe"]\
             ,## [7] ocean_cobalt_fluxes_int.nc
              ["wc_vert_int_nfix", "jfe_fert_100", "jfe_ads_100"]\
             ,## [8] ocean_cobalt_omip_tracers_month_z.nc
              ["po4",    "o2",  "o2sat", "no3", 
               "dissic", "dfe", "chl",   "talk", 
               "ph",     "pp",  "expc",  "si"]\
             ,## [9] ocean_cobalt_omip_rates_year_z.nc
              ["pp",    "pnitrate", "pbfe",   "expc",   "remoc", 
               "expfe", "bddtdife", "fescav", "fediss", "fefert"]\
             ,## [10] ocean_cobalt_tracers_year_z.nc
              ["ndet",   "fedet",  "kfe_eq_lig" ,
               "ligand", "fe_sol", "feprime"]
            ]


# Access the arguments
yr_strt     =  int(sys.argv[1])                 # Start year of regrdding
yr_end      =  int(sys.argv[2])                 # End year of regridding
ind_exp     =  int(sys.argv[3])
# ind_file  =  int(sys.argv[4])

for ind_file in range(len(file_list)):
    file_type   =  file_list[ind_file]
    var         =  var_list[ind_file]


    date        =  "0101"             # Month & Day of simulation results
    exp         =  exp_list[ind_exp]

    model       =  "ESM4"    # The name of simulation
    dir_path    =  "/archive/Kyungmin.Noh/CMIP6/ESM4/C4MIP_IF/"
    output_base =  "/archive/Kyungmin.Noh/DATA/GFDL_ESM4/2.PERSISTENCE_OIF/"  
    input_path  =  dir_path    + model + "_" + exp \
                               + "/gfdl.ncrc5-intel22-prod-openmp/history/extracted_files/"
    output_path =  output_base + output_path_list[ind_exp]

    print("Input PATH    : "+input_path)
    print("Output PATH   : "+output_path)

    num_var=len(var)

    for ivar in range(num_var):
        regrid_file =  var[ivar] + "." + str(yr_strt) + "-" + str(yr_end) + "yr."\
                                 + model + "_" + exp + ".nc"
        input_files =  []

        if (os. path. exists(regrid_file)):
            print("")
            print("#################  SYSTEM ALRET  ################")
            print("#    REGRID FILE EXISTS, CHECK ONE MORE TIME    #")
            print("#################################################")
            print("")
        else:
            print("")
            print("#################  SYSTEM ALRET  ################")
            print("            STARTING REGRIDDING "+var[ivar]+"             ")
            print("#################################################")
            print("")
            print("Regid file name : "+regrid_file)
            print("Start   Year : "+str(yr_strt) )
            print("End     Year : "+str(yr_end) )
            print("")

            # Regridding Process	
            for yr in range(yr_strt,yr_end+1):
                print("Present Year  : "+str(yr))

                # Regridding - change input.nml
                input_file_name=str(yr)+date+"."+file_type
                output_file_name=str(yr)+"."+var[ivar]+".nc"
                var_name=var[ivar]

                print("variable name : "+var_name)
                print("input file    : "+input_file_name)
                print("output file   : "+output_file_name)
                print(input_path+"/"+input_file_name)


                # Extract variables from original files
                nco = Nco()
                nco.ncks(input=input_path+input_file_name, 
                         output=output_path+output_file_name, 
                         variable=var_name)
                print("")
                input_files.append(output_path+output_file_name)

            # Combine the regridded files
            nco.ncrcat(input=input_files, output=output_path+regrid_file)
            for ind in range(len(input_files)): os.remove(input_files[ind])
