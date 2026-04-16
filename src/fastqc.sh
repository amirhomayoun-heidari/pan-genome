#! /bin/bash

#$ -N fastQC_short_reads
#$ -cwd
#$ -l h_vmem=16G
#$ -l h_rt=120:00:00
#$ -pe sharedmem 1
#$ -o /exports/eddie/scratch/s2909361/pan-genie/logs/$JOB_NAME.$JOB_ID.out
#$ -e /exports/eddie/scratch/s2909361/pan-genie/logs/$JOB_NAME.$JOB_ID.err


set -euo pipefail

. /etc/profile.d/modules.sh

module load igmm/apps/FastQC/0.12.1


#I define base 
BASE="/exports/eddie/scratch/s2909361/pan-genie"
OUT_DIR="/exports/eddie/scratch/s2909361/pan-genie/fastqc_results"
READS="/exports/eddie/scratch/s2909361/pan-genie/fastqc_path"

mkdir -p "$OUT_DIR"



while read -r line
do 
    [ -z "$line" ] && continue
    echo "Processing $line"
    fastqc "$line" -o "$OUT_DIR"
    echo "Finished $line"
done < "$READS"






































/exports/eddie/scratch/s2909361/pan-genie/fastq/ITCH-GGT-0024/ERR4133500_1.fastq.gz
/exports/eddie/scratch/s2909361/pan-genie/fastq/ITCH-GGT-0024/ERR4133500_2.fastq.gz
/exports/eddie/scratch/s2909361/pan-genie/fastq/ITCH-GGT-0026/ERR4133480_1.fastq.gz
/exports/eddie/scratch/s2909361/pan-genie/fastq/ITCH-GGT-0026/ERR4133480_2.fastq.gz
/exports/eddie/scratch/s2909361/pan-genie/fastq/ITCH-GGT-0030/ERR4133494_1.fastq.gz
/exports/eddie/scratch/s2909361/pan-genie/fastq/ITCH-GGT-0030/ERR4133494_2.fastq.gz
/exports/eddie/scratch/s2909361/pan-genie/fastq/ITCH-GGT-0031/ERR4133329_1.fastq.gz
/exports/eddie/scratch/s2909361/pan-genie/fastq/ITCH-GGT-0031/ERR4133329_2.fastq.gz
/exports/eddie/scratch/s2909361/pan-genie/fastq2/ITCH-VAL-0002/ERR4133399_1.fastq.gz
/exports/eddie/scratch/s2909361/pan-genie/fastq2/ITCH-VAL-0002/ERR4133399_2.fastq.gz
/exports/eddie/scratch/s2909361/pan-genie/fastq2/ITCH-VAL-0002/ERR4133406_1.fastq.gz
/exports/eddie/scratch/s2909361/pan-genie/fastq2/ITCH-VAL-0002/ERR4133406_2.fastq.gz
/exports/eddie/scratch/s2909361/pan-genie/fastq2/ITCH-VAL-0014/ERR4133455_1.fastq.gz
/exports/eddie/scratch/s2909361/pan-genie/fastq2/ITCH-VAL-0014/ERR4133455_2.fastq.gz
/exports/eddie/scratch/s2909361/pan-genie/fastq2/ITCH-VAL-0014/ERR4133467_1.fastq.gz
/exports/eddie/scratch/s2909361/pan-genie/fastq2/ITCH-VAL-0014/ERR4133467_2.fastq.gz