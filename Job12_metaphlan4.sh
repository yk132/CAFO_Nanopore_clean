#!/usr/bin/env bash
#SBATCH --partition=dmcshared
#SBATCH --cpus-per-task=32
#SBATCH --mem=400G
#SBATCH --mail-type=ALL

set -u

#-------------------------------
export STORE_DIR="/hpc/home/yk132/storage"
export CAFO_DIR="${STORE_DIR}/20230908_Dust_Redo_R9"
export CAFO_GIT_DIR="${CAFO_DIR}/CAFO_Nanopore_clean"
export WORK_DIR="/work/${USER}" # CHANGE ME if needed 
export CAFO_WORK_DIR="${WORK_DIR}/CAFO_Nanopore_work"
export IMAGEDIR="${WORK_DIR}/images"
export NXF_SINGULARITY_CACHEDIR="$APPTAINER_CACHEDIR"
export NXF_WORK="${CAFO_WORK_DIR}/nf_working"
export NXF_TEMP="${CAFO_WORK_DIR}/nf_temp"
export DATA_DIR="${CAFO_DIR}/20230908_1516_MN33275_FAK80584_b5659fa0"
export OUTPUT_DIR="${CAFO_DIR}/Outputs"
export SLURM_CPUS_PER_TASK="32" # CHANGE ME
export METAPHLAN_OUTPUT="${OUTPUT_DIR}/Job12_MetaPhlAn4_Illumina_pairedend"
export ILAB_DIR="${STORE_DIR}/ILAB_Dust"
export METAPHLAN_DB="${METAPHLAN_OUTPUT}/Database"
export FarmA_F="${ILAB_DIR}/Farm_A_Dust_S3_L001_R1_001.fastq"
export FarmA_R="${ILAB_DIR}/Farm_A_Dust_S3_L001_R2_001.fastq"
export FarmC_F="${ILAB_DIR}/Farm_C_Dust_S2_L001_R1_001.fastq"
export FarmC_R="${ILAB_DIR}/Farm_C_Dust_S2_L001_R2_001.fastq"
#------------------------------

# make output directories 
mkdir -p $METAPHLAN_OUTPUT
mkdir -p $METAPHLAN_DB

# obtain latest database and store in a database folder: recommended for HPC cluster
## https://github.com/biobakery/MetaPhlAn/wiki/MetaPhlAn-4
# singularity exec \
#	--bind /work:/work \
#	--bind /hpc/group:/hpc/group \
#	docker://biobakery/metaphlan:4.0.2 \
#	metaphlan --install --bowtie2db $METAPHLAN_DB

# run metaphlan4 on Farm A
#singularity exec \
#	--bind /work:/work \
#	--bind /hpc/group:/hpc/group \
#	docker://biobakery/metaphlan:4.0.2 \
#	metaphlan $FarmA_F,$FarmA_R --input_type fastq \
#	--bowtie2db $METAPHLAN_DB \
#	--bowtie2out $METAPHLAN_OUTPUT/FarmA.bowtie2.bz2 \
#	--nproc $SLURM_CPUS_PER_TASK \
#	--unclassified_estimation \
#	-o $METAPHLAN_OUTPUT/FarmA_metaphlan.txt
 	
# run metaphlan4 on Farm C
#singularity exec \
#	--bind /work:/work \
#	--bind /hpc/group:/hpc/group \
#	docker://biobakery/metaphlan:4.0.2 \
#	metaphlan $FarmC_F,$FarmC_R --input_type fastq \
#	--bowtie2db $METAPHLAN_DB \
#	--bowtie2out $METAPHLAN_OUTPUT/FarmC.F.bowtie2.bz2 \
#	--nproc $SLURM_CPUS_PER_TASK \
#	--unclassified_estimation \
#	-o $METAPHLAN_OUTPUT/FarmC_F_metaphlan.txt

# merge abundance tables
cd $METAPHLAN_OUTPUT
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
	docker://biobakery/metaphlan:4.0.2 \
	merge_metaphlan_tables.py $METAPHLAN_OUTPUT/*.txt > $METAPHLAN_OUTPUT/merged_abundance.txt
