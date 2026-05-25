#!/usr/bin/env Rscript

#This is a modified version of "plot_metagenome_contributions.R" script from microbiome-helper (https://github.com/LangilleLab/microbiome_helper/wiki)
#Comeau AM, Douglas GM, Langille MGI. 2017. Microbiome Helper: a Custom and Streamlined Workflow for Microbiome Research. mSystems 2(1): e00127-16; DOI: 10.1128/mSystems.00127-16
#Modified by: Annette Lan (Phillips Lab, March 2019)

version <- "1.0"

# read in required libraries
library( "ggplot2" )
library( "optparse" )
library( "data.table" )

option_list <- list(

		  make_option( c( "-i", "--input"), type="character", default=NA, 
	                  help = "Input table (required)" , metavar="path"),

		  make_option( c( "-o", "--output"), type="character", default=NA, 
        	          help = "Output file path (required)", metavar="path"),
		  
		  make_option( c( "-m", "--mapping"), type="character", default=NA, 
		               help = "Metadata mapping file (required)", metavar="path"),
		  
		  make_option( c( "-c", "--category"), type="character", default=NA, 
		               help = "Metadata categories to be plotted; separate with a ',' (required)", metavar="path"),

		  make_option( c( "-t", "--table" ) , action = "store_true" , type="logical" , default=FALSE , 
		  	  help = "Flag to indicate that plotted data should be saved as a text file[default = %default]" ) ,

		  make_option(  c( "-w", "--width" )  , type="numeric" , default=45 ,
          	          help = "Manually set pdf width in centimetres [default = %default]",
			  metavar = "number" ) ,

		  make_option( c( "-h", "--height" ) , type="numeric" , default=30 ,
          	          help = "Manually set pdf height in centimetres [default = %default]",
 			  metavar = "number" ) 

		 )

opt_parser <- OptionParser( option_list=option_list , 
							usage = "%prog [options] --input PATH --output PATH --mapping PATH", add_help_option = F)
opt <- parse_args( opt_parser )

# check for required arguments
if ( is.na( opt$input ) ) {
	stop( "Path to input table needs to be specified with -i or --input\nType \"plot_metagenome_contributions.R --help\" for help." )
} else if ( is.na( opt$output )) {
	stop( "Path to output pdf needs to be specified with -o or --output\nType \"plot_metagenome_contributions.R --help\" for help." )
} else if ( is.na( opt$mapping )) {
  stop( "Path to metadata mapping file needs to be specified with -m or --mapping\nType \"plot_metagenome_contributions.R --help\" for help." )
} else if ( is.na( opt$category )) {
  stop( "Metadata categories to plot need to be specified with -c or --category\nType \"plot_metagenome_contributions.R --help\" for help." )
}

# Parse desired metadata categories
categories <- unlist(strsplit(opt$category, ","))

# Read in mapping file
map <- read.delim( opt$mapping , stringsAsFactors = FALSE, check.names = F )
names(map)[1] <- "SampleID"

# Stop if requested category does not exist in mapping file
if (!all(categories %in% names(map))) {
  stop( paste("Metadata category", categories[!(categories %in% names(map))], 
              "not found in given mapping file!\n"))
}

# Read in input file
input <- read.delim( opt$input , stringsAsFactors = FALSE )

# Pull out relevant input columns
e <- which(colnames(input) == "taxonomy") - 1
guild <- e + 5
input_subset <- input[,c(2:e, guild)]

# Remove rows with no guild or NULL
input_subset <- input_subset[!grepl("-$|NULL", input_subset$Guild),]

# Sum rows by guild
data <- setDT(input_subset)[,lapply(.SD, sum),Guild]
data <- as.data.frame(data)

# Sum totals per guild
totals <- 1:nrow(data)
for (i in 1:nrow(data)){  
  totals[i] <- sum(data[i,2:ncol(data)])
}
names(totals) <- unlist(data$Guild)

# Calculate relative abundances
for (i in 1:length(totals)) {
  g <- names(totals)[i]
  data[which(data$Guild == g),2:ncol(data)] <- data[which(data$Guild == g),2:ncol(data)] * 100 / totals[i]
}

# Reshape data into wide format
data <- melt(data, id.vars = "Guild", variable.name = "Category", value.name = "Relab")

# Loop over all provided metadata categories
for (i in categories) {
  # Swap out SampleID for desired metadata category
  key <- map[,c("SampleID", i)]
  plot_data <- data
  plot_data$Category <- key[,i][match(plot_data$Category, key$SampleID)]
  
  # Combine rows with identical values of the metadata category
  plot_data <- as.data.table(plot_data)
  plot_data <- setDT(plot_data)[,lapply(.SD, sum), by = list(Guild, Category)]
  
  # Plot data
  plot <- ggplot(plot_data, aes(Guild, Category)) + geom_tile(aes(fill = Relab), color = "white") + 
    scale_fill_gradient(low = "azure", high = "steelblue4", name = "Relative abundance (%)") 

  plot <- plot + theme_gray(base_size = 9) + labs(x="Guild", y=i) + scale_x_discrete(expand = c(0,0)) +
    theme(axis.ticks = element_blank(), axis.text.x = element_text(size = 7.2, angle = 330, hjust = 0, 
                                                                   color = "grey50"),
          axis.title = element_text(color = "grey40"))
  plot <- plot + theme(panel.background = element_blank(), panel.grid.major = element_blank(), 
                       panel.grid.minor = element_blank())
  
  # Save plot as pdf
  ggsave(paste0(opt$output, i, ".pdf"), plot = plot, device = "pdf", width = opt$width, height = opt$height, units = "cm")
  
  # Save data in corresponding text file if specified
  if (opt$table) {
   write.table(plot_data, paste0(opt$output, i, ".txt"), sep = "\t", row.names = F)
  }
}
