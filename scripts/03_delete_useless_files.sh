#!/usr/bin/env bash
set -euo pipefail

# Change directory to where your data directories (SRR...) are located
cd ~/projects/gene-study-reproduction/rawdata

# Loop through each directory that starts with 'SRR'
for sample_dir in SRR*; do
    if [ -d "$sample_dir" ]; then
        cd "$sample_dir"

        # Delete all FASTQ files except the filtered ones
        # This finds any .fastq.gz that does NOT contain ".filtered." and deletes it.
        find . -maxdepth 1 -type f -name '*.fastq.gz' ! -name '*filtered.fastq.gz' -exec rm {} \;

        # Delete SRA and related cache files
        rm -f *.sra.vdbcache

        # Delete AC_000* files if they are no longer needed
        rm -f AC_000*

        # Delete fastp reports if not needed
        rm -f fastp.html fastp.json fastp.log

        cd ..
    fi
done

echo "Unwanted files deleted successfully."

