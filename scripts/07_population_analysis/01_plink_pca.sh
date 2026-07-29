#!/bin/bash
# Stage 07 - Population structure: SNP extraction, LD pruning, allele
# frequencies, and PCA with PLINK2.
#$ -N plink_pca
#$ -cwd
#$ -l h_rt=08:00:00
#$ -pe sharedmem 8
#$ -l h_vmem=16G
#$ -o logs/$JOB_NAME.$JOB_ID.out
#$ -e logs/$JOB_NAME.$JOB_ID.err

set -euo pipefail
. /etc/profile.d/modules.sh
module load igmm/apps/bcftools/1.20
source "${REPO_ROOT:-.}/config/paths.sh"

WORK="${OUTPUT_DIR}/popgen"
mkdir -p "${WORK}" logs
cd "${WORK}"

VCF="${OUTPUT_DIR}/cactus/goat-pg.vcf.gz"

# Keep SNPs only.
bcftools view -v snps "${VCF}" -Oz -o goat-pg.snps.vcf.gz

# LD pruning.
plink2 --vcf goat-pg.snps.vcf.gz --double-id --allow-extra-chr \
  --indep-pairwise 50 10 0.1 --bad-ld --out pruned_snps

# Allele frequencies on the pruned set.
plink2 --vcf goat-pg.snps.vcf.gz --double-id --allow-extra-chr \
  --extract pruned_snps.prune.in --freq --bad-ld --out goat_freqs

# PCA.
plink2 --vcf goat-pg.snps.vcf.gz --double-id --allow-extra-chr \
  --extract pruned_snps.prune.in --read-freq goat_freqs.afreq \
  --pca 10 --out goat_pca

echo "finished"
