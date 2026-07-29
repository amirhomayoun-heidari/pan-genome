#!/bin/bash
# Stage 05 - Short-read quality control (FastQC) before genotyping.
# Reads a file of FASTQ paths (one per line).
#$ -N fastqc
#$ -cwd
#$ -l h_vmem=16G
#$ -l h_rt=120:00:00
#$ -pe sharedmem 1
#$ -o logs/$JOB_NAME.$JOB_ID.out
#$ -e logs/$JOB_NAME.$JOB_ID.err

set -euo pipefail
. /etc/profile.d/modules.sh
module load igmm/apps/FastQC/0.12.1
source "${REPO_ROOT:-.}/config/paths.sh"

OUT_DIR="${OUTPUT_DIR}/fastqc"
FASTQ_LIST="${READS_DIR}/fastq_paths.txt"
mkdir -p "${OUT_DIR}" logs

while read -r line; do
  [ -z "$line" ] && continue
  echo "Processing $line"
  fastqc "$line" -o "${OUT_DIR}"
done < "${FASTQ_LIST}"
echo "finished"
