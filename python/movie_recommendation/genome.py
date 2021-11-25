import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity

# creating a data frame

genome = pd.read_csv("genome-scores.csv")
genome=genome.pivot(index="movieId",columns="tagId")
ids = genome.index.tolist()
similarity_matrix = pd.DataFrame(cosine_similarity(genome,genome),index=ids)
similarity_matrix.columns = ids
similarity_matrix.to_pickle("Content_SimMatrix.pkl")