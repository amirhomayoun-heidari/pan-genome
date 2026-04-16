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










/exports/eddie/scratch/s2909361/assemblies/reference_genome.fna
/exports/eddie/scratch/s2909361/assemblies/CA669-S09-001P0001.hap1.p_ctg.fna
/exports/eddie/scratch/s2909361/assemblies/CA669-S09-001P0001.hap2.p_ctg.fna
/exports/eddie/scratch/s2909361/assemblies/CA669-S09-001P0002.hap1.p_ctg.fna
/exports/eddie/scratch/s2909361/assemblies/CA669-S09-001P0002.hap2.p_ctg.fna
/exports/eddie/scratch/s2909361/assemblies/CA669-S09-001P0003.hap1.p_ctg.fna
/exports/eddie/scratch/s2909361/assemblies/CA669-S09-001P0003.hap2.p_ctg.fna
/exports/eddie/scratch/s2909361/assemblies/CP095_001P0001.hap1.p_ctg.fna
/exports/eddie/scratch/s2909361/assemblies/CP095_001P0001.hap2.p_ctg.fna
/exports/eddie/scratch/s2909361/assemblies/CP095_001P0002.hap1.p_ctg.fna
/exports/eddie/scratch/s2909361/assemblies/CP095_001P0002.hap2.p_ctg.fna
/exports/eddie/scratch/s2909361/assemblies/public_01.fna
/exports/eddie/scratch/s2909361/assemblies/public_02.fna
/exports/eddie/scratch/s2909361/assemblies/public_03.fna
/exports/eddie/scratch/s2909361/assemblies/public_04.fna
/exports/eddie/scratch/s2909361/assemblies/public_05.fna
/exports/eddie/scratch/s2909361/assemblies/public_06.fna
/exports/eddie/scratch/s2909361/assemblies/public_07.fna


odgi build -g goat-pg.gfa -o goat-pg.og

#!/bin/bash
#$ -N odgi_stats
#$ -cwd
#$ -l h_rt=02:00:00
#$ -pe sharedmem 4
#$ -l h_vmem=32G
#$ -o /exports/eddie/scratch/s2909361/pangenome-goat/analysis/$JOB_NAME.$JOB_ID.out
#$ -e /exports/eddie/scratch/s2909361/pangenome-goat/analysis/$JOB_NAME.$JOB_ID.err

set -euo pipefail 

. /etc/profile.d/modules.sh

source ~/.bashrc
conda activate odgi_env

odgi stats -i goat-pg.full.og -S > graph_stats.txt
odgi viz -i goat-pg.full.og -o goat_overview.png -x 1500 -y 400

echo "Done"























#!/bin/bash
#$ -N odgi_stats
#$ -cwd
#$ -l h_rt=02:00:00
#$ -pe sharedmem 4
#$ -l h_vmem=32G
#$ -o /exports/eddie/scratch/s2909361/pangenome-goat/analysis/$JOB_NAME.$JOB_ID.out
#$ -e /exports/eddie/scratch/s2909361/pangenome-goat/analysis/$JOB_NAME.$JOB_ID.err

set -euo pipefail

. /etc/profile.d/modules.sh

# Make sure log/output dir exists
mkdir -p /exports/eddie/scratch/s2909361/pangenome-goat/analysis

# Activate conda
source ~/.bashrc
conda activate odgi_env

# Go to the cactus results directory (where the .og is)
cd /exports/eddie/scratch/s2909361/pangenome-goat/cactus

OG="/exports/eddie/scratch/s2909361/pangenome-goat/cactus/goat-pg.full.og"

odgi stats -i "$OG" -S > /exports/eddie/scratch/s2909361/pangenome-goat/analysis/graph_stats.txt
odgi viz   -i "$OG" -o /exports/eddie/scratch/s2909361/pangenome-goat/analysis/goat_overview.png -x 1500 -y 400

echo "Done"






plot-vcfstats -p vcfstats_plots goat-pg.bcftools.stats.txt



module load anaconda
python3 -c "import matplotlib; print(matplotlib.__version__)"

scp s2909361@eddie.ecdf.ed.ac.uk:/exports/eddie/scratch/s2909361/pangenome-goat/results/cactus/vcfstats_plots/substitutions.0.png . 


python3 plot.py










scp s2909361@eddie.ecdf.ed.ac.uk:/exports/eddie/scratch/s2909361/pangenome-goat/analysis/goat_overview.png .



bcftools stats -s - goat-pg.vcf.gz | grep "^PSC" > per_sample_counts.txt

module load igmm/apps/bcftools/1.20

bcftools +dist goat-pg.vcf.gz -- -p > distance_matrix.txt

bcftools +variant-distance goat-pg.vcf.gz -- -p > distance_matrix.txt






plink2 --vcf goat-pg.vcf.gz \
      --double-id \
      --allow-extra-chr \
      --make-bed \
      --out goat_pg




bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%GT]\n' 

bcftools view -v snps goat-pg.vcf.gz -Oz -o goat-pg.snps.vcf.gz

bcftools view -v snps goat-pg.vcf.gz -Oz -o goat-pg.snps.vcf.gz


bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%GT]\n' goat-pg.snps.vcf.gz | head -n 20


plink2 --vcf goat-pg.snps.vcf.gz \
  --double-id \
  --allow-extra-chr \
  --indep-pairwise 50 10 0.1 \
  --bad-ld \
  --out pruned_snps


plink2 --vcf goat-pg.snps.vcf.gz \
  --double-id \
  --allow-extra-chr \
  --extract pruned_snps.prune.in \
  --freq \
  --bad-ld \
  --out goat_freqs


plink2 --vcf goat-pg.snps.vcf.gz \
  --double-id \
  --allow-extra-chr \
  --extract pruned_snps.prune.in \
  --read-freq goat_freqs.afreq \
  --pca \
  --out goat_pca






qsub -pe shared 8 -l h_vmem=16G -b y "plink2 --vcf goat-pg.snps.vcf.gz --double-id --allow-extra-chr --extract pruned_snps.prune.in --pca 10 --out goat_pca"


















#$ -N cactus_goat_pg
#$ -cwd
#$ -l h_rt=168:00:00
#$ -pe sharedmem 15
#$ -l h_vmem=16G
#$ -o /exports/eddie/scratch/s2909361/pangenome-goat/logs/$JOB_NAME.$JOB_ID.out
#$ -e /exports/eddie/scratch/s2909361/pangenome-goat/logs/$JOB_NAME.$JOB_ID.err

set -euo pipefail

. /etc/profile.d/modules.sh
module load igmm/apps/singularity/3

SCRATCH="/exports/eddie/scratch/s2909361"
PROJECT="${SCRATCH}/pangenome-goat"

RUN_DIR="${PROJECT}/cactus"
OUT_DIR="${PROJECT}/results_new/cactus"
TMP_DIR="${PROJECT}/tmp/cactus"
JOBSTORE="${RUN_DIR}/js"

GENOMES_TXT="${PROJECT}/config/goat_genomes.txt"
REF_NAME="reference"
REF_FASTA="${SCRATCH}/assemblies/final_files/reference_genome.final.fna"
SIF="${PROJECT}/containers/cactus_v2.9.9.sif"

mkdir -p "${RUN_DIR}" "${OUT_DIR}" "${TMP_DIR}"

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
    --maxCores 15 \
    --defaultMemory 16G \
    --defaultDisk 50G

echo "finished"




























#!/bin/bash
#$ -N cactus_goat_pg
#$ -cwd
#$ -l h_rt=168:00:00
#$ -pe sharedmem 15
#$ -l h_vmem=16G
#$ -o /exports/eddie/scratch/s2909361/pangenome-goat/logs/$JOB_NAME.$JOB_ID.out
#$ -e /exports/eddie/scratch/s2909361/pangenome-goat/logs/$JOB_NAME.$JOB_ID.err

set -euo pipefail

. /etc/profile.d/modules.sh
module load igmm/apps/singularity/3

SCRATCH="/exports/eddie/scratch/s2909361"
PROJECT="${SCRATCH}/pangenome-goat"

RUN_DIR="${PROJECT}/cactus"
OUT_DIR="${PROJECT}/results_new/cactus"

# Unique per-job directories to avoid "already exists" failures
TMP_DIR="${PROJECT}/tmp/cactus_${JOB_ID}"
JOBSTORE="${RUN_DIR}/js_${JOB_ID}"

GENOMES_TXT="${PROJECT}/config/goat_genomes.txt"
REF_NAME="reference"
REF_FASTA="${SCRATCH}/assemblies/final_files/reference_genome.final.fna"
SIF="${PROJECT}/containers/cactus_v2.9.9.sif"

LOGDIR="${PROJECT}/logs"

mkdir -p "${RUN_DIR}" "${OUT_DIR}" "${TMP_DIR}" "${JOBSTORE}" "${LOGDIR}"

# Basic sanity checks (fail fast if anything is missing/empty)
test -s "${GENOMES_TXT}"
test -s "${REF_FASTA}"
test -s "${SIF}"

cd "${RUN_DIR}"

echo "JOB_ID=${JOB_ID}"
echo "RUN_DIR=${RUN_DIR}"
echo "OUT_DIR=${OUT_DIR}"
echo "TMP_DIR=${TMP_DIR}"
echo "JOBSTORE=${JOBSTORE}"
echo "GENOMES_TXT=${GENOMES_TXT}"
echo "REF_FASTA=${REF_FASTA}"
echo "SIF=${SIF}"

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
    --maxCores 15 \
    --defaultMemory 16G \
    --defaultDisk 50G

echo "finished"
















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
  --outmatrix ./mashtree/output/distances_new.tsv \
  $(cat genomes.list) \
  > ./mashtree/output/tree_new.nwk

echo "Finished"
date








/exports/eddie/scratch/s2909361/assemblies/final_files/reference_genome.final.fna
/exports/eddie/scratch/s2909361/assemblies/final_files/CA669-S09-001P0001.hap1.p_ctg.final.fna
/exports/eddie/scratch/s2909361/assemblies/final_files/CA669-S09-001P0001.hap2.p_ctg.final.fna
/exports/eddie/scratch/s2909361/assemblies/final_files/CA669-S09-001P0002.hap1.p_ctg.final.fna
/exports/eddie/scratch/s2909361/assemblies/final_files/CA669-S09-001P0002.hap2.p_ctg.final.fna
/exports/eddie/scratch/s2909361/assemblies/final_files/CA669-S09-001P0003.hap1.p_ctg.final.fna
/exports/eddie/scratch/s2909361/assemblies/final_files/CA669-S09-001P0003.hap2.p_ctg.final.fna
/exports/eddie/scratch/s2909361/assemblies/final_files/CP095_001P0001.hap1.p_ctg.final.fna
/exports/eddie/scratch/s2909361/assemblies/final_files/CP095_001P0001.hap2.p_ctg.final.fna
/exports/eddie/scratch/s2909361/assemblies/final_files/CP095_001P0002.hap1.p_ctg.final.fna
/exports/eddie/scratch/s2909361/assemblies/final_files/CP095_001P0002.hap2.p_ctg.final.fna
/exports/eddie/scratch/s2909361/assemblies/final_files/public_01.final.fna
/exports/eddie/scratch/s2909361/assemblies/final_files/public_02.final.fna
/exports/eddie/scratch/s2909361/assemblies/final_files/public_03.final.fna
/exports/eddie/scratch/s2909361/assemblies/final_files/public_04.final.fna
/exports/eddie/scratch/s2909361/assemblies/final_files/public_05.final.fna
/exports/eddie/scratch/s2909361/assemblies/final_files/public_06.final.fna
/exports/eddie/scratch/s2909361/assemblies/final_files/public_07.final.fna
/exports/eddie/scratch/s2909361/assemblies/final_files/capra_aegagrus.final.fna
/exports/eddie/scratch/s2909361/assemblies/final_files/capra_ibex.final.fna
/exports/eddie/scratch/s2909361/assemblies/final_files/capra_nubiana_hap1.final.fna
/exports/eddie/scratch/s2909361/assemblies/final_files/capra_nubiana_hap2.final.fna
/exports/eddie/scratch/s2909361/assemblies/final_files/capra_sibirica.final.fna










#!/bin/bash



#$ -N gfastats_capra_aegagrus
#$ -cwd
#$ -l h_vmem=8G
#$ -pe sharedmem 1
#$ -l h_rt=04:00:00
#$ -o /exports/eddie/scratch/s2909361/Public_genomes/capra_aegagrus/ncbi_dataset/data/GCA_000978405.1/$JOB_ID.$JOB_NAME.out
#$ -e /exports/eddie/scratch/s2909361/Public_genomes/capra_aegagrus/ncbi_dataset/data/GCA_000978405.1/$JOB_ID.$JOB_NAME.err


. /etc/profile.d/modules.sh

set -euo pipefail

GFASTATS="/exports/eddie/scratch/s2909361/tool/gfastats/gfastats/build/bin/gfastats"
FASTA="/exports/eddie/scratch/s2909361/Public_genomes/capra_aegagrus/ncbi_dataset/data/GCA_000978405.1/capra_aegagrus"

"${GFASTATS}" "${FASTA}" > /exports/eddie/scratch/s2909361/Public_genomes/capra_aegagrus/ncbi_dataset/data/GCA_000978405.1/capra_aegagrus_gfastats.txt










#!/bin/bash



#$ -N gfastats_capra_aegagrus
#$ -cwd
#$ -l h_vmem=8G
#$ -pe sharedmem 1
#$ -l h_rt=04:00:00
#$ -o /exports/eddie/scratch/s2909361/Public_genomes/capra_ibex/ncbi_dataset/data/GCA_054642885.1/$JOB_ID.$JOB_NAME.out
#$ -e /exports/eddie/scratch/s2909361/Public_genomes/capra_ibex/ncbi_dataset/data/GCA_054642885.1/$JOB_ID.$JOB_NAME.err


. /etc/profile.d/modules.sh

set -euo pipefail

GFASTATS="/exports/eddie/scratch/s2909361/tool/gfastats/gfastats/build/bin/gfastats"
FASTA="/exports/eddie/scratch/s2909361/Public_genomes/capra_ibex/ncbi_dataset/data/GCA_054642885.1/capra_ibex"

"${GFASTATS}" "${FASTA}" > /exports/eddie/scratch/s2909361/Public_genomes/capra_ibex/ncbi_dataset/data/GCA_054642885.1/capra_ibex_gfastats.txt







#!/bin/bash



#$ -N gfastats_capra_sibirica
#$ -cwd
#$ -l h_vmem=8G
#$ -pe sharedmem 1
#$ -l h_rt=04:00:00
#$ -o /exports/eddie/scratch/s2909361/Public_genomes/capra_sibirica/ncbi_dataset/data/GCA_003182615.2/$JOB_ID.$JOB_NAME.out
#$ -e /exports/eddie/scratch/s2909361/Public_genomes/capra_sibirica/ncbi_dataset/data/GCA_003182615.2/$JOB_ID.$JOB_NAME.err


. /etc/profile.d/modules.sh

set -euo pipefail

GFASTATS="/exports/eddie/scratch/s2909361/tool/gfastats/gfastats/build/bin/gfastats"
FASTA="/exports/eddie/scratch/s2909361/Public_genomes/capra_sibirica/ncbi_dataset/data/GCA_003182615.2/capra_sibirica.fna"

"${GFASTATS}" "${FASTA}" > /exports/eddie/scratch/s2909361/Public_genomes/capra_sibirica/ncbi_dataset/data/GCA_003182615.2/capra_sibirica_gfastats.txt








#!/bin/bash



#$ -N gfastats_capra_nubiana_hap1
#$ -cwd
#$ -l h_vmem=8G
#$ -pe sharedmem 1
#$ -l h_rt=04:00:00
#$ -o /exports/eddie/scratch/s2909361/Public_genomes/capra_nubiana/ncbi_dataset/data/GCA_054855995.1/$JOB_ID.$JOB_NAME.out
#$ -e /exports/eddie/scratch/s2909361/Public_genomes/capra_nubiana/ncbi_dataset/data/GCA_054855995.1/$JOB_ID.$JOB_NAME.err


. /etc/profile.d/modules.sh

set -euo pipefail

GFASTATS="/exports/eddie/scratch/s2909361/tool/gfastats/gfastats/build/bin/gfastats"
FASTA="/exports/eddie/scratch/s2909361/Public_genomes/capra_nubiana/ncbi_dataset/data/GCA_054855995.1/capra_nubiana_hap1.fna"

"${GFASTATS}" "${FASTA}" > /exports/eddie/scratch/s2909361/Public_genomes/capra_nubiana/ncbi_dataset/data/GCA_054855995.1/capra_nubiana_hap1_gfastats.txt









#!/bin/bash



#$ -N gfastats_capra_nubiana_hap2
#$ -cwd
#$ -l h_vmem=8G
#$ -pe sharedmem 1
#$ -l h_rt=04:00:00
#$ -o /exports/eddie/scratch/s2909361/Public_genomes/capra_nubiana2/ncbi_dataset/data/GCA_054856215.1/$JOB_ID.$JOB_NAME.out
#$ -e /exports/eddie/scratch/s2909361/Public_genomes/capra_nubiana2/ncbi_dataset/data/GCA_054856215.1/$JOB_ID.$JOB_NAME.err


. /etc/profile.d/modules.sh

set -euo pipefail

GFASTATS="/exports/eddie/scratch/s2909361/tool/gfastats/gfastats/build/bin/gfastats"
FASTA="/exports/eddie/scratch/s2909361/Public_genomes/capra_nubiana2/ncbi_dataset/data/GCA_054856215.1/capra_nubiana_hap2.fna"

"${GFASTATS}" "${FASTA}" > /exports/eddie/scratch/s2909361/Public_genomes/capra_nubiana2/ncbi_dataset/data/GCA_054856215.1/capra_nubiana_hap2_gfastats.txt



find "$(pwd)" -maxdepth 1 -type f -name "*.fna" | sort > mashtree_genomes.list



#!/bin/bash
#$ -N mashtree_goat_final_40_samples
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
  $(cat new_genomes.list) \
  > ./mashtree/output/tree.nwk

echo "Finished"
date



find "$(pwd)" -maxdepth 1 -type f -name "*.fna" | sort > mashtree_genomes.list























reference	/exports/eddie/scratch/s2909361/assemblies/final_files/reference_genome.final.fna
alpine_milk_goat2_hap1	/exports/eddie/scratch/s2909361/assemblies/final_files/alpine_milk_goat2_hap1.fna
alpine_milk_goat2_hap2	/exports/eddie/scratch/s2909361/assemblies/final_files/alpine_milk_goat2_hap2.fna
Bionda_dell_adamello_cp095_001p0002_hap1	/exports/eddie/scratch/s2909361/assemblies/final_files/Bionda_dell_adamello_CP095_001P0002.hap1.p_ctg.fna
Bionda_dell_adamello_cp095_001p0002_hap2	/exports/eddie/scratch/s2909361/assemblies/final_files/Bionda_dell_adamello_CP095_001P0002.hap2.p_ctg.fna
boer2_hap1	/exports/eddie/scratch/s2909361/assemblies/final_files/boer2_hap1.fna
boer2_hap2	/exports/eddie/scratch/s2909361/assemblies/final_files/boer2_hap2.fna
capra_ibex	/exports/eddie/scratch/s2909361/assemblies/final_files/capra_ibex.fna
capra_nubiana_hap1	/exports/eddie/scratch/s2909361/assemblies/final_files/capra_nubiana_hap1.fna
capra_nubiana_hap2	/exports/eddie/scratch/s2909361/assemblies/final_files/capra_nubiana_hap2.fna
giorgintana_ca669_s09_001p0003_hap1	/exports/eddie/scratch/s2909361/assemblies/final_files/Giorgintana_CA669-S09-001P0003.hap1.p_ctg.fna
giorgintana_ca669_s09_001p0003_hap2	/exports/eddie/scratch/s2909361/assemblies/final_files/Giorgintana_CA669-S09-001P0003.hap2.p_ctg.fna
guanzhong_milk_goat2_hap1	/exports/eddie/scratch/s2909361/assemblies/final_files/guanzhong_milk_goat2_hap1.fna
guanzhong_milk_goat2_hap2	/exports/eddie/scratch/s2909361/assemblies/final_files/guanzhong_milk_goat2_hap2.fna
hanian_black_goat2_hap1	/exports/eddie/scratch/s2909361/assemblies/final_files/hanian_black_goat2_hap1.fna
hanian_black_goat2_hap2	/exports/eddie/scratch/s2909361/assemblies/final_files/hanian_black_goat2_hap2.fna
inner_mongolia_cashmere_aebs_806099	/exports/eddie/scratch/s2909361/assemblies/final_files/inner_mongolia_cashmere_AEBS_806099.fna
inner_mongolia_cashmere_t2t_goat2	/exports/eddie/scratch/s2909361/assemblies/final_files/inner_mongolia_cashmere_T2T_goat2.fna
nguni	/exports/eddie/scratch/s2909361/assemblies/final_files/nguni.fna
nicastrese_cp095_001p0001_hap1	/exports/eddie/scratch/s2909361/assemblies/final_files/Nicastrese_CP095_001P0001.hap1.p_ctg.fna
nicastrese_cp095_001p0001_hap2	/exports/eddie/scratch/s2909361/assemblies/final_files/Nicastrese_CP095_001P0001.hap2.p_ctg.fna
nubian2_hap1	/exports/eddie/scratch/s2909361/assemblies/final_files/nubian2_hap1.fna
nubian2_hap2	/exports/eddie/scratch/s2909361/assemblies/final_files/nubian2_hap2.fna
orobica_ca669_s09_001p0002_hap1	/exports/eddie/scratch/s2909361/assemblies/final_files/Orobica_CA669-S09-001P0002.hap1.p_ctg.fna
orobica_ca669_s09_001p0002_hap2	/exports/eddie/scratch/s2909361/assemblies/final_files/Orobica_CA669-S09-001P0002.hap2.p_ctg.fna
saanen_diary_goat	/exports/eddie/scratch/s2909361/assemblies/final_files/saanen_diary_goat.fna
shanbei_cashmere	/exports/eddie/scratch/s2909361/assemblies/final_files/shanbei_cashmere.fna
shannan_white_goat2_hap1	/exports/eddie/scratch/s2909361/assemblies/final_files/shannan_white_goat2_hap1.fna
shannan_white_goat2_hap2	/exports/eddie/scratch/s2909361/assemblies/final_files/shannan_white_goat2_hap2.fna
shannan_white_goat3_hap1	/exports/eddie/scratch/s2909361/assemblies/final_files/shannan_white_goat3_hap1.fna
shannan_white_goat3_hap2	/exports/eddie/scratch/s2909361/assemblies/final_files/shannan_white_goat3_hap2.fna
tibetan2_hap1	/exports/eddie/scratch/s2909361/assemblies/final_files/tibetan2_hap1.fna
tibetan2_hap2	/exports/eddie/scratch/s2909361/assemblies/final_files/tibetan2_hap2.fna
valdostana_ca669_s09_001p0001_hap1	/exports/eddie/scratch/s2909361/assemblies/final_files/Valdostana_CA669-S09-001P0001.hap1.p_ctg.fna
valdostana_ca669_s09_001p0001_hap2	/exports/eddie/scratch/s2909361/assemblies/final_files/Valdostana_CA669-S09-001P0001.hap2.p_ctg.fna
xiong_saanen_dairy_goat /exports/eddie/scratch/s2909361/assemblies/final_files/xiong_saanen_dairy_goat.fna
yunna_black_goat	/exports/eddie/scratch/s2909361/assemblies/final_files/yunna_black_goat.fna

















#!/bin/bash
#$ -N cactus_goat_pg_37_samples
#$ -cwd
#$ -l h_rt=168:00:00
#$ -pe sharedmem 15
#$ -l h_vmem=18G
#$ -o /exports/eddie/scratch/s2909361/pangenome-goat/logs/$JOB_NAME.$JOB_ID.out
#$ -e /exports/eddie/scratch/s2909361/pangenome-goat/logs/$JOB_NAME.$JOB_ID.err

set -euo pipefail

. /etc/profile.d/modules.sh
module load igmm/apps/singularity/3

SCRATCH="/exports/eddie/scratch/s2909361"
PROJECT="${SCRATCH}/pangenome-goat"

RUN_DIR="${PROJECT}/cactus"
OUT_DIR="${PROJECT}/results_new/cactus"

# Make these unique per run to avoid "already exists"
TMP_DIR="${PROJECT}/tmp/cactus_${JOB_ID}"
JOBSTORE="${RUN_DIR}/js_${JOB_ID}"

GENOMES_TXT="${PROJECT}/config/goat_genomes.txt"
REF_NAME="reference"
REF_FASTA="${SCRATCH}/assemblies/final_files/reference_genome.final.fna"
SIF="${PROJECT}/containers/cactus_v2.9.9.sif"

# Create needed dirs (BUT NOT JOBSTORE!)
mkdir -p "${RUN_DIR}" "${OUT_DIR}" "${TMP_DIR}"

test -s "${GENOMES_TXT}"
test -s "${REF_FASTA}"
test -s "${SIF}"

cd "${RUN_DIR}"

echo "JOB_ID=${JOB_ID}"
echo "OUT_DIR=${OUT_DIR}"
echo "TMP_DIR=${TMP_DIR}"
echo "JOBSTORE=${JOBSTORE}"
echo "REF_FASTA=${REF_FASTA}"

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
    --maxCores 15 \
    --defaultMemory 18G \
    --defaultDisk 50G

echo "finished"


bcftools index goat-pg.vcf.gz
bcftools view -h goat-pg.vcf.gz
bcftools query -l goat-pg.vcf.gz
bcftools view goat-pg.vcf.gz | head
bcftools stats goat-pg.vcf.gz > vcf_stats.txt
bcftools view -H goat-pg.vcf.gz | wc -l
bcftools view goat-pg.vcf.gz chr1 | head
bcftools view -i 'INFO/SVTYPE!=""' goat-pg.vcf.gz
bcftools view goat-pg.vcf.gz | grep SVTYPE | head
bcftools query -f '%INFO/SVTYPE\n' goat-pg.vcf.gz | sort | uniq -c
bcftools view -i 'INFO/SVTYPE!=""' goat-pg.vcf.gz -Oz -o goat_sv.vcf.gz
bcftools index goat_sv.vcf.gz
bcftools query -f '%CHROM\t%POS[\t%GT]\n' goat_sv.vcf.gz > sv_genotypes.tsv



















#!/bin/bash
#$ -N cactus_goat_pg_37_samples
#$ -cwd
#$ -l h_rt=168:00:00
#$ -pe sharedmem 20
#$ -l h_vmem=18G
#$ -o /exports/eddie/scratch/s2909361/pangenome-goat/logs/$JOB_NAME.$JOB_ID.out
#$ -e /exports/eddie/scratch/s2909361/pangenome-goat/logs/$JOB_NAME.$JOB_ID.err

set -euo pipefail

. /etc/profile.d/modules.sh
module load igmm/apps/singularity/3

SCRATCH="/exports/eddie/scratch/s2909361"
PROJECT="${SCRATCH}/pangenome-goat"

RUN_DIR="${PROJECT}/cactus"
OUT_DIR="${PROJECT}/results_new/cactus"

# Make these unique per run to avoid "already exists"
TMP_DIR="${PROJECT}/tmp/cactus_${JOB_ID}"
JOBSTORE="${RUN_DIR}/js_${JOB_ID}"

GENOMES_TXT="${PROJECT}/config/goat_genomes.txt"
REF_NAME="reference"
REF_FASTA="${SCRATCH}/assemblies/final_files/reference_genome.final.fna"
SIF="${PROJECT}/containers/cactus_v2.9.9.sif"

# Create needed dirs (BUT NOT JOBSTORE!)
mkdir -p "${RUN_DIR}" "${OUT_DIR}" "${TMP_DIR}"

test -s "${GENOMES_TXT}"
test -s "${REF_FASTA}"
test -s "${SIF}"

cd "${RUN_DIR}"

echo "JOB_ID=${JOB_ID}"
echo "OUT_DIR=${OUT_DIR}"
echo "TMP_DIR=${TMP_DIR}"
echo "JOBSTORE=${JOBSTORE}"
echo "REF_FASTA=${REF_FASTA}"

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
    --maxCores 20 \
    --defaultMemory 18G \
    --defaultDisk 50G

echo "finished"













#!/bin/bash
#$ -N cactus_goat_pg_37_samples
#$ -cwd
#$ -l h_rt=168:00:00
#$ -pe sharedmem 18
#$ -l h_vmem=20G
#$ -o /exports/eddie/scratch/s2909361/pangenome-goat_run2/logs/$JOB_NAME.$JOB_ID.out
#$ -e /exports/eddie/scratch/s2909361/pangenome-goat_run2/logs/$JOB_NAME.$JOB_ID.err

set -euo pipefail

. /etc/profile.d/modules.sh
module load igmm/apps/singularity/3

SCRATCH="/exports/eddie/scratch/s2909361"
PROJECT="${SCRATCH}/pangenome-goat_run2"

RUN_DIR="${PROJECT}/cactus"
OUT_DIR="${PROJECT}/results/cactus"

# Make these unique per run to avoid "already exists"
TMP_DIR="${PROJECT}/tmp/cactus_${JOB_ID}"
JOBSTORE="${RUN_DIR}/js_${JOB_ID}"

GENOMES_TXT="${PROJECT}/config/goat_genomes.txt"
REF_NAME="reference"
REF_FASTA="${SCRATCH}/assemblies/final_files/reference_genome.final.fna"
SIF="${PROJECT}/containers/cactus_v2.9.9.sif"

# Create needed dirs (BUT NOT JOBSTORE!)
mkdir -p "${RUN_DIR}" "${OUT_DIR}" "${TMP_DIR}" "${PROJECT}/logs"

test -s "${GENOMES_TXT}"
test -s "${REF_FASTA}"
test -s "${SIF}"

cd "${RUN_DIR}"

echo "JOB_ID=${JOB_ID}"
echo "OUT_DIR=${OUT_DIR}"
echo "TMP_DIR=${TMP_DIR}"
echo "JOBSTORE=${JOBSTORE}"
echo "REF_FASTA=${REF_FASTA}"

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
    --maxCores 18 \
    --defaultMemory 20G \
    --defaultDisk 80G

echo "finished"




install.packages("ComplexUpset")
library(ComplexUpset)
library(tidyverse)
data <- read.table("sv_presence_matrix.tsv",
                   header=TRUE,
                   sep="\t")
sv_data <- data %>%
  select(-SV_ID)

upset(sv_data,
      intersect=colnames(sv_data))


pdf("sv_upset_plot.pdf",
    width=10,
    height=7)

upset(sv_data,
      intersect=colnames(sv_data))

dev.off()







find /exports/eddie/scratch/s2909361/ -exec touch -d '13 Mar' * {} \;
 



















 #$ -N cactus_goat_pg_37_samples
#$ -cwd
#$ -l h_rt=168:00:00
#$ -pe sharedmem 16
#$ -l h_vmem=20G
#$ -o /exports/eddie/scratch/s2909361/pangenome-goat_run2/logs/$JOB_NAME.$JOB_ID.out
#$ -e /exports/eddie/scratch/s2909361/pangenome-goat_run2/logs/$JOB_NAME.$JOB_ID.err

set -euo pipefail

. /etc/profile.d/modules.sh
module load igmm/apps/singularity/3

SCRATCH="/exports/eddie/scratch/s2909361"
PROJECT="${SCRATCH}/pangenome-goat_run2"

RUN_DIR="${PROJECT}/cactus"
OUT_DIR="${PROJECT}/results/cactus"

# Unique per run
TMP_DIR="${PROJECT}/tmp/cactus_${JOB_ID}"
JOBSTORE="${RUN_DIR}/js_${JOB_ID}"

GENOMES_TXT="${PROJECT}/config/goat_genomes.txt"
REF_NAME="reference"
REF_FASTA="${SCRATCH}/assemblies/final_files/reference_genome.final.fna"
SIF="${PROJECT}/containers/cactus_v2.9.9.sif"

# Create needed dirs
mkdir -p "${RUN_DIR}" "${OUT_DIR}" "${TMP_DIR}" "${PROJECT}/logs"

# Basic checks
test -s "${GENOMES_TXT}"
test -s "${REF_FASTA}"
test -s "${SIF}"

cd "${RUN_DIR}"

echo "JOB_ID=${JOB_ID}"
echo "OUT_DIR=${OUT_DIR}"
echo "TMP_DIR=${TMP_DIR}"
echo "JOBSTORE=${JOBSTORE}"
echo "REF_FASTA=${REF_FASTA}"
echo "GENOMES_TXT=${GENOMES_TXT}"
echo "SIF=${SIF}"

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
    --maxCores 16 \
    --defaultMemory 20G \
    --defaultDisk 80G

echo "finished"



bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%GT]\n' goat-pg.vcf.gz > goat_pg_table.tsv




awk '
BEGIN{OFS="\t"}
{
ref=$3
alt=$4
if (length(ref)-length(alt) >= 50 || length(alt)-length(ref) >= 50)
print
}
' goat_pg_table.tsv > goat_pg_SV.tsv



awk '
BEGIN{OFS="\t"}
{
if ($4 !~ ",")
print
}
' goat_pg_SV.tsv > goat_pg_SV_biallelic.tsv




(
echo -e "CHROM\tPOS\tREF\tALT\t$(paste -sd'\t' sample_names.txt)"
cat goat_pg_SV_biallelic.tsv
) > goat_pg_SV_biallelic_header.tsv




scp s2909361@eddie.ecdf.ed.ac.uk:/exports/eddie/scratch/s2909361/pangenome-goat_run2/results/cactus/goat_pg_SV_biallelic_header.tsv .


library(data.table)

sv <- fread("goat_pg_SV_biallelic_header.tsv")

dim(sv)


sv[, ref_len := nchar(REF)]
sv[, alt_len := nchar(ALT)]

sv[, sv_length := alt_len - ref_len]
sv[, abs_sv_length := abs(sv_length)]

sv[, sv_type := ifelse(sv_length > 0, "INS", "DEL")]

table(sv$sv_type)





sample_cols <- names(sv)[5:ncol(sv)]

sv[, sv_carriers := rowSums(.SD), .SDcols = sample_cols]


set.seed(42)

sv_plot_sample <- sv_plot[sample(.N, 2000)]

upset_data <- sv_plot_sample[, ..sample_cols]



library(ComplexUpset)

upset(
    upset_data,
    intersect = sample_cols,
    min_size = 10
)









#!/bin/bash
#$ -N vep_goat
#$ -cwd
#$ -l h_rt=48:00:00
#$ -pe sharedmem 10
#$ -l h_vmem=10G
#$ -o /exports/eddie/scratch/s2909361/pangenome-goat_run2/results/cactus/vep/logs/$JOB_NAME.$JOB_ID.out
#$ -e /exports/eddie/scratch/s2909361/pangenome-goat_run2/results/cactus/vep/logs/$JOB_NAME.$JOB_ID.err

set -euo pipefail

. /etc/profile.d/modules.sh
module load igmm/apps/vep/115

cd /exports/eddie/scratch/s2909361/pangenome-goat_run2/results/cactus/vep

vep \
  -i goat-pg.vcf.gz \
  -o goat-pg.vep.vcf.gz \
  --vcf \
  --compress_output bgzip \
  --species capra_hircus \
  --assembly ARS1 \
  --fasta reference_genome.final.fna \
  --fork 10 \
  --everything \
  --force_overwrite















 #!/bin/bash
#$ -N vep_goat
#$ -cwd
#$ -l h_rt=48:00:00
#$ -pe sharedmem 10
#$ -l h_vmem=10G
#$ -o /exports/eddie/scratch/s2909361/pangenome-goat_run2/results/cactus/vep/logs/$JOB_NAME.$JOB_ID.out
#$ -e /exports/eddie/scratch/s2909361/pangenome-goat_run2/results/cactus/vep/logs/$JOB_NAME.$JOB_ID.err

set -euo pipefail

. /etc/profile.d/modules.sh
module load igmm/apps/vep/115

VEP=/exports/eddie/scratch/s2909361/pangenome-goat_run2/results/cactus/vep/ensembl-vep-release-115/vep

$VEP \
-i /exports/eddie/scratch/s2909361/pangenome-goat_run2/results/cactus/vep/goat-pg.vcf.gz \
-o /exports/eddie/scratch/s2909361/pangenome-goat_run2/results/cactus/vep/goat-pg.vep.vcf.gz \
--vcf \
--compress_output bgzip \
--species capra_hircus \
--assembly ARS1 \
--cache \
--offline \
--dir_cache /exports/eddie/scratch/s2909361/vep_cache \
--fasta /exports/eddie/scratch/s2909361/pangenome-goat_run2/results/cactus/vep/reference_genome.final.fna \
--fork 10 \
--everything \
--force_overwrite















#!/bin/bash
#$ -N vep_goat
#$ -cwd
#$ -l h_rt=48:00:00
#$ -pe sharedmem 10
#$ -l h_vmem=10G
#$ -o /exports/eddie/scratch/s2909361/pangenome-goat_run2/results/cactus/vep/logs/$JOB_NAME.$JOB_ID.out
#$ -e /exports/eddie/scratch/s2909361/pangenome-goat_run2/results/cactus/vep/logs/$JOB_NAME.$JOB_ID.err

set -euo pipefail

. /etc/profile.d/modules.sh
module load igmm/apps/vep/115

vep \
-i /exports/eddie/scratch/s2909361/pangenome-goat_run2/results/cactus/vep/goat-pg.vcf.gz \
-o /exports/eddie/scratch/s2909361/pangenome-goat_run2/results/cactus/vep/goat-pg.vep.vcf.gz \
--vcf \
--compress_output bgzip \
--species capra_hircus \
--assembly ARS1 \
--cache \
--offline \
--dir_cache /exports/eddie/scratch/s2909361/vep_cache \
--fasta /exports/eddie/scratch/s2909361/pangenome-goat_run2/results/cactus/vep/reference_genome.final.fna \
--fork 10 \
--everything \
--force_overwrite


















#!/bin/bash
#$ -N split_vcf
#$ -cwd
#$ -l h_rt=10:00:00
#$ -pe sharedmem 4
#$ -l h_vmem=5G
#$ -o /exports/eddie/scratch/s2909361/pangenome-goat_run2/results/cactus/vep/logs/split.$JOB_ID.out
#$ -e /exports/eddie/scratch/s2909361/pangenome-goat_run2/results/cactus/vep/logs/split.$JOB_ID.err

#!/bin/bash
set -euo pipefail

. /etc/profile.d/modules.sh
module load igmm/apps/bcftools/1.20

# ==============================
# INPUTS
# ==============================
INPUT_VCF="/exports/eddie/scratch/s2909361/pangenome-goat_run2/results/cactus/vep/goat-pg.vcf.gz"
OUTDIR="/exports/eddie/scratch/s2909361/pangenome-goat_run2/results/cactus/vep/chunks"
NCHUNKS=20

# ==============================
# PREP
# ==============================
mkdir -p "${OUTDIR}"
TMPDIR="${OUTDIR}/tmp_split_work"
mkdir -p "${TMPDIR}"

HEADER_FILE="${TMPDIR}/header.vcf"
BODY_FILE="${TMPDIR}/body_only.vcf"
PREFIX="${TMPDIR}/chunk_body_"

echo "==> Extracting VCF header..."
bcftools view -h "${INPUT_VCF}" > "${HEADER_FILE}"

echo "==> Extracting VCF body..."
bcftools view -H "${INPUT_VCF}" > "${BODY_FILE}"

echo "==> Counting total variant records..."
TOTAL_LINES=$(wc -l < "${BODY_FILE}")
echo "Total variant lines: ${TOTAL_LINES}"

if [ "${TOTAL_LINES}" -eq 0 ]; then
    echo "ERROR: No variant lines found in input VCF."
    exit 1
fi

# ==============================
# COMPUTE CHUNK SIZE
# ==============================
# ceiling division so that split creates enough chunks
LINES_PER_CHUNK=$(( (TOTAL_LINES + NCHUNKS - 1) / NCHUNKS ))

echo "Requested number of chunks: ${NCHUNKS}"
echo "Lines per chunk (ceiling division): ${LINES_PER_CHUNK}"

# ==============================
# SPLIT BODY INTO CHUNKS
# ==============================
echo "==> Splitting body into chunk bodies..."
split -d -l "${LINES_PER_CHUNK}" "${BODY_FILE}" "${PREFIX}"

# Count actual produced chunks
mapfile -t BODY_CHUNKS < <(find "${TMPDIR}" -maxdepth 1 -type f -name 'chunk_body_*' | sort)

ACTUAL_CHUNKS=${#BODY_CHUNKS[@]}
echo "Actual chunk bodies created: ${ACTUAL_CHUNKS}"

if [ "${ACTUAL_CHUNKS}" -ne "${NCHUNKS}" ]; then
    echo "WARNING: Expected ${NCHUNKS} chunks, but got ${ACTUAL_CHUNKS}."
    echo "This is not necessarily wrong."
    echo "If total lines are not divisible evenly, the last chunk may be smaller."
fi

# ==============================
# BUILD FULL VCF CHUNKS
# ==============================
echo "==> Building full VCF chunk files with header + body..."

chunk_num=1
for chunk_body in "${BODY_CHUNKS[@]}"; do
    OUT_VCF="${OUTDIR}/chunk_${chunk_num}.vcf"
    OUT_GZ="${OUTDIR}/chunk_${chunk_num}.vcf.gz"

    cat "${HEADER_FILE}" "${chunk_body}" > "${OUT_VCF}"
    bgzip -f "${OUT_VCF}"
    tabix -f -p vcf "${OUT_GZ}"

    echo "Created: ${OUT_GZ}"
    chunk_num=$((chunk_num + 1))
done

# ==============================
# FINAL CHECK
# ==============================
echo "==> Verifying total number of records across all chunks..."

SUM_LINES=0
for i in $(seq 1 $((chunk_num - 1))); do
    CHUNK_LINES=$(bcftools view -H "${OUTDIR}/chunk_${i}.vcf.gz" | wc -l)
    echo "chunk_${i}.vcf.gz : ${CHUNK_LINES} variants"
    SUM_LINES=$((SUM_LINES + CHUNK_LINES))
done

echo "Original total variants : ${TOTAL_LINES}"
echo "Sum of chunk variants   : ${SUM_LINES}"

if [ "${SUM_LINES}" -ne "${TOTAL_LINES}" ]; then
    echo "ERROR: Variant count mismatch after splitting!"
    exit 1
fi

echo "SUCCESS: All variants were split across chunks with no loss."

echo "==> Output directory:"
echo "${OUTDIR}"













































#!/bin/bash
#$ -N vep_chunk
#$ -cwd
#$ -t 1-20
#$ -l h_rt=168:00:00
#$ -pe sharedmem 5
#$ -l h_vmem=8G
#$ -o /exports/eddie/scratch/s2909361/pangenome-goat_run2/results/cactus/vep/chunks/logs/$JOB_NAME.$TASK_ID.$JOB_ID.out
#$ -e /exports/eddie/scratch/s2909361/pangenome-goat_run2/results/cactus/vep/chunks/logs/$JOB_NAME.$TASK_ID.$JOB_ID.err

set -euo pipefail

. /etc/profile.d/modules.sh
module load igmm/apps/vep/115

CHUNK_DIR="/exports/eddie/scratch/s2909361/pangenome-goat_run2/results/cactus/vep/chunks"
OUT_DIR="${CHUNK_DIR}/annotated"

INPUT_VCF="${CHUNK_DIR}/chunk_${SGE_TASK_ID}.vcf.gz"
OUTPUT_VCF="${OUT_DIR}/chunk_${SGE_TASK_ID}.vep.vcf.gz"

mkdir -p "${OUT_DIR}"

vep \
-i "${INPUT_VCF}" \
-o "${OUTPUT_VCF}" \
--vcf \
--compress_output bgzip \
--species capra_hircus \
--assembly ARS1 \
--cache \
--offline \
--dir_cache /exports/eddie/scratch/s2909361/vep_cache \
--fasta /exports/eddie/scratch/s2909361/pangenome-goat_run2/results/cactus/vep/reference_genome.final.fna \
--fork 5 \
--everything \
--force_overwrite




























for i in $(seq 1 20); do
    echo "Checking chunk_${i}"
    bcftools view -h chunk_${i}.vep.vcf.gz | head -3
done



total=0
for i in $(seq 1 20); do
    n=$(bcftools view -H chunk_${i}.vep.vcf.gz | wc -l)
    echo "chunk_${i}: $n"
    total=$((total + n))
done
echo "TOTAL_AFTER_VEP=$total"



ls chunk_*.vep.vcf.gz | sort -V > file_list.txt
bcftools concat -f file_list.txt -Oz -o goat-pg.vep.merged.vcf.gz
tabix -p vcf goat-pg.vep.merged.vcf.gz









#!/bin/bash
#$ -N merge_vep
#$ -cwd
#$ -l h_rt=08:00:00
#$ -pe sharedmem 1
#$ -l h_vmem=16G
#$ -o /exports/eddie/scratch/s2909361/pangenome-goat_run2/results/cactus/vep/chunks/logs/merge.$JOB_ID.out
#$ -e /exports/eddie/scratch/s2909361/pangenome-goat_run2/results/cactus/vep/chunks/logs/merge.$JOB_ID.err

set -euo pipefail

. /etc/profile.d/modules.sh
module load igmm/apps/bcftools/1.20

cd /exports/eddie/scratch/s2909361/pangenome-goat_run2/results/cactus/vep/chunks/annotated

ls chunk_*.vep.vcf.gz | sort -V > file_list.txt

bcftools concat -f file_list.txt -Oz -o goat-pg.vep.merged.vcf.gz
tabix -p vcf goat-pg.vep.merged.vcf.gz





bcftools view -H goat-pg.vep.merged.vcf.gz | head
bcftools +split-vep goat-pg.vep.merged.vcf.gz -l



cut -f3 vep_clean.txt | sort | uniq -c | sort -nr | head

grep -E "missense_variant|stop_gained|frameshift_variant|synonymous_variant" vep_clean.txt > coding.txt

cut -f3 coding.txt | sort | uniq -c | sort -nr

cut -f3 coding.txt | cut -d'&' -f1 > coding_main.txt

sort coding_main.txt | uniq -c | sort -nr


cut -f4 coding.txt | sort | uniq -c


cut -f5 coding.txt | sort | uniq -c | sort -nr | head

awk -F'\t' '$5 != "." && $5 != ""' coding.txt > coding_with_genes.txt

cut -f5 coding_with_genes.txt | sort | uniq -c | sort -nr | head -20

awk -F'\t' 'BEGIN{OFS="\t"} {split($3,a,"&"); $3=a[1]; print}' coding_with_genes.txt > coding_clean.txt

awk -F'\t' '$4 == "HIGH"' coding_clean.txt > high_clean.txt

cut -f5 high_clean.txt | sort | uniq -c | sort -nr | head -20











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






























#!/bin/bash
#$ -N download_fastq
#$ -cwd
#$ -l h_rt=48:00:00
#$ -l h_vmem=16G
#$ -pe sharedmem 3
#$ -o /exports/eddie/scratch/s2909361/pan-genie/logs/$JOB_NAME.$JOB_ID.out
#$ -e /exports/eddie/scratch/s2909361/pan-genie/logs/$JOB_NAME.$JOB_ID.err

set -euo pipefail

. /etc/profile.d/modules.sh
module load igmm/apps/sratoolkit

BASE="/exports/eddie/scratch/s2909361/pan-genie"
mkdir -p "$BASE/sra" "$BASE/fastq2" "$BASE/tmp" "$BASE/logs"

for RUN in ERR4133406 ERR4133399 ERR4133467 ERR4133455
do
    echo "=============================="
    echo "Processing $RUN"

    prefetch "$RUN" --max-size 100G --output-directory "$BASE/sra"

    fasterq-dump "$BASE/sra/$RUN/$RUN.sra" \
        --split-files \
        -O "$BASE/fastq2" \
        -t "$BASE/tmp"

    gzip -f "$BASE/fastq2/${RUN}_1.fastq"
    gzip -f "$BASE/fastq2/${RUN}_2.fastq"

    echo "$RUN finished"
done

echo "All runs finished"














scp s2909361@eddie.ecdf.ed.ac.uk:/exports/eddie/scratch/s2909361/pan-genie/fastqc_results/*.html* . 




module load anaconda

conda create -p /exports/eddie/scratch/s2909361/conda_envs/multiqc_env -c conda-forge -c bioconda multiqc -y

conda activate /exports/eddie/scratch/s2909361/conda_envs/multiqc_env


cd /exports/eddie/scratch/s2909361/pan-genie/fastqc_results
multiqc .

pip install multiqc














cat ERR4133500_1.fastq.gz ERR4133500_2.fastq.gz > ITCH-GGT-0024_mixed_R1R2.fastq.gz
cat ERR4133480_1.fastq.gz ERR4133480_2.fastq.gz > ITCH-GGT-0026_mixed_R1R2.fastq.gz
cat ERR4133494_1.fastq.gz ERR4133494_2.fastq.gz > ITCH-GGT-0030_mixed_R1R2.fastq.gz
cat ERR4133329_1.fastq.gz ERR4133329_2.fastq.gz > ITCH-GGT-0031_mixed_R1R2.fastq.gz

cat ERR4133399_1.fastq.gz ERR4133399_2.fastq.gz ERR4133406_1.fastq.gz ERR4133406_2.fastq.gz > ITCH-VAL-0002_mixed_4.fastq.gz

cat ERR4133455_1.fastq.gz ERR4133455_2.fastq.gz ERR4133467_1.fastq.gz ERR4133467_2.fastq.gz > ITCH-VAL-0014_mixed_4.fastq.gz






gunzip -c ITCH-GGT-0024_mixed_R1R2.fastq.gz > ITCH-GGT-0024.fastq
gunzip -c ITCH-GGT-0026_mixed_R1R2.fastq.gz > ITCH-GGT-0026.fastq
gunzip -c ITCH-GGT-0030_mixed_R1R2.fastq.gz > ITCH-GGT-0030.fastq
gunzip -c ITCH-GGT-0031_mixed_R1R2.fastq.gz > ITCH-GGT-0031.fastq
gunzip -c ITCH-VAL-0002_mixed_4.fastq.gz   > ITCH-VAL-0002.fastq
gunzip -c ITCH-VAL-0014_mixed_4.fastq.gz   > TCH-VAL-0014.fastq
























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

    filename=$(basename "$line" .gz)

    echo "Processing $line"

    gunzip -c "$line" > "$OUT_DIR/$filename"

    echo "Finished $filename"

done < "$READS"







/exports/eddie/scratch/s2909361/pan-genie/input/reads_gz/ITCH-GGT-0024_mixed_R1R2.fastq.gz
/exports/eddie/scratch/s2909361/pan-genie/input/reads_gz/ITCH-GGT-0026_mixed_R1R2.fastq.gz
/exports/eddie/scratch/s2909361/pan-genie/input/reads_gz/ITCH-GGT-0030_mixed_R1R2.fastq.gz
/exports/eddie/scratch/s2909361/pan-genie/input/reads_gz/ITCH-GGT-0031_mixed_R1R2.fastq.gz
/exports/eddie/scratch/s2909361/pan-genie/input/reads_gz/ITCH-VAL-0002_mixed_4.fastq.gz
/exports/eddie/scratch/s2909361/pan-genie/input/reads_gz/ITCH-VAL-0014_mixed_4.fastq.gz










#!/bin/bash

#$ -N uindex_pan-genie_inputs
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
















#!/bin/bash

#$ -N unzip_short_reads_val_14
#$ -cwd
#$ -l h_vmem=16G
#$ -l h_rt=120:00:00
#$ -pe sharedmem 1
#$ -o /exports/eddie/scratch/s2909361/pan-genie/logs/$JOB_NAME.$JOB_ID.out
#$ -e /exports/eddie/scratch/s2909361/pan-genie/logs/$JOB_NAME.$JOB_ID.err

set -euo pipefail

. /etc/profile.d/modules.sh

BASE="/exports/eddie/scratch/s2909361/pan-genie"
OUT_DIR="$BASE/input/reads"
READS="/exports/eddie/scratch/s2909361/pan-genie/input/reads_gz/ITCH-VAL-0014_mixed_4.fastq.gz"

mkdir -p "$OUT_DIR"

gunzip -c "$READS" > "$OUT_DIR/ITCH-VAL-0014.fastq"

    



bcftools query -l goat-pg.vcf > sample_names.txt
grep -E '_hap[12]$' sample_names.txt > hap_samples.txt

bcftools view \
  -S hap_samples.txt \
  goat-pg.vcf \
  -o goat-pg.haponly.vcf









 


#!/bin/bash

#$ -N remove_multiallelic
#$ -cwd
#$ -l h_vmem=16G
#$ -l h_rt=120:00:00
#$ -pe sharedmem 1
#$ -o /exports/eddie/scratch/s2909361/pan-genie/logs/$JOB_NAME.$JOB_ID.out
#$ -e /exports/eddie/scratch/s2909361/pan-genie/logs/$JOB_NAME.$JOB_ID.err


set -euo pipefail

. /etc/profile.d/modules.sh
module load igmm/apps/bcftools/1.20


 bcftools norm -m -both \
  -Oz \
  -o /exports/eddie/scratch/s2909361/pan-genie/input/vcf/goat_pg_biallelic.vcf.gz \
  /exports/eddie/scratch/s2909361/pan-genie/input/vcf/goat-pg.haponly.diploid.vcf














  
















  #!/bin/bash

#$ -N remove_multiallelic
#$ -cwd
#$ -l h_vmem=16G
#$ -l h_rt=120:00:00
#$ -pe sharedmem 1
#$ -o /exports/eddie/scratch/s2909361/pan-genie/logs/$JOB_NAME.$JOB_ID.out
#$ -e /exports/eddie/scratch/s2909361/pan-genie/logs/$JOB_NAME.$JOB_ID.err

set -euo pipefail


. /etc/profile.d/modules.sh
module load igmm/apps/bcftools/1.20

bcftools view -m2 -M2 -v snps,indels \
  -Ov \
  -o /exports/eddie/scratch/s2909361/pan-genie/input/vcf/goat_pg_biallelic_only.vcf \
  /exports/eddie/scratch/s2909361/pan-genie/input/vcf/goat-pg.haponly.diploid.vcf























#!/bin/bash

#$ -N index_pan-genie_inputs
#$ -cwd
#$ -l h_vmem=16G
#$ -l h_rt=120:00:00
#$ -pe sharedmem 8
#$ -o /exports/eddie/scratch/s2909361/pan-genie/logs/$JOB_NAME.$JOB_ID.out
#$ -e /exports/eddie/scratch/s2909361/pan-genie/logs/$JOB_NAME.$JOB_ID.err

set -euo pipefail

. /etc/profile.d/modules.sh

cd /exports/eddie/scratch/s2909361/pan-genie

/exports/eddie/scratch/s2909361/tools/pangenie/build/src/PanGenie-index \
  -v input/vcf/goat_pg_biallelic_only.vcf \
  -r input/ref/reference_genome.final.fna \
  -t 8 \
  -o input/indexed_vcf/goat_pg_index


  














#!/bin/bash

#$ -N run_pangenie
#$ -cwd
#$ -t 1-6
#$ -l h_vmem=16G
#$ -l h_rt=120:00:00
#$ -pe sharedmem 8
#$ -o /exports/eddie/scratch/s2909361/pan-genie/logs/$JOB_NAME.$TASK_ID.$JOB_ID.out
#$ -e /exports/eddie/scratch/s2909361/pan-genie/logs/$JOB_NAME.$TASK_ID.$JOB_ID.err

set -euo pipefail

. /etc/profile.d/modules.sh

BASE="/exports/eddie/scratch/s2909361/pan-genie"
PG="/exports/eddie/scratch/s2909361/tools/pangenie/build/src/PanGenie"
INDEX="$BASE/input/indexed_vcf/goat_pg_index"
READDIR="$BASE/input/reads"
OUTDIR="$BASE/results"

mkdir -p "$OUTDIR" "$BASE/logs"

READS=(
"$READDIR/ITCH-GGT-0024_mixed_R1R2.fastq"
"$READDIR/ITCH-GGT-0026_mixed_R1R2.fastq"
"$READDIR/ITCH-GGT-0030_mixed_R1R2.fastq"
"$READDIR/ITCH-GGT-0031_mixed_R1R2.fastq"
"$READDIR/ITCH-VAL-0002_mixed_4.fastq"
"$READDIR/ITCH-VAL-0014_mixed_4.fastq"
)

READFILE="${READS[$((SGE_TASK_ID-1))]}"

SAMPLE=$(basename "$READFILE" .fastq)
SAMPLE=${SAMPLE%_mixed_R1R2}
SAMPLE=${SAMPLE%_mixed_4}

echo "======================================"
echo "Running PanGenie for sample: $SAMPLE"
echo "Read file: $READFILE"
echo "Index prefix: $INDEX"
echo "Output prefix: $OUTDIR/$SAMPLE"
echo "Task ID: $SGE_TASK_ID"
echo "Hostname: $(hostname)"
echo "Start time: $(date)"
echo "======================================"

"$PG" \
  -f "$INDEX" \
  -i "$READFILE" \
  -o "$OUTDIR/$SAMPLE" \
  -s "$SAMPLE" \
  -t 8 \
  -j 8

echo "Finished sample: $SAMPLE"
echo "End time: $(date)"



















#$ -cwd
#$ -l h_rt=168:00:00
#$ -pe sharedmem 16
#$ -l h_vmem=20G
#$ -o /exports/eddie/scratch/s2909361/pangenome-goat_run2/logs/$JOB_NAME.$JOB_ID.out
#$ -e /exports/eddie/scratch/s2909361/pangenome-goat_run2/logs/$JOB_NAME.$JOB_ID.err

set -euo pipefail

. /etc/profile.d/modules.sh
module load igmm/apps/singularity/3

SCRATCH="/exports/eddie/scratch/s2909361"
PROJECT="${SCRATCH}/pangenome-goat_run2"

RUN_DIR="${PROJECT}/cactus"
OUT_DIR="${PROJECT}/results/cactus"

TMP_DIR="${PROJECT}/tmp/cactus_${JOB_ID}"
JOBSTORE="${RUN_DIR}/js_${JOB_ID}"

GENOMES_TXT="${PROJECT}/config/goat_genomes.txt"
REF_NAME="reference"
REF_FASTA="${SCRATCH}/assemblies/final_files/reference_genome.final.fna"
SIF="${PROJECT}/containers/cactus_v2.9.9.sif"

mkdir -p "${RUN_DIR}" "${OUT_DIR}" "${TMP_DIR}" "${PROJECT}/logs"

test -s "${GENOMES_TXT}"
test -s "${REF_FASTA}"
test -s "${SIF}"

cd "${RUN_DIR}"

echo "JOB_ID=${JOB_ID}"
echo "OUT_DIR=${OUT_DIR}"
echo "TMP_DIR=${TMP_DIR}"
echo "JOBSTORE=${JOBSTORE}"
echo "REF_FASTA=${REF_FASTA}"
echo "GENOMES_TXT=${GENOMES_TXT}"
echo "SIF=${SIF}"

singularity exec \
  -B "${SCRATCH}:${SCRATCH}" \
  "${SIF}" \
  cactus-pangenome \
    "${JOBSTORE}" \
    "${GENOMES_TXT}" \
    --outDir "${OUT_DIR}" \
    --outName "goat-pg" \
    --reference "${REF_NAME}" \
    --vcf \
    --gfa \
    --workDir "${TMP_DIR}" \
    --maxCores 16 \
    --defaultMemory 20G \
    --defaultDisk 80G

echo "finished"



bcftools stats "$VCF" > vcf_check.stats
grep '^SN' vcf_check.stats | head -n 20




# Main goals of these checks:
# 1. Confirm the VCF is compressed and indexed
# 2. Confirm GT exists in the FORMAT field
# 3. Confirm samples appear as diploid individuals, not hap1/hap2 columns
# 4. Confirm genotypes are phased diploid style (0|0, 0|1, 1|0, 1|1)
# 5. Measure number of samples and variants
# 6. Inspect general VCF quality with bcftools stats
# 7. Check multiallelic and symbolic ALT representation
# 8. Check for repeated genomic positions before downstream analyses









#!/bin/bash

############################################################
# VCF checking notes for goat-pg.vcf.gz
# Purpose:
# Check whether the new Cactus VCF is a proper multisample,
# diploid-style phased VCF and inspect features relevant for
# UpSet plotting and later PanGenie preparation.
############################################################

# Path to the VCF file
VCF="/exports/eddie/scratch/s2909361/pangenome-goat_run2/results/cactus/goat-pg.vcf.gz"

############################################################
# 1. Check that the VCF file and its index exist
# This confirms the file is present, compressed, and indexed.
############################################################
ls -lh "$VCF" "$VCF.tbi"

############################################################
# 2. View the first lines of the VCF header
# This shows file format, FILTER, FORMAT, INFO, and contig lines.
############################################################
bcftools view -h "$VCF" | head -n 30

############################################################
# 3. Show FORMAT fields in the header
# This checks whether GT and other sample FORMAT fields exist.
############################################################
bcftools view -h "$VCF" | grep '^##FORMAT'

############################################################
# 4. View the end of the header
# This shows the final header line with sample names.
############################################################
bcftools view -h "$VCF" | tail -n 5

############################################################
# 5. List all sample names in the VCF
# This checks whether samples appear as one individual per column.
############################################################
bcftools query -l "$VCF"

############################################################
# 6. View the first variant records
# This gives a raw look at how variants and genotypes are stored.
############################################################
bcftools view "$VCF" | head -n 10

############################################################
# 7. Extract CHROM, POS, and GT values only
# This is a cleaner way to inspect genotype representation directly.
############################################################
bcftools query -f '%CHROM\t%POS[\t%GT]\n' "$VCF" | head -n 10

############################################################
# 8. Count the number of samples
# This gives the total number of sample columns in the VCF.
############################################################
bcftools query -l "$VCF" | wc -l

############################################################
# 9. Count the total number of variant records
# This gives the total number of lines/variants in the VCF body.
############################################################
bcftools view -H "$VCF" | wc -l

############################################################
# 10. Generate bcftools summary statistics
# This creates a general stats file for the multisample VCF.
############################################################
bcftools stats "$VCF" > vcf_check.stats

############################################################
# 11. Show summary numbers from the stats file
# SN lines contain general summary counts.
############################################################
grep '^SN' vcf_check.stats | head -n 20

############################################################
# 12. Show transition/transversion summary
# This gives Ts/Tv ratios as a quick sanity check of SNP patterns.
############################################################
grep '^TSTV' vcf_check.stats | head

############################################################
# 13. Show per-sample counts from bcftools stats
# PSC lines summarize sample-level variant statistics.
############################################################
grep '^PSC' vcf_check.stats | head

############################################################
# 14. Count genotype classes across the whole VCF
# This is one of the most useful checks for phased diploid GTs.
# We want to see values like 0|0, 0|1, 1|0, 1|1, and maybe missing.
############################################################
bcftools query -f '[%GT\n]' "$VCF" | sort | uniq -c | sort -nr | head -n 20

############################################################
# 15. Count multiallelic sites
# Multiallelic sites have ALT fields containing commas.
# Important because PanGenie often requires extra processing here.
############################################################
bcftools view -H "$VCF" | awk '$5 ~ /,/' | wc -l

############################################################
# 16. Show examples of multiallelic sites
# This helps inspect how complex ALT alleles are represented.
############################################################
bcftools view -H "$VCF" | awk '$5 ~ /,/' | head -n 10

############################################################
# 17. Count symbolic ALT alleles
# Symbolic alleles look like <DEL>, <INS>, etc.
# This matters for downstream compatibility and interpretation.
############################################################
bcftools view -H "$VCF" | awk '$5 ~ /^</' | wc -l

############################################################
# 18. Show examples of symbolic ALT alleles
# Useful to see whether SVs are symbolic or sequence-resolved.
############################################################
bcftools view -H "$VCF" | awk '$5 ~ /^</' | head -n 10

############################################################
# 19. Check for duplicate CHROM-POS pairs
# This is a rough warning check for repeated positions.
# It is not a full overlap test, but it can reveal potential issues.
############################################################
bcftools query -f '%CHROM\t%POS\n' "$VCF" | uniq -d | head -n 20

############################################################
# 20. Count duplicate CHROM-POS pairs
# Gives the number of repeated coordinate pairs in the VCF.
############################################################
bcftools query -f '%CHROM\t%POS\n' "$VCF" | uniq -d | wc -l
















#!/bin/bash

#$ -N index_pangenie
#$ -cwd
#$ -l h_vmem=8G
#$ -l h_rt=72:00:00
#$ -pe sharedmem 16
#$ -o /exports/eddie/scratch/s2909361/pan-genie/logs/$JOB_NAME.$JOB_ID.out
#$ -e /exports/eddie/scratch/s2909361/pan-genie/logs/$JOB_NAME.$JOB_ID.err

set -euo pipefail

. /etc/profile.d/modules.sh

BASE="/exports/eddie/scratch/s2909361/pan-genie"
LOGS="$BASE/logs"

PANGENIE_INDEX="/exports/eddie/scratch/s2909361/tools/pangenie/build/src/PanGenie-index"
REF="$BASE/input/ref/reference_genome.final.fna"


VCF="$BASE/input/vcf/goat-pg.phased.vcf"

OUT_PREFIX="$BASE/input/goat_pg_index"

mkdir -p "$LOGS"

echo "Checking input files..."

[ -x "$PANGENIE_INDEX" ] || { echo "ERROR: PanGenie-index not found or not executable: $PANGENIE_INDEX"; exit 1; }
[ -f "$REF" ] || { echo "ERROR: Reference FASTA not found: $REF"; exit 1; }
[ -f "$VCF" ] || { echo "ERROR: VCF not found: $VCF"; exit 1; }

if [[ "$REF" == *.gz ]]; then
    echo "ERROR: Reference FASTA must NOT be compressed."
    exit 1
fi

if [[ "$VCF" == *.gz ]]; then
    echo "ERROR: VCF must NOT be compressed."
    exit 1
fi

echo "Starting PanGenie-index"
date
echo "Reference: $REF"
echo "VCF: $VCF"
echo "Output prefix: $OUT_PREFIX"

"$PANGENIE_INDEX" \
    -r "$REF" \
    -v "$VCF" \
    -t 16 \
    -o "$OUT_PREFIX"

echo "PanGenie-index finished successfully"
date



bcftools view -m2 -M2 \
  -Oz \
  -o /exports/eddie/scratch/s2909361/pan-genie/input/vcf/goat-pg.biallelic.only.vcf.gz \
  /exports/eddie/scratch/s2909361/pan-genie/input/vcf/goat-pg.vcf.gz

  bcftools index -t /exports/eddie/scratch/s2909361/pan-genie/input/vcf/goat-pg.biallelic.only.vcf.gz

  gunzip -c /exports/eddie/scratch/s2909361/pan-genie/input/vcf/goat-pg.biallelic.only.vcf.gz > /exports/eddie/scratch/s2909361/pan-genie/input/vcf/goat-pg.biallelic.only.vcf





  bcftools view \
  -i 'REF~"^[ACGT]+$" && ALT~"^[ACGT,]+$"' \
  -Oz \
  -o goat-pg.clean.vcf.gz \
  goat-pg.biallelic.only.vcf.gz

  bcftools index -t goat-pg.clean.vcf.gz
  gunzip -c goat-pg.clean.vcf.gz > goat-pg.clean.vcf


  bcftools view -H goat-pg.biallelic.only.vcf | wc -l
bcftools view -H goat-pg.clean.vcf | wc -l

bcftools query -f '[%GT\t]\n' goat-pg.clean.vcf.gz | grep '/'
bcftools view -Ov goat-pg.biallelic.only.vcf | sed 's/\//|/g' | bcftools view -Oz -o goat-pg.phased.vcf.gz
bcftools query -f '[%GT\t]\n' goat-pg.phased.vcf.gz | grep '/'

gunzip -c goat-pg.phased.vcf.gz > goat-pg.phased.vcf














#!/bin/bash

#$ -N run_pangenie_0024
#$ -cwd
#$ -l h_vmem=16G
#$ -l h_rt=72:00:00
#$ -pe sharedmem 5
#$ -o /exports/eddie/scratch/s2909361/pan-genie/logs/$JOB_NAME.$JOB_ID.out
#$ -e /exports/eddie/scratch/s2909361/pan-genie/logs/$JOB_NAME.$JOB_ID.err

set -euo pipefail

. /etc/profile.d/modules.sh

BASE="/exports/eddie/scratch/s2909361/pan-genie"
LOGS="$BASE/logs"
READS="$BASE/input/reads/ITCH-GGT-0024_mixed_R1R2.fastq"

INDEX_PREFIX="/exports/eddie/scratch/s2909361/pan-genie/input/index/goat_pg_index"

PANGENIE="/exports/eddie/scratch/s2909361/tools/pangenie/build/src/PanGenie"

SAMPLE="ITCH-GGT-0024"
OUT_DIR="$BASE/results/$SAMPLE"
OUT_PREFIX="$OUT_DIR/$SAMPLE"

mkdir -p "$LOGS" "$OUT_DIR"

echo "Checking input files..."

[ -x "$PANGENIE" ] || { echo "ERROR: PanGenie not found or not executable: $PANGENIE"; exit 1; }
[ -f "$READS" ] || { echo "ERROR: Reads file not found: $READS"; exit 1; }
[ -f "${INDEX_PREFIX}_UniqueKmersMap.cereal" ] || { echo "ERROR: PanGenie index prefix seems wrong: $INDEX_PREFIX"; exit 1; }

echo "Starting PanGenie genotyping"
date
echo "Reads: $READS"
echo "Index prefix: $INDEX_PREFIX"
echo "Sample: $SAMPLE"
echo "Output prefix: $OUT_PREFIX"

"$PANGENIE" \
    -f "$INDEX_PREFIX" \
    -i "$READS" \
    -s "$SAMPLE" \
    -j 5 \
    -t 5 \
    -o "$OUT_PREFIX"

echo "PanGenie finished successfully"
date


















#!/bin/bash

#$ -N index_pangenie
#$ -cwd
#$ -l h_vmem=16G
#$ -l h_rt=72:00:00
#$ -pe sharedmem 5
#$ -o /exports/eddie/scratch/s2909361/pan-genie/logs/$JOB_NAME.$JOB_ID.out
#$ -e /exports/eddie/scratch/s2909361/pan-genie/logs/$JOB_NAME.$JOB_ID.err

set -euo pipefail

. /etc/profile.d/modules.sh

BASE="/exports/eddie/scratch/s2909361/pan-genie"
LOGS="$BASE/logs"

PANGENIE_INDEX="/exports/eddie/scratch/s2909361/tools/pangenie/build/src/PanGenie-index"
REF="$BASE/input/ref/reference_genome.final.fna"


VCF="$BASE/input/vcf/goat-pg.phased.vcf"

OUT_PREFIX="$BASE/input/goat_pg_index"

mkdir -p "$LOGS"

echo "Checking input files..."

[ -x "$PANGENIE_INDEX" ] || { echo "ERROR: PanGenie-index not found or not executable: $PANGENIE_INDEX"; exit 1; }
[ -f "$REF" ] || { echo "ERROR: Reference FASTA not found: $REF"; exit 1; }
[ -f "$VCF" ] || { echo "ERROR: VCF not found: $VCF"; exit 1; }

if [[ "$REF" == *.gz ]]; then
    echo "ERROR: Reference FASTA must NOT be compressed."
    exit 1
fi

if [[ "$VCF" == *.gz ]]; then
    echo "ERROR: VCF must NOT be compressed."
    exit 1
fi

echo "Starting PanGenie-index"
date
echo "Reference: $REF"
echo "VCF: $VCF"
echo "Output prefix: $OUT_PREFIX"

"$PANGENIE_INDEX" \
    -r "$REF" \
    -v "$VCF" \
    -t 5 \
    -o "$OUT_PREFIX"

echo "PanGenie-index finished successfully"
date



bcftools query -f '%GT\n' ITCH-GGT-0024_genotyping.vcf | sort | uniq -c















