# Movie Recommendation System: A Practical Machine Learning Project in R

### Project Overview
The primary goal of this project is to build a **movie recommendation system** using R, leveraging machine learning techniques to suggest movies to users based on their preferences. Specifically, I’ve implemented an **Item-Based Collaborative Filtering** system. This project not only allowed me to explore the underlying mechanics of recommendation engines but also gave me hands-on experience with R, data manipulation, and machine learning concepts in a real-world scenario.

### Dataset: MovieLens
For this project, I used the well-known **MovieLens** dataset, which contains:
- **105,339 ratings** from users on
- **10,329 movies**, as provided in the `ratings.csv` and `movies.csv` files.

### Libraries Used
Key R libraries that were instrumental in building the project:
- **recommenderlab**: For building and testing the recommendation algorithms
- **ggplot2**: For visualizing data insights
- **data.table** and **reshape2**: For data manipulation and reshaping.

### Data Preprocessing
The journey begins by cleaning and transforming the raw data into a format suitable for machine learning.

### Genre Encoding:
Movies often belong to multiple genres, so I used **one-hot encoding** to transform genres into a binary matrix (0 or 1). This allows the model to understand each movie's genre easily. A **search matrix** was then created to help users search movies based on genres.

### Ratings Matrix:
To use the collaborative filtering algorithm, I converted the user ratings data into a **sparse matrix** format called `realRatingMatrix`, which is more efficient for large datasets. This matrix is essential for computing user-item similarities, a core component of any recommendation engine.

### Collaborative Filtering
Collaborative filtering is the core technique behind this recommendation system. It works by recommending movies based on the behavior of similar users. For instance, if User A and User B both enjoy action films, then the system can recommend action movies that User B has watched to User A, and vice versa.

#### Similarity Measures:
With the help of the **recommenderlab** library, I calculated similarities between users and items using metrics like **cosine similarity** and **pearson correlation**. These metrics help the algorithm understand which users or items are most alike.

### Data Visualizations

#### Similarity Between Users and Movies:
I visualized the **similarity matrix** between both users and movies, which gives a visual representation of how closely aligned their preferences are. These insights helped in evaluating the effectiveness of the recommendation algorithm.

#### Most Watched Movies:
I explored which movies were the most popular in the dataset. After calculating the total views for each movie, I created a bar plot to display the top-viewed films. Unsurprisingly, **Pulp Fiction** and **Forrest Gump** were among the most-watched.

#### Heatmap of Movie Ratings:
A **heatmap** was used to visualize movie ratings, which showed patterns in user behavior, particularly how certain groups of users tended to rate specific sets of movies.

### Data Preparation: Filtering and Normalization
Before diving into the collaborative filtering model, I performed a few critical data preparation steps:

1. **Selecting Relevant Data**: Filtered out users and movies with very few ratings to focus on more active participants in the system.
   
2. **Normalization**: Users tend to have biases—some might give higher ratings across the board, while others might rate movies more conservatively. To mitigate these biases, I normalized the data, ensuring fairer comparisons between user ratings.

3. **Binarization**: To further simplify the model, I **binarized** the ratings. This means ratings of 3 and above were marked as "liked" (1), and anything below that as "not liked" (0). This helps the recommendation system work more efficiently by focusing on user preferences.

### Building the Collaborative Filtering System

#### Item-Based Collaborative Filtering:
I implemented the **Item-Based Collaborative Filtering (IBCF)** system, which finds similar items (movies) based on how users rate them. In simple terms, the model identifies patterns in how users rate items and suggests movies that are similar to those the user has already enjoyed.

#### Training and Testing:
To ensure the system's accuracy, I split the dataset into **80% training data** and **20% testing data**. This allowed me to build the model using the training set and then evaluate its performance on unseen data (testing set).

### Recommendation Model

After building the collaborative filtering system, I configured the model to recommend movies to users based on the top **30 similar items**. Using the `getModel()` function, I retrieved the details of the recommendation model, including the similarity matrix that highlights how similar certain movies are to each other.

#### Generating Recommendations:
For each user in the testing set, I generated the **top 10 movie recommendations**. The model compares each movie with the most similar movies and ranks them based on user preferences. The end result is a tailored list of movie suggestions for each user.

### Visualizing Results

#### Recommendation Insights:
I visualized the **distribution of recommended items** across all users, which showed how often certain movies were recommended. The model identified the most similar movies and displayed them in descending order, providing a clear picture of which movies were being suggested the most.

#### Top Recommended Movies:
Finally, I extracted the **top 4 most recommended movies** based on their overall similarity scores. These were then converted from their movie IDs to titles, offering an easy-to-understand output of the most popular recommendations from the system.

### Conclusion

This project was a practical exploration of how **machine learning** and **collaborative filtering** can be used to build an effective movie recommendation system. By using a combination of **data science techniques**, **visualizations**, and a collaborative filtering algorithm, I successfully created a system that provides users with tailored movie recommendations based on their past behavior and that of similar users.

This experience has deepened my understanding of the inner workings of recommendation engines and enhanced my skills in **R**, **data manipulation**, and **machine learning**.
