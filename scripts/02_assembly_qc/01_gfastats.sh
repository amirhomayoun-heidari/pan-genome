#!/bin/bash
# Stage 02 - Assembly statistics (length, contig count, N50, L50) with gfastats.
# Runs over every FASTA in ASSEMBLY_DIR.
#$ -N gfastats
#$ -cwd
#$ -pe sharedmem 1
#$ -l h_vmem=4G
#$ -l h_rt=02:00:00
#$ -o logs/$JOB_NAME.$JOB_ID.out
#$ -e logs/$JOB_NAME.$JOB_ID.err

set -euo pipefail
. /etc/profile.d/modules.sh
source "${REPO_ROOT:-.}/config/paths.sh"

OUT_DIR="${OUTPUT_DIR}/gfastats"
mkdir -p "${OUT_DIR}" logs

# Sanity checks: fail fast before wasting cluster time.
[[ -x "${GFASTATS_BIN}" ]] || { echo "ERROR: gfastats not executable: ${GFASTATS_BIN}" >&2; exit 1; }
[[ -d "${ASSEMBLY_DIR}"  ]] || { echo "ERROR: no assembly dir: ${ASSEMBLY_DIR}" >&2; exit 1; }

shopt -s nullglob
assemblies=( "${ASSEMBLY_DIR}"/*.{fa,fasta,fna,fa.gz,fasta.gz,fna.gz} )
[[ ${#assemblies[@]} -gt 0 ]] || { echo "ERROR: no assemblies found" >&2; exit 1; }

for f in "${assemblies[@]}"; do
  base=$(basename "$f"); base=${base%.gz}; base=${base%.fa}; base=${base%.fasta}; base=${base%.fna}
  echo "gfastats on: $f"
  "${GFASTATS_BIN}" "$f" > "${OUT_DIR}/${base}.gfastats.txt" 2> "${OUT_DIR}/${base}.gfastats.err"
done

echo "Done. Results in ${OUT_DIR}"
