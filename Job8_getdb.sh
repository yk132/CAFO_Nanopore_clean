#!/usr/bin/env bash

# https://github.com/epi2me-labs/wf-metagenomics
# using pipeline ONLY to download the RefSeq marker gene database formatted for MiniMap2

#-------------------------------
export STORE_DIR="/hpc/group/gunschlab/yk132/storage"
export SCRATCH_DIR="/work/yk132/CAFO_Nanopore"
export NXF_SINGULARITY_CACHEDIR="$APPTAINER_CACHEDIR"
export NXF_WORK="${SCRATCH_DIR}/nf_working"
export NXF_TEMP="${SCRATCH_DIR}/nf_temp"
export DATA_DIR="${STORE_DIR}/20230908_Dust_Redo_R9/20230908_1516_MN33275_FAK80584_b5659fa0"
export MERGED_DIR="${DATA_DIR}/dorado_fastq_results/Merged_bam_fastq"
export BARCODE03_FASTQ="${MERGED_DIR}/barcode03_merged.fastq"
export OUTPUT_DIR="${CAFO_DIR}/Outputs"
export DB_DIR="${$OUTPUT_DIR}/Job8_db"
export RESULTS_DIR="${OUTPUT_DIR}/Job8_wf_meta_barcode03_res"
#-------------------------------

# make directories

mkdir -p $SCRATCH_DIR
mkdir -p $DB_DIR
mkdir -p $NXF_WORK
mkdir -p $NXF_TEMP
mkdir -p $RESULTS_DIR

# Run nextflow with smallest data (barcode03) to quickly download the database. 

nextflow run epi2me-labs/wf-metagenomics/main.nf \
	-profile singularity \
	-c ./nextflow.config \
	--fastq $BARCODE03_FASTQ \
	--database_set ncbi_16s_18s_28s_ITS \
	--classifier minimap2 \
	--threads 40 \
	--out_dir $RESULTS_DIR \
	--min_len 50 \
	--store_dir $DB_DIR 

