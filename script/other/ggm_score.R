if (!require("qgraph")) install.packages("qgraph")
if (!require("psychonetrics")) install.packages("psychonetrics")
if (!require("bootnet")) install.packages("bootnet")
library(qgraph)
library(bootnet)
feas <- setdiff(fea_df$fea, c("feargain", "fearfood"))
sm_ls <- df_post$sm_id[which(df_post$group=="ed")]
# sm_ls <- df_gpt$sm_id[which(df_gpt$ed==1)]
df <- df_ens
df <- df[which(df$sm_id%in%sm_ls),feas]
network <- estimateNetwork(df, default = "pcor",
                           threshold = "sig", alpha = 0.01)
plot(network)

# df <- score_df_gpt4o
# df <- df[which(df$sm_id%in%sm_ls),feas]
# network <- estimateNetwork(df, default = "pcor",
#                            threshold = "sig", alpha = 0.05)
# plot(network)


# w <- network$graph
# rownames(w) <- network$labels
# colnames(w) <- network$labels
# qgraph(as.matrix(w), 
#        theme = "colorblind",
#        layout = "spring", 
#        # nodeNames = network$labels,
#        details=T)

