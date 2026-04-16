#!/bin/bash
#$ -N vep_chunk
#$ -cwd
#$ -t 1-20
#$ -tc 5
#$ -l h_rt=168:00:00
#$ -pe sharedmem 5
#$ -l h_vmem=8G
#$ -o /exports/eddie/scratch/s2909361/pan-genie/vep/logs/$JOB_NAME.$TASK_ID.$JOB_ID.out
#$ -e /exports/eddie/scratch/s2909361/pan-genie/vep/logs/$JOB_NAME.$TASK_ID.$JOB_ID.err

set -euo pipefail

. /etc/profile.d/modules.sh
module load igmm/apps/vep/115

# ==============================
# PATHS
# ==============================
CHUNK_DIR="/exports/eddie/scratch/s2909361/pan-genie/vep/chunks"
OUT_DIR="/exports/eddie/scratch/s2909361/pan-genie/vep/chunks/annotated"

INPUT_VCF="${CHUNK_DIR}/chunk_${SGE_TASK_ID}.vcf.gz"
OUTPUT_VCF="${OUT_DIR}/chunk_${SGE_TASK_ID}.vep.vcf.gz"

CACHE_DIR="/exports/eddie/scratch/s2909361/vep_cache"
REF_FASTA="/exports/eddie/scratch/s2909361/pan-genie/reference_genome.final.fna"

mkdir -p "${OUT_DIR}"

# ==============================
# RUN VEP
# ==============================
vep \
  -i "${INPUT_VCF}" \
  -o "${OUTPUT_VCF}" \
  --vcf \
  --compress_output bgzip \
  --species capra_hircus \
  --assembly ARS1 \
  --cache \
  --offline \
  --dir_cache "${CACHE_DIR}" \
  --fasta "${REF_FASTA}" \
  --fork 5 \
  --everything \
  --pick \
  --force_overwrite
   