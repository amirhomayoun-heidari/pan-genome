#!/bin/bash
#
## Grid Engine options
#$ -N cactus_goat_pangenome
#$ -cwd
#$ -l h_rt=168:00:00
#$ -pe sharedmem 30
#$ -l h_vmem=16G
#$ -P roslin_prendergast_cores
#$ -o /exports/eddie/scratch/s2909361/pangenome-goat/logs/$JOB_NAME.$JOB_ID.out
#$ -e /exports/eddie/scratch/s2909361/pangenome-goat/logs/$JOB_NAME.$JOB_ID.err

set -euo pipefail

. /etc/profile.d/modules.sh
module load igmm/apps/singularity/3

# =========================
# Your directories (goat)
# =========================
SCRATCH="/exports/eddie/scratch/s2909361"
PROJECT="${SCRATCH}/pangenome-goat"

LOG_DIR="${PROJECT}/logs"
RUN_DIR="${PROJECT}/cactus"
OUT_DIR="${PROJECT}/results/cactus"
TMP_DIR="${PROJECT}/tmp/cactus"

JOBSTORE="${RUN_DIR}/js"

# Your genomes list (make sure the file exists at this path)
GENOMES_TXT="${PROJECT}/config/goat_genomes.txt"

# Your reference sample name MUST match column 1 of genomes.txt
REF_NAME="reference"

# Container image (stored in your project area)
SIF_DIR="${PROJECT}/containers"
CACTUS_SIF="${SIF_DIR}/cactus_v2.9.9.sif"

mkdir -p "${LOG_DIR}" "${RUN_DIR}" "${OUT_DIR}" "${TMP_DIR}" "${JOBSTORE}" "${SIF_DIR}" "$(dirname "${GENOMES_TXT}")"

echo "Working directory: ${RUN_DIR}"
cd "${RUN_DIR}"

echo "Check genomes list exists"
test -s "${GENOMES_TXT}"

echo "Pull cactus container if missing"
if [[ ! -s "${CACTUS_SIF}" ]]; then
  singularity pull "${CACTUS_SIF}" docker://quay.io/comparative-genomics-toolkit/cactus:v2.9.9
fi

echo "Infer ref contigs from the reference FASTA (your headers are CP162xxx style)"
REF_FASTA="/exports/eddie/scratch/s2909361/assemblies/final_files/reference_genome.final.fna"
test -s "${REF_FASTA}"

# Build a ref contigs string from the FIRST token of each header line
# (for you, that token is like: reference_genome|CP162209.1)
REFCONTIGS="$(grep '^>' "${REF_FASTA}" | sed 's/^>//' | cut -d' ' -f1 | tr '\n' ' ')"

echo "Number of ref contigs: $(grep -c '^>' "${REF_FASTA}")"

echo "Run cactus-pangenome"
singularity exec \
  -B "${SCRATCH}:${SCRATCH}" \
  "${CACTUS_SIF}" \
  cactus-pangenome \
    "${JOBSTORE}" \
    "${GENOMES_TXT}" \
    --outDir "${OUT_DIR}" \
    --outName "goat-pg" \
    --reference "${REF_NAME}" \
    --refContigs ${REFCONTIGS} \
    --vcf --giraffe --gfa --gbz --viz --odgi \
    --workDir "${TMP_DIR}" \
    --restart

echo "finished"

