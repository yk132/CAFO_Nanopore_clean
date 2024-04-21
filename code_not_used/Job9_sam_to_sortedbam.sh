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
export SLURM_CPUS_PER_TASK="40" # CHANGE ME
export MINIMAP2_OUTPUT="${CAFO_DIR}/Minimap_res"
export DATABASE_PARENT_DIR="${STORE_DIR}/wf_meta_db/ncbi_16s_18s_28s_ITS"
export DATABASE_DIR="${DATABASE_PARENT_DIR}/ncbi_16s_18s_28s_ITS_db"
export DATABASE_FNA="${DATABASE_DIR}/ncbi_16s_18s_28s_ITS.fna"
export DATABASE_MMI="${DATABASE_DIR}/ncbi_16s_18s_28s_ITS.mmi"
export BAR01_SAM="${MINIMAP2_OUTPUT}/barcode01_alignment.sam"
export BAR02_SAM="${MINIMAP2_OUTPUT}/barcode02_alignment.sam"
export BAR03_SAM="${MINIMAP2_OUTPUT}/barcode03_alignment.sam"
export BAR01_BAM="${MINIMAP2_OUTPUT}/barcode01_alignment.bam"
export BAR02_BAM="${MINIMAP2_OUTPUT}/barcode02_alignment.bam"
export BAR03_BAM="${MINIMAP2_OUTPUT}/barcode03_alignment.bam"


export BAR01_BAM_SORTED="${MINIMAP2_OUTPUT}/barcode01_alignment.sorted.bam"
export BAR02_BAM_SORTED="${MINIMAP2_OUTPUT}/barcode02_alignment.sorted.bam"
export BAR03_BAM_SORTED="${MINIMAP2_OUTPUT}/barcode03_alignment.sorted.bam"
#------------------------------

# Sort and index BAM files
## staphb/samtools = staphb/samtools:1.19

singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/samtools \
	samtools sort -O BAM --write-index -o $BAR01_BAM_SORTED $BAR01_BAM
	
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/samtools \
	samtools sort -O BAM --write-index -o $BAR02_BAM_SORTED $BAR02_BAM
	
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/samtools \
	samtools sort -O BAM --write-index -o $BAR03_BAM_SORTED $BAR03_BAM


## for reference: create flagstat

singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/samtools \
	samtools flagstat $BAR01_BAM_SORTED > $MINIMAP2_OUTPUT/bar01_stat.txt

	
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/samtools \
	samtools flagstat $BAR02_BAM_SORTED > $MINIMAP2_OUTPUT/bar02_stat.txt
	
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/samtools \
	samtools flagstat $BAR03_BAM_SORTED > $MINIMAP2_OUTPUT/bar03_stat.txt
