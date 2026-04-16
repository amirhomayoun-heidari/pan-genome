#! /bin/bash
#$ -N hifiasm_CP095-0010001
#$ -cwd
#$ -pe sharedmem 12
#$ -l h_vmem=8G
#$ -l h_rt=48:00:00
#$ -o /exports/eddie/scratch/s2909361/HIFIASM_run/Hifiasm_results/hifiasm.out
#$ -e /exports/eddie/scratch/s2909361/HIFIASM_run/Hifiasm_results/hifiasm.err


set -euo pipefail
. /etc/profile.d/modules.sh

RUN_DIR="/exports/eddie/scratch/s2909361/HIFIASM_run"
OUT_DIR="${RUN_DIR}/Hifiasm_results"
READS="/exports/eddie/scratch/s2909361/My_genomes/CP095-001P0001/cell/CP095-001P0001.ccs.fastq.gz"
PREFIX="${OUT_DIR}/CP095-001P0001"


mkdir -p "$OUT_DIR"
cd "$OUT_DIR"


echo "Running job on host: $(hostname)"
echo "Working directory : $(pwd)"
echo "Reads : $READS"
echo "Output prefix: $PREFIX"

/exports/eddie/scratch/s2909361/tool/hifiasm/hifiasm -o "$PREFIX" -t 12 "$READS"








