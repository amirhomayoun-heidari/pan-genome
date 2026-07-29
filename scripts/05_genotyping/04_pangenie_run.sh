#!/bin/bash
# Stage 05 - Genotype pangenome variants in one short-read sample with PanGenie.
# Usage: qsub 04_pangenie_run.sh <SAMPLE_ID> <MERGED_R1R2_FASTQ>
#$ -N pangenie_run
#$ -cwd
#$ -l h_vmem=16G
#$ -l h_rt=72:00:00
#$ -pe sharedmem 5
#$ -o logs/$JOB_NAME.$JOB_ID.out
#$ -e logs/$JOB_NAME.$JOB_ID.err

set -euo pipefail
. /etc/profile.d/modules.sh
source "${REPO_ROOT:-.}/config/paths.sh"

SAMPLE="${1:?Usage: qsub 04_pangenie_run.sh <SAMPLE_ID> <READS_FASTQ>}"
READS="${2:?provide merged R1R2 FASTQ path}"
INDEX_PREFIX="${PROJECT_DIR}/pangenie/input/index/goat_pg_index"
OUT_DIR="${OUTPUT_DIR}/pangenie/${SAMPLE}"
mkdir -p "${OUT_DIR}" logs

[ -x "${PANGENIE}" ] || { echo "ERROR: PanGenie not executable: ${PANGENIE}"; exit 1; }
[ -f "${READS}" ]    || { echo "ERROR: reads not found: ${READS}"; exit 1; }
[ -f "${INDEX_PREFIX}_UniqueKmersMap.cereal" ] || { echo "ERROR: bad index prefix: ${INDEX_PREFIX}"; exit 1; }

"${PANGENIE}" \
  -f "${INDEX_PREFIX}" \
  -i "${READS}" \
  -s "${SAMPLE}" \
  -j 5 -t 5 \
  -o "${OUT_DIR}/${SAMPLE}"

echo "finished"
