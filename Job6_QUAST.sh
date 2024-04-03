#!/usr/bin/env bash
#SBATCH --partition=chsi
#SBATCH -A chsi
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=100G
#SBATCH --mail-type=ALL

set -u

#-------------------------------
export STORE_DIR="/hpc/group/gunschlab/yk132/storage"
export QUAST_DIR="${STORE_DIR}/quast"
export SLURM_CPUS_PER_TASK="16" # CHANGE ME
export STORE_DIR="/hpc/home/yk132/storage"
export CAFO_DIR="${STORE_DIR}/20230908_Dust_Redo_R9"

export SPADES_OUTPUT="${CAFO_DIR}/metaSPAdes"
export SPADES_1="${SPADES_OUTPUT}/barcode01"
export SPADES_2="${SPADES_OUTPUT}/barcode02"
export CONTIG_01="${SPADES_1}/contigs.fasta"
export CONTIG_02="${SPADES_2}/contigs.fasta"
export CONTIG_01_FLYE="${CAFO_DIR}/20230908_1516_MN33275_FAK80584_b5659fa0/flye_output/barcode01/assembly.fasta"

export QUAST_OUTPUT="${CAFO_DIR}/quast_output"
export QUAST_01="${QUAST_OUTPUT}/barcode01"
export QUAST_02="${QUAST_OUTPUT}/barcode02"
export QUAST_01_FLYE="${QUAST_OUTPUT}/barcode01_metaflye"
#-------------------------------

#-------------------------------
echo $CONTIG_01
echo $CONTIG_02
echo $CONTIG_01_FLYE

mkdir -p $QUAST_OUTPUT
mkdir -p $QUAST_01
mkdir -p $QUAST_02
mkdir -p $QUAST_01_FLYE
#-------------------------------

# Run Quast on assembled contigs
$QUAST_DIR/metaquast.py $CONTIG_01 -t $SLURM_CPUS_PER_TASK -o $QUAST_01
$QUAST_DIR/metaquast.py $CONTIG_02 -t $SLURM_CPUS_PER_TASK -o $QUAST_02
$QUAST_DIR/metaquast.py $CONTIG_01_FLYE -t $SLURM_CPUS_PER_TASK -o $QUAST_01_FLYE


