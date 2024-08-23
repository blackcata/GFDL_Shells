#------------------------------------------------------------------------------------#
#								                                                 #
#	  SCRIPT FOR CONVERTING MONTHLY DATA TO ANNUAL DATA		                 #
#								   BY   : KM.Noh     #
#								   DATE : 2024.05.19 #      
#								                                                 #      
#------------------------------------------------------------------------------------#

import os
import sys
import subprocess

# Set specific variables, years, file type
variables = ["co2_mol_flux"]  # Add other variables if needed

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

input_path_list = [    
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

# Access the arguments
yr_strt     =  int(sys.argv[1])                 # Start year of regrdding
yr_end      =  int(sys.argv[2])                 # End year of regridding
ind_exp     =  int(sys.argv[3])



date = "0101"	        # Month & Day of simulation results
exp = exp_list[ind_exp]

model       = "ESM4"        # The name of the simulation
input_base  =  "/archive/Kyungmin.Noh/DATA/GFDL_ESM4/2.PERSISTENCE_OIF/"  
input_path  = input_base + input_path_list[ind_exp]
output_path = input_path

print("#################################################################")
print("                        BASIC INFORMATIONS                       ")
print("#################################################################")
print("Input PATH    : ", input_path)
print("Output PATH   : ", output_path)
num_var = len(variables)  # the number of variables
print("Output Files  : ", num_var)

# Initialize the output directory
if not os.path.exists(output_path):
    os.makedirs(output_path)

for var_name in variables:
    print("")
    print("######################  SYSTEM ALERT  #####################")
    print(f"               STARTING CONVERTING {var_name}             ")
    print("###########################################################")
    print("")
    print(f"Start   Year : {yr_strt}")
    print(f"End     Year : {yr_end}")
    print("")

    input_file_name = f"{var_name}.{yr_strt}-{yr_end}yr.{model}_{exp}.nc"
    output_file_name = f"ann.{input_file_name}"

    print("input file    : ", input_file_name)
    print("input path    : ", os.path.join(input_path, input_file_name))
    print("output path   : ", os.path.join(output_path, output_file_name))

    # Check if the output file already exists
    if os.path.isfile(os.path.join(output_path, output_file_name)):
        print("")
        print("#################  SYSTEM ALERT  ################")
        print("        FILE EXISTS, CHECK ONE MORE TIME         ")
        print("#################################################")
        print("")
        continue

    # Run the cdo command
    command = ["cdo", "-yearmean", 
               os.path.join(input_path, input_file_name), 
               os.path.join(output_path, output_file_name)]
    subprocess.run(command)

    print("")
