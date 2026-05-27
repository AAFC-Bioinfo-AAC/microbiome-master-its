#!/bin/bash

# Check if required databases are present for pipeline execution or download before proceeding

#echo " "                                                               
#echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
#echo ">>>>>>                                                                                   >>>>>>" 
#echo ">>>>>>                          This is Microbiome Master v1.0.2                         >>>>>>"
#echo ">>>>>>                                                                                   >>>>>>"                               
#echo ">>>>>>             Developed by the Microbial Ecology Group (AAFC-Harrow)                >>>>>>"
#echo ">>>>>>                                                                                   >>>>>>"           
#echo ">>>>>>             Suggestions or issues should be sent to Brent Seuradge                >>>>>>"
#echo ">>>>>>                                                                                   >>>>>>" 
#echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
#echo " " 

### FOR NEW UNITE VERSIONS; UPDATE THESE PARAMTERS

CURRENT_LINK="https://s3.hpc.ut.ee/plutof-public/original"
CURRENT_FILE="6fa9d7a2-1d4a-4846-ab03-59a251f9477f.tgz"
CURRENT_NAME="sh_refs_qiime_ver10_dynamic_19.02.2025"
CURRENT_VER="v10"
CURRENT_DATE="2025-02-19"

echo "[DB_DOWNLOAD] Checking for UNITE $CURRENT_VER ($CURRENT_DATE) reference training sets in order to proceed with taxonomic assignments"

if test -f "ref/UNITE/$CURRENT_VER/$CURRENT_NAME.fasta"
then
    md5sum ref/UNITE/$CURRENT_VER/$CURRENT_NAME.fasta > ref/UNITE/$CURRENT_VER/$CURRENT_NAME.md5
    if md5sum --status -c ref/UNITE/$CURRENT_VER/$CURRENT_NAME.md5; then
        echo "[DB_DOWNLOAD] UNITE v10 dynamic reference training set present (md5sum validated)."
    else
        echo "[DB_DOWNLOAD] UNITE $CURRENT_VER ($CURRENT_DATE) dynamic training set present but errors detected. Please redownload the database files to prevent downstream issues."
    fi
else 
    echo "[DB_DOWNLOAD] No UNITE $CURRENT_VER ($CURRENT_DATE) dynamic training set present. Downloading in order to proceed with snakemake."
    mkdir -p ref/UNITE/$CURRENT_VER
    wget -O "ref/UNITE/$CURRENT_VER/"$CURRENT_FILE $CURRENT_LINK/$CURRENT_FILE
    tar -xvzf ref/UNITE/$CURRENT_VER/$CURRENT_FILE -C ref/UNITE/$CURRENT_VER/
    md5sum ref/UNITE/$CURRENT_VER/$CURRENT_NAME.fasta > ref/UNITE/$CURRENT_VER/$CURRENT_NAME.md5
    if md5sum --status -c ref/UNITE/$CURRENT_VER/$CURRENT_NAME.md5; then
        rm -r ref/UNITE/$CURRENT_VER/developer
        rm ref/UNITE/$CURRENT_VER/$CURRENT_FILE
        echo "[DB_DOWNLOAD] Download successful (md5sum validated)"
    else
        echo "[DB_DOWNLOAD] Download unsuccessful (md5sum not validated; please re-try downloading)"
    fi
fi

