#!/bin/bash
#$ -N download_fastq
#$ -cwd
#$ -l h_rt=48:00:00
#$ -l h_vmem=16G
#$ -pe sharedmem 1
#$ -o /exports/eddie/scratch/s2909361/pan-genie/logs/$JOB_NAME.$JOB_ID.out
#$ -e /exports/eddie/scratch/s2909361/pan-genie/logs/$JOB_NAME.$JOB_ID.err

set -euo pipefail

. /etc/profile.d/modules.sh
module load igmm/apps/sratoolkit

BASE="/exports/eddie/scratch/s2909361/pan-genie"
mkdir -p "$BASE/sra" "$BASE/fastq" "$BASE/tmp" "$BASE/logs"

for RUN in ERR4133500 ERR4133480 ERR4133494 ERR4133329
do
    echo "=============================="
    echo "Processing $RUN"

    prefetch "$RUN" --output-directory "$BASE/sra"

    fasterq-dump "$BASE/sra/$RUN/$RUN.sra" \
        --split-files \
        -O "$BASE/fastq" \
        -t "$BASE/tmp"

    gzip -f "$BASE/fastq/${RUN}_1.fastq"
    gzip -f "$BASE/fastq/${RUN}_2.fastq"

    echo "$RUN finished"
done

echo "All runs finished"