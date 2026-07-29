#!/bin/bash
# Stage 05 - Prepare the PanGenie panel: split multiallelics into biallelic records.
#$ -N prepare_panel
#$ -cwd
#$ -l h_vmem=16G
#$ -l h_rt=120:00:00
#$ -pe sharedmem 1
#$ -o logs/$JOB_NAME.$JOB_ID.out
#$ -e logs/$JOB_NAME.$JOB_ID.err

set -euo pipefail
. /etc/profile.d/modules.sh
module load igmm/apps/bcftools/1.20
source "${REPO_ROOT:-.}/config/paths.sh"

PANEL_DIR="${PROJECT_DIR}/pangenie/input/vcf"
mkdir -p "${PANEL_DIR}" logs

bcftools norm -m -both \
  -Oz -o "${PANEL_DIR}/goat_pg_biallelic.vcf.gz" \
  "${PANEL_DIR}/goat-pg.haponly.diploid.vcf"

echo "finished"
