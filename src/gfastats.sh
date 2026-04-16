#!/bin/bash
# GFastats - A tool for analyzing and summarizing assembly FASTA/FNA files

#$ -N gfastats_public_data
#$ -cwd
#$ -pe sharedmem 1
#$ -l h_vmem=4G
#$ -l h_rt=02:00:00
#$ -o /exports/eddie/scratch/$USER/pangenome-goat/logs/gfastats.$JOB_ID.out
#$ -e /exports/eddie/scratch/$USER/pangenome-goat/logs/gfastats.$JOB_ID.err

# -e = exit immediately if any command failed to run
# -u = treat unset variables as errors
# pipefail = if A | B and A fails, pipeline fails

set -euo pipefail
. /etc/profile.d/modules.sh

# Defining variables so we don't have to keep writing paths

# ---- USER SETTINGS ----
SCRATCH="/exports/eddie/scratch/$USER"
PROJECT="$SCRATCH/pangenome-goat"

# Where my assemblies are (FASTA .fna/.fa/.fasta, even .gz)
ASSEMBLY_DIR="$SCRATCH/assemblies"

# Where gfastats binary lives (my compiled location) - adjust if needed
GFASTATS_BIN="$SCRATCH/tool/gfastats/gfastats"

# Output directory
# -p means if directory already exists don't fail the project because of set -e
OUTDIR="$PROJECT/results/gfastats"
mkdir -p "$OUTDIR" "$PROJECT/logs"

# ------------- SANITY CHECKS ------------
# Sanity checks make the script fail immediately, before wasting time:
# Here lets check if gfastats is found and executable
# >&2 sends the message to stderr because on eddie, stderr goes to .err file and this keeps error separated from normal logs
# exit 1

if [[ ! -x "$GFASTATS_BIN" ]]; then
  echo "ERROR: gfastats binary not found/executable: $GFASTATS_BIN" >&2
  exit 1
fi

# Check if this directory exists
# -d means is a directory?

if [[ ! -d "$ASSEMBLY_DIR" ]]; then
  echo "ERROR: assembly directory does not exist: $ASSEMBLY_DIR" >&2
  exit 1
fi

echo "Host: $(hostname)"
echo "Date: $(date)"
echo "Assembly dir: $ASSEMBLY_DIR"
echo "Output dir: $OUTDIR"
echo "gfastats: $GFASTATS_BIN"
echo "gfastats version:"
"$GFASTATS_BIN" --version || true
echo
echo "Modules loaded:"
module list 2>&1 || true
echo

# --- RUN GFASTATS ---
# Option A: Run all the FASTA files in the folder

# -s nullglob is for making sure empty glob does not produce fake filenames
shopt -s nullglob


assemblies=(
  "$ASSEMBLY_DIR"/*.fa
  "$ASSEMBLY_DIR"/*.fasta
  "$ASSEMBLY_DIR"/*.fna
  "$ASSEMBLY_DIR"/*.fa.gz
  "$ASSEMBLY_DIR"/*.fasta.gz
  "$ASSEMBLY_DIR"/*.fna.gz
)

# Check if the files are not empty
# -eq 0 is equal to 0 and [@] means all the elements inside assemblies and ${#...} means length of it
# All together checks if length of the content inside assemblies is 0, write an ERROR message

if [[ ${#assemblies[@]} -eq 0 ]]; then
  echo "ERROR: no assemblies found in $ASSEMBLY_DIR" >&2
  exit 1
fi

# Lets do the analysis
# basename takes the directory address before the file and removes it:
# f=/exports/eddie/scratch/s2909361/assemblies/GCA_12345.fna.gz  ==>  GCA_12345.fna.gz
# bash string manipulation: ${var%pattern} remove pattern from end if present
# Example: file="file.fa.gz"  ${file%.gz} ==> file.fa
# Here we remove .gz and then remove .fa/.fasta/.fna to have a clean base name

for f in "${assemblies[@]}"; do
  base=$(basename "$f")
  base=${base%.gz}
  base=${base%.fa}
  base=${base%.fasta}
  base=${base%.fna}

  echo "Running gfastats on: $f"
  "$GFASTATS_BIN" "$f" > "$OUTDIR/$base.gfastats.txt" 2> "$OUTDIR/$base.gfastats.err"
done

echo
echo "Done. Results in: $OUTDIR"



awk 'BEGIN{FS=" "} /^>/ {print $1; next} {print}' public_02.fna > public_02.clean.fna









