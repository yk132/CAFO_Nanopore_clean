#!/usr/bin/env bash
#SBATCH --partition=dmcshared
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=30
#SBATCH --mem=300G
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
export MERGED_DIR="${DORADO_RESULTS_DIR}/Merged_bam_fastq"
export BAR01_MERGED="${MERGED_DIR}/barcode01_merged.fastq"
export BAR02_MERGED="${MERGED_DIR}/barcode02_merged.fastq"
export BAR03_MERGED="${MERGED_DIR}/barcode03_merged.fastq"
export ILAB_DIR="${STORE_DIR}/ILAB_Dust"

export SPADES_OUTPUT="${CAFO_DIR}/metaSPAdes"
export SPADES_1="${SPADES_OUTPUT}/barcode01"
export SPADES_2="${SPADES_OUTPUT}/barcode02"
export SPADES_3="${SPADES_OUTPUT}/barcode03"
#------------------------------

# make output directories 
mkdir -p $SPADES_OUTPUT
mkdir -p $SPADES_1
mkdir -p $SPADES_2

#//staphb/spades:latest = //staphb/spades:3.15.5

# Run metaSPAdes on barcode 1
## barcode 1 is Farm C 
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/spades:latest \
        spades.py --meta \
	-t 30 \
	-m 300 \
        --pe1-1 $ILAB_DIR/Farm_C_Dust_S2_L001_R1_001.fastq.gz \
        --pe1-2 $ILAB_DIR/Farm_C_Dust_S2_L001_R2_001.fastq.gz \
        --nanopore $BAR01_MERGED \
	-o $SPADES_1

# Run metaSPAdes on barcode 2
## barcode 2 is Farm C 
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/spades:latest \
        spades.py --meta \
	-t 30 \
	-m 300 \
        --pe1-1 $ILAB_DIR/Farm_A_Dust_S3_L001_R1_001.fastq.gz \
        --pe1-2 $ILAB_DIR/Farm_A_Dust_S3_L001_R2_001.fastq.gz \
        --nanopore $BAR02_MERGED \
	-o $SPADES_2	
