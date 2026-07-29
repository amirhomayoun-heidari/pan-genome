#!/bin/bash
# ---------------------------------------------------------------------------
# Central path configuration for the goat-pangenome workflow.
#
# Usage:
#   cp config/paths.example.sh config/paths.sh
#   # then edit config/paths.sh for your system
#
# Every script sources config/paths.sh instead of hardcoding paths, so the
# repo contains no machine-specific or personal paths. config/paths.sh is
# git-ignored.
# ---------------------------------------------------------------------------

# Root working area (large scratch/storage on your system)
export SCRATCH="/path/to/scratch"
export PROJECT_DIR="${SCRATCH}/pangenome-goat"

# Inputs
export ASSEMBLY_DIR="${SCRATCH}/assemblies"       # haplotype-resolved + public assemblies
export READS_DIR="${SCRATCH}/reads"               # short-read FASTQs for genotyping
export REFERENCE_FASTA="${ASSEMBLY_DIR}/reference_genome.final.fna"  # ARS1.2 reference
export GENOMES_TXT="${PROJECT_DIR}/config/goat_genomes.txt"          # Minigraph-Cactus input list

# Outputs
export OUTPUT_DIR="${PROJECT_DIR}/results"

# Tool locations (edit to match your installs; several are locally compiled)
export HIFIASM="${SCRATCH}/tools/hifiasm/hifiasm"
export GFASTATS_BIN="${SCRATCH}/tools/gfastats/gfastats"
export CACTUS_SIF="${PROJECT_DIR}/containers/cactus_v2.9.9.sif"
export PANGENIE="${SCRATCH}/tools/pangenie/build/src/PanGenie"
export PANGENIE_INDEX="${SCRATCH}/tools/pangenie/build/src/PanGenie-index"
export VEP_CACHE_DIR="${SCRATCH}/vep_cache"

# Conda env names (used by odgi / mashtree steps)
export ODGI_ENV="odgi_env"
export MASHTREE_ENV="mashtree_env"
