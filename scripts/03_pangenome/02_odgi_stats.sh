#!/bin/bash
# Stage 03 - Graph summary statistics and an overview visualization with odgi.
#$ -N odgi_stats
#$ -cwd
#$ -l h_rt=02:00:00
#$ -pe sharedmem 4
#$ -l h_vmem=32G
#$ -o logs/$JOB_NAME.$JOB_ID.out
#$ -e logs/$JOB_NAME.$JOB_ID.err

set -euo pipefail
. /etc/profile.d/modules.sh
source ~/.bashrc
conda activate "${ODGI_ENV}"
source "${REPO_ROOT:-.}/config/paths.sh"

OG="${OUTPUT_DIR}/cactus/goat-pg.full.og"
ANALYSIS_DIR="${OUTPUT_DIR}/analysis"
mkdir -p "${ANALYSIS_DIR}" logs

odgi stats -i "${OG}" -S > "${ANALYSIS_DIR}/graph_stats.txt"
odgi viz   -i "${OG}" -o "${ANALYSIS_DIR}/goat_overview.png" -x 1500 -y 400

echo "Done"
