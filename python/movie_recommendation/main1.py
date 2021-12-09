import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity


movies_df = pd.read_csv("movies.csv")
find_movie_similiar_to = 69 #int(input("Enter the id of the movie :"))
content_similiarity_matrix_df = pd.read_pickle("Content_SimMatrix.pkl")
similar_items = pd.DataFrame(content_similiarity_matrix_df.loc[find_movie_similiar_to])
content_similiarity_matrix_df=None
similar_items.columns = ["content_similarity_score"]
similar_items = similar_items.sort_values('content_similarity_score', ascending=False)
similar_items = similar_items.head(10)
similar_items.reset_index(inplace=True)
similar_items = similar_items.rename(index=str, columns={"index": "movieId"})
similar_movies_content = pd.merge(movies_df, similar_items, on="movieId")

collaborative_similiarity_matrix_df = pd.read_pickle("ratings.pkl")
ids = collaborative_similiarity_matrix_df.index
collaborative_similiarity_matrix_df = pd.DataFrame(cosine_similarity(collaborative_similiarity_matrix_df),index=ids)
collaborative_similiarity_matrix_df.columns = ids
similar_items = pd.DataFrame(collaborative_similiarity_matrix_df.loc[find_movie_similiar_to])
collaborative_similiarity_matrix_df = None
similar_items.columns = ["collaborative_similarity_score"]
similar_items = similar_items.sort_values('collaborative_similarity_score', ascending=False)
similar_items = similar_items.head(10)
similar_items.reset_index(inplace=True)
similar_items = similar_items.rename(index=str, columns={"index": "movieId"})
similar_movies_collab = similar_items
similar_movies_collab = pd.merge(movies_df, similar_movies_collab, on="movieId")
similar_movies_collab = similar_movies_collab.sort_values('collaborative_similarity_score', ascending=False)

similiar_hybrid_df = pd.merge(similar_movies_collab, pd.DataFrame(similar_movies_content['content_similarity_score']), left_index=True, right_index=True)
similiar_hybrid_df['average_similarity_score'] = (similiar_hybrid_df['content_similarity_score'] + similiar_hybrid_df['collaborative_similarity_score']) / 2
similiar_hybrid_df.drop("collaborative_similarity_score", axis=1, inplace=True)
similiar_hybrid_df.drop("content_similarity_score", axis=1, inplace=True)
similiar_hybrid_df.sort_values('average_similarity_score', ascending=False, inplace=True)
print(similiar_hybrid_df)
print("*************")
data = []

print(similiar_hybrid_df['movieId'])
for i in range(0, len(similiar_hybrid_df['movieId']) - 1):
    data.append({
        "id": similiar_hybrid_df['movieId'][i],
        "name": similiar_hybrid_df['title'][i],
        "genre": str(similiar_hybrid_df['genres'][i]).split("|"),
        "link": "defaultYoutubeLink",
        "series": "",
        "cover": ""
    })
print(data)