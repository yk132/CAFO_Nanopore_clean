#!/usr/bin/env bash

set -u

#--------------------------------------------
export STORE_DIR="/hpc/home/yk132/storage"
export CAFO_DIR="${STORE_DIR}/20230908_Dust_Redo_R9"
export FILE_DIR="${CAFO_DIR}/20230908_1516_MN33275_FAK80584_b5659fa0"
export SKIP_DIR="${FILE_DIR}/pod5_skip"
export PASS_DIR="${FILE_DIR}/pod5_pass"
export FAIL_DIR="${FILE_DIR}/pod5_fail"
export ALL_DIR="${FILE_DIR}/pod5_all"
export BARCODE01_DIR="${ALL_DIR}/barcode01"
export BARCODE02_DIR="${ALL_DIR}/barcode02"
export BARCODE03_DIR="${ALL_DIR}/barcode03"
export UNCLASSIFIED_DIR="${ALL_DIR}/unclassified"
#--------------------------------------------

mkdir -p $ALL_DIR
mkdir -p $BARCODE01_DIR
mkdir -p $BARCODE02_DIR
mkdir -p $BARCODE03_DIR
mkdir -p $UNCLASSIFIED_DIR

cp $SKIP_DIR/* $UNCLASSIFIED_DIR

cp -n $PASS_DIR/barcode01/* $BARCODE01_DIR
cp -n $PASS_DIR/barcode02/* $BARCODE02_DIR
cp -n $PASS_DIR/barcode03/* $BARCODE03_DIR
cp -n $PASS_DIR/unclassified/* $UNCLASSIFIED_DIR

cp -n $FAIL_DIR/barcode01/* $BARCODE01_DIR
cp -n $FAIL_DIR/barcode02/* $BARCODE02_DIR
cp -n $FAIL_DIR/barcode03/* $BARCODE03_DIR
cp -n $FAIL_DIR/unclassified/* $UNCLASSIFIED_DIR
