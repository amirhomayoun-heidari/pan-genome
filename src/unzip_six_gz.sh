#!/bin/bash

#$ -N unzip_short_reads
#$ -cwd
#$ -l h_vmem=16G
#$ -l h_rt=120:00:00
#$ -pe sharedmem 2
#$ -o /exports/eddie/scratch/s2909361/pan-genie/logs/$JOB_NAME.$JOB_ID.out
#$ -e /exports/eddie/scratch/s2909361/pan-genie/logs/$JOB_NAME.$JOB_ID.err

set -euo pipefail

. /etc/profile.d/modules.sh

BASE="/exports/eddie/scratch/s2909361/pan-genie"
OUT_DIR="$BASE/input/reads"
READS="$BASE/input/reads_gz/paths.txt"

mkdir -p "$OUT_DIR"

while read -r line
do 
    [ -z "$line" ] && continue
    [ ! -f "$line" ] && echo "File not found: $line" && continue

    filename=$(basename "$line" .gz)

    echo "Processing $line"

    gunzip -c "$line" > "$OUT_DIR/$filename"

    echo "Finished $filename"

done < "$READS"


