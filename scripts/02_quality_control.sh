#!/usr/bin/env bash
set -e  # Exit on errors

cd ~/projects/gene-study-reproduction/rawdata

delete_raw=true  # Set to false if you want to keep the original files

find SRR* -type d | parallel -j 8 '
    cd {} && \
    sample=$(basename {}) && \
    r1=$(find . -maxdepth 1 -name "*_1.fastq.gz" -print -quit) && \
    r2=$(find . -maxdepth 1 -name "*_2.fastq.gz" -print -quit) && \
    if [[ -z "$r1" || -z "$r2" ]]; then
        echo "Error: Missing paired-end files for $sample" >&2
        exit 1
    fi && \
    fastp \
        -i "$r1" \
        -I "$r2" \
        -o "${sample}_1.filtered.fastq.gz" \
        -O "${sample}_2.filtered.fastq.gz" \
        --qualified_quality_phred 20 \
        --cut_right \
        --cut_right_mean_quality 20 \
        --average_qual 20 \
        --n_base_limit 3
        --length_required 50 \
        --thread 2 \
        --html "${sample}.fastp.html" \
        --json "${sample}.fastp.json" > "${sample}_fastp.log" 2>&1 && \
    if [ "$delete_raw" = true ]; then rm "$r1" "$r2"; fi && \
    cd .. || echo "Error in sample $sample"
'

