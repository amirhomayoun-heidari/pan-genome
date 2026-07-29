#!/bin/bash
# Stage 06 - Split the merged VCF into N chunks for parallel VEP annotation.
#$ -N split_vcf
#$ -cwd
#$ -l h_rt=24:00:00
#$ -pe sharedmem 4
#$ -l h_vmem=5G
#$ -o logs/$JOB_NAME.$JOB_ID.out
#$ -e logs/$JOB_NAME.$JOB_ID.err

set -euo pipefail
. /etc/profile.d/modules.sh
module load igmm/apps/bcftools/1.20
source "${REPO_ROOT:-.}/config/paths.sh"

INPUT_VCF="${PROJECT_DIR}/pangenie/merged_for_vep/pangenie_merged.vcf.gz"
OUTDIR="${PROJECT_DIR}/pangenie/vep/chunks"
TMP="${OUTDIR}/tmp"
NCHUNKS=20
mkdir -p "${TMP}" logs

bcftools view -h "${INPUT_VCF}" > "${TMP}/header.vcf"
bcftools view -H "${INPUT_VCF}" > "${TMP}/body.vcf"

TOTAL=$(wc -l < "${TMP}/body.vcf")
LINES_PER_CHUNK=$(( (TOTAL + NCHUNKS - 1) / NCHUNKS ))
echo "Total variants: ${TOTAL}; per chunk: ${LINES_PER_CHUNK}"

split -d -l "${LINES_PER_CHUNK}" "${TMP}/body.vcf" "${TMP}/chunk_body_"

i=1
for f in "${TMP}"/chunk_body_*; do
  OUT="${OUTDIR}/chunk_${i}.vcf"
  cat "${TMP}/header.vcf" "$f" > "${OUT}"
  bgzip -f "${OUT}"; tabix -f -p vcf "${OUT}.gz"
  echo "Created chunk_${i}.vcf.gz"; i=$((i+1))
done
echo "Done splitting."
