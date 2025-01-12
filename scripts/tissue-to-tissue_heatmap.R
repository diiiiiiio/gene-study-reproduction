# 加载所需库
library(pheatmap)
library(readxl)
library(RColorBrewer)

# 第1步：加载数据
expression_data <- read_excel("MM.xlsx")
expression_data <- as.data.frame(expression_data)
rownames(expression_data) <- expression_data[, 1]  # 设置基因名为行名
expression_data <- expression_data[, -1]           # 移除基因名列

metadata <- read.csv("SraRunTable.csv")
rownames(metadata) <- metadata$Run
metadata <- metadata[rownames(metadata) %in% colnames(expression_data), ]
expression_data <- expression_data[, colnames(expression_data) %in% rownames(metadata)]

# 第2步：按组织类型聚合数据
metadata$tissue <- factor(metadata$tissue)
tissue_data <- t(apply(expression_data, 1, function(row) tapply(row, metadata$tissue, mean, na.rm = TRUE)))

# 第3步：归一化数据
normalized_data <- t(scale(t(tissue_data)))  # z-score归一化

# 第4步：计算相关性和距离
correlation_matrix <- cor(normalized_data, method = "pearson", use = "pairwise.complete.obs")
dissimilarity_matrix <- as.dist(1 - correlation_matrix)

# 第5步：生成热图
color_palette <- colorRampPalette(brewer.pal(9, "Reds"))(100)

pheatmap(
  correlation_matrix,
  clustering_distance_rows = dissimilarity_matrix,
  clustering_distance_cols = dissimilarity_matrix,
  clustering_method = "ward.D2",                   # 使用Ward.D2方法
  color = color_palette,                           # 白到红渐变
  border_color = NA,                               # 移除边框
  main = "组织间相关性热图",                          # 热图标题
  fontsize = 10,
  fontsize_row = 10,
  fontsize_col = 10,
  labels_row = colnames(correlation_matrix),
  labels_col = colnames(correlation_matrix),
  legend = TRUE,
  legend_breaks = seq(0, 1, 0.2)                   # 优化图例
)

# 保存相关性矩阵到文件
write.csv(correlation_matrix, "tissue_correlation_matrix.csv")
