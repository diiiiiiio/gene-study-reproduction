#!/usr/bin/env bash

set -euo pipefail

mkdir -p rawdata
prefetch SRP042639 --output-directory rawdata

cd rawdata
for sra_dir in SRR*; do
    if [ -d "$sra_dir" ] && ls "$sra_dir"/*.sra 1> /dev/null 2>&1; then
        cd "$sra_dir"
        
        
        sra_file=$(ls *.sra)
        
        echo "Converting $sra_file to FASTQ..."
        fasterq-dump --split-files "$sra_file"  
        echo "Compressing FASTQ files..."
        gzip *.fastq  
        
        echo "Removing original SRA file $sra_file..."
        rm "$sra_file"

        
        cd ..
    fi
done
echo "All SRA files have been processed and FASTQ files are in data/fastq."
