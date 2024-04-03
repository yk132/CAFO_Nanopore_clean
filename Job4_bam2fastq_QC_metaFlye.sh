#!/usr/bin/env bash
#SBATCH --partition=chsi
#SBATCH -A chsi
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40
#SBATCH --mem=500G
#SBATCH --mail-type=ALL

set -u

#-------------------------------
export STORE_DIR="/hpc/home/yk132/storage"
export CAFO_DIR="${STORE_DIR}/20230908_Dust_Redo_R9"
export CAFO_GIT_DIR="${CAFO_DIR}/CAFO_Nanopore"
export WORK_DIR="/work/${USER}"
export FILE_DIR="${CAFO_DIR}/20230908_1516_MN33275_FAK80584_b5659fa0"
export DORADO_RESULTS_DIR="${FILE_DIR}/dorado_fastq_results"
export IMAGEDIR="${WORK_DIR}/images"
export SLURM_CPUS_PER_TASK="40" # CHANGE ME
export FLYE_OUT_DIR="${FILE_DIR}/flye_output"
export FASTQC_DIR="${FILE_DIR}/QC"
export DEMUXED_DIR="${DORADO_RESULTS_DIR}/unclassified_demuxed"
export BAR01_BAM="${DEMUXED_DIR}/SQK-RPB004_barcode01.bam"
export BAR02_BAM="${DEMUXED_DIR}/SQK-RPB004_barcode02.bam"
export BAR03_BAM="${DEMUXED_DIR}/SQK-RPB004_barcode03.bam"
export BAR01_FASTQ="${DORADO_RESULTS_DIR}/SQK-RPB004_barcode01.fastq"
export BAR02_FASTQ="${DORADO_RESULTS_DIR}/SQK-RPB004_barcode02.fastq"
export BAR03_FASTQ="${DORADO_RESULTS_DIR}/SQK-RPB004_barcode03.fastq"
export MERGED_DIR="${DORADO_RESULTS_DIR}/Merged_bam_fastq"
export BAR01_MERGED="${MERGED_DIR}/barcode01_merged.fastq"
export BAR02_MERGED="${MERGED_DIR}/barcode02_merged.fastq"
export BAR03_MERGED="${MERGED_DIR}/barcode03_merged.fastq"
export FLYE_OUT_DIR_01="${FLYE_OUT_DIR}/barcode01"
export FLYE_OUT_DIR_02="${FLYE_OUT_DIR}/barcode02"
export FLYE_OUT_DIR_03="${FLYE_OUT_DIR}/barcode03"
export DORADO_SIF_PATH='oras://gitlab-registry.oit.duke.edu/granek-lab/granek-container-images/dorado-simg:0.4.2'
#------------------------------

# Make sure that BAM files exist
if [ -f "${BAR01_BAM}" ]; then 
  echo "${BAR01_BAM} exists."
else
  echo "${BAR01_BAM} does NOT exist. Check previous code"
fi

if [ -f "${BAR02_BAM}" ]; then 
  echo "${BAR02_BAM} exists."
else
  echo "${BAR02_BAM} does NOT exist. Check previous code"
fi

if [ -f "${BAR03_BAM}" ]; then 
  echo "${BAR03_BAM} exists."
else
  echo "${BAR03_BAM} does NOT exist. Check previous code"
fi

# Turn .bam files from unclassified into fastq files 
## the singularity container for dorado contains samtools
if [ -f "${BAR01_FASTQ}" ]; then 
  echo "${BAR01_FASTQ} exists."
else
  echo "${BAR01_FASTQ} does NOT exist. Need to run samtools fastq"
# remove previous .fastq file if necessary
  rm $BAR01_FASTQ
  singularity exec \
  --bind /work:/work \
  --bind /hpc/group:/hpc/group \
  ${DORADO_SIF_PATH} \
  samtools fastq --threads $SLURM_CPUS_PER_TASK $BAR01_BAM > $BAR01_FASTQ
fi

if [ -f "${BAR02_FASTQ}" ]; then 
  echo "${BAR02_FASTQ} exists."
else
  echo "${BAR02_FASTQ} does NOT exist. Need to run samtools fastq"
# remove previous .fastq file if necessary
  rm $BAR02_FASTQ
  singularity exec \
  --bind /work:/work \
  --bind /hpc/group:/hpc/group \
  ${DORADO_SIF_PATH} \
  samtools fastq --threads $SLURM_CPUS_PER_TASK $BAR02_BAM > $BAR02_FASTQ
fi

if [ -f "${BAR03_FASTQ}" ]; then 
  echo "${BAR03_FASTQ} exists."
else
  echo "${BAR03_FASTQ} does NOT exist. Need to run samtools fastq"
# remove previous .fastq file if necessary
  rm $BAR03_FASTQ
  singularity exec \
  --bind /work:/work \
  --bind /hpc/group:/hpc/group \
  ${DORADO_SIF_PATH} \
  samtools fastq --threads $SLURM_CPUS_PER_TASK $BAR03_BAM > $BAR03_FASTQ
fi

# merge fastq files 
mkdir -p $MERGED_DIR

cat ${DORADO_RESULTS_DIR}/*01.fastq > $BAR01_MERGED
cat ${DORADO_RESULTS_DIR}/*02.fastq > $BAR02_MERGED
cat ${DORADO_RESULTS_DIR}/*03.fastq > $BAR03_MERGED

# output folder for fastqc
mkdir -p $FASTQC_DIR

# Run FastQC on raw reads
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/fastqc:latest \
	fastqc -o $FASTQC_DIR --extract --memory 10000 -t 24 -f fastq \
	$MERGED_DIR/* 

# Get FastQC version for reproducibility
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/fastqc:latest \
	fastqc -v 

# make output folder for metaFlye
mkdir -p $FLYE_OUT_DIR
mkdir -p $FLYE_OUT_DIR_01
mkdir -p $FLYE_OUT_DIR_02
mkdir -p $FLYE_OUT_DIR_03

# Run metaFlye for EACH barcode! 
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/flye:latest \
	flye --nano-raw $BAR01_MERGED \
	--meta -t $SLURM_CPUS_PER_TASK -o $FLYE_OUT_DIR_01

singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/flye:latest \
	flye --nano-raw $BAR02_MERGED \
	--meta -t $SLURM_CPUS_PER_TASK -o $FLYE_OUT_DIR_02

 singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/flye:latest \
	flye --nano-raw $BAR03_MERGED \
	--meta -t $SLURM_CPUS_PER_TASK -o $FLYE_OUT_DIR_03

# Get Flye version for reproducibility
 singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/flye:latest \
	flye -v
