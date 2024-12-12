#!/usr/bin/env bash
set -euo pipefail

# Adjust this if you want to limit threads:
THREADS=$(nproc)  # Automatically detects available CPU cores

# Directory setup
REF_DIR=~/projects/gene-study-reproduction/ref
RAW_DIR=~/projects/gene-study-reproduction/rawdata
ALIGN_DIR=~/projects/gene-study-reproduction/alignment

mkdir -p "$ALIGN_DIR"

# Files for reference
GENOME_FA="$REF_DIR/Bos_taurus.UMD3.1.75.dna.toplevel.fa"
GTF="$REF_DIR/Bos_taurus.UMD3.1.75.gtf"

# STAR index directory
INDEX_DIR="$REF_DIR/STAR_index"
mkdir -p "$INDEX_DIR"

echo "=== Indexing genome with STAR ==="
STAR --runThreadN 4 \
     --runMode genomeGenerate \
     --genomeDir "$INDEX_DIR" \
     --genomeFastaFiles "$GENOME_FA" \
     --sjdbGTFfile "$GTF" \
     --sjdbOverhang 100 \
     --limitGenomeGenerateRAM 10000000000

echo "=== Genome indexing complete ==="

# Align all samples
echo "=== Starting alignment of all samples ==="
for SAMPLE_DIR in "$RAW_DIR"/SRR*; do
    if [ -d "$SAMPLE_DIR" ]; then
        SAMPLE=$(basename "$SAMPLE_DIR")

        # Find paired filtered FASTQ files
        R1=$(find "$SAMPLE_DIR" -maxdepth 1 -name "*_1.filtered.fastq.gz" -print -quit)
        R2=$(find "$SAMPLE_DIR" -maxdepth 1 -name "*_2.filtered.fastq.gz" -print -quit)

        if [[ -z "$R1" || -z "$R2" ]]; then
            echo "Warning: No paired filtered FASTQs found for $SAMPLE. Skipping..."
            continue
        fi

        echo "=== Aligning $SAMPLE ==="
        STAR --runThreadN "$THREADS" \
             --genomeDir "$INDEX_DIR" \
             --readFilesIn "$R1" "$R2" \
             --readFilesCommand "gzip -dc" \
             --outFileNamePrefix "$ALIGN_DIR/${SAMPLE}_" \
             --outSAMtype BAM SortedByCoordinate

        echo "=== $SAMPLE alignment complete ==="
    fi
done

echo "=== All alignments complete ==="
