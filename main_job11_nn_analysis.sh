#!/usr/bin/env bash

set -u
shopt -s nullglob

#-----------------------------
export STORE_DIR="/hpc/home/yk132/storage"
export CAFO_DIR="${STORE_DIR}/20230908_Dust_Redo_R9"
export CAFO_GIT_DIR="${CAFO_DIR}/CAFO_Nanopore_clean"
export LOG_DIR="${CAFO_GIT_DIR}/log_dir"
#-----------------------------

mkdir -p ${LOG_DIR}
# this file covers: metaphlan4

# Run metaphlan4
JOBID_12=$(sbatch --parsable --job-name=metaphlan --output="$LOG_DIR/%x.%j.out" --error="$LOG_DIR/%x.%j.err" Job12_metaphlan4.sh)

# Job13_metaphlan4.sh, this time without the unclassified

#JOBID_13=$(sbatch --parsable --job-name=MPA --output="$LOG_DIR/%x.%j.out" --error="$LOG_DIR/%x.%j.err" Job13_metaphlan4_nounclassified.sh)

