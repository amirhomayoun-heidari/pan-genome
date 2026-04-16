#!/bin/bash

#$ -N index_pan-genie_inputs
#$ -cwd
#$ -l h_vmem=8G
#$ -l h_rt=120:00:00
#$ -pe sharedmem 8
#$ -o /exports/eddie/scratch/s2909361/pan-genie/logs/$JOB_NAME.$JOB_ID.out
#$ -e /exports/eddie/scratch/s2909361/pan-genie/logs/$JOB_NAME.$JOB_ID.err

set -euo pipefail

. /etc/profile.d/modules.sh

cd /exports/eddie/scratch/s2909361/pan-genie

/exports/eddie/scratch/s2909361/tools/pangenie/build/src/PanGenie-index \
  -v input/vcf/goat-pg.vcf \
  -r input/ref/reference_genome.final.fna \
  -t 8 \
  -o input/goat_pg_index

  