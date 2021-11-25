import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity


genome = pd.read_csv("genome-scores.csv")
genome=genome.pivot(index="movieId",columns="tagId")
ids = genome.index.tolist()
genome = pd.DataFrame(cosine_similarity(genome,genome),index=ids)
genome.columns = ids
genome.to_pickle("Content_SimMatrix.pkl")
genome = None
ratings_20m_df = pd.read_csv("ratings.csv")
ratings_20m_df=ratings_20m_df.pivot(index="movieId",columns="userId",values="rating")
ratings_20m_df.fillna(0,inplace=True)
ratings_20m_df.to_pickle("ratings.pkl")





genome = pd.read_csv("genome-scores.csv")
genome=genome.pivot(index="movieId",columns="tagId")

ratings = pd.read_csv("ratings.csv")
ratings=ratings.pivot(index="movieId",columns="userId",values="rating")

idx = genome.index.intersection(ratings.index)
genome = None
ratings = None
df1 = pd.read_pickle("Content_SimMatrix.pkl")
df1 =df1[idx]
df1 = df1.loc[idx]
df1.to_pickle("Content_SimMatrix.pkl")

df1 = pd.read_pickle("ratings.pkl")
df1 = df1.loc[idx]
df1.to_pickle("ratings.pkl")