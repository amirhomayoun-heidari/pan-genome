#!/bin/bash
# Stage 03 - Graph-pangenome construction with Minigraph-Cactus.
# Input: GENOMES_TXT (37 named genomes incl. reference). Reference coordinate
# system: ARS1.2. Produces GFA, GBZ, HAL and a multisample VCF.
#$ -N cactus_pangenome
#$ -cwd
#$ -l h_rt=168:00:00
#$ -pe sharedmem 30
#$ -l h_vmem=16G
#$ -o logs/$JOB_NAME.$JOB_ID.out
#$ -e logs/$JOB_NAME.$JOB_ID.err

set -euo pipefail
. /etc/profile.d/modules.sh
module load igmm/apps/singularity/3
source "${REPO_ROOT:-.}/config/paths.sh"

RUN_DIR="${PROJECT_DIR}/cactus"
OUT_DIR="${OUTPUT_DIR}/cactus"
TMP_DIR="${PROJECT_DIR}/tmp/cactus"
JOBSTORE="${RUN_DIR}/js"
REF_NAME="reference"

mkdir -p "${RUN_DIR}" "${OUT_DIR}" "${TMP_DIR}" "${JOBSTORE}" logs
test -s "${GENOMES_TXT}"
test -s "${REFERENCE_FASTA}"

# Pull the Cactus container once if missing.
if [[ ! -s "${CACTUS_SIF}" ]]; then
  singularity pull "${CACTUS_SIF}" docker://quay.io/comparative-genomics-toolkit/cactus:v2.9.9
fi

# Restrict the graph to the reference contigs (first token of each FASTA header).
REFCONTIGS="$(grep '^>' "${REFERENCE_FASTA}" | sed 's/^>//' | cut -d' ' -f1 | tr '\n' ' ')"
echo "Reference contigs: $(grep -c '^>' "${REFERENCE_FASTA}")"

cd "${RUN_DIR}"
singularity exec -B "${SCRATCH}:${SCRATCH}" "${CACTUS_SIF}" \
  cactus-pangenome \
    "${JOBSTORE}" "${GENOMES_TXT}" \
    --outDir "${OUT_DIR}" \
    --outName "goat-pg" \
    --reference "${REF_NAME}" \
    --refContigs ${REFCONTIGS} \
    --vcf --giraffe --gfa --gbz --viz --odgi \
    --workDir "${TMP_DIR}"

echo "finished"
