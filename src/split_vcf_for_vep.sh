#!/bin/bash
#$ -N split_vcf
#$ -cwd
#$ -l h_rt=24:00:00
#$ -pe sharedmem 4
#$ -l h_vmem=5G
#$ -o /exports/eddie/scratch/s2909361/pan-genie/vep/logs/split.$JOB_ID.out
#$ -e /exports/eddie/scratch/s2909361/pan-genie/vep/logs/split.$JOB_ID.err

set -euo pipefail

. /etc/profile.d/modules.sh
module load igmm/apps/bcftools/1.20

# ==============================
# INPUT
# ==============================
INPUT_VCF="/exports/eddie/scratch/s2909361/pan-genie/merged_for_vep/pangenie_merged.vcf.gz"

OUTDIR="/exports/eddie/scratch/s2909361/pan-genie/vep/chunks"
TMPDIR="${OUTDIR}/tmp"

NCHUNKS=20

mkdir -p "${OUTDIR}"
mkdir -p "${TMPDIR}"

HEADER="${TMPDIR}/header.vcf"
BODY="${TMPDIR}/body.vcf"

echo "Extracting header..."
bcftools view -h "${INPUT_VCF}" > "${HEADER}"

echo "Extracting body..."
bcftools view -H "${INPUT_VCF}" > "${BODY}"

echo "Counting variants..."
TOTAL=$(wc -l < "${BODY}")
echo "Total variants: ${TOTAL}"

LINES_PER_CHUNK=$(( (TOTAL + NCHUNKS - 1) / NCHUNKS ))
echo "Lines per chunk: ${LINES_PER_CHUNK}"

echo "Splitting..."
split -d -l "${LINES_PER_CHUNK}" "${BODY}" "${TMPDIR}/chunk_body_"

echo "Building chunk VCFs..."

i=1
for f in ${TMPDIR}/chunk_body_*; do
    OUT="${OUTDIR}/chunk_${i}.vcf"

    cat "${HEADER}" "$f" > "${OUT}"
    bgzip -f "${OUT}"
    tabix -f -p vcf "${OUT}.gz"

    echo "Created chunk_${i}.vcf.gz"
    i=$((i+1))
done

echo "Done splitting."