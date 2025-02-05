rm(list = ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
setwd("../../")
print(getwd())
require(readr)

# prepare post info
fea_df <- read_csv("./data/topic_info.csv.zip")
df_post <- read_csv("./data/reddit_posts.csv.zip")
df_key <- read_csv("./data/key.csv.zip")
df_forum <- read_csv("./data/reddit_forums.csv.zip")
df_post <- merge(df_post, df_key, by="sm_id", all.x=T)
df_post <- merge(df_post, df_forum, by="sr_name", all.x=T)
# prepare each llm 
df_gpt <- read_csv("./data/topic_gpt4o.csv.zip")
df_llama <- read_csv("./data/topic_Llama-3.1-8B-Instruct.csv.zip")
df_mistral <- read_csv("./data/topic_Mistral-7B-Instruct-v0.3.csv.zip")
df_qwen <- read_csv("./data/topic_Qwen2.5-7B-Instruct.csv.zip")
df_vicuna <- read_csv("./data/topic_Vicuna-7b-v1.5.csv.zip")
df_human <- read_csv("./data/topic_human.csv.zip")

colnames(df_human)[2:ncol(df_human)] <- paste0("human_", colnames(df_human)[2:ncol(df_human)])
colnames(df_gpt)[2:ncol(df_gpt)] <- paste0("gpt4o_", colnames(df_gpt)[2:ncol(df_gpt)])
colnames(df_llama)[2:ncol(df_llama)] <- paste0("llama_", colnames(df_llama)[2:ncol(df_llama)])
colnames(df_mistral)[2:ncol(df_mistral)] <- paste0("mistral_", colnames(df_mistral)[2:ncol(df_mistral)])
colnames(df_qwen)[2:ncol(df_qwen)] <- paste0("qwen_", colnames(df_qwen)[2:ncol(df_qwen)])
colnames(df_vicuna)[2:ncol(df_vicuna)] <- paste0("vicuna_", colnames(df_vicuna)[2:ncol(df_vicuna)])

# combine into one csv
df <- df_human
df <- merge(df, df_gpt, by="sm_id", all.x=T)
df <- merge(df, df_llama, by="sm_id", all.x=T)
df <- merge(df, df_mistral, by="sm_id", all.x=T)
df <- merge(df, df_qwen, by="sm_id", all.x=T)
df <- merge(df, df_vicuna, by="sm_id", all.x=T)
df <- merge(df, df_post[,c("sm_id", "raw_text", "sr_name")], by="sm_id", all.x=T)


write.csv(df, "./data/post1080.csv", row.names = F)

# take a look at some false positives by llama
table(df[,c("human_bodyhate01","llama_bodyhate01")])
fp <- df[which(df$human_bodyhate01==0 & df$llama_bodyhate01==1),c("sm_id","human_bodyhate01","llama_bodyhate01","raw_text")]



