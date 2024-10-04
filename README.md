# Movie Recommendation System: A Machine Learning Project in R

### 1. Project Overview
The goal of this project is to build a **movie recommendation system** using R, employing **Item-Based Collaborative Filtering**. This project enhanced my skills in R, data manipulation, and machine learning by simulating a real-world recommendation engine.

### 2. Dataset: MovieLens
I used the **MovieLens** dataset, which includes:
- **105,339 ratings**
- **10,329 movies** from the `ratings.csv` and `movies.csv` files.

### 3. Libraries Used
- **recommenderlab**: For recommendation algorithms
- **ggplot2**: For data visualization
- **data.table** and **reshape2**: For data manipulation

### 4. Data Preprocessing
I cleaned and transformed the raw data, including **one-hot encoding** for genres and converting the ratings into a **sparse matrix** (`realRatingMatrix`), a crucial step for efficient recommendation processing.

### 5. Collaborative Filtering
This system recommends movies based on user behavior, identifying similar users and suggesting movies they’ve enjoyed. I calculated similarities between users and items using metrics like **cosine similarity** and **pearson correlation** with the **recommenderlab** library.

### 6. Data Preparation
- **Filtering**: Focused on users and movies with sufficient ratings.
- **Normalization**: Adjusted for user biases (e.g., always rating high or low).
- **Binarization**: Ratings above 3 were labeled as "liked" (1), simplifying the recommendation process.

### 7. Building the Collaborative Filtering System
I built an **Item-Based Collaborative Filtering (IBCF)** system, trained on **80% of the data** and tested on the remaining 20%. The system recommends movies based on the top **30 most similar items**.

### 8. Recommendation Model
After building the collaborative filtering system, I configured the model to recommend movies to users based on the top 30 similar items. Using the getModel() function, I retrieved the details of the recommendation model, including the similarity matrix that highlights how similar certain movies are to each other.

### 9. Conclusion
This project demonstrated how machine learning and collaborative filtering can create a movie recommendation system, giving me valuable insights into R, data science, and real-world application of machine learning models.
