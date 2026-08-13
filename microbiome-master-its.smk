#######################################################################################
#######################################################################################
######                                                                           ######
######                   Microbial Ecology Group (AAFC-Harrow)                   ######
######                16S rRNA gene Amplicon Processing Pipeline                 ######
######                                                                           ######
###### ------------------------------------------------------------------------- ######
######                              Snakefile File                               ######
###### ------------------------------------------------------------------------- ######
######                                                                           ######
###### Author:        Brent Seuradge                                             ######
######                                                                           ######
###### Contributors:  Lori Phillips, Noor Ahmad, Annette Lan                     ######
######                                                                           ######
###### Version:       1.0.2 (2025-12-11)                                         ######
######                                                                           ######
###### ------------------------------------------------------------------------- ######
######                                                                           ######
#######################################################################################
#######################################################################################

#https://forum.qiime2.org/t/q2-itsxpress-a-tutorial-on-a-qiime-2-plugin-to-trim-its-sequences/5780

# >>> GLOBAL PARAMETERS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

configfile: "config.yaml"
workdir: config["workdir"]
version = "1.0.2"

import os
import os.path
from os.path import join
import multiprocessing
import psutil
from datetime import datetime

# Grab information for helpful printing
today = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
pcpus = multiprocessing.cpu_count()
pmem = round(((psutil.virtual_memory().total)/1024/1024/1024),1) 

# Pipeline notifications
onstart:
    print()
    print(f"[INFO] Microbiome Master ITS v.{version} [{pcpus} CPUs, {pmem} RAM] STARTED! ({today})")
    print(f"[INFO] Modules to complete: ")
    if(config["module_selection"]["grdi_legacy"]=="TRUE"):
        print(f"[INFO] ----> GRDI legacy")
    if(config["module_selection"]["qiime2_dada2_ITS"]=="TRUE"):
        print(f"[INFO] ----> QIIME2-DADA2 [ASV table generation and general analysis]")
    print()

onsuccess:
    print()
    print(f"[INFO] Microbiome Master ITS v.{version} [{pcpus} CPUs, {pmem} RAM] COMPLETED SUCCESSFULLY! ({today})")
    print(f"[INFO] Modules completed: ")
    if(config["module_selection"]["grdi_legacy"]=="TRUE"):
        print(f"[INFO] ----> GRDI legacy")
    if(config["module_selection"]["qiime2_dada2_ITS"]=="TRUE"):
        print(f"[INFO] ----> QIIME2-DADA2 [ASV table generation and general analysis]")
    print()

onerror:
    print()
    print(f"[ERROR] Microbiome Master ITS v.{version} FAILED! Check above error messages for troubleshooting ({today})")
    print(f"[INFO] Modules to complete: ")
    if(config["module_selection"]["grdi_legacy"]=="TRUE"):
        print(f"[INFO] ----> GRDI legacy")
    if(config["module_selection"]["qiime2_dada2_ITS"]=="TRUE"):
        print(f"[INFO] ----> QIIME2-DADA2 [ASV table generation and general analysis]")
    print()

postfix_length =  len(config["input_file_forward_postfix"])


# Dynamically set input directory
INPUTDIR = config["initial_input_dir"]
if not os.path.isabs(config["initial_input_dir"]):
    INPUTDIR=join(config["workdir"],config["initial_input_dir"])
    if not os.path.isabs(config["workdir"]):
        INPUTDIR=join(os.getcwd(),config["initial_input_dir"])

postfix_length =  len(config["input_file_forward_postfix"])
samples_prefix = {f[:-postfix_length] 
    for f in os.listdir(config["initial_input_dir"]) 
    if f.endswith(config["input_file_forward_postfix"])
    }

extension_length = len(config["input_file_extension"])
file_names = {f[:-extension_length] 
    for f in os.listdir(config["initial_input_dir"]) 
    if f.endswith(config["input_file_extension"])
    }

#Patterns for input files 
PATTERN_INITIAL = '{file_name}' + config["input_file_extension"]
#PATTERN_INIT_R1 = '{file_name}' + config["input_file_forward_postfix"]
#PATTERN_INIT_R2 = '{file_name}' + config["input_file_reverse_postfix"]

#PATTERN_TRIM1 = '{sample}' + config["input_file_forward_postfix"]
#PATTERN_TRIM2 = '{sample}' + config["input_file_reverse_postfix"]

file_ext = config["input_file_extension"]

# >>> MODULE SELECTION >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#include: "workflow/rules/init.smk"

if (config["module_selection"]["grdi_legacy"]=="TRUE"):
    include: "workflow/rules/sm-grdi-legacy.smk"

if (config["module_selection"]["qiime2_dada2_ITS"]=="TRUE"):
    include: "workflow/rules/sm-dada2_v5.smk"

#if(config["module_selection"]["grdi_legacy"]=="TRUE"):
#    print("- GRDI legacy")

#if(config["module_selection"]["qiime2_dada2_ITS"]=="TRUE"):
#    print("- QIIME2-DADA2")

# >>> TARGET DEFINITIONS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Ensure that user specifies a tree building method to avoid pipeline halting
#if(config["tree_method"] != "fasttree" or "raxml"):
#    print("")
#    print("'",config["tree_method"], "' is not a valid phylogenetic choice")
#    print("Please select either 'fasttree' or 'raxml' (case sensitive). Exiting.")
#    exit()

module_outputs = list()

if (config["module_selection"]["grdi_legacy"]=="TRUE"):
    module_outputs.append("data/process/grdi-legacy/step0_initial_data_quality/Read2/stdin_fastqc.html")

if(config["module_selection"]["qiime2_dada2_ITS"]=="TRUE"):
    module_outputs.append("checkpoint/dada2-module/step1-complete_import.done")
    module_outputs.append("checkpoint/dada2-module/step2-complete_itsxpress.done")
    module_outputs.append("checkpoint/dada2-module/step3-complete_run-dada2.done")
    module_outputs.append("checkpoint/dada2-module/step4a-complete_train_classifier.done")
    module_outputs.append("checkpoint/dada2-module/step4b-complete_assign-taxonomy.done")
    module_outputs.append("checkpoint/dada2-module/step5-complete_compile-feature-table.done")
    module_outputs.append("checkpoint/dada2-module/step6-complete_rarefy-feature-table.done")
    module_outputs.append("checkpoint/dada2-module/step7-complete_visualize-taxonomy.done")
    module_outputs.append("checkpoint/dada2-module/step8-complete_alpha-rarefaction.done")
    module_outputs.append("checkpoint/dada2-module/step9-complete_alpha-diversity.done")
    module_outputs.append("checkpoint/dada2-module/step10-complete_beta-diversity.done")
    module_outputs.append("checkpoint/dada2-module/step11-complete_funguild.done")

#print(module_outputs)

# >>> GLOBAL RULES >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

rule all:
    input:
        module_outputs, 
        #"checkpoint/init-complete",
        "checkpoint/ITS-dada2-complete.done"
