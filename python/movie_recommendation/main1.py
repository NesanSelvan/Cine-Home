from contextlib import contextmanager
import pickle
from re import split
from numpy import void
import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity
import json
from imdb import IMDb
import hyperlink
class MovieRecommender():

    def __init__(self,id):
         if(id == 0):
            Collab_Matrix = pd.read_pickle("ratings.pkl")
            max_id = list(Collab_Matrix.columns)
            a = max_id[-1]
            self.id = a + 1
            Collab_Matrix[self.id] = 0.0
            Collab_Matrix.to_pickle("ratings.pkl")
            Collab_Matrix = None
         else:
            self.id = id
         self.watchlist_name = "ID_"+str(self.id)+"_Watchlist.json"
         self.movie_recommend = "ID_"+str(self.id)+"_Movies.pkl"
         if(id == 0):
            dictionary = {}
            with open(self.watchlist_name, 'w') as f:
                f.write(json.dumps(dictionary))


    def lookup_movie_id_by_title(movie_title):
        print(movies[movies.title.str.contains(movie_title)])

    
    def Content_Recommender_individual_movie(self):
        find_movie_similiar_to = 114709
        similar_items = pd.read_pickle("Content_SimMatrix.pkl").loc[find_movie_similiar_to]
        similar_items = similar_items.sort_values( ascending=False).head(20)
        similar_items = similar_items.drop(find_movie_similiar_to)
        ids = similar_items.index.tolist()
        return ids

    def Collab_Recommender_individual_movie(self):
        find_movie_similiar_to = int(input("Enter the id of the movie :"))
        similar_items = pd.read_pickle("Collab_SimMatrix.pkl").loc[find_movie_similiar_to]
        similar_items = similar_items.sort_values( ascending=False).head(20)
        similar_items = similar_items.drop(find_movie_similiar_to)
        ids = similar_items.index.tolist
        return ids
   

    def update_data(self):
        with open(self.watchlist_name,'r') as file:
            watchlist =  data = json.load(file)
        keys = list(map(int,list(watchlist.keys())))

        user_Content_matrix = pd.read_pickle("Content_SimMatrix.pkl").loc[:,keys ]
        for i in keys:
            user_Content_matrix[i] = user_Content_matrix[i].apply(lambda x: x * watchlist[str(i)])
        user_Content_matrix['mean'] = user_Content_matrix.mean(axis=1)
        user_Content_matrix = user_Content_matrix['mean']

        Collab_Matrix = pd.read_pickle("ratings.pkl")
        for i in watchlist.keys():
            Collab_Matrix.at[int(i),self.id] = watchlist[i]
        Collab_Matrix.to_pickle("ratings.pkl")
        ids = Collab_Matrix.index.tolist()
        Collab_Matrix = cosine_similarity(Collab_Matrix,Collab_Matrix)
        Collab_Matrix = pd.DataFrame(Collab_Matrix,index = ids)
        Collab_Matrix.columns = ids
        Collab_Matrix = Collab_Matrix.loc[:, keys]
        Collab_Matrix['mean'] = Collab_Matrix.mean(axis=1)
        Collab_Matrix = Collab_Matrix['mean']

        Final_Matrix = pd.merge(Collab_Matrix,user_Content_matrix,left_index=True, right_index=True)
        user_Content_matrix = None
        Collab_Matrix = None
        Final_Matrix = Final_Matrix.mean(axis=1)
        Final_Matrix = Final_Matrix.drop(keys)
        Final_Matrix = Final_Matrix.sort_values(ascending=False).head(10)
        ids = Final_Matrix.index.tolist()
        Final_Matrix = None
        ia = IMDb()
        for i in ids:
            movie = ia.get_movie(i)
            print(movie['cover url'], movie['title'] + '(' + str(movie['year']) + ')')
        #with open(self.movie_recommend, 'wb') as f:
         #   pickle.dump(ids,f)

    def add_to_watchlist(self,new_movies):
        with open(self.watchlist_name, "r+") as file:
            data = json.load(file)
            data.update(new_movies)
            file.seek(0)
            json.dump(data,file)

Hardik = MovieRecommender(0)
# Hardik.add_to_watchlist({114709:4.5})
Hardik.update_data()
# ids = Hardik.Content_Recommender_individual_movie()
# print(ids)
# for index in range(0, len(ids)):
#     print(ids[index])

