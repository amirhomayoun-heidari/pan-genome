#!/bin/bash
#$ -N mashtree_goat
#$ -cwd
#$ -pe sharedmem 16
#$ -l h_vmem=4G
#$ -l h_rt=04:00:00
#$ -o /exports/eddie/scratch/s2909361/mashtree/logs/$JOB_NAME.$JOB_ID.out
#$ -e /exports/eddie/scratch/s2909361/mashtree/logs/$JOB_NAME.$JOB_ID.err

set -euo pipefail

. /etc/profile.d/modules.sh
module load anaconda

conda activate /exports/eddie/scratch/s2909361/conda_envs/mashtree_env

cd /exports/eddie/scratch/s2909361

echo "Running MashTree..."
date

mashtree \
  --numcpus 16 \
  --tempdir ./mashtree/tmp \
  --outmatrix ./mashtree/output/distances.tsv \
  $(cat genomes.list) \
  > ./mashtree/output/tree.nwk

echo "Finished"
date