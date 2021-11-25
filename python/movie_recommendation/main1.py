import pickle
import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity

class MovieRecommender():

    def __init__(self,id):
        self.id = id
        self.watchlist = "ID-"+str(id)+"-Watchlist.pkl"
        #self.watchlist_name = "Watchlist_" + self.name + ".csv"
        #watchlist = pd.DataFrame(watchlist,columns = "ratings" ,index = "movieId")

    def lookup_movie_id_by_title(movie_title):
        print(movies[movies.title.str.contains(movie_title)])

    
    # def Content_Recommender_individual_movie(self):
    #     find_movie_similiar_to = int(input("Enter the id of the movie :"))
    #     similar_items = pd.read_pickle("Content_SimMatrix.pkl").loc[find_movie_similiar_to]
    #     similar_items = similar_items.sort_values( ascending=False).head(20)
    #     similar_items = similar_items.drop(find_movie_similiar_to)
    #     ids = similar_items.index.tolist
    #     return ids

    # def Collab_Recommender_individual_movie(self):
    #     find_movie_similiar_to = int(input("Enter the id of the movie :"))
    #     similar_items = pd.read_pickle("Collab_SimMatrix.pkl").loc[find_movie_similiar_to]
    #     similar_items = similar_items.sort_values( ascending=False).head(20)
    #     similar_items = similar_items.drop(find_movie_similiar_to)
    #     ids = similar_items.index.tolist
    #     return ids
   

    def update_data(self):
        user_Content_matrix = pd.read_pickle("Content_SimMatrix.pkl").loc[:, list(self.watchlist.keys())]
        for i in self.watchlist.keys():
            user_Content_matrix[i] = user_Content_matrix[i].apply(lambda x: x * self.watchlist[i])
        user_Content_matrix['mean'] = user_Content_matrix.mean(axis=1)
        user_Content_matrix = user_Content_matrix['mean']

        Collab_Matrix = pd.read_pickle("ratings.pkl")
        for i in self.watchlist.keys():
            Collab_Matrix[i][self.id] = self.watchlist[i]
        ids = Collab_Matrix.index.tolist()
        Collab_Matrix = cosine_similarity(Collab_Matrix,Collab_Matrix)
        Collab_Matrix = pd.DataFrame(Collab_Matrix,index = ids)
        Collab_Matrix.columns = ids
        Collab_Matrix = Collab_Matrix.loc[:, list(self.watchlist.keys())]
        Collab_Matrix['mean'] = Collab_Matrix.mean(axis=1)
        Collab_Matrix = Collab_Matrix['mean']

        Final_Matrix = pd.merge(Collab_Matrix,user_Content_matrix,left_index=True, right_index=True)
        user_Content_matrix = None
        Collab_Matrix = None
        Final_Matrix = Final_Matrix.mean(axis=1)
        Final_Matrix = Final_Matrix.drop(watchlist.keys())
        Final_Matrix = Final_Matrix.sort_values(ascending=False).head(50)
        ids = Final_Matrix.index.tolist()
        Final_Matrix = None
        return ids

    def new_user(self):
        Collab_Matrix = pd.read_pickle("ratings.pkl")
        max_id = list(Collab_Matrix.columns)
        max_id = max_id[-1]
        Collab_Matrix[str(max_id)] = 0.0
        Collab_Matrix.to_pickle("ratings.pkl")
        Collab_Matrix = None
        watchlist = {}
        with open(self.watchlist, 'w') as f:
            pickle.dump(watchlist, f)

    def add_to_watchlist(self,new_movies):
        with open(self.watchlist,'r+') as f:
            dictionary = pickle.load(f)
            dictionary.update(new_movies)
            pickle.dump(dictionary)


MovieRecommender(10).update_data()



