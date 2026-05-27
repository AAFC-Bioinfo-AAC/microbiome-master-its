""" Phillips Lab - Snakemake 16S Sequence Processing Pipeline.

Version: 1.0.2
Author: Brent Seuradge (adpated from Oksana Korol; GRDI Ecobiomics Pipeline 2016)
Contributors: Annette Lan (Jan-April 2019)
Date: 2020-03-19

Steps of the workflow:

The firsts rule (rule all:...) specifies the final output of the workflow. 
The rule right after it is the first step in the workflow. The rest of the 
steps (rules) are specified in order of execution. See message:, version:,
shell: and other keywords to gain understanding what each step is doing.

"""

configfile: "config.yaml"

# Workdir can be changed when executing workflow:
# snakemake --config workdir="data/amplicon_workflow/"
workdir: config["workdir"]

# Unpack the input files:
import os
import os.path
from os.path import join

#dynamically set input directory
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

#rule all:
#    input:
#        # Step 16 - QIIME2 Alpha Diversity
#        "results/qiime2/qiime2_alpha_div/q2_non-rarefied_taxa_plots.qzv",
#        "results/qiime2/qiime2_alpha_div/q2_rarefied_taxa_plots.qzv",
#        expand("results/qiime2/qiime2_alpha_div/{metric1}/{metric1}_correlation.qzv", metric1={config["q2_alpha_metric"]["metric1"]}),
#        expand("results/qiime2/qiime2_alpha_div/{metric2}/{metric2}_correlation.qzv", metric2={config["q2_alpha_metric"]["metric2"]}),
#        expand("results/qiime2/qiime2_alpha_div/{metric3}/{metric3}_correlation.qzv", metric3={config["q2_alpha_metric"]["metric3"]}),
#        expand("results/qiime2/qiime2_alpha_div/{metric1}/{metric1}_significance.qzv", metric1={config["q2_alpha_metric"]["metric1"]}),
#        expand("results/qiime2/qiime2_alpha_div/{metric2}/{metric2}_significance.qzv", metric2={config["q2_alpha_metric"]["metric2"]}),
#        expand("results/qiime2/qiime2_alpha_div/{metric3}/{metric3}_significance.qzv", metric3={config["q2_alpha_metric"]["metric3"]}),
#        expand("results/qiime2/qiime2_alpha_div/{metric1}/{metric1}.qza", metric1={config["q2_alpha_metric"]["metric1"]}),
#        expand("results/qiime2/qiime2_alpha_div/{metric2}/{metric2}.qza", metric2={config["q2_alpha_metric"]["metric2"]}),
#        expand("results/qiime2/qiime2_alpha_div/{metric3}/{metric3}.qza", metric3={config["q2_alpha_metric"]["metric3"]}),
        # Step 15 - QIIME2 Artifact Table Generation
#        "results/qiime2/qiime2_source_artifacts/q2_otu_feature-table.qza",
#        "results/qiime2/qiime2_source_artifacts/q2_otu_rarefied_feature-table.qza",
#        "results/qiime2/qiime2_source_artifacts/q2_otu_taxonomy.qza",
#        "results/qiime2/qiime2_source_artifacts/q2_otu_rarefied_taxonomy.qza",
#        "results/qiime2/qiime2_source_artifacts/q2_metadata_mapping.qzv",
        # Step 14 - FAPROTAX
#        "results/faprotax/func_table.txt",
#        "results/faprotax/report.txt",
#        "results/faprotax/otu_group.txt",
#        "results/faprotax/group_definitions.txt",
#        "results/faprotax/heatmap.pdf", 
        # Step 13 - Beta Diversity
#        "results/beta_div/bray_curtis_rarefy_otu_table.txt", 
#        "results/beta_div/unweighted_unifrac_rarefy_otu_table.txt",
#        "results/beta_div/weighted_unifrac_rarefy_otu_table.txt",
#        "results/beta_div/pc_coords/pcoa_bray_curtis_rarefy_otu_table.txt",
#        "results/beta_div/pc_coords/pcoa_unweighted_unifrac_rarefy_otu_table.txt",
#        "results/beta_div/pc_coords/pcoa_weighted_unifrac_rarefy_otu_table.txt",
#        "results/beta_div/emperor/bray/index.html", 
#        "results/beta_div/emperor/weighted_unifrac/index.html",
#        "results/beta_div/emperor/unweighted_unifrac/index.html",
#        "results/indicator_analysis/raw/ind_species_raw.txt",
#        "results/indicator_analysis/indicator_species.html",
        # Step 12 - Alpha Diversity
#        "results/alpha_div/summarize_taxa/summarize_by_levels/rarefy_otu_table_L2.txt",
#        "results/alpha_div/summarize_taxa/summarize_by_levels/rarefy_otu_table_L3.txt",
#        "results/alpha_div/summarize_taxa/summarize_by_levels/rarefy_otu_table_L4.txt",
#        "results/alpha_div/summarize_taxa/summarize_by_levels/rarefy_otu_table_L5.txt",
#        "results/alpha_div/summarize_taxa/summarize_by_levels/rarefy_otu_table_L6.txt",
#        "results/alpha_div/summarize_taxa/summarize_by_levels_metadata/metadata_mapping_L2.txt",
#        "results/alpha_div/taxa_plots/charts/",
#        "results/alpha_div/rarefaction/alpha_rarefaction_plots/rarefaction_plots.html",
        # Step 11 - Summarize Sequence Quality Information
#        "results/seq_quality/stdin_fastqc_Read1.html",
#        "results/seq_quality/stdin_fastqc_Read2.html",
#        "results/seq_quality/stdin_fastqc_merged.html",
#        "results/seq_quality/stdin_fastqc_filtered.html",
#        "results/seq_quality/stdin_fastqc_trimmed.html",
#        "results/seq_quality/seq_counts.txt",
        # Step 10 - Rarefy OTU table
#        "results/otu_table/rarefied_otu_table/rarefy_otu_table.biom",
#        "results/otu_table/rarefied_otu_table/rarefy_otu_table.txt",
#        "results/otu_table/rarefied_otu_table/rarefy_otu_table_summary.txt",
#        "results/otu_table/rarefied_otu_table/rarefy_otu_table_json.biom",
        # Step 9 - Make OTU table
#        "results/otu_table/otu_table.biom",
#        "results/otu_table/otu_table.txt",
#        "results/otu_table/summary.txt",
#        "results/otu_table/otu_table_json.biom",
        # Step 8 - Sequnece Alignment & Phylogeny
#        "data/process/step7_phylogeny/aligned/rep_set_relabel_aligned.fasta", 
#        "data/process/step7_phylogeny/aligned/rep_set_relabel_failures.fasta",
#        "data/process/step7_phylogeny/aligned/rep_set_relabel_log.txt",
#        "results/phylogenetic_tree/rep_set.tre",
        # Step 7 - Classification 
#        "data/process/step6_classification/qiime_rdp/rep_set_relabel_tax_assignments.txt",
#        "data/process/step6_classification/qiime_rdp/rep_set_relabel_tax_assignments.log",
        # Step 6 - Clustering
#	"data/process/step5_clustering/concatenated/combined_seqs.fna",
#        "data/process/step5_clustering/unique.fasta",
#        "data/process/step5_clustering/sorted.fasta",
#        "data/process/step5_clustering/nochimeras.fasta",
#        "data/process/step5_clustering/rep_set.fasta",
#        "data/process/step5_clustering/rep_set_relabel.fasta",
#        "data/process/step5_clustering/map.uc",
#        "data/process/step5_clustering/seq_otus.txt",
        # Step 5 - Convert Fastq to Fasta
#        expand("data/process/step4_fastq_to_fasta/{sample}trimmed.fasta", sample=samples_prefix),
        # Step 4 - Quality Control - Trimming Quality (via FASTQC)
#        "data/process/step3_QC_trimming/quality/fastqc_trimmed_combined/stdin_fastqc.html",
#        expand("data/process/step3_QC_trimming/quality/fastqc_trimmed_all/{sample}trimmed_fastqc.html", sample=samples_prefix),
        # Step 4 - Quality Control - Trimming (via Trimmomatic)
#        expand("data/process/step3_QC_trimming/{sample}trimmed.fastq", sample=samples_prefix),
        # Step 3 - Quality Control - Low Quality Filtering Quality (via FASTQC)
#        "data/process/step2_QC_filtering/quality/fastqc_filtered_combined/stdin_fastqc.html",
#        expand("data/process/step2_QC_filtering/quality/fastqc_filtered_all/{sample}filtered_fastqc.html", sample =samples_prefix),
        # Step 3 - Quality Control - Low Quality Filtering (via VSEARCH)
#        expand("data/process/step2_QC_filtering/{sample}filtered.fastq", sample=samples_prefix),
        # Step 2 - Merged Paired-End Reads Quality (via FASTQC) 
#        "data/process/step1_merged_pear/assembled/quality/fastqc_merged_combined/stdin_fastqc.html",
#        expand("data/process/step1_merged_pear/assembled/quality/fastqc_merged_all/{sample}.assembled_fastqc.html", sample=samples_prefix),
        # Step 2 - Merge Paired-End Reads (via PEAR)
#        expand("data/process/step1_merged_pear/assembled/{sample}.assembled.fastq", sample=samples_prefix), 
#        expand("data/process/step1_merged_pear/discarded/{sample}.discarded.fastq", sample=samples_prefix),
#        expand("data/process/step1_merged_pear/unassembled/{sample}.unassembled.forward.fastq", sample=samples_prefix),
#        expand("data/process/step1_merged_pear/unassembled/{sample}.unassembled.reverse.fastq", sample=samples_prefix),
        # Step 1 - Primer Removal
#        expand("data/process/step1_merged_pear/input/{sample}ptrimmed_R1.fastq", sample=samples_prefix),
#        expand("data/process/step1_merged_pear/input/{sample}ptrimmed_R2.fastq", sample=samples_prefix),
        # Step 0 - Initial Quality (Raw Reads)
#        expand("data/process/step0_initial_data_quality/{file_name}_fastqc.html", file_name=file_names),
#        "data/process/step0_initial_data_quality/Read1/stdin_fastqc.html",
#        "data/process/step0_initial_data_quality/Read2/stdin_fastqc.html"

rule initial_data_quality_merged:
    version: "0.11.2"
    input:
        READ1 = expand("data/raw/{sample}R1" + file_ext, sample = samples_prefix),
        READ2 = expand("data/raw/{sample}R2" + file_ext, sample = samples_prefix), 
    output:
        "data/process/grdi-legacy/step0_initial_data_quality/Read1/stdin_fastqc.html",
        "data/process/grdi-legacy/step0_initial_data_quality/Read2/stdin_fastqc.html", 
    priority: 100
    message:
        ">>>>>> [GRDI-LEGACY SUBMODULE] Step 1 - Running FastQC to Determine the Overall Quality of: READ1 and READ2"
    benchmark:
        "benchmarks/step0/step0_initial_data_quality_reads_merged.txt"
    run:
        shell("echo Pipeline Started !")
        shell("echo $(date -u)")
        shell("echo This is the Phillips Lab 16S Pipeline Version 2.1")
        shell("cat {input.READ1} | fastqc stdin -o data/process/grdi-legacy/step0_initial_data_quality/Read1")
        shell("cat {input.READ2} | fastqc stdin -o data/process/grdi-legacy/step0_initial_data_quality/Read2")

rule initial_data_quality_all:
    version: "0.11.2"
    input:
        join(INPUTDIR, PATTERN_INITIAL),
    output:
        "data/process/step0_initial_data_quality/{file_name}_fastqc.html",
    priority: 99
    message:
        "\n =====> Running FastQC to Determine the Quality of: ALL READS."
    benchmark:
        "benchmarks/step0/step0_initial_data_quality_all.txt"
    shell:
        """
        initial_data_quality_all_cmd="fastqc {input} -t 6 --outdir=data/process/step0_initial_data_quality" ;\
        echo "Executed command:\n" $initial_data_quality_all_cmd ;\
        $initial_data_quality_all_cmd 
        """

rule cutadapt:
    version: "1.15"
    input:
        exec = os.path.expanduser(config["cutadapt"]["path"]),
        raw_forward_paired = "data/raw/{sample}R1" + file_ext,
        raw_reverse_paired = "data/raw/{sample}R2" + file_ext,
    output:
        ptrimmedR1 = "data/process/step1_merged_pear/input/{sample}ptrimmed_R1.fastq",
        ptrimmedR2 = "data/process/step1_merged_pear/input/{sample}ptrimmed_R2.fastq",
    priority: 98
    threads: 10
    params:
        sample_base = "{sample}"
    message:
        "\n =====> Removing gene specific primers using cutadapt | min/max sequence length set to {config[cutadapt][Minlength]}/{config[cutadapt][Maxlength]}"
    benchmark:
        "benchmarks/step0/step0_primer_removal.txt"
    shell:
        """
        {input.exec} -g {config[cutadapt][Fprimer]} -G {config[cutadapt][Rprimer]} \
        -m {config[cutadapt][Minlength]} -M {config[cutadapt][Maxlength]} \
        --discard-untrimmed \
        -o {output.ptrimmedR1} \
        -p {output.ptrimmedR2} \
        {input.raw_forward_paired} \
        {input.raw_reverse_paired} \
        """

rule merge_reads_pear:
    version: "v.0.9.10 [May 30, 2016]"
    input:
        forward_paired = "data/process/step1_merged_pear/input/{sample}ptrimmed_R1.fastq",
        reverse_paired = "data/process/step1_merged_pear/input/{sample}ptrimmed_R2.fastq",
        exec = os.path.expanduser(config["pear"]["path"]),
    output:
        assembled = "data/process/step1_merged_pear/{sample}.assembled.fastq",
        discarded = "data/process/step1_merged_pear/{sample}.discarded.fastq",
        un_fwd = "data/process/step1_merged_pear/{sample}.unassembled.forward.fastq",
        un_rev = "data/process/step1_merged_pear/{sample}.unassembled.reverse.fastq",
    priority: 97
    threads: 10
    params: 
        sample_base = "{sample}"
    message:
        "\n =====> Joining Forward and Reverse Paired-End Read Sequences Using PEAR."
    benchmark:
        "benchmarks/step1/step1_merge_pear.txt"
    shell:
        """
        {input.exec} -f {input.forward_paired} -r {input.reverse_paired} -u {config[pear][uncalled_bases]} -j {config[pear][threads]} -o data/process/step1_merged_pear/{params.sample_base}
        """

rule organize_merged_reads:
    input:
        assembled = "data/process/step1_merged_pear/{sample}.assembled.fastq",
        discarded = "data/process/step1_merged_pear/{sample}.discarded.fastq",
        un_fwd = "data/process/step1_merged_pear/{sample}.unassembled.forward.fastq",
        un_rev = "data/process/step1_merged_pear/{sample}.unassembled.reverse.fastq",
    output:
        "data/process/step1_merged_pear/assembled/{sample}.assembled.fastq",
        "data/process/step1_merged_pear/discarded/{sample}.discarded.fastq",
        "data/process/step1_merged_pear/unassembled/{sample}.unassembled.forward.fastq",
        "data/process/step1_merged_pear/unassembled/{sample}.unassembled.reverse.fastq",
    priority: 96
    params: 
        sample_base = "{sample}"
    shell:
        """
        mv {input.assembled} data/process/step1_merged_pear/assembled/{params.sample_base}.assembled.fastq;
        mv {input.discarded} data/process/step1_merged_pear/discarded/{params.sample_base}.discarded.fastq;
        mv {input.un_fwd} data/process/step1_merged_pear/unassembled/{params.sample_base}.unassembled.forward.fastq;
        mv {input.un_rev} data/process/step1_merged_pear/unassembled/{params.sample_base}.unassembled.reverse.fastq;
        """

rule merged_reads_combined_fastqc:
    version: "0.11.2"
    input:
        merged_reads = expand("data/process/step1_merged_pear/assembled/{sample}.assembled.fastq", sample = samples_prefix)
    output:
        "data/process/step1_merged_pear/assembled/quality/fastqc_merged_combined/stdin_fastqc.html",
    priority: 95
    message:
        "\n =====> Running FastQC to Determine the Overall Quality of: Combined Merged Reads (via PEAR)"
    benchmark:
        "benchmarks/step1/step1_merged_reads_quality_combined.txt"
    run:
        shell("cat {input.merged_reads} | fastqc stdin -o data/process/step1_merged_pear/assembled/quality/fastqc_merged_combined")

rule merged_reads_all_fastqc:
    version: "0.11.2"
    input:
        merged_reads = expand("data/process/step1_merged_pear/assembled/{sample}.assembled.fastq", sample = samples_prefix)
    output:
        expand("data/process/step1_merged_pear/assembled/quality/fastqc_merged_all/{sample}.assembled_fastqc.html", sample = samples_prefix)
    priority: 94
    message:
        "\n =====> Running FastQC to Determine the Overall Quality of: All Merged Reads (via PEAR)"
    benchmark:
        "benchmarks/step1/step1_merged_reads_quality_all.txt"
    shell:
        """
        fastqc {input.merged_reads} -t 6 --outdir=data/process/step1_merged_pear/assembled/quality/fastqc_merged_all 
        """

rule quality_filtering:
    version: "2.4.3"
    input:
        exec = os.path.expanduser(config["vsearch"]["path"]),
        merged_reads = "data/process/step1_merged_pear/assembled/{sample}.assembled.fastq",
    output:
        filtered = "data/process/step2_QC_filtering/{sample}filtered.fastq",
    priority: 93
    message:
        "\n =====> Using VSEARCH for filtering low quality reads | max error threshold set to: {config[vsearch][filtermaxee]}"
    benchmark:
        "benchmarks/step2/step2_QC_filtering.txt"
    shell:
        """
        {input.exec} --fastq_filter {input.merged_reads} --fastq_maxee {config[vsearch][filtermaxee]} --fastqout {output.filtered}
        """

rule quality_filtering_combined_fastqc:
    version: "0.11.2"
    input:
        merged_reads = expand("data/process/step2_QC_filtering/{sample}filtered.fastq", sample = samples_prefix),
    output:
        "data/process/step2_QC_filtering/quality/fastqc_filtered_combined/stdin_fastqc.html",
    priority: 92
    message:
        "\n =====> Running FastQC to Determine Quality of: Filtered Reads Combined | max error threshold set to: {config[vsearch][filtermaxee]}"
    benchmark:
        "benchmarks/step2/step2_fastqc_filtered_combined.txt"
    run:
        shell("cat {input.merged_reads} | fastqc stdin -o data/process/step2_QC_filtering/quality/fastqc_filtered_combined")

rule quality_filtering_all_fastqc:
    version: "0.11.2"
    input:
        "data/process/step2_QC_filtering/{sample}filtered.fastq"
    output:
        "data/process/step2_QC_filtering/quality/fastqc_filtered_all/{sample}filtered_fastqc.html",
    priority: 91
    message:
        "\n =====> Running FastQC to Determine Quality of: Filtered Reads | Max Error Threshold Set to: {config[vsearch][filtermaxee]}"
    benchmark:
        "benchmarks/step2/step2_fastqc_filtered_all.txt"
    shell:
        """
        fastqc {input} -t 6 --outdir=data/process/step2_QC_filtering/quality/fastqc_filtered_all 
        """

rule quality_trimming:
    version: "2.4.3"
    input:
        exec = os.path.expanduser(config["trimmomatic"]["path"]),
        filtered_reads = "data/process/step2_QC_filtering/{sample}filtered.fastq"
    output:
        trimmed = "data/process/step3_QC_trimming/{sample}trimmed.fastq",
    priority: 90
    message:
        "\n =====> Using Trimmomatic to Trim Read Ends | Crop Length Set to: {config[trimmomatic][CROP]} bp"
    benchmark:
        "benchmarks/step3/step3_QC_trimming.txt"
    shell:
        """
        java -jar {input.exec} SE -threads {threads} -phred33 {input.filtered_reads} {output.trimmed} CROP:{config[trimmomatic][CROP]}        
        """

rule quality_trimming_combined_fastqc:
    version: "0.11.2"
    input:
        trimmed_reads = expand("data/process/step3_QC_trimming/{sample}trimmed.fastq", sample = samples_prefix)
    output:
        "data/process/step3_QC_trimming/quality/fastqc_trimmed_combined/stdin_fastqc.html",
    priority: 89
    message:
        "\n =====> Running FastQC to Determine Quality of: Trimmed Reads Combined | Crop Length Set to: {config[trimmomatic][CROP]}"
    benchmark:
        "benchmarks/step3/step3_fastqc_trimmed_combined.txt"
    run:
        shell("cat {input.trimmed_reads} | fastqc stdin -o data/process/step3_QC_trimming/quality/fastqc_trimmed_combined")

rule quality_trimming_all_fastqc:
    version: "0.11.2"
    input:
        "data/process/step3_QC_trimming/{sample}trimmed.fastq"
    output:
        "data/process/step3_QC_trimming/quality/fastqc_trimmed_all/{sample}trimmed_fastqc.html",
    priority: 88
    message:
        "\n =====> Running FastQC to Determine Quality of: Trimmed Reads All | Crop Length Set to: {config[trimmomatic][CROP]} bp"
    benchmark:
        "benchmarks/step3/step3_fastqc_trimmed_all.txt"
    shell:
        """
        fastqc {input} -t 6 --outdir=data/process/step3_QC_trimming/quality/fastqc_trimmed_all 
        """

rule convert_fastq_to_fasta:
    version: "NA"
    input:
        exec = os.path.expanduser(config["microbiomehelper"]["path"]),
        qc_reads = "data/process/step3_QC_trimming/{sample}trimmed.fastq",
    output:
        "data/process/step4_fastq_to_fasta/{sample}trimmed.fasta",
    priority: 87
    message:
        "\n =====> Converting FASTQ Sequence Files to FASTA Format Using Microbiome-Helper"
    benchmark:
        "benchmarks/step4/step4_fastq_to_fasta.txt"
    shell:
        """
        perl {input.exec} {input.qc_reads} -o data/process/step4_fastq_to_fasta
        """

rule add_qiime_labels:
    version: "1.9.1"
    input:
        mapping = {config["file_mapping"]}
        #mapping = "data/mapping/file_mapping.txt",
        #fasta = "data/process/step4_fastq_to_fasta",
    output:
        "data/process/step5_clustering/concatenated/combined_seqs.fna", 
    priority: 86
    message:
        "\n =====> Concatenating FASTA Files and Preparing for Clustering"
    benchmark:
        "benchmarks/step5/step5_cluster_concatenating.txt"
    shell:
        """
        add_qiime_labels.py -i data/process/step4_fastq_to_fasta/ -m {input.mapping} -c FileInput -o data/process/step5_clustering/concatenated/
        """

rule dereplication:
    version: "2.4.3"
    input:
        exec = os.path.expanduser(config["vsearch"]["path"]),
        concatenated = "data/process/step5_clustering/concatenated/combined_seqs.fna",
    output:
        unique = "data/process/step5_clustering/unique.fasta",
        log_unique = "data/process/step5_clustering/log_files/derep_vsearch_log.txt", 
    priority: 85
    message:
        "\n =====> Dereplicating Sequences | Minimum Sequence Length Set to: {config[vsearch][minglength]}"
    benchmark:
        "benchmarks/step5/step5_cluster_dereplication.txt"
    shell:
        """
        {input.exec} --derep_fulllength {input.concatenated} --output {output.unique} --sizeout --minseqlength {config[vsearch][minglength]} --log {output.log_unique}
        """

rule sorting:
    version: "2.4.3"
    input:
        exec = os.path.expanduser(config["vsearch"]["path"]),
        unique = "data/process/step5_clustering/unique.fasta",
    output:
        sorted = "data/process/step5_clustering/sorted.fasta",
        log_sorted = "data/process/step5_clustering/log_files/sorted_vsearch_log.txt",
    priority: 84
    message:
        "\n =====> Sorting Sequences | Minimum Cluster Size Set to: {config[vsearch][minclustersize]}"
    benchmark:
        "benchmarks/step5/step5_cluster_Sorted.txt"
    shell:
        """
        {input.exec} --sortbysize {input.unique} --output {output.sorted} --minsize {config[vsearch][minclustersize]} --log {output.log_sorted}
        """

rule chimera_checking:
    version: "2.4.3"
    input:
        exec = os.path.expanduser(config["vsearch"]["path"]),
        sorted = "data/process/step5_clustering/sorted.fasta",
    output:
        nochimeras = "data/process/step5_clustering/nochimeras.fasta",
        log_nochimeras = "data/process/step5_clustering/log_files/chimera_vsearch_log.txt",
    priority: 83
    message:
        "\n =====> Removing Chimeric Sequences (de novo)"
    benchmark:
        "benchmarks/step5/step5_cluster_chimeras.txt"
    shell:
        """
        {input.exec} --uchime_denovo {input.sorted} --nonchimeras {output.nochimeras} --log {output.log_nochimeras}
        """

rule picking_otus:
    version: "2.4.3"
    input:
        exec = os.path.expanduser(config["vsearch"]["path"]),
        nochimeras = "data/process/step5_clustering/nochimeras.fasta",
    output:
        rep_set = "data/process/step5_clustering/rep_set.fasta",
        log_rep_set = "data/process/step5_clustering/log_files/rep_set_vsearch_log.txt",
    priority: 82
    message:
        "\n =====> Picking OTUs | Cluster Size Threshold Set to: {config[vsearch][clusterthreshold]}"
    benchmark:
        "benchmarks/step5/step5_cluster_rep_set.txt"
    shell:
        """
        {input.exec} --cluster_smallmem {input.nochimeras} --id {config[vsearch][clusterthreshold]} --consout {output.rep_set} --usersort --log {output.log_rep_set}
        """

rule rep_set_relabel:
    version: "NA"
    input:
        exec = os.path.expanduser(config["vsearch"]["pathr"]), 
        rep_set = "data/process/step5_clustering/rep_set.fasta",
    output:
        rep_set_relabel = "data/process/step5_clustering/rep_set_relabel.fasta",
    priority: 81
    message:
        "\n =====> Relabeling Rep Set File | Cluster Size Threshold Set to: {config[vsearch][clusterthreshold]}"
    benchmark:
        "benchmarks/step5/step5_cluster_rep_set_relabel.txt"
    shell:
        """
        awk -f {input.exec} {input.rep_set} > {output.rep_set_relabel}
        """

rule cluster_map:
    version: "2.4.3"
    input:
        exec = os.path.expanduser(config["vsearch"]["path"]), 
        concatenated = "data/process/step5_clustering/concatenated/combined_seqs.fna",
        rep_set_relabel = "data/process/step5_clustering/rep_set_relabel.fasta",
    output:
        map = "data/process/step5_clustering/map.uc",
        log_mapping = "data/process/step5_clustering/log_files/mapping_vsearch_log.txt",
    priority: 80
    message:
        "\n =====> Mapping Reads Back to IDs | Database Mapping Threshold Set to: {config[vsearch][dbthreshold]}"
    benchmark:
        "benchmarks/step5/step5_cluster_rep_set_mapping.txt"
    shell:
        """
        {input.exec} --usearch_global {input.concatenated} --db {input.rep_set_relabel} --strand both --id {config[vsearch][dbthreshold]} --uc {output.map} --threads {config[vsearch][threads]} --log {output.log_mapping}
        """

rule uc_to_clust:
    version: "NA"
    input:
        exec = os.path.expanduser(config["vsearch"]["pathms"]), 
        map = "data/process/step5_clustering/map.uc",
    output:
        otu_seq = "data/process/step5_clustering/seq_otus.txt",
    priority: 79
    message:
        "\n =====> Mapping .uc File to Clusters | Database Mapping Threshold Set to: {config[vsearch][dbthreshold]}"
    benchmark:
        "benchmarks/step5/step5_cluster_uc_to_cluster.txt"
    shell:
        """
        python {input.exec} {input.map} {output.otu_seq}
        """

rule classification:
    version: "1.9.1"
    input:
        rep_set_relabel = "data/process/step5_clustering/rep_set_relabel.fasta",
    output:
        "data/process/step6_classification/qiime_rdp/rep_set_relabel_tax_assignments.txt",
        "data/process/step6_classification/qiime_rdp/rep_set_relabel_tax_assignments.log",
    priority: 78
    message:
        "\n =====> Classifying Representative Sequences | Boot-Strap Confidence Set to: {config[assign_taxonomy][c]}"
    benchmark:
        "benchmarks/step6/step6_classification.txt"
    shell:
        """
        assign_taxonomy.py -m {config[assign_taxonomy][method]} -i {input.rep_set_relabel} -o data/process/step6_classification/qiime_rdp -c {config[assign_taxonomy][c]} --rdp_max_memory {config[assign_taxonomy][max_memory]}
        """

rule make_otu_table:
    version: "2.0"
    input:
        otu_seq = "data/process/step5_clustering/seq_otus.txt",
        tax = "data/process/step6_classification/qiime_rdp/rep_set_relabel_tax_assignments.txt",
    output:
        biom = "results/otu_table/otu_table.biom",
        tab = "results/otu_table/otu_table.txt",
        json = "results/otu_table/otu_table_json.biom",
        summary = "results/otu_table/summary.txt",
        out_dir = "results/otu_table/"
    priority: 77
    message:
        "\n =====> Constructing OTU Table and Generating Summary Information"
    benchmark:
        "benchmarks/step8/step8_otu_table.txt"
    run:
        shell("""make_otu_table.py -i {input.otu_seq} -t {input.tax} -o {output.biom} ; 
        biom convert -i {output.biom} -o {output.tab} --to-tsv --header-key taxonomy ; 
        biom convert -i {output.biom} -o {output.json} --table-type="OTU table" --to-json --header-key taxonomy ;
        biom summarize-table -i {output.biom} -o {output.summary}""")
        
        shell("""cp data/mapping/metadata_mapping.txt results/copy_metadata_mapping.txt""")
        shell("""cp config.yaml results/copy_config.yaml""")
        
        if config["filter"]["do"]:
            shell("""mkdir -p results/otu_table/unfiltered/ ;
            mv results/otu_table/*.* results/otu_table/unfiltered/ ;
            filter_taxa_from_otu_table.py -i results/otu_table/unfiltered/otu_table.biom -o {output.biom} -n {config[filter][remove]} ;
            biom convert -i {output.biom} -o {output.tab} --to-tsv --header-key taxonomy ;
            biom convert -i {output.biom} -o {output.json} --table-type="OTU table" --to-json --header-key taxonomy ;
            biom summarize-table -i {output.biom} -o {output.summary}""")

rule rarefy_otu_table:
    version: "1.9.1"
    input:
        otus = "results/otu_table/otu_table.biom",
    output:
        biom = "results/otu_table/rarefied_otu_table/rarefy_otu_table.biom",
        tab = "results/otu_table/rarefied_otu_table/rarefy_otu_table.txt",
        summary = "results/otu_table/rarefied_otu_table/rarefy_otu_table_summary.txt",
        json = "results/otu_table/rarefied_otu_table/rarefy_otu_table_json.biom",
    priority: 76
    message:
        "\n =====> Rarefying OTU Table and Generating Summary Information | Rarefaction Depth Set to: {config[rarefaction][depth]} seqs/sample"
    benchmark:
        "benchmarks/step9/step9_rarefy_otu_table.txt"
    shell:
        """
        single_rarefaction.py -i {input.otus} -o {output.biom} -d {config[rarefaction][depth]} ;
        biom convert -i {output.biom} -o {output.tab} --table-type="OTU table" --to-tsv --header-key taxonomy ; 
        biom convert -i {output.biom} -o {output.json} --table-type="OTU table" --to-json --header-key taxonomy ;
        biom summarize-table -i {output.biom} -o {output.summary}
        """

rule summarize_fastqc:
    input:
        Read1 = "data/process/step0_initial_data_quality/Read1/stdin_fastqc.html",
        Read2 = "data/process/step0_initial_data_quality/Read2/stdin_fastqc.html",
        merged = "data/process/step1_merged_pear/assembled/quality/fastqc_merged_combined/stdin_fastqc.html",
        filtered = "data/process/step2_QC_filtering/quality/fastqc_filtered_combined/stdin_fastqc.html",
        trimmed = "data/process/step3_QC_trimming/quality/fastqc_trimmed_combined/stdin_fastqc.html",
    output:
        Read1 = "results/seq_quality/stdin_fastqc_Read1.html",
        Read2 = "results/seq_quality/stdin_fastqc_Read2.html",
        merged = "results/seq_quality/stdin_fastqc_merged.html",
        filtered = "results/seq_quality/stdin_fastqc_filtered.html",
        trimmed = "results/seq_quality/stdin_fastqc_trimmed.html",
        counts = "results/seq_quality/seq_counts.txt",
    priority: 75
    shell:
        """
        cp {input.Read1} {output.Read1} ;
        cp {input.Read2} {output.Read2} ;
        cp {input.merged} {output.merged} ;
        cp {input.filtered} {output.filtered} ;
        cp {input.trimmed} {output.trimmed} ;
        bash code/summarize_seq_counts.bash > {output.counts} ;
        """

rule align_sequences:
    version: "1.9.1"
    input:
        rep_set_relabel = "data/process/step5_clustering/rep_set_relabel.fasta",
    output:
        "data/process/step7_phylogeny/aligned/rep_set_relabel_aligned.fasta",
        "data/process/step7_phylogeny/aligned/rep_set_relabel_failures.fasta",
        "data/process/step7_phylogeny/aligned/rep_set_relabel_log.txt",
    priority: 74
    message:
        "\n =====> Aligning Representative Sequences | Method: {config[align_seqs][method]}"
    benchmark:
        "benchmarks/step7/step7_alignment.txt"
    shell:
        """
        align_seqs.py -i {input.rep_set_relabel} -o data/process/step7_phylogeny/aligned -m {config[align_seqs][method]}
        """

rule phylogeny:
    version: "1.9.1"
    input:
        aligned = "data/process/step7_phylogeny/aligned/rep_set_relabel_aligned.fasta",
        otus = "results/otu_table/otu_table.biom",
    output:
        tree = "results/phylogenetic_tree/rep_set.tre",
    priority: 73
    message:
        "\n =====> Constructing Phylogenetic Tree | Method: {config[phylogeny][method]}"
    benchmark:
        "benchmarks/step7/step7_phylogeny.txt"
    run:
        if config["filter"]["do"]:
            shell("""filter_fasta.py -f {input.aligned} -o data/process/step7_phylogeny/aligned/rep_set_relabel_filtered.fasta -b {input.otus} ;
            make_phylogeny.py -i data/process/step7_phylogeny/aligned/rep_set_relabel_filtered.fasta -o {output.tree} -t {config[phylogeny][method]}""")
        else:
            shell("make_phylogeny.py -i {input.aligned} -o {output.tree} -t {config[phylogeny][method]}")

rule summarize_taxa_levels:
    version: "1.9.1"
    input:
        otus = "results/otu_table/rarefied_otu_table/rarefy_otu_table.biom",
    output:
        "results/alpha_div/summarize_taxa/summarize_by_levels/rarefy_otu_table_L2.txt",
        "results/alpha_div/summarize_taxa/summarize_by_levels/rarefy_otu_table_L3.txt",
        "results/alpha_div/summarize_taxa/summarize_by_levels/rarefy_otu_table_L4.txt",
        "results/alpha_div/summarize_taxa/summarize_by_levels/rarefy_otu_table_L5.txt",
        "results/alpha_div/summarize_taxa/summarize_by_levels/rarefy_otu_table_L6.txt",
    priority: 72
    message:
        "\n =====> Summarizing OTU by Each Taxonomic Level (Using a Rarefied OTU table)"
    benchmark:
        "benchmarks/step10/step10_summarize_by_levels.txt"
    shell:
        """
        summarize_taxa.py -i {input.otus} -o results/alpha_div/summarize_taxa/summarize_by_levels 
        """

rule summarize_taxa_levels_metadata:
    version: "1.9.1"
    input:
        otus = "results/otu_table/rarefied_otu_table/rarefy_otu_table.biom",
        mapping = {config["mapping_file"]},
    output:
        "results/alpha_div/summarize_taxa/summarize_by_levels_metadata/metadata_mapping_L2.txt",
    priority: 71
    message:
        "\n =====> Summarizing OTU by Each Taxonomic Level and Appending Metadata (Using a Rarefied OTU table)"
    benchmark:
        "benchmarks/step10/step10_summarize_by_levels_metadata.txt"
    shell:
        """
        summarize_taxa.py -i {input.otus} -o results/alpha_div/summarize_taxa/summarize_by_levels_metadata -m {input.mapping} -t
        """

rule plot_taxa:
    version: "1.9.1"
    input:
        L2 = "results/alpha_div/summarize_taxa/summarize_by_levels/rarefy_otu_table_L2.txt",  
        L3 = "results/alpha_div/summarize_taxa/summarize_by_levels/rarefy_otu_table_L3.txt",
        L4 = "results/alpha_div/summarize_taxa/summarize_by_levels/rarefy_otu_table_L4.txt",
        L5 = "results/alpha_div/summarize_taxa/summarize_by_levels/rarefy_otu_table_L5.txt",
        L6 = "results/alpha_div/summarize_taxa/summarize_by_levels/rarefy_otu_table_L6.txt",
    output:
        "results/alpha_div/taxa_plots/charts/", 
    priority: 70
    message:
        "\n =====> Generating Taxa Plots (Using a Rarefied OTU table)"
    benchmark:
        "benchmarks/step10/step10_taxaplots.txt"
    shell:
        """
        plot_taxa_summary.py -i {input.L2},{input.L3},{input.L4},{input.L5},{input.L6} -l L2,L3,L4,L5,L6 -c pie,bar,area -o results/alpha_div/taxa_plots/charts/ -s
        """

rule beta_diversity:
    version: "1.9.1"
    input:
        otus = "results/otu_table/rarefied_otu_table/rarefy_otu_table.biom",
        mapping = {config["mapping_file"]},
        tree = "results/phylogenetic_tree/rep_set.tre"
    output:
        "results/beta_div/bray_curtis_rarefy_otu_table.txt", 
        "results/beta_div/unweighted_unifrac_rarefy_otu_table.txt",
        "results/beta_div/weighted_unifrac_rarefy_otu_table.txt",  
    priority: 69
    message:
        "\n =====> Calculating Pair-wise (Dis)similarities (Using a Rarefied OTU table) | Distance Metric(s) Selected: {config[beta_plots][params]}"
    benchmark:
        "benchmarks/step11/step11_beta_diversity.txt"
    shell:
        """
        beta_diversity.py -i {input.otus} -m {config[beta_plots][params]} -t {input.tree} -o results/beta_div/ -f
        """

rule principal_coordinates:
    version: "1.9.1"
    input:
        bray_dis = "results/beta_div/bray_curtis_rarefy_otu_table.txt", 
        uwuni_dis = "results/beta_div/unweighted_unifrac_rarefy_otu_table.txt",
        wuni_dis = "results/beta_div/weighted_unifrac_rarefy_otu_table.txt", 
    output:
        "results/beta_div/pc_coords/pcoa_bray_curtis_rarefy_otu_table.txt",
        "results/beta_div/pc_coords/pcoa_weighted_unifrac_rarefy_otu_table.txt",
        "results/beta_div/pc_coords/pcoa_unweighted_unifrac_rarefy_otu_table.txt", 
    priority: 68
    message:
        "\n =====> Calculating Principal Coordinates (Using a Rarefied OTU table) | Distance Metric(s) Selected: {config[beta_plots][params]}"
    benchmark:
        "benchmarks/step11/step11_pc.txt"
    run:
        shell("principal_coordinates.py -i {input.bray_dis} -o results/beta_div/pc_coords/pcoa_bray_curtis_rarefy_otu_table.txt")
        shell("principal_coordinates.py -i {input.wuni_dis} -o results/beta_div/pc_coords/pcoa_weighted_unifrac_rarefy_otu_table.txt")
        shell("principal_coordinates.py -i {input.uwuni_dis} -o results/beta_div/pc_coords/pcoa_unweighted_unifrac_rarefy_otu_table.txt")

rule emperor:
    version: "1.9.1"
    input:
        bray_pc = "results/beta_div/pc_coords/pcoa_bray_curtis_rarefy_otu_table.txt",
        wuni_pc = "results/beta_div/pc_coords/pcoa_weighted_unifrac_rarefy_otu_table.txt",
        uwuni_pc = "results/beta_div/pc_coords/pcoa_unweighted_unifrac_rarefy_otu_table.txt",
        mapping = "data/mapping/metadata_mapping.txt",
        otus = "results/alpha_div/summarize_taxa/summarize_by_levels/rarefy_otu_table_L6.txt"
    output:
        "results/beta_div/emperor/bray/index.html", 
        "results/beta_div/emperor/weighted_unifrac/index.html",
        "results/beta_div/emperor/unweighted_unifrac/index.html", 
    priority: 67
    message:
        "\n =====> Generating Emperor Plots (Using a Rarefied OTU table) | Distance Metric(s) Selected: {config[beta_plots][params]}"
    benchmark:
        "benchmarks/step11/step11_emperor.txt"
    run:
        shell("make_emperor.py -i {input.bray_pc} -m {input.mapping} -t {input.otus} -n {config[beta_plots][taxa]} -o results/beta_div/emperor/bray/")
        shell("make_emperor.py -i {input.wuni_pc} -m {input.mapping} -t {input.otus} -n {config[beta_plots][taxa]} -o results/beta_div/emperor/weighted_unifrac/")
        shell("make_emperor.py -i {input.uwuni_pc} -m {input.mapping} -t {input.otus} -n {config[beta_plots][taxa]} -o results/beta_div/emperor/unweighted_unifrac/")
 
rule indicator_analysis:
    version: "1.9.1"
    input:
        mapping = {config["mapping_file"]},
        otus = "results/otu_table/rarefied_otu_table/rarefy_otu_table.txt",
        exec = {config["indic_otus"]["species"]}
    output:
        "results/indicator_analysis/raw/ind_species_raw.txt", 
    priority: 66
    message:
        "\n =====> Finding Indicator OTUs (Using a Rarefied OTU table) | Significance Value Set to: {config[indic_otus][pval]}"
    benchmark:
        "benchmarks/step12/step12_indicator_analysis.txt"
    shell:
        """
        set +u ;
        source /space/project/grdi/eco/groups/phillipsl/tools/miniconda3/bin/activate r-base-3.6 ;
        {input.exec} -i {input.otus} -o results/indicator_analysis/raw -m {input.mapping} -p {config[indic_otus][pval]} ; 
        conda deactivate ;
        set -u ;
        """

rule indicator_otus:
    version: "1.9.1"
    input:
        mapping = {config["mapping_file"]},
        indics = "results/indicator_analysis/raw/ind_species_raw.txt",
        otus = "results/otu_table/rarefied_otu_table/rarefy_otu_table.txt",
        exec = {config["indic_otus"]["otu"]}
    output:
        "results/indicator_analysis/indicator_species.html", 
    priority: 65
    message:
        "\n =====> Consolidating Filtered Indicator OTUs (Using a Rarefied OTU table) | Significance Value Set to: {config[indic_otus][pval]}"
    benchmark:
        "benchmarks/step12/step12_indicator_otus.txt"
    shell:
        """
        python {input.exec} -i {input.indics} -t {input.otus} -m {input.mapping} -o results/indicator_analysis
        """

rule alpha_rarefaction:
    version: "1.9.1"
    input:
        otus = "results/otu_table/otu_table.biom",
        mapping = {config["mapping_file"]},
        tree = "results/phylogenetic_tree/rep_set.tre",
        params = {config["alpha_rarefaction"]["method"]},
    output:
        "results/alpha_div/rarefaction/alpha_rarefaction_plots/rarefaction_plots.html",
    priority: 64
    message:
        "\n =====> Generating Alpha Rarefaction Plots | Rarefaction Depth Set to: {config[rarefaction][depth]} seqs/sample"
    benchmark:
        "benchmarks/step13/step13_Alpha_Rarefaction.txt"
    shell:
        """
        alpha_rarefaction.py -i {input.otus} -m {input.mapping} -p {input.params} -t {input.tree} -e {config[alpha_rarefaction][depth]} -a -O {config[alpha_rarefaction][jobs]} --output_dir results/alpha_div/rarefaction/ -f
        """

rule faprotax:
    input:
        otus = "results/otu_table/rarefied_otu_table/rarefy_otu_table.txt",
        exec = {config["faprotax"]["path"]},
        mapping = {config["mapping_file"]},
    output:
        func = "results/faprotax/func_table.txt",
        report = "results/faprotax/report.txt",
        otu_group = "results/faprotax/otu_group.txt",
        defs = "results/faprotax/group_definitions.txt",
        heatmap = "results/faprotax/heatmap.pdf",
    priority: 63
    message:
        "\n =====> Generating Functional Information with FAPROTAX"
    benchmark:
        "benchmarks/step14/step14_FAPROTAX.txt"
    shell:
        """
        python {input.exec} -i {input.otus} -o {output.func} -g {config[faprotax][ref]} -d 'taxonomy' --column_names_are_in last_comment_line --omit_columns {config[faprotax][omit_col]} -r {output.report} --out_groups2records_table {output.otu_group} --out_group_definitions_used {output.defs} -n {config[faprotax][norm]} -v
        make_otu_heatmap.py -i {output.func} -o {output.heatmap}
        """

rule qiime2_artifact_generation:
    version: "2020.2"
    input:
        nrbiom = "results/otu_table/otu_table.biom",
        rbiom = "results/otu_table/rarefied_otu_table/rarefy_otu_table.biom",
        mapping = "data/mapping/metadata_mapping.txt",
    output:
        ft_nrbiom = "results/qiime2/qiime2_source_artifacts/q2_otu_feature-table.qza",
        ft_rbiom = "results/qiime2/qiime2_source_artifacts/q2_otu_rarefied_feature-table.qza",
        tx_nrbiom = "results/qiime2/qiime2_source_artifacts/q2_otu_taxonomy.qza",
        tx_rbiom = "results/qiime2/qiime2_source_artifacts/q2_otu_rarefied_taxonomy.qza",
        map_qza = "results/qiime2/qiime2_source_artifacts/q2_metadata_mapping.qzv",
    priority: 62
    message:
        "\n =====> [QIIME2] Converting QIIME 1.9 (legacy) OTU tables to QIIME2 Artifact Files"
    benchmark:
        "benchmarks/step15/step15_QIIME2_artifact_generation.txt"
    shell:
        """
        set +u ;
        source /space/project/grdi/eco/groups/phillipsl/tools/miniconda3/bin/activate qiime2-2020.2 ;
        qiime tools import --input-path {input.nrbiom} --type 'FeatureTable[Frequency]' --input-format BIOMV210Format --output-path {output.ft_nrbiom} ;
        qiime tools import --input-path {input.rbiom} --type 'FeatureTable[Frequency]' --input-format BIOMV210Format --output-path {output.ft_rbiom} ;
        qiime tools import --input-path {input.nrbiom} --output-path {output.tx_nrbiom} --input-format BIOMV210Format --type "FeatureData[Taxonomy]" ;
        qiime tools import --input-path {input.rbiom} --output-path {output.tx_rbiom} --input-format BIOMV210Format --type "FeatureData[Taxonomy]" ;
        qiime metadata tabulate --m-input-file {input.mapping} --o-visualization {output.map_qza} ;
        conda deactivate ;
        set -u ;
        """

rule qiime2_alpha_div:
    version: "2020.2"
    input:
        ft_rbiom = "results/qiime2/qiime2_source_artifacts/q2_otu_rarefied_feature-table.qza",
    output:
        q2_metric1 = expand("results/qiime2/qiime2_alpha_div/{metric1}/{metric1}.qza", metric1={config["q2_alpha_metric"]["metric1"]}),
        q2_metric2 = expand("results/qiime2/qiime2_alpha_div/{metric2}/{metric2}.qza", metric2={config["q2_alpha_metric"]["metric2"]}),
        q2_metric3 = expand("results/qiime2/qiime2_alpha_div/{metric3}/{metric3}.qza", metric3={config["q2_alpha_metric"]["metric3"]}),
    priority: 61
    params:
        metric1 = {config["q2_alpha_metric"]["metric1"]},
        metric2 = {config["q2_alpha_metric"]["metric2"]},
        metric3 = {config["q2_alpha_metric"]["metric3"]},
    message:
        "\n =====> [QIIME 2] Computing alpha diversity metrics (based on a rarefied OTU table) | specified metrics: {config[q2_alpha_metric][metric1]}, {config[q2_alpha_metric][metric2]}, {config[q2_alpha_metric][metric3]}"
    benchmark:
        "benchmarks/step16/QIIME2_alpha_div.txt"
    shell:
        """
        set +u ;
        source /space/project/grdi/eco/groups/phillipsl/tools/miniconda3/bin/activate qiime2-2020.2 ;
        qiime diversity alpha --i-table {input.ft_rbiom} --p-metric {params.metric1} --o-alpha-diversity {output.q2_metric1} ;
        qiime diversity alpha --i-table {input.ft_rbiom} --p-metric {params.metric2} --o-alpha-diversity {output.q2_metric2} ;
        qiime diversity alpha --i-table {input.ft_rbiom} --p-metric {params.metric3} --o-alpha-diversity {output.q2_metric3} ;
        conda deactivate ;
        set -u ;
        """

rule qiime2_alpha_div_significance:
    version: "2020.2"
    input:
        q2_metric1 = expand("results/qiime2/qiime2_alpha_div/{metric1}/{metric1}.qza", metric1={config["q2_alpha_metric"]["metric1"]}),
        q2_metric2 = expand("results/qiime2/qiime2_alpha_div/{metric2}/{metric2}.qza", metric2={config["q2_alpha_metric"]["metric2"]}),
        q2_metric3 = expand("results/qiime2/qiime2_alpha_div/{metric3}/{metric3}.qza", metric3={config["q2_alpha_metric"]["metric3"]}),
        mapping = "data/mapping/metadata_mapping.txt",
    output:
        q2_sig_metric1 = expand("results/qiime2/qiime2_alpha_div/{metric1}/{metric1}_significance.qzv", metric1={config["q2_alpha_metric"]["metric1"]}),
        q2_sig_metric2 = expand("results/qiime2/qiime2_alpha_div/{metric2}/{metric2}_significance.qzv", metric2={config["q2_alpha_metric"]["metric2"]}),
        q2_sig_metric3 = expand("results/qiime2/qiime2_alpha_div/{metric3}/{metric3}_significance.qzv", metric3={config["q2_alpha_metric"]["metric3"]}),
    priority: 60
    params:
        metric1 = {config["q2_alpha_metric"]["metric1"]},
        metric2 = {config["q2_alpha_metric"]["metric2"]},
        metric3 = {config["q2_alpha_metric"]["metric3"]},
    message:
        "\n =====> [QIIME 2] Comparing alpha diversity metrics across metadata (based on a rarefied OTU table) | specified metrics: {config[q2_alpha_metric][metric1]}, {config[q2_alpha_metric][metric2]}, {config[q2_alpha_metric][metric3]}"
    benchmark:
        "benchmarks/step16/QIIME2_alpha_div_significance.txt"
    shell:
        """
        set +u ;
        source /space/project/grdi/eco/groups/phillipsl/tools/miniconda3/bin/activate qiime2-2020.2 ; 
        export PYTHONPATH='/fs/ssm/sys/base/services/rhel-6-amd64-64/lib/python:/fs/ssm/sys/base/services/all/lib/python:/fs/ssm/main/base/20191220/all/lib/python:/fs/ssm/main/env/20190814/all/lib/python' ;
        qiime diversity alpha-group-significance --i-alpha-diversity {input.q2_metric1} --m-metadata-file {input.mapping} --o-visualization {output.q2_sig_metric1} ;
        qiime diversity alpha-group-significance --i-alpha-diversity {input.q2_metric2} --m-metadata-file {input.mapping} --o-visualization {output.q2_sig_metric2} ;
        qiime diversity alpha-group-significance --i-alpha-diversity {input.q2_metric3} --m-metadata-file {input.mapping} --o-visualization {output.q2_sig_metric3} ;
        conda deactivate ;
        set -u ;
        """

rule qiime2_alpha_div_correlation:
    version: "2020.2"
    input:
        q2_metric1 = expand("results/qiime2/qiime2_alpha_div/{metric1}/{metric1}.qza", metric1={config["q2_alpha_metric"]["metric1"]}),
        q2_metric2 = expand("results/qiime2/qiime2_alpha_div/{metric2}/{metric2}.qza", metric2={config["q2_alpha_metric"]["metric2"]}),
        q2_metric3 = expand("results/qiime2/qiime2_alpha_div/{metric3}/{metric3}.qza", metric3={config["q2_alpha_metric"]["metric3"]}),
        mapping = "data/mapping/metadata_mapping.txt",
    output:
        q2_cor_metric1 = expand("results/qiime2/qiime2_alpha_div/{metric1}/{metric1}_correlation.qzv", metric1={config["q2_alpha_metric"]["metric1"]}),
        q2_cor_metric2 = expand("results/qiime2/qiime2_alpha_div/{metric2}/{metric2}_correlation.qzv", metric2={config["q2_alpha_metric"]["metric2"]}),
        q2_cor_metric3 = expand("results/qiime2/qiime2_alpha_div/{metric3}/{metric3}_correlation.qzv", metric3={config["q2_alpha_metric"]["metric3"]}),
    priority: 59
    params:
        metric1 = {config["q2_alpha_metric"]["metric1"]},
        metric2 = {config["q2_alpha_metric"]["metric2"]},
        metric3 = {config["q2_alpha_metric"]["metric3"]},
    message:
        "\n =====> [QIIME 2] Calculating correlations of alpha diversity with metadata (based on a rarefied OTU table) | specified metrics: {config[q2_alpha_metric][metric1]}, {config[q2_alpha_metric][metric2]}, {config[q2_alpha_metric][metric3]} / correlation method: {config[q2_alpha_corr][method]}"
    benchmark:
        "benchmarks/step16/QIIME2_alpha_div_correlation.txt"
    shell:
        """
        set +u ;
        source /space/project/grdi/eco/groups/phillipsl/tools/miniconda3/bin/activate qiime2-2020.2 ; 
        #export PYTHONPATH='/fs/ssm/sys/base/services/rhel-6-amd64-64/lib/python:/fs/ssm/sys/base/services/all/lib/python:/fs/ssm/main/base/20191220/all/lib/python:/fs/ssm/main/env/20190814/all/lib/python' ;
        qiime diversity alpha-correlation --i-alpha-diversity {input.q2_metric1} --m-metadata-file {input.mapping} --p-method {config[q2_alpha_corr][method]} --o-visualization {output.q2_cor_metric1} ;
        qiime diversity alpha-correlation --i-alpha-diversity {input.q2_metric2} --m-metadata-file {input.mapping} --p-method {config[q2_alpha_corr][method]} --o-visualization {output.q2_cor_metric2} ; 
        qiime diversity alpha-correlation --i-alpha-diversity {input.q2_metric3} --m-metadata-file {input.mapping} --p-method {config[q2_alpha_corr][method]} --o-visualization {output.q2_cor_metric3} ;
        conda deactivate ;
        set -u ;
        """

rule qiime2_alpha_div_plot:
    version: "2020.2"
    input:
        ft_nrbiom = "results/qiime2/qiime2_source_artifacts/q2_otu_feature-table.qza",
        ft_rbiom = "results/qiime2/qiime2_source_artifacts/q2_otu_rarefied_feature-table.qza",
        tx_nrbiom = "results/qiime2/qiime2_source_artifacts/q2_otu_taxonomy.qza",
        tx_rbiom = "results/qiime2/qiime2_source_artifacts/q2_otu_rarefied_taxonomy.qza",
        mapping = "data/mapping/metadata_mapping.txt",
    output:
        nr_taxaplot = "results/qiime2/qiime2_alpha_div/q2_non-rarefied_taxa_plots.qzv",
        r_taxaplot = "results/qiime2/qiime2_alpha_div/q2_rarefied_taxa_plots.qzv",
    priority: 58
    message:
        "\n =====> [QIIME 2] Generating Taxa Plots"
    benchmark:
        "benchmarks/step16/QIIME2_alpha_div_correlation.txt"
    shell:
        """
        set +u ;
        source /space/project/grdi/eco/groups/phillipsl/tools/miniconda3/bin/activate qiime2-2020.2 ; 
        #export PYTHONPATH='/fs/ssm/sys/base/services/rhel-6-amd64-64/lib/python:/fs/ssm/sys/base/services/all/lib/python:/fs/ssm/main/base/20191220/all/lib/python:/fs/ssm/main/env/20190814/all/lib/python' ;
        qiime taxa barplot --i-table {input.ft_nrbiom} --i-taxonomy {input.tx_nrbiom} --m-metadata-file {input.mapping} --o-visualization {output.nr_taxaplot} ;
        qiime taxa barplot --i-table {input.ft_rbiom} --i-taxonomy {input.tx_rbiom} --m-metadata-file {input.mapping} --o-visualization {output.r_taxaplot} ;
        conda deactivate ;
        set -u ;
        echo Pipeline Completed ! ;
        echo $(date -u) ;
        """
