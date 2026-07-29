#!/bin/bash
# Stage 02 - Whole-genome distance tree (Mash sketches) across all assemblies.
# Provides a quick relatedness check before pangenome construction.
#$ -N mashtree
#$ -cwd
#$ -pe sharedmem 16
#$ -l h_vmem=4G
#$ -l h_rt=04:00:00
#$ -o logs/$JOB_NAME.$JOB_ID.out
#$ -e logs/$JOB_NAME.$JOB_ID.err

set -euo pipefail
. /etc/profile.d/modules.sh
module load anaconda
conda activate "${MASHTREE_ENV}"
source "${REPO_ROOT:-.}/config/paths.sh"

OUT_DIR="${OUTPUT_DIR}/mashtree"
mkdir -p "${OUT_DIR}/tmp" logs

# genomes.list = one assembly path per line
mashtree \
  --numcpus 16 \
  --tempdir "${OUT_DIR}/tmp" \
  --outmatrix "${OUT_DIR}/distances.tsv" \
  $(cat "${OUTPUT_DIR}/genomes.list") \
  > "${OUT_DIR}/tree.nwk"

echo "finished"
