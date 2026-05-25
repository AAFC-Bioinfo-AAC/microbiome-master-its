#!/usr/bin/env Rscript

library(tidyverse)
library(optparse)


option_list <- list(
  make_option( c( "-i", "--input"), type="character", default=NA, help = "Input taxonomy table (required)" , metavar="path"),
  make_option( c( "-o", "--output"), type="character", default=NA, help = "Output file path (required)", metavar="path"))

opt_parser <- OptionParser( option_list=option_list , 
                            usage = "%prog [options] --input PATH --output PATH --mapping PATH", add_help_option=F )
opt <- parse_args( opt_parser )

# Check for required arguments
if ( is.na( opt$input ) ) {
  stop( "Path to input table needs to be specified with --input\nType \"format_taxonomy.R --help\" for help." )
} else if ( is.na( opt$output )) {
  stop( "Path to output pdf needs to be specified with --output\nType \"format_taxonomy.R --help\" for help." )
}

# Load in taxonomy table exported from QIIME2
message("Preparing taxonomy.qza table for feature table construction")

tax <- read.table(opt$input, header=TRUE, sep="\t")

# Rename to BIOM formatted column names
tax_formatted <- rename(tax,  "#OTUID"="Feature.ID") 
tax_formatted <- rename(tax_formatted,  "taxonomy"=Taxon) 

write_tsv(tax_formatted, opt$output)
#write_tsv(tax_formatted, "data/process/qiime-dada2-module/step4_taxonomy/taxonomy_formatted.tsv")