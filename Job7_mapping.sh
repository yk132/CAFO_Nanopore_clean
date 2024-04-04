#!/usr/bin/env bash
#SBATCH --partition=chsi
#SBATCH -A chsi
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=100G
#SBATCH --mail-type=ALL

set -u

#-------------------------------
export STORE_DIR="/hpc/home/yk132/storage"
export CAFO_DIR="${STORE_DIR}/20230908_Dust_Redo_R9"
export CAFO_GIT_DIR="${CAFO_DIR}/CAFO_Nanopore_clean"
export WORK_DIR="/work/${USER}" # CHANGE ME if needed 
export CAFO_WORK_DIR="${WORK_DIR}/CAFO_Nanopore_work"
export OUTPUT_DIR="${CAFO_DIR}/Outputs"
export SLURM_CPUS_PER_TASK="16" # CHANGE ME
export MERGED_DIR="${OUTPUT_DIR}/Job4_merged_fastq"
export BAR01_MERGED="${MERGED_DIR}/barcode01_merged.fastq"
export BAR02_MERGED="${MERGED_DIR}/barcode02_merged.fastq"
export ILAB_DIR="${STORE_DIR}/ILAB_Dust"
export SPADES_OUTPUT="${OUTPUT_DIR}/Job5_metaSPAdes"
export SPADES_1="${SPADES_OUTPUT}/barcode01"
export SPADES_2="${SPADES_OUTPUT}/barcode02"
export CONTIG_01="${SPADES_1}/contigs.fasta"
export CONTIG_02="${SPADES_2}/contigs.fasta"
export ILAB_DIR="${STORE_DIR}/ILAB_Dust"
export MAP_DIR="${OUTPUT_DIR}/Job7_mapping"
#-------------------------------

#-------------------------------
mkdir -p $MAP_DIR
#-------------------------------

# Build indexer
## barcode 1 is Farm C 
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/bowtie2:2.5.1 \
        bowtie2-build $SLURM_CPUS_PER_TASK $CONTIG_01 $MAP_DIR/barcode01_assembly \
  --threads $SLURM_CPUS_PER_TASK

# Build indexer
## barcode 2 is Farm A 
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/bowtie2:2.5.1 \
        bowtie2-build $SLURM_CPUS_PER_TASK $CONTIG_02 $MAP_DIR/barcode02_assembly \
  --threads $SLURM_CPUS_PER_TASK