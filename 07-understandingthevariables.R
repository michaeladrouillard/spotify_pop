mydata <- read_csv("inputs/data/df.csv")
#cleaning lol
mydata <- data.frame(sapply(mydata, as.numeric))
mydata <- mydata[, c("jack", "danceability", "energy", "loudness", "speechiness", "key", "acousticness", "instrumentalness", "liveness", "valence")]

# Verify the new structure of your dataset
str(mydata)


# Examine the distribution of a variable
hist(mydata$danceability, main = "Distribution of Danceability", xlab = "Danceability Score")

# Calculate the mean, median, and standard deviation of a variable
mean(mydata$danceability)
median(mydata$danceability)
sd(mydata$danceability)

# Calculate basic summary statistics for all variables in the dataset
summary(mydata)



# Create a scatterplot of two variables
plot(mydata$danceability, mydata$energy, main = "Danceability vs. Energy", xlab = "Danceability", ylab = "Energy")








library(corrplot)

# Calculate the correlation matrix
cor_matrix <- cor(mydata)

# Create the correlation plot
corrplot(cor_matrix, method = "circle", type = "lower")
cor(mydata)




