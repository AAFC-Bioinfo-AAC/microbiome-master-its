# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# >>>                                                                          >>>        
# >>> MICROBIOME MASTER [PHILLIPS AAFC-HARROW]                                 >>>
# >>> QIIME2-DADA2 SUBMODULE                                                   >>>
# >>>                                                                          >>>
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# >>> GLOBAL PARAMETERS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 
# https://github.com/aomlomics/tourmaline/blob/master/Snakefile

configfile: "config.yaml"

#if(config["tree_method"]=="fasttree"):
#    ruleorder: asv_dada2_construct_phylogeny_fasttree > asv_dada2_construct_phylogeny_raxml

#if(config["tree_method"]=="raxml"):
#    ruleorder: asv_dada2_construct_phylogeny_raxml > asv_dada2_construct_phylogeny_fasttree 

# >>> GENERAL SET-UP >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Get working directory
workdir: config["workdir"]

# Unpack the input files:
import os
import os.path
from os.path import join

#Patterns for input files 
PATTERN_INITIAL = '{file_name}' + config["input_file_extension"]

file_ext = config["input_file_extension"]
default_qiime2_conda = config["qiime2_env"]

# >>> CORE RULES >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

rule asv_dada2_import_artefact: 
    input:
        mapping = {config["mapping_file_2"]},
    output:
        qza = "data/process/qiime-dada2-module/step1_import/demux.qza",
        qzv = "data/process/qiime-dada2-module/step1_import/demux.qzv",
        checkpoint = touch("checkpoint/dada2-module/step1-complete_import.done"),
    conda: default_qiime2_conda
    message: ">>>>>> [QIIME2-DADA2 SUBMODULE] Step 1 - Importing demultiplexed forward and reverse raw reads and summarizing output"
    shell:
        """
        echo "[Process] Importing sequence files..."

        qiime tools import --type 'SampleData[PairedEndSequencesWithQuality]' \
            --input-path {input.mapping} \
            --input-format PairedEndFastqManifestPhred33V2 \
            --output-path {output.qza}

        echo "[Process] Done."
        
        echo "[Process] Summarizing import files..."
        
        qiime demux summarize --i-data {output.qza} --o-visualization {output.qzv}
        
        touch {output.checkpoint}        

        echo "[Process] Done."
        """

rule asv_dada2_itsxpress: 
    input:
        qza = "data/process/qiime-dada2-module/step1_import/demux.qza",
    output:
        itsx_out = "data/process/qiime-dada2-module/step2_itsxpress/trimmed_exact.qza",
        itsx_out_v = "data/process/qiime-dada2-module/step2_itsxpress/trimmed_exact.qzv",
        checkpoint = touch("checkpoint/dada2-module/step2-complete_itsxpress.done"),
    conda: default_qiime2_conda
    message: ">>>>>> [QIIME2-DADA2 SUBMODULE] Step 2 - Searching and extracting {config[ITSx][region]} regions from sequences"
    shell:
        """
        echo "[Process] Running ITSxpress..."

        qiime itsxpress trim-pair-output-unmerged \
            --i-per-sample-sequences {input.qza} \
            --p-region {config[ITSx][region]} \
            --p-taxa {config[ITSx][taxonomic_group]} \
            --p-cluster-id {config[ITSx][clutser_ID]} \
            --p-threads {config[ITSx][threads]} \
            --o-trimmed {output.itsx_out}

        echo "[Process] Done."

        echo "[Process] Summarizing ITSxpress output..."

        qiime demux summarize --i-data {output.itsx_out} --o-visualization {output.itsx_out_v}

        touch {output.checkpoint} 

        echo "[Process] Done."
        """

rule asv_dada2_asv: 
    input:
        itsx_out = "data/process/qiime-dada2-module/step2_itsxpress/trimmed_exact.qza",
    output:
        asvtable = "data/process/qiime-dada2-module/step3_dada2/dada2-asv-table.qza",
        repset = "data/process/qiime-dada2-module/step3_dada2/dada2-asv-rep-seqs.qza",
        repset_o = "data/process/qiime-dada2-module/step3_dada2/dada2-asv-rep-seqs.qzv",
        stats = "data/process/qiime-dada2-module/step3_dada2/dada2-asv-stats.qza",
        stats_o = "data/process/qiime-dada2-module/step3_dada2/dada2-asv-stats.qzv",
        report = "data/process/qiime-dada2-module/step3_dada2/denoising_stats/dada2_report.html",
        checkpoint = touch("checkpoint/dada2-module/step3-complete_run-dada2.done"),
    conda: default_qiime2_conda
    params:
        stats_fp = "results/qiime-dada2-module/feature_table/denoising_stats",
    message: ">>>>>> [QIIME2-DADA2 SUBMODULE] Step 3 - Identifying ASVs from ITSxpress processed sequences"
    shell:
        """
        echo "[Process] Running DADA2..."

        qiime dada2 denoise-paired \
            --i-demultiplexed-seqs {input.itsx_out} \
            --p-pooling-method {config[dada2][pooling_method]} \
            --p-n-threads {config[dada2][cores]} \
            --p-trunc-q {config[dada2][trunc_q]} \
            --p-trunc-len-r 0 \
            --p-trunc-len-f 0 \
            --p-max-ee-f {config[dada2][maxee_f]} \
	    --p-max-ee-r {config[dada2][maxee_r]} \
            --p-min-overlap {config[dada2][min_overlap]} \
	    --p-n-reads-learn {config[dada2][reads_learn]} \
	    --p-chimera-method {config[dada2][chimera_method]} \
            --p-min-fold-parent-over-abundance {config[dada2][min_fold_parent_over_abundance]} \
	    --o-table {output.asvtable} \
	    --o-representative-sequences {output.repset} \
	    --o-denoising-stats {output.stats}

        echo "[Process] Done."

        echo "[Process] Summarizing DADA2 denoised sequences..."
        
        qiime metadata tabulate \
            --m-input-file {output.stats} \
            --o-visualization {output.stats_o}

        qiime tools export --input-path {output.stats} --output-path {params.stats_fp}
        Rscript -e "rmarkdown::render('workflow/scripts/denoising_report.Rmd', 'html_document', output_file = '../../{output.report}')"

        echo "[Process] Done."

        echo "[Process] Exporting representative sequences of ASVs..."

        qiime feature-table tabulate-seqs \
            --i-data {output.repset} \
            --o-visualization {output.repset_o}

        touch {output.checkpoint}      
        """

rule asv_dada2_train_classifier: 
    input:
        repset = "data/process/qiime-dada2-module/step3_dada2/dada2-asv-rep-seqs.qza",
    output:
        unite_fasta = "data/process/qiime-dada2-module/step4_taxonomy/unite-fasta.qza",
        unite_taxonomy = "data/process/qiime-dada2-module/step4_taxonomy/unite-taxonomy.qza",
        unite_classifier = "data/process/qiime-dada2-module/step4_taxonomy/unite-classifier.qza",
        checkpoint = touch("checkpoint/dada2-module/step4a-complete_train_classifier.done"),
    conda: default_qiime2_conda
    message: ">>>>>> [QIIME2-DADA2 SUBMODULE] Step 4a - Training classifier using the UNITE database"
    shell:
        """
        echo "[Process] Assigning taxonomy using the UNITE database..."

        bash workflow/scripts/db_download.sh

        echo "[Process] Importing UNITE database into QIIME2 formats..."

        qiime tools import \
            --type 'FeatureData[Sequence]' \
            --input-path {config[taxonomy][unite_fasta]} \
            --output-path {output.unite_fasta}

        qiime tools import \
            --type 'FeatureData[Taxonomy]' \
            --input-format HeaderlessTSVTaxonomyFormat \
            --input-path {config[taxonomy][unite_taxonomy]} \
            --output-path {output.unite_taxonomy}

        echo "[Process] Done."

        echo "[Process] Training naive Bayes classifier using UNITE reference data..."

        qiime feature-classifier fit-classifier-naive-bayes \
            --i-reference-reads {output.unite_fasta} \
            --i-reference-taxonomy {output.unite_taxonomy} \
            --o-classifier {output.unite_classifier}

        touch {output.checkpoint}

        echo "[Process] Done."
        """

rule asv_dada2_taxonomy: 
    input:
        unite_classifier = "data/process/qiime-dada2-module/step4_taxonomy/unite-classifier.qza",
        repset = "data/process/qiime-dada2-module/step3_dada2/dada2-asv-rep-seqs.qza",
    output:
        sklearn = "data/process/qiime-dada2-module/step4_taxonomy/taxonomy.qza",
        sklearn_o = "data/process/qiime-dada2-module/step4_taxonomy/taxonomy.qzv",
        repset_tabulate = "data/process/qiime-dada2-module/step4_taxonomy/repset_tabulated.qzv",
        sklearn_tsv_o = "data/process/qiime-dada2-module/step4_taxonomy/taxonomy.tsv",
        sklearn_tsv_f = "data/process/qiime-dada2-module/step4_taxonomy/taxonomy_formatted.tsv",
        checkpoint = touch("checkpoint/dada2-module/step4b-complete_assign-taxonomy.done"),
    conda: default_qiime2_conda
    message: ">>>>>> [QIIME2-DADA2 SUBMODULE] Step 4b - Assigning taxonomy to ASVs"
    shell:
        """
        echo "[Process] Classifying ASVs against the UNITE database..."

        qiime feature-classifier classify-sklearn \
            --i-classifier {input.unite_classifier} \
            --i-reads {input.repset} \
            --p-n-jobs {config[taxonomy][cores]} \
            --p-confidence {config[taxonomy][confidence_threshold]} \
            --p-pre-dispatch {config[taxonomy][dispatch]} \
            --o-classification {output.sklearn}

        echo "[Process] Done."

        echo "[Process] Summarizing taxonomic assignments and generating outputs..."

        qiime metadata tabulate \
            --m-input-file {output.sklearn} \
            --o-visualization {output.sklearn_o}

        qiime metadata tabulate \
            --m-input-file {input.repset} \
            --m-input-file {output.sklearn} \
            --o-visualization {output.repset_tabulate}

        echo "[Process] Done."

        qiime tools export \
            --input-path {output.sklearn} \
            --output-path {output.sklearn_tsv_o} \
            --output-format TSVTaxonomyFormat

        Rscript workflow/scripts/format_taxonomy_v2.R -i {output.sklearn_tsv_o} -o {output.sklearn_tsv_f}
        
        touch {output.checkpoint}

        echo "[Process] Done."
        """

rule asv_dada2_create_feature_table: 
    input:
        asvtable = "data/process/qiime-dada2-module/step3_dada2/dada2-asv-table.qza",
        taxonomy = "data/process/qiime-dada2-module/step4_taxonomy/taxonomy.qza",
        sklearn_tsvf_o = "data/process/qiime-dada2-module/step4_taxonomy/taxonomy_formatted.tsv",
    output:
        filtered_table = "results/qiime-dada2-module/feature_table/dada2-asv-table_filtered.qza",
        feat = "results/qiime-dada2-module/feature_table/dada2-asv-table_filtered.biom",
        tsv = "results/qiime-dada2-module/feature_table/dada2-asv-table_filtered.tsv",
        biom_tax = "results/qiime-dada2-module/feature_table/dada2-asv-table-taxonomy_filtered.biom",
        tsv_tax = "results/qiime-dada2-module/feature_table/dada2-asv-table-taxonomy_filtered.tsv",
        summary = "results/qiime-dada2-module/feature_table/feature_table_summary.tsv",
        checkpoint = touch("checkpoint/dada2-module/step5-complete_compile-feature-table.done"),
    priority: 2
    conda: default_qiime2_conda
    message: ">>>>>> [QIIME2-DADA2 SUBMODULE] Step 5 - Compiling Feature Tables"
    shell:
        """
        echo "[Process] Filtering non-fungal taxonomic hits from data before conversion..."

        qiime taxa filter-table --i-table {input.asvtable} --i-taxonomy {input.taxonomy} --p-include Fungi --o-filtered-table {output.filtered_table}
        
        echo "[Process] Generating ASV feature table and converting output to biom and tsv files..."

        qiime tools export --input-path {output.filtered_table} --output-path results/qiime-dada2-module/feature_table

        mv results/qiime-dada2-module/feature_table/feature-table.biom {output.feat}

        biom convert -i {output.feat}  -o {output.tsv} --to-tsv
        biom add-metadata -i {output.feat} -o {output.biom_tax} --observation-metadata-fp {input.sklearn_tsvf_o} --sc-separated taxonomy
        biom convert -i {output.biom_tax} -o {output.tsv_tax} --to-tsv --header-key taxonomy
        biom summarize-table -i {output.biom_tax} -o {output.summary}

        touch {output.checkpoint}

        echo "[Process] Done."
        """

rule asv_dada2_rarefy_feature_table: 
    input:
        table = "data/process/qiime-dada2-module/step3_dada2/dada2-asv-table.qza",
        sklearn_tsvf_o = "data/process/qiime-dada2-module/step4_taxonomy/taxonomy_formatted.tsv",
    output:
        rarefy = "results/qiime-dada2-module/feature_table/rarefied/rarefied-dada2-asv-table_filtered.qza",
        rarefy_biom = "results/qiime-dada2-module/feature_table/rarefied/rarefied-dada2-asv-table_filtered.biom",
        rarefy_tsv = "results/qiime-dada2-module/feature_table/rarefied/rarefied-dada2-asv-table_filtered.tsv", 
        rarefy_biom_tax = "results/qiime-dada2-module/feature_table/rarefied/rarefied-dada2-asv-table-taxonomy_filtered.biom",
        rarefy_tsv_tax = "results/qiime-dada2-module/feature_table/rarefied/rarefied-dada2-asv-table-taxonomy_filtered.tsv",
        summary = "results/qiime-dada2-module/feature_table/rarefied/rarefied_feature_table_summary.tsv",
        checkpoint = touch("checkpoint/dada2-module/step6-complete_rarefy-feature-table.done"),
    conda: default_qiime2_conda
    message: ">>>>>> [QIIME2-DADA2 SUBMODULE] Step 6 - Rarefying Feature Tables"
    shell:
        """
        echo "[Process] Rarefying ASV feature table and converting output to biom and tsv files..."

        qiime feature-table rarefy --i-table {input.table} --p-sampling-depth {config[rarefaction_depth]} --o-rarefied-table {output.rarefy}

        qiime tools export --input-path {output.rarefy} --output-path results/qiime-dada2-module/feature_table/rarefied/

        mv results/qiime-dada2-module/feature_table/rarefied/feature-table.biom {output.rarefy_biom} 

        biom convert -i {output.rarefy_biom}  -o {output.rarefy_tsv} --to-tsv
        biom add-metadata -i {output.rarefy_biom} -o {output.rarefy_biom_tax} --observation-metadata-fp {input.sklearn_tsvf_o} --sc-separated taxonomy
        biom convert -i {output.rarefy_biom_tax} -o {output.rarefy_tsv_tax} --to-tsv --header-key taxonomy
        biom summarize-table -i {output.rarefy_biom_tax} -o {output.summary}

        touch {output.checkpoint}

        echo "[Process] Done."
        """

rule asv_dada2_visualize_taxonomy: 
    input:
        feature_table = "results/qiime-dada2-module/feature_table/dada2-asv-table_filtered.qza",
        feature_table_rarefied = "results/qiime-dada2-module/feature_table/rarefied/rarefied-dada2-asv-table_filtered.qza",
        taxonomy = "data/process/qiime-dada2-module/step4_taxonomy/taxonomy.qza",
    output:
        taxa_plot = "results/qiime-dada2-module/taxa_plots/taxa-bar-nr.qzv",
        taxa_plot_r = "results/qiime-dada2-module/taxa_plots/taxa-bar-r.qzv",
        checkpoint = touch("checkpoint/dada2-module/step7-complete_visualize-taxonomy.done"),
    conda: default_qiime2_conda
    message: ">>>>>> [QIIME2-DADA2 SUBMODULE] Step 7 - Generating taxa plot outputs"
    shell:
        """
        echo "[Process] Generating non-rarefied taxa plots..."

        qiime taxa barplot \
            --i-table {input.feature_table} \
            --i-taxonomy {input.taxonomy} \
            --m-metadata-file {config[mapping_file_2]} \
            --o-visualization {output.taxa_plot}

        echo "[Process] Done."

        echo "[Process] Generating rarefied taxa plots..."

        qiime taxa barplot \
            --i-table {input.feature_table_rarefied} \
            --i-taxonomy {input.taxonomy} \
            --m-metadata-file {config[mapping_file_2]} \
            --o-visualization {output.taxa_plot_r}

        touch {output.checkpoint}

        echo "[Process] Done."
        """

rule asv_dada2_alpha_rarefaction: 
    input:
        feature_table = "results/qiime-dada2-module/feature_table/dada2-asv-table_filtered.qza",
        mapping = {config["mapping_file_2"]},
    output:
        rarefaction = "results/qiime-dada2-module/alpha_rarefaction/alpha-rarefaction.qzv",
        checkpoint = touch("checkpoint/dada2-module/step8-complete_alpha-rarefaction.done"),
    conda: default_qiime2_conda
    message: ">>>>>> [QIIME2-DADA2 SUBMODULE] Step 8 - Generating alpha rarefaction plots"
    shell:
        """
        echo "[Process] Generating alpha rarefaction plots..."
        
        qiime diversity alpha-rarefaction \
            --i-table {input.feature_table} \
            --p-max-depth {config[rarefaction_depth]} \
            --p-min-depth {config[alpha_min_depth]} \
            --p-steps {config[alpha_steps]} \
            --p-iterations {config[alpha_interations]} \
            --m-metadata-file {input.mapping} \
            --o-visualization {output.rarefaction}

        touch {output.checkpoint}

        echo "[Process] Done."
        """

rule asv_dada2_alpha_diversity: 
    input:
        #feature_table = "results/qiime-dada2-module/feature_table/dada2-asv-table_filtered.qza",
        feature_table_rarefied = "results/qiime-dada2-module/feature_table/rarefied/rarefied-dada2-asv-table_filtered.qza",
        mapping = {config["mapping_file_2"]},
    output:
        shannon_o = "results/qiime-dada2-module/alpha_diversity/shannon.qza",
        observed_o = "results/qiime-dada2-module/alpha_diversity/observed.qza",
        evenness_o = "results/qiime-dada2-module/alpha_diversity/evenness.qza",
        shannon = "results/qiime-dada2-module/alpha_diversity/kruskal-wallis/shannon-group-significance.qzv",
        observed = "results/qiime-dada2-module/alpha_diversity/kruskal-wallis/observed-group-significance.qzv",
        evenness = "results/qiime-dada2-module/alpha_diversity/kruskal-wallis/evenness-group-significance.qzv",
        shannon_c = "results/qiime-dada2-module/alpha_diversity/correlations/shannon-correlation.qzv",
        observed_c = "results/qiime-dada2-module/alpha_diversity/correlations/observed-correlation.qzv",
        evenness_c = "results/qiime-dada2-module/alpha_diversity/correlations/evenness-correlation.qzv",
        checkpoint = touch("checkpoint/dada2-module/step9-complete_alpha-diversity.done"),
    conda: default_qiime2_conda
    message: ">>>>>> [QIIME2-DADA2 SUBMODULE] Step 9 - Running alpha diversity analyses"
    shell:
        """
        echo "[Process] Calculting core alpha diversity..."
        
        qiime diversity alpha --i-table {input.feature_table_rarefied} --p-metric shannon --o-alpha-diversity {output.shannon_o}
        qiime diversity alpha --i-table {input.feature_table_rarefied} --p-metric observed_features --o-alpha-diversity {output.observed_o}
        qiime diversity alpha --i-table {input.feature_table_rarefied} --p-metric simpson --o-alpha-diversity {output.evenness_o}

        echo "[Process] Done."

        echo "[Process] Conducting KW Tests between metadata and diversity metrics..."

        qiime diversity alpha-group-significance --i-alpha-diversity {output.shannon_o} --m-metadata-file {input.mapping} --o-visualization {output.shannon}
        qiime diversity alpha-group-significance --i-alpha-diversity {output.observed_o} --m-metadata-file {input.mapping} --o-visualization {output.observed}
        qiime diversity alpha-group-significance --i-alpha-diversity {output.evenness_o} --m-metadata-file {input.mapping} --o-visualization {output.evenness}

        echo "[Process] Done."

        echo "[Process] Conducting correlation tests between metadata and diversity metrics..."

        qiime diversity alpha-correlation --i-alpha-diversity {output.shannon_o} --m-metadata-file {input.mapping} --o-visualization {output.shannon_c}
        qiime diversity alpha-correlation --i-alpha-diversity {output.observed_o} --m-metadata-file {input.mapping} --o-visualization {output.observed_c}
        qiime diversity alpha-correlation --i-alpha-diversity {output.evenness_o} --m-metadata-file {input.mapping} --o-visualization {output.evenness_c}

        touch {output.checkpoint}

        echo "[Process] Done."
        """

rule asv_dada2_beta_diversity: 
    input:
        feature_table_rarefied = "results/qiime-dada2-module/feature_table/rarefied/rarefied-dada2-asv-table_filtered.qza",
        taxonomy = "data/process/qiime-dada2-module/step4_taxonomy/taxonomy.qza",
        mapping = {config["mapping_file_2"]},
        rep_set = "data/process/qiime-dada2-module/step3_dada2/dada2-asv-rep-seqs.qza",
    output:
        bray = "results/qiime-dada2-module/beta_diversity/bray_curtis.qza",
        bray_pcoa = "results/qiime-dada2-module/beta_diversity/bray_curtis_pcoa.qza",
        bray_pcoa_biplot = "results/qiime-dada2-module/beta_diversity/bray_curtis_pcoa_biplot.qza",
        bray_pcoa_emp = "results/qiime-dada2-module/beta_diversity/bray_curtis_pcoa_emperor.qzv",
        feature_table_rarefied_rf = "results/qiime-dada2-module/feature_table/rarefied/rarefied-dada2-asv-table_rf.qza",
        checkpoint = touch("checkpoint/dada2-module/step10-complete_beta-diversity.done"),
    conda: default_qiime2_conda
    message: ">>>>>> [QIIME2-DADA2 SUBMODULE] Step 10 - Generating beta-diversity outputs"
    shell:
        """
        echo "[Process] Calculating Bray-Curtis (dis)similarities..."

        qiime diversity beta \
            --i-table {input.feature_table_rarefied} \
            --p-metric braycurtis \
            --p-n-jobs auto \
            --o-distance-matrix {output.bray}

        echo "[Process] Done."

        echo "[Process] Conducting Principal Coordinate Analysis on pair-wise distance matrices..."

        qiime diversity pcoa --i-distance-matrix {output.bray} --o-pcoa {output.bray_pcoa}

        echo "[Process] Done."

        echo "[Process] Generating Emperor PCoA biplots..."

        qiime feature-table relative-frequency --i-table {input.feature_table_rarefied} --o-relative-frequency-table {output.feature_table_rarefied_rf}

        qiime diversity pcoa-biplot --i-pcoa {output.bray_pcoa} --i-features {output.feature_table_rarefied_rf} --o-biplot {output.bray_pcoa_biplot}
        qiime emperor biplot --i-biplot {output.bray_pcoa_biplot} --m-sample-metadata-file {input.mapping} --m-feature-metadata-file {input.rep_set} --o-visualization {output.bray_pcoa_emp}

        echo "[Process] Done."

        touch {output.checkpoint}
        """

rule asv_dada2_funguild: 
    input:
        otu = "results/qiime-dada2-module/feature_table/rarefied/rarefied-dada2-asv-table-taxonomy_filtered.tsv",
        #mapping = {config["mapping_file_2"]},
    output:
        funguild_formatted = "results/qiime-dada2-module/funguild/rarefied-dada2-asv-table-taxonomy_filtered_funguild-formatted.txt",
        guilds = "results/qiime-dada2-module/funguild/rarefied-dada2-asv-table-taxonomy_filtered_funguild-formatted.guilds.txt",
        checkpoint = touch("checkpoint/dada2-module/step11-complete_funguild.done"), 
        check_final = touch("checkpoint/ITS-dada2-complete.done"),
    conda: default_qiime2_conda
    message: ">>>>>> [QIIME2-DADA2 SUBMODULE] Step 11 - Starting FUNGuild analysis"
    shell:
        """
        echo "[Process] Starting FUNGuild analysis..."

        Rscript workflow/scripts/strip_otu_table_v2.R -i {input.otu} -o {output.funguild_formatted}
        touch {output.funguild_formatted}

        python {config[funguild][path_guilds]} -otu {output.funguild_formatted} -db fungi -m -u
        touch {output.guilds}

        touch {output.checkpoint}
        echo "[Process] Done."

        touch {output.check_final}
        """