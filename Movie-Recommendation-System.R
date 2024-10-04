# Load necessary libraries
library(recommenderlab)
library(ggplot2)
library(data.table)
library(reshape2)

# Set working directory and load dataset
setwd("/Users/aninjogeorge/Desktop/Movie-Recommendation-System/Dataset")
movie_data <- read.csv("movies.csv", stringsAsFactors=FALSE)
rating_data <- read.csv("ratings.csv")

# Overview of the dataset
str(movie_data)         # Structure of the movie data
summary(movie_data)     # Summary statistics for movie data
head(movie_data)        # Display first few rows of movie data

summary(rating_data)    # Summary statistics for rating data
head(rating_data)       # Display first few rows of rating data

# Data Preprocessing
# One-hot encoding of genres to create a binary matrix (1 if movie belongs to a genre, 0 otherwise)
movie_genre <- as.data.frame(movie_data$genres, stringsAsFactors=FALSE)
movie_genre2 <- as.data.frame(tstrsplit(movie_genre[,1], '[|]', type.convert=TRUE), stringsAsFactors=FALSE)
colnames(movie_genre2) <- c(1:10)   # Assign column names

# List of all genres
list_genre <- c("Action", "Adventure", "Animation", "Children", "Comedy", "Crime",
                "Documentary", "Drama", "Fantasy", "Film-Noir", "Horror", "Musical",
                "Mystery", "Romance", "Sci-Fi", "Thriller", "War", "Western")

# Initialize a binary matrix for genres (0 or 1)
genre_mat1 <- matrix(0, nrow(movie_data)+1, length(list_genre))
genre_mat1[1, ] <- list_genre
colnames(genre_mat1) <- list_genre

# Populate the binary genre matrix
for (index in 1:nrow(movie_genre2)) {
  for (col in 1:ncol(movie_genre2)) {
    gen_col <- which(genre_mat1[1, ] == movie_genre2[index, col])
    genre_mat1[index + 1, gen_col] <- 1
  }
}

# Remove the first row (genre list) and convert columns to integers
genre_mat2 <- as.data.frame(genre_mat1[-1, ], stringsAsFactors=FALSE)
for (col in 1:ncol(genre_mat2)) {
  genre_mat2[, col] <- as.integer(genre_mat2[, col])
}

# Create a search matrix with movie titles and genres
SearchMatrix <- cbind(movie_data[, 1:2], genre_mat2[])
head(SearchMatrix)    # Display first few rows of the search matrix

# Reshape rating data into a user-item rating matrix
ratingMatrix <- dcast(rating_data, userId ~ movieId, value.var = "rating", na.rm=FALSE)
ratingMatrix <- as.matrix(ratingMatrix[, -1])   # Remove userIds

# Convert rating matrix to a recommenderlab sparse matrix
ratingMatrix <- as(ratingMatrix, "realRatingMatrix")

# Check available recommendation models in recommenderlab
recommendation_model <- recommenderRegistry$get_entries(dataType = "realRatingMatrix")
names(recommendation_model)       # List the names of available models
lapply(recommendation_model, "[[", "description")  # Display descriptions of each model

# Item-Based Collaborative Filtering (IBCF) Model
similarity_mat <- similarity(ratingMatrix[1:4, ], method = "cosine", which = "users")
image(as.matrix(similarity_mat), main = "User's Similarities")   # Plot user similarity matrix

# Movie Similarity matrix
movie_similarity <- similarity(ratingMatrix[, 1:4], method = "cosine", which = "items")
image(as.matrix(movie_similarity), main = "Movies similarity")   # Plot movie similarity matrix

# Get unique rating values and their counts
rating_values <- as.vector(ratingMatrix@data)
unique(rating_values)
Table_of_Ratings <- table(rating_values)   # Count occurrences of each rating value

# Most viewed movies visualization
movie_views <- colCounts(ratingMatrix)     # Count views for each movie
table_views <- data.frame(movie = names(movie_views), views = movie_views)
table_views <- table_views[order(table_views$views, decreasing = TRUE), ]   # Sort by number of views

# Add movie titles to the table
table_views$title <- NA
for (index in 1:10325) {
  table_views[index, 3] <- as.character(subset(movie_data, movie_data$movieId == table_views[index, 1])$title)
}

# Visualize top 6 most viewed movies
ggplot(table_views[1:6, ], aes(x = title, y = views)) +
  geom_bar(stat="identity", fill = 'steelblue') +
  geom_text(aes(label = views), vjust = -0.3, size = 3.5) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("Total Views of the Top Films")

# Visualize heatmap of movie ratings
image(ratingMatrix[1:20, 1:25], axes = FALSE, main = "Heatmap of the first 25 rows and 25 columns")

# Data Preparation: Filter movies and users with more than 50 ratings
movie_ratings <- ratingMatrix[rowCounts(ratingMatrix) > 50, colCounts(ratingMatrix) > 50]

# Display heatmap for top users and movies
minimum_movies <- quantile(rowCounts(movie_ratings), 0.98)
minimum_users <- quantile(colCounts(movie_ratings), 0.98)
image(movie_ratings[rowCounts(movie_ratings) > minimum_movies, colCounts(movie_ratings) > minimum_users],
      main = "Heatmap of the top users and movies")

# Visualize distribution of average ratings per user
average_ratings <- rowMeans(movie_ratings)
qplot(average_ratings, fill = I("steelblue"), col = I("red")) +
  ggtitle("Distribution of the average rating per user")

# Normalize ratings and visualize normalized heatmap
normalized_ratings <- normalize(movie_ratings)
image(normalized_ratings[rowCounts(normalized_ratings) > minimum_movies, colCounts(normalized_ratings) > minimum_users],
      main = "Normalized Ratings of the Top Users")

# Binarize movie ratings (1 for ratings >= 3, 0 otherwise) and visualize heatmap
good_rated_films <- binarize(movie_ratings, minRating = 3)
image(good_rated_films[rowCounts(movie_ratings) > binary_minimum_movies, colCounts(movie_ratings) > binary_minimum_users],
      main = "Heatmap of the top users and movies")

# Collaborative Filtering System
# Split data into 80% training set and 20% testing set
sampled_data <- sample(x = c(TRUE, FALSE), size = nrow(movie_ratings), replace = TRUE, prob = c(0.8, 0.2))
training_data <- movie_ratings[sampled_data, ]
testing_data <- movie_ratings[!sampled_data, ]

# Build IBCF recommendation system with k=30
recommen_model <- Recommender(data = training_data, method = "IBCF", parameter = list(k = 30))

# Explore the recommendation system model
model_info <- getModel(recommen_model)
top_items <- 20
image(model_info$sim[1:top_items, 1:top_items], main = "Heatmap of the first rows and columns")

# Distribution of similarity matrix (rows and columns with non-zero similarity)
sum_rows <- rowSums(model_info$sim > 0)
table(sum_rows)
sum_cols <- colSums(model_info$sim > 0)
qplot(sum_cols, fill = I("steelblue"), col = I("red")) + ggtitle("Distribution of the column count")

# Generate top 10 recommendations for each user in the test set
top_recommendations <- 10
predicted_recommendations <- predict(object = recommen_model, newdata = testing_data, n = top_recommendations)

# Display movie recommendations for the first user
user1 <- predicted_recommendations@items[[1]]
movies_user1 <- predicted_recommendations@itemLabels[user1]
movies_user2 <- movies_user1

# Convert movie IDs to titles
for (index in 1:10) {
  movies_user2[index] <- as.character(subset(movie_data, movie_data$movieId == movies_user1[index])$title)
}
movies_user2

# Matrix with recommendations for each user
recommendation_matrix <- sapply(predicted_recommendations@items, function(x){ as.integer(colnames(movie_ratings)[x]) })
recommendation_matrix[, 1:4]    # Display recommendations for first four users

# Visualize distribution of the number of items recommended
number_of_items <- factor(table(recommendation_matrix))
qplot(number_of_items, fill = I("steelblue"), col = I("red")) + ggtitle("Distribution of the Number of Items for IBCF")

# Display the top 4 most recommended movies
number_of_items_sorted <- sort(number_of_items, decreasing = TRUE)
number_of_items_top <- head(number_of_items_sorted, n = 4)
table_top <- data.frame(as.integer(names(number_of_items_top)), number_of_items_top)

# Convert movie IDs to titles
for (i in 1:4) {
  table_top[i, 1] <- as.character(subset(movie_data, movie_data$movieId == table_top[i, 1])$title)
}

# Rename columns and display the top movies
colnames(table_top) <- c("Movie Title", "No. of Items")
head(table_top)
