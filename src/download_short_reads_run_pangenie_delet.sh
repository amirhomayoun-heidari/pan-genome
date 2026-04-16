#!/bin/bash

#$ -N batch_pangenie_singlefq
#$ -cwd
#$ -l h_vmem=16G
#$ -l h_rt=120:00:00
#$ -pe sharedmem 8
#$ -t 1-1
#$ -tc 1
#$ -o /exports/eddie/scratch/s2909361/pan-genie/logs/$JOB_NAME.$JOB_ID.$SGE_TASK_ID.out
#$ -e /exports/eddie/scratch/s2909361/pan-genie/logs/$JOB_NAME.$JOB_ID.$SGE_TASK_ID.err

set -euo pipefail

. /etc/profile.d/modules.sh
module load igmm/apps/sratoolkit/3.3.0

BASE="/exports/eddie/scratch/s2909361/pan-genie"
SAMPLE_LIST="$BASE/samples/sample_ids.txt"
TMP_DIR="$BASE/tmp/${JOB_ID}_${SGE_TASK_ID}"
RESULT_DIR="$BASE/results"

PAN_GENIE="/exports/eddie/scratch/s2909361/tools/pangenie/build/src/PanGenie"
INDEX_PREFIX="$BASE/input/index/goat_pg_index"

mkdir -p "$TMP_DIR" "$RESULT_DIR"
trap 'rm -rf "$TMP_DIR"' EXIT

LINE=$(sed -n "${SGE_TASK_ID}p" "$SAMPLE_LIST")
SAMPLE_NAME=$(echo "$LINE" | awk '{print $1}')
ACCESSION=$(echo "$LINE" | awk '{print $2}')

echo "Processing sample: $SAMPLE_NAME"
echo "Accession: $ACCESSION"

cd "$TMP_DIR"

prefetch "$ACCESSION" --max-size 100G --output-directory "$TMP_DIR"
fasterq-dump "$ACCESSION" -O "$TMP_DIR"

ls -lh "$TMP_DIR"

cat "$TMP_DIR"/*_*.fastq > "$TMP_DIR/${SAMPLE_NAME}.fastq"

ls -lh "$TMP_DIR/${SAMPLE_NAME}.fastq"

"$PAN_GENIE" \
  -f "$INDEX_PREFIX" \
  -i "$TMP_DIR/${SAMPLE_NAME}.fastq" \
  -o "$RESULT_DIR/$SAMPLE_NAME" \
  -t 8


echo "Finished sample: $SAMPLE_NAME"