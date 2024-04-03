#!/usr/bin/env bash

set -u
shopt -s nullglob

#-----------------------------
SCRATCH_DIR="/work"
export NUM_READS=100
export RANDOM_SEED=12345
# export SIF_PATH="/work/${USER}/images/meta-methylome-simage_v002.sif"
export SIF_PATH="oras://gitlab-registry.oit.duke.edu/granek-lab/granek-container-images/meta-methylome-simage:v002"
#-----------------------------

WORK_DIR="${SCRATCH_DIR}/${USER}/eva_2023_06_28"
export RESULTS_DIR="${WORK_DIR}/results_${NUM_READS}"
export LOG_DIR="${RESULTS_DIR}/log_dir"

export MUXFASTQ_DIR="${RESULTS_DIR}/mux_fastq"
export DEMUX_DIR="${RESULTS_DIR}/demux"
# export BAM_DIR="${RESULTS_DIR}/bam_dir"

# export DORADO_OUTPUT_BAM=${BAM_DIR}/multiplexed_unmapped.bam
export DORADO_OUTPUT_FASTQ=${MUXFASTQ_DIR}/multiplexed.fastq.gz
# export DORADO_OUTPUT_FASTQ_GZ=${MUXFASTQ_DIR}/multiplexed.fastq.gz
# export FINAL_BAM=${DORADO_OUTPUT_BAM/_unmapped/""}

export DATA_DIR="${WORK_DIR}/seqdata"
export FAST5_DIR="/hpc/group/graneklab/projects/premier/eva_nanopore_2023_06_28/Recover"
export POD5_DIR="${DATA_DIR}/pod5"

export DORADO_MODEL_DIR="${WORK_DIR}/models"

export DORADO__941_5MCG_MODEL="dna_r9.4.1_e8_sup@v3.3_5mCG@v0"
export DORADO__941_SUP_MODEL="dna_r9.4.1_e8_sup@v3.3" # "dna_r9.4.1_e8_sup@v3.6" # 

export BARCODE_KIT="SQK-RBK004"

#-----------------------------
#-----------------------------

mkdir -p ${LOG_DIR}
# mkdir -p ${BAM_DIR} # Need to make OUTPUT directories here if using sbatch arrays

# Download Dorado Models
JOBID_5=$(sbatch --parsable --job-name=download_models --output="$LOG_DIR/%x-%A-%a.log" --error="$LOG_DIR/%x-%A-%a.log" sbatch_download_models_job.sh)

# # FAST5 to POD5
JOBID_6=$(sbatch --parsable --job-name=fast5_to_pod5 --output="$LOG_DIR/%x-%A-%a.log" --error="$LOG_DIR/%x-%A-%a.log" sbatch_pod5_job.sh)

# # Run Dorado
JOBID_7=$(sbatch --parsable --dependency=afterok:${JOBID_6}:${JOBID_5} --job-name=dorado --output="$LOG_DIR/%x-%A-%a.log" --error="$LOG_DIR/%x-%A-%a.log" sbatch_dorado_job.sh)

# Demux with Guppy
JOBID_8=$(sbatch --parsable --dependency=afterok:$JOBID_7 --job-name=demux --output="$LOG_DIR/%x-%A-%a.log" --error="$LOG_DIR/%x-%A-%a.log" sbatch_demux_job.sh)

# 
# # Run Mapping and Sorting
# JOBID_8=$(sbatch --parsable --dependency=afterok:$JOBID_7 --job-name=map --output="$LOG_DIR/%x-%A-%a.log" --error="$LOG_DIR/%x-%A-%a.log" sbatch_map_job.sh)
# 
# # Run Modkit
# JOBID_9=$(sbatch --parsable --dependency=afterok:$JOBID_8 --job-name=modkit --output="$LOG_DIR/%x-%A-%a.log" --error="$LOG_DIR/%x-%A-%a.log" sbatch_modkit_job.sh)



