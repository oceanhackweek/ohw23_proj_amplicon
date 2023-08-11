library(dplyr)
library(mixOmics)
library(stringr)
library(mixKernel)


first_draft = function(){
  df = read.csv("data/ampliseq/ampliseq_results/qiime2/abundance_tables/abs-abund-table-4.tsv",
                         sep="\t", skip = 1)
  metadata = read.csv("data/metadata.tsv", sep="\t", row.names=1)
  
  
  # Concatenate unknowns and format row names
  fmt_rows = str_split_fixed(df$X.OTU.ID, ";", n=4)[,4]
  fmt_rows = replace(fmt_rows, fmt_rows=="", "Unknown")
  df$X.OTU.ID = fmt_rows
  df = df %>% group_by(X.OTU.ID) %>% summarise(across(everything(), ~ sum(.))) %>% as.data.frame
  row.names(df) = df$X.OTU.ID
  df = df[,-1] %>% t
  metadata = metadata[c(df %>% row.names),]
  
  
  # Sparse PCA
  model = spca(df+1, logratio="CLR", center=T, scale=T)
  plotIndiv(model, title="Sparse PCA of Ampliseq data, order level.", group=metadata$Depth_cat, legend=T)
  plotVar(model, title="Correlation plot of Sparse PCA of Ampliseq data, order level.")
  cim(model, title="Cluster Image Map of Sparse PCA of Ampliseq data, order level.")
  
  # PCA
  model = pca(df+1, logratio="CLR", center=T, scale=T)
  plotIndiv(model, title="PCA of Ampliseq data, order level.", group=metadata$Depth_cat, legend=T)
  plotVar(model, title="Correlation plot of PCA of Ampliseq data, order level.")
}

first_draft()

metadata = read.csv("data/metadata.tsv", sep="\t", row.names=1)

# Family-level analysis
faseq = as.data.frame(read.csv("data/tables/aseq_Family.csv", row.names=1) %>% t)
ftour = as.data.frame(read.csv("data/tables/tour_Family.csv", row.names=1) %>% t)
fobit = as.data.frame(read.csv("data/tables/obit_Family.csv", row.names=1) %>% t)

# Remove samples that aren't present from metadata
metadata = metadata[c(faseq %>% row.names),]

# Block pls
# X = list(X1=faseq, X2=ftour, X3=fobit)
# model = block.pls(X, near.zero.var=T, mode="canonical")

# PCA
model = pca(fobit + 1, logratio="CLR", ncomp = 5)
plotIndiv(model, group=metadata$Depth_cat, legend=T)

# PLS
model = pls(logratio.transfo(faseq + 1), metadata$Depth_m)
