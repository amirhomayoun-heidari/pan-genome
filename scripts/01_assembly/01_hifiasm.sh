#!/bin/bash
# Stage 01 - Haplotype-resolved assembly of PacBio HiFi reads with hifiasm.
# Run once per individual; both haplotypes are retained.
#$ -N hifiasm
#$ -cwd
#$ -pe sharedmem 12
#$ -l h_vmem=8G
#$ -l h_rt=48:00:00
#$ -o logs/$JOB_NAME.$JOB_ID.out
#$ -e logs/$JOB_NAME.$JOB_ID.err

set -euo pipefail
. /etc/profile.d/modules.sh
source "${REPO_ROOT:-.}/config/paths.sh"

SAMPLE="${1:?Usage: qsub 01_hifiasm.sh <SAMPLE_ID>}"
READS="${READS_DIR}/${SAMPLE}/${SAMPLE}.ccs.fastq.gz"
OUT_DIR="${OUTPUT_DIR}/assembly/${SAMPLE}"
PREFIX="${OUT_DIR}/${SAMPLE}"

mkdir -p "${OUT_DIR}" logs
test -s "${READS}"

echo "Host: $(hostname)   Reads: ${READS}   Prefix: ${PREFIX}"

# HiFi-only dual assembly (no Hi-C / trio); outputs hap1 + hap2 contigs.
"${HIFIASM}" -o "${PREFIX}" -t 12 "${READS}"

echo "finished"
