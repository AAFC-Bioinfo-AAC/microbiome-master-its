#!/usr/bin/env Rscript
#return text file with first line removed and '#OTU ID' changed to 'OTU_ID'


version <- "1.0.2.2"

# read in required libraries
library( "ggplot2" )
library( "optparse" )
library( "data.table" )

# Set up option list
option_list <- list(
  
  make_option( c( "-i", "--input"), type="character", default=NA, 
               help = "Input ASV/OTU table to format for FUNGuild (required)", metavar="path"),
  
  make_option( c( "-o", "--output"), type="character", default=NA, 
               help = "Output file path (required)", metavar="path")
  )

opt_parser <- OptionParser( option_list=option_list , usage = "%prog [options] --input PATH --output PATH", add_help_option = T)

opt <- parse_args( opt_parser )

if ( is.na( opt$input ) ) {
  stop( "Path to input table needs to be specified with -i or --input\nType \"strip_otu_table.R --help\" for help." )
} else if ( is.na( opt$output )) {
  stop( "Path to output needs to be specified with -o or --output\nType \"strip_otu_table.R --help\" for help." ) }

message("Reading in otu table to be formatted for FUNGuild...")

data <- read.csv(opt$input, header=T, check.names=F, skip=1, sep="\t")
message("Done.")

message("Formatting table...")
names(data)[1] <- "OTU_ID"
data$taxonomy <- gsub('\\s+', '', data$taxonomy)
message("Formatting complete.")

message("Saving output...")
dir.create("results/qiime-dada2-module/funguild", showWarnings = FALSE)
write.table(data, opt$output, sep="\t", row.names=F, quote=F)
message(paste0("Output saved to ", opt$output))
