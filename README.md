# Research Background  

Dear colleagues in the genetics field,  

I am an AI student, and this repository showcases my independent replication of the paper [Extensive variation between tissues in allele-specific expression in an outbred mammal](https://www.researchgate.net/publication/284570492_Extensive_variation_between_tissues_in_allele_specific_expression_in_an_outbred_mammal).  

I came across this paper as supplementary reading during the clustering chapter of my **Fundamentals of Data Analytics** course. I chose to replicate its computational sections because I do not currently belong to any biology lab, and the data for this study is openly available on NCBI.  
The raw data can be accessed from [NCBI SRA (Accession: SRP042639)](https://www.ncbi.nlm.nih.gov/sra?term=SRP042639).  

---

# Method Overview  

**Excerpt from the original methods section (partial citation):**  

> *Methods  
> Tissue sampling: Eighteen tissues—black skin, white skin, adrenal gland, brain caudal lobe, brain cerebellum, heart, kidney, liver, lung, intestinal lymph node, mammary gland, leg muscle (semimembranosus), ovary, spleen, thymus, thyroid, and tongue—from one lactating dairy cow were collected immediately after...*

This study involved extracting RNA from 18 different tissues (e.g., black skin, white skin, adrenal gland, brain, liver, lung, and blood), constructing libraries, and sequencing them using Illumina HiSeq2000 to obtain 100bp paired-end reads. After sequencing, the data underwent quality control, trimming of low-quality bases and short reads, alignment to the UMD3.1 bovine genome (Ensembl release 75), and differential expression and tissue-specific expression analysis using tools like TOPHAT2, HTSeq, and EdgeR.  

**I have structured the workflow into the following steps:**  

1. **Data Acquisition** (Run `bash scripts/01_download.sh` in the project directory)  
   - Organize file structure  
   - Create necessary folders  
   - Download `sratoolkit`  
   - Use `sratoolkit` to retrieve RNA-seq files from NCBI and convert them into FASTQ format  

2. **Quality Control**  
   - Use `FastQC` to check RNA sequencing quality  
   - Filter low-quality reads using `fastp`  

3. **Alignment to the Genome Template**  
   - Build genome index using `STAR`  
   - Perform alignment using `STAR`  

4. **Gene Expression Matrix Generation**  
   - Quantify aligned results using `HTSeq-count`  

**Downstream Steps:**  
5. Differential expression analysis and tissue-specific expression (TSE) analysis using `EdgeR`  
6. Visualization of differential gene results (e.g., volcano plots, heatmaps, etc.)  

---

# Experimental Environment  

- **Operating System:** Ubuntu 22.04.5 LTS (running on WSL2, GNU/Linux 5.15.167.4-microsoft-standard-WSL2 x86_64)  
- **Package Management and Environment Control:** Conda  
- **Tools and Versions Used:**  
  - SRA Toolkit (`fastq-dump`/`fasterq-dump`)  
  - FastQC  
  - Trimmomatic / Cutadapt (as needed)  
  - TopHat2 or HISAT2  
  - HTSeq  
  - R language with packages such as `EdgeR`, `DESeq`, `gplots`  
