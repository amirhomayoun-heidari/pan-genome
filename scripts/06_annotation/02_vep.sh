#!/bin/bash
# Stage 06 - Annotate each VCF chunk with Ensembl VEP (array job).
# NOTE: Cactus used the ARS1.2 reference; in Ensembl VEP that assembly is
# named ARS1, so --assembly ARS1 is correct (same genome, Ensembl naming).
#$ -N vep_chunk
#$ -cwd
#$ -t 1-20
#$ -tc 5
#$ -l h_rt=168:00:00
#$ -pe sharedmem 5
#$ -l h_vmem=8G
#$ -o logs/$JOB_NAME.$TASK_ID.$JOB_ID.out
#$ -e logs/$JOB_NAME.$TASK_ID.$JOB_ID.err

set -euo pipefail
. /etc/profile.d/modules.sh
module load igmm/apps/vep/115
source "${REPO_ROOT:-.}/config/paths.sh"

CHUNK_DIR="${PROJECT_DIR}/pangenie/vep/chunks"
OUT_DIR="${CHUNK_DIR}/annotated"
mkdir -p "${OUT_DIR}" logs

vep \
  -i "${CHUNK_DIR}/chunk_${SGE_TASK_ID}.vcf.gz" \
  -o "${OUT_DIR}/chunk_${SGE_TASK_ID}.vep.vcf.gz" \
  --vcf --compress_output bgzip \
  --species capra_hircus --assembly ARS1 \
  --cache --offline --dir_cache "${VEP_CACHE_DIR}" \
  --fasta "${REFERENCE_FASTA}" \
  --fork 5 --everything --pick --force_overwrite

echo "finished chunk ${SGE_TASK_ID}"
