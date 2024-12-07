# 研究背景

亲爱的基因领域业内人士，我是一个 AI 学生，在此展示我单独复现这篇 [Extensive variation between tissues in allele specific expression in an outbred mammal](https://www.researchgate.net/publication/284570492_Extensive_variation_between_tissues_in_allele_specific_expression_in_an_outbred_mammal) 论文的成果。

这篇论文是我在 **Fundamentals of Data Analytics** 课程中了解聚类章节时额外阅读到的参考文献之一。我选择复现其中的计算部分是因为我没有加入任何生物实验室，但这篇论文的数据已公开在 NCBI 中。  
原始数据可从 [NCBI SRA (Accession: SRP042639)](https://www.ncbi.nlm.nih.gov/sra?term=SRP042639) 获得。

# 方法概览

**论文原文方法章节 (部分引用)**：  

> *Methods  
> Tissue sampling Eighteen tissues: black skin, white skin, adrenal gland, brain caudal lobe, brain cerebellum, heart, kidney, liver, lung, intestinal lymph node, mammary, leg muscle (semimembranosus), ovary, spleen, thymus, thyroid and tongue, from one lactating dairy cow were collected directly after ...*

该研究对 18 种不同组织（如黑色皮肤、白色皮肤、肾上腺、脑、肝、肺、血液等）提取 RNA，构建文库并使用 Illumina HiSeq2000 进行测序，获得 100bp 双端测序数据。数据在测序后经质控、去低质量碱基和过短reads过滤，然后映射到 UMD3.1 牛基因组 (Ensembl release 75) 上，并使用 TOPHAT2、HTSeq、EdgeR 等进行差异表达与组织特异性表达分析。

**我将处理流程分为：**

  1. 数据获取  （请在 project 目录下执行 bash scripts/01_download.sh）
     - 确定文件结构           
     - 创建文件夹  
     - 下载 sratoolkit  
     - 用 sratoolkit 从 NCBI 下载 RNA-seq 文件并转换为 FASTQ  
  2. 质量控制  
     - 使用 FastQC 查看 RNA 测序质量  
     - 使用 fastp 过滤掉低质量片段  
  3. 与基因组模板比对  
     - 使用 STAR 建立基因组索引  
     - 使用 STAR 进行比对  
  4. 得出基因表达矩阵  
     - 使用 HTSeq-count 对比对结果进行定量
- 下游步骤：  
  5. 差异表达分析和组织特异性表达（TSE）分析（使用 EdgeR）  
  6. 对差异基因结果可视化（绘制火山图、热图等）

# 实验环境

- 操作系统：Ubuntu 22.04.5 LTS (在 WSL2 上运行，GNU/Linux 5.15.167.4-microsoft-standard-WSL2 x86_64)  
- 包管理与环境控制：Conda  
- 其他工具与版本：  
  - SRA Toolkit (fastq-dump/fasterq-dump)  
  - FastQC  
  - Trimmomatic / Cutadapt (根据需要)  
  - TopHat2 或 HISAT2  
  - HTSeq  
  - R 语言及 EdgeR、DESeq、gplots 等 R 包





