#!/bin/bash
#$ -N cactus_goat_pg
#$ -cwd
#$ -l h_rt=168:00:00
#$ -pe sharedmem 25
#$ -l h_vmem=16G
#$ -o /exports/eddie/scratch/s2909361/pangenome-goat/logs/$JOB_NAME.$JOB_ID.out
#$ -e /exports/eddie/scratch/s2909361/pangenome-goat/logs/$JOB_NAME.$JOB_ID.err

set -euo pipefail

. /etc/profile.d/modules.sh
module load igmm/apps/singularity/3

SCRATCH="/exports/eddie/scratch/s2909361"
PROJECT="${SCRATCH}/pangenome-goat"

RUN_DIR="${PROJECT}/cactus"
OUT_DIR="${PROJECT}/results/cactus"
TMP_DIR="${PROJECT}/tmp/cactus"
JOBSTORE="${RUN_DIR}/js"

GENOMES_TXT="${PROJECT}/config/goat_genomes.txt"
REF_NAME="reference"
REF_FASTA="${SCRATCH}/assemblies/final_files/reference_genome.final.fna"
SIF="${PROJECT}/containers/cactus_v2.9.9.sif"

mkdir -p "${RUN_DIR}" "${OUT_DIR}" "${TMP_DIR}" "${JOBSTORE}"

test -s "${GENOMES_TXT}"
test -s "${REF_FASTA}"
test -s "${SIF}"

cd "${RUN_DIR}"

singularity exec \
  -B "${SCRATCH}:${SCRATCH}" \
  "${SIF}" \
  cactus-pangenome \
    "${JOBSTORE}" \
    "${GENOMES_TXT}" \
    --outDir "${OUT_DIR}" \
    --outName "goat-pg" \
    --reference "${REF_NAME}" \
    --vcf --giraffe --gfa --gbz --viz --odgi \
    --workDir "${TMP_DIR}" \
    --batchSystem gridEngine \
    --maxCores 25 \
    --defaultMemory 16G \
    --defaultDisk 100G

echo "finished"