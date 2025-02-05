rm(list = ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
setwd("../../")
print(getwd())
require(readr)

# prepare post info
fea_df <- as.data.frame(read_csv("./data/topic_info.csv.zip"))
rownames(fea_df) <- fea_df$fea
fea_df$oppo_feature <- NA
fea_df['relation', 'oppo_feature'] <- "Personal isolation and antisocial behavior."
fea_df['protein', 'oppo_feature'] <- "Low protein diet and avoid to eat protein."
fea_df['ed', 'oppo_feature'] <- "Healthy eating habits and maintaining a balanced relationship with food."
fea_df['exercise', 'oppo_feature'] <- "No physical exercise and avoid body movements."
fea_df['crave', 'oppo_feature'] <- "Lack of appetite or disinterest in food."
fea_df['restrict', 'oppo_feature'] <- "No restriction on food, nutrition or calorie intake."
fea_df['binge', 'oppo_feature'] <- "Regular meals and feeling under control when eating food."
fea_df['loss', 'oppo_feature'] <- "Maintain healthy weight."
fea_df['gain', 'oppo_feature'] <- "Aim at weight loss."
fea_df['calorie', 'oppo_feature'] <- "Do not count calorie."
fea_df['idealbody', 'oppo_feature'] <- "Body image positivity and health at every size."
fea_df['bodyhate', 'oppo_feature'] <- "Positive view on self body image."
fea_df['feargain', 'oppo_feature'] <- "Acceptance of body weight gain or fluctuation."
fea_df['fearfood', 'oppo_feature'] <- "Acceptance of all food or being open to all foods."
fea_df['depressedmood', 'oppo_feature'] <- "Elevated mood or feeling positive."

# ChatGPT: Provide 5 simple example sentences in which an individual describes their personal experiences with this topic.
fea_df$oppo_examples <- NA
fea_df['relation', 'oppo_examples'] <- paste0(c(
  "I am not discussing relationships in this post.",
  "This post is just about me and my life."
), collapse = " (^_^) ")

fea_df['protein', 'oppo_examples'] <- paste0(c(
  "I dislike protein.",
  "I avoid foods high in protein like beans.",
  "I reduce protein intake."
), collapse = " (^_^) ")

fea_df['ed', 'oppo_examples'] <- paste0(c(
  "I do not have disordered eating.",
  "I have healthy relation with food.",
  "I do not have problem with eating.",
  "No eating problems."
), collapse = " (^_^) ")

fea_df['exercise', 'oppo_examples'] <- paste0(c(
  "I stay home all day and avoid exercise.",
  "My routine doesn't include any exercise; I just sit and work.",
  "I skip the gym and take elevators instead of stairs.",
  "I've cut out walking and use my car for even short trips.",
  "I spend most of my time on the couch watching TV or reading."
), collapse = " (^_^) ")

fea_df['crave', 'oppo_examples'] <- paste0(c(
  "I have no interest in food.",
  "Meals just don't appeal to me that much.",
  "Food are just food.",
  "I have no urge to eat."
), collapse = " (^_^) ")


fea_df['restrict', 'oppo_examples'] <- paste0(c(
  "I eat whatever I want, whenever I want.",
  "There are no limits on my portions, so I just enjoy food freely.",
  "I am free to eat anything I want.",
  "I have no limit on how much I should eat."
), collapse = " (^_^) ")


fea_df['binge', 'oppo_examples'] <- paste0(c(
  "I each regular amount of food.",
  "I feel under control while eating.",
  "I feel safe while eating.",
  "I do not overeat any food."
), collapse = " (^_^) ")


fea_df['loss', 'oppo_examples'] <- paste0(c(
  "I am happy with my current weight",
  "I stay at a healthy weight.",
  "I don't need to lose weight."
), collapse = " (^_^) ")

fea_df['gain', 'oppo_examples'] <- paste0(c(
  "I want to lose weight.",
  "Every morning I go for a run to help with my weight loss goals.",
  "This is my weight loss journey.",
  "I joined a gym to lose weight.",
  "I don't need to gain weight."
), collapse = " (^_^) ")

fea_df['calorie', 'oppo_examples'] <- paste0(c(
  "I do not count calories.",
  "I listen to my body instead of calculating calories.",
  "Eating without counting calories has made me feel free and happy."
), collapse = " (^_^) ")

fea_df['idealbody', 'oppo_examples'] <- paste0(c(
  "I've learned to love my body just the way it is, no matter the size.",
  "Embracing my curves has made me happier and more confident.",
  "Celebrating all body types in my community has been really empowering.",
  "Health at every size has taught me to appreciate my body's unique needs."
), collapse = " (^_^) ")

fea_df['bodyhate', 'oppo_examples'] <- paste0(c(
  "I love my body just the way it is.",
  "I feel good about myself.",
  "I appreciate how strong and capable my body is.",
  "I celebrate my unique shape and all it does for me."
), collapse = " (^_^) ")

fea_df['feargain', 'oppo_examples'] <- paste0(c(
  "I feel safe if I put on weight.",
  "I am happy to gain more weight.",
  "Seeing the scale go up doesn’t scare me.",
  "I accept weight changes."
), collapse = " (^_^) ")

fea_df['fearfood', 'oppo_examples'] <- paste0(c(
  "I like trying every new food that comes my way.",
  "I am open to all foods.",
  "I eat everything served to me.",
  "I never pick around my plate."
), collapse = " (^_^) ")

fea_df['depressedmood', 'oppo_examples'] <- paste0(c(
  "I feel happy today.",
  "I feel happy recently.",
  "I feel optimistic.",
  "I've been in such a great mood."
), collapse = " (^_^) ")




write.csv(fea_df, "./data/fea.csv", row.names = F)












