#!/bin/bash

#I used this script to figure out which reads had a space in the quality line. 
#Create conda environment and install validatefastq here; conda install -c bioconda biopet-validatefastq 
#Best to save the stdout to file using fix_fastqs.bash |& tee -a log.txt 

#mkdir -p fixed 

#for i in `ls *.fq`; do echo "Removing spaces and replacing with '!' for file $i"; sed -e 's/\s\+/!/g' $i >> fixed/$i ; echo "Complete." ; done

for i in `ls *.fq`; do echo "Checking fastq file $i for possible errors"; python $PWD -i $i ; echo "Complete." ;  done 

#You can check how many errors (if any) in the output by then running this in the output text file 

#grep -c "Exception" log.txt 
