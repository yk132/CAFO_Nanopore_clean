#!/usr/bin/env bash
#SBATCH --partition=dmcshared
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40
#SBATCH --mem=300G
#SBATCH --mail-type=ALL

set -u

# now that wf-metagenomics accepts .bam as input, can we use the Minimap results .bam files as input? 

#-------------------------------
export STORE_DIR="/hpc/home/yk132/storage"
export CAFO_DIR="${STORE_DIR}/20230908_Dust_Redo_R9"
export CAFO_GIT_DIR="${CAFO_DIR}/CAFO_Nanopore"
export SLURM_CPUS_PER_TASK="40" # CHANGE ME
export MINIMAP2_OUTPUT="${CAFO_DIR}/Minimap_res"
export DATABASE_PARENT_DIR="${STORE_DIR}/wf_meta_db/ncbi_16s_18s_28s_ITS"
export DATABASE_DIR="${DATABASE_PARENT_DIR}/ncbi_16s_18s_28s_ITS_db"
export DATABASE_FNA="${DATABASE_DIR}/ncbi_16s_18s_28s_ITS.fna"
export DATABASE_MMI="${DATABASE_DIR}/ncbi_16s_18s_28s_ITS.mmi"
export BAR01_BAM="${MINIMAP2_OUTPUT}/barcode01_alignment.bam"
export BAR02_BAM="${MINIMAP2_OUTPUT}/barcode02_alignment.bam"
export BAR03_BAM="${MINIMAP2_OUTPUT}/barcode03_alignment.bam"

export NXF_SINGULARITY_CACHEDIR="$APPTAINER_CACHEDIR"
export DB_DIR="${STORE_DIR}/wf_meta_db/ncbi_16s_18s_28s_ITS_db"
export SCRATCH_DIR="/work/yk132/CAFO_Nanopore"
export NXF_WORK="${SCRATCH_DIR}/nf_working"
export NXF_TEMP="${SCRATCH_DIR}/nf_temp"
export RES_DIR01="${CAFO_DIR}/wf_meta_bam_res_barcode01"
export RES_DIR02="${CAFO_DIR}/wf_meta_bam_res_barcode02"
export RES_DIR03="${CAFO_DIR}/wf_meta_bam_res_barcode03"
#------------------------------

# make directories

mkdir -p $SCRATCH_DIR
mkdir -p $DB_DIR
mkdir -p $NXF_WORK
mkdir -p $NXF_TEMP
mkdir -p $RES_DIR01
mkdir -p $RES_DIR02
mkdir -p $RES_DIR03

# update wf-metagenomics
nextflow pull epi2me-labs/wf-metagenomics/

# Run nextflow on barcode 01

nextflow run epi2me-labs/wf-metagenomics/main.nf \
	-profile singularity \
	-c ./nextflow.config \
	--bam $BAR02_BAM \
	--database_set ncbi_16s_18s_28s_ITS \
	--classifier minimap2 \
	--threads 40 \
	--out_dir $RES_DIR02 \
	--min_len 50 \
#	--amr \
#	--amr_db resfinder \
	--store_dir $DB_DIR 
