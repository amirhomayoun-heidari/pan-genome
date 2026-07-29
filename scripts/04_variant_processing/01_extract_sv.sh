#!/bin/bash
# Stage 04 - Extract and filter structural variants from the pangenome VCF.
# Defines SVs as REF/ALT length difference >= 50 bp, keeps biallelic records,
# and builds a headered genotype table for downstream R analysis.
#$ -N extract_sv
#$ -cwd
#$ -l h_rt=12:00:00
#$ -pe sharedmem 4
#$ -l h_vmem=16G
#$ -o logs/$JOB_NAME.$JOB_ID.out
#$ -e logs/$JOB_NAME.$JOB_ID.err

set -euo pipefail
. /etc/profile.d/modules.sh
module load igmm/apps/bcftools/1.20
source "${REPO_ROOT:-.}/config/paths.sh"

WORK="${OUTPUT_DIR}/cactus"
cd "${WORK}"
mkdir -p logs

VCF="goat-pg.vcf.gz"

# Overall callset statistics (source of the reported record counts).
bcftools stats "${VCF}" > vcf_stats.txt

# Flatten to a genotype table: CHROM POS REF ALT GT...
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%GT]\n' "${VCF}" > goat_pg_table.tsv

# Keep records where |len(ALT) - len(REF)| >= 50 bp  -> structural variants.
awk 'BEGIN{OFS="\t"} { if (length($3)-length($4) >= 50 || length($4)-length($3) >= 50) print }' \
  goat_pg_table.tsv > goat_pg_SV.tsv

# Keep biallelic SVs only (ALT has no comma).
awk 'BEGIN{OFS="\t"} { if ($4 !~ ",") print }' goat_pg_SV.tsv > goat_pg_SV_biallelic.tsv

# Add a header row (sample_names.txt = one sample per line, in column order).
( echo -e "CHROM\tPOS\tREF\tALT\t$(paste -sd'\t' sample_names.txt)"; cat goat_pg_SV_biallelic.tsv ) \
  > goat_pg_SV_biallelic_header.tsv

echo "Done. Table: ${WORK}/goat_pg_SV_biallelic_header.tsv"
