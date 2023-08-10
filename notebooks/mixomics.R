library(dplyr)
library(mixOmics)
library(stringr)

df = read.csv("data/ampliseq/ampliseq_results/qiime2/abundance_tables/abs-abund-table-4.tsv",
                       sep="\t", skip = 1)
fmt_rows = str_split_fixed(df$X.OTU.ID, ";", n=4)[,4]
fmt_rows = replace(fmt_rows, fmt_rows=="", "Unknown")
df$X.OTU.ID = fmt_rows
df = df %>% group_by(X.OTU.ID) %>% summarise(across(everything(), ~ sum(.))) %>% as.data.frame
row.names(df) = df$X.OTU.ID
df = df[,-1] %>% t

model = spca(df+1, logratio="CLR", center=T, scale=T)
plotIndiv(model)
plotVar(model)
cim(model)

model = pca(df+1, logratio="CLR", center=T, scale=T)
plotIndiv(model)
plotVar(model)
cim(model)
