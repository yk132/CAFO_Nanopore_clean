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
export BAR03_MERGED="${MERGED_DIR}/barcode03_merged.fastq"
export ILAB_DIR="${STORE_DIR}/ILAB_Dust"
export SPADES_OUTPUT="${CAFO_DIR}/metaSPAdes"
export SPADES_1="${SPADES_OUTPUT}/barcode01"
export SPADES_2="${SPADES_OUTPUT}/barcode02"
export CONTIG_01="${SPADES_1}/contigs.fasta"
export CONTIG_02="${SPADES_2}/contigs.fasta"

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
#------------------------------

# make output directories 
mkdir -p $MINIMAP2_OUTPUT

#//staphb/minimap2 = //staphb/minimap:2.26

# Make minimap2 index (MMI) File
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/minimap2 \
	minimap2 -ax map-ont \
 	-d $DATABASE_MMI $DATABASE_FNA

# Run minimap2 on barcode01
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/minimap2 \
	minimap2 -ax map-ont \
 	$DATABASE_MMI $CONTIG_01 > $BAR01_SAM
 	
# Run minimap2 on barcode02
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/minimap2 \
	minimap2 -ax map-ont \
 	$DATABASE_MMI $CONTIG_02 > $BAR02_SAM
 	
# Run minimap2 on barcode03
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/minimap2 \
	minimap2 -ax map-ont \
 	$DATABASE_MMI $BAR03_MERGED > $BAR03_SAM

# make .bam files using samtools 
## staphb/samtools = staphb/samtools:1.19

singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/samtools \
	samtools view -b $BAR01_SAM -o $BAR01_BAM
	
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/samtools \
	samtools view -b $BAR02_SAM -o $BAR02_BAM
	
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/samtools \
	samtools view -b $BAR03_SAM -o $BAR03_BAM
