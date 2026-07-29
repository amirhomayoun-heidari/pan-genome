#!/bin/bash
# Stage 05 - Build the PanGenie index from the prepared panel + reference.
#$ -N pangenie_index
#$ -cwd
#$ -l h_vmem=8G
#$ -l h_rt=120:00:00
#$ -pe sharedmem 8
#$ -o logs/$JOB_NAME.$JOB_ID.out
#$ -e logs/$JOB_NAME.$JOB_ID.err

set -euo pipefail
. /etc/profile.d/modules.sh
source "${REPO_ROOT:-.}/config/paths.sh"

PG_DIR="${PROJECT_DIR}/pangenie"
mkdir -p "${PG_DIR}/input" logs

[ -x "${PANGENIE_INDEX}" ] || { echo "ERROR: PanGenie-index not executable: ${PANGENIE_INDEX}"; exit 1; }

"${PANGENIE_INDEX}" \
  -v "${PG_DIR}/input/vcf/goat-pg.vcf" \
  -r "${REFERENCE_FASTA}" \
  -t 8 \
  -o "${PG_DIR}/input/goat_pg_index"

echo "finished"
