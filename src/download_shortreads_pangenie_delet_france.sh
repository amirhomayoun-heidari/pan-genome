#!/bin/bash

#$ -N batch_pangenie_singlefq_16_samples_france 
#$ -cwd
#$ -l h_vmem=16G
#$ -l h_rt=120:00:00
#$ -pe sharedmem 6
#$ -t 1-16
#$ -tc 3
#$ -o /exports/eddie/scratch/s2909361/pan-genie/logs/$JOB_NAME.$JOB_ID.$SGE_TASK_ID.out
#$ -e /exports/eddie/scratch/s2909361/pan-genie/logs/$JOB_NAME.$JOB_ID.$SGE_TASK_ID.err

set -euo pipefail

. /etc/profile.d/modules.sh
module load igmm/apps/sratoolkit/3.3.0
module load igmm/apps/FastQC/0.12.1

BASE="/exports/eddie/scratch/s2909361/pan-genie"
SAMPLE_LIST="$BASE/samples/sample_ids_16_france.txt"
TMP_DIR="$BASE/tmp/${JOB_ID}_${SGE_TASK_ID}"
RESULT_DIR="$BASE/results"

PAN_GENIE="/exports/eddie/scratch/s2909361/tools/pangenie/build/src/PanGenie"
INDEX_PREFIX="$BASE/input/index/goat_pg_index"

LINE=$(sed -n "${SGE_TASK_ID}p" "$SAMPLE_LIST")
SAMPLE_NAME=$(echo "$LINE" | awk '{print $1}')
ACCESSION=$(echo "$LINE" | awk '{print $2}')

FASTQC_DIR="$BASE/results/fastqc/$SAMPLE_NAME"qstat

mkdir -p "$TMP_DIR" "$RESULT_DIR" "$FASTQC_DIR"
trap 'rm -rf "$TMP_DIR"' EXIT

echo "Processing sample: $SAMPLE_NAME"
echo "Accession: $ACCESSION"

cd "$TMP_DIR"

# Download SRA data
prefetch "$ACCESSION" --max-size 100G --output-directory "$TMP_DIR"

# Convert to FASTQ
fasterq-dump "$ACCESSION" -O "$TMP_DIR"

echo "FASTQ files created:"
ls -lh "$TMP_DIR"

# Define paired-end files
R1=$(find "$TMP_DIR" -maxdepth 1 -name "*_1.fastq" | head -n 1)
R2=$(find "$TMP_DIR" -maxdepth 1 -name "*_2.fastq" | head -n 1)

if [[ -z "${R1:-}" || -z "${R2:-}" ]]; then
    echo "Error: Could not find both paired FASTQ files for $SAMPLE_NAME"
    exit 1
fi

echo "R1 file: $R1"
echo "R2 file: $R2"

# Run FastQC on the two raw read files
fastqc -t 2 -o "$FASTQC_DIR" "$R1" "$R2"

# Merge R1 and R2 into one FASTQ for PanGenie
cat "$R1" "$R2" > "$TMP_DIR/${SAMPLE_NAME}.fastq"

echo "Merged FASTQ:"
ls -lh "$TMP_DIR/${SAMPLE_NAME}.fastq"

# Run PanGenie
"$PAN_GENIE" \
  -f "$INDEX_PREFIX" \
  -i "$TMP_DIR/${SAMPLE_NAME}.fastq" \
  -o "$RESULT_DIR/$SAMPLE_NAME" \
  -t 6

echo "Finished sample: $SAMPLE_NAME"











