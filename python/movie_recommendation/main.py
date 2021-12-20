from flask.helpers import flash
from flask.scaffold import _endpoint_from_view_func
import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity
import matplotlib.pyplot as plt
from scipy.sparse import csr_matrix
from flask import Flask
from flask import jsonify,request,make_response,url_for,redirect
from contextlib import contextmanager
import pickle
from re import split
from numpy import void
from imdb import IMDb
import hyperlink
from contextlib import contextmanager
import pickle
from re import split
from numpy import void
from imdb import IMDb
import hyperlink
import json
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
            l=[]
            with open(self.watchlist_name, 'w') as f:
                f.write(json.dumps(dictionary))
            with open(self.movie_recommend, 'wb') as f:
                pickle.dump(l,f)


    def lookup_movie_id_by_title(movie_title):
        print(movies[movies.title.str.contains(movie_title)])


    def Content_Recommender_individual_movie(self, movieID):
        find_movie_similiar_to = int(movieID)
        similar_items = pd.read_pickle("Content_SimMatrix.pkl").loc[find_movie_similiar_to]
        similar_items = similar_items.sort_values( ascending=False).head(20)
        similar_items = similar_items.drop(find_movie_similiar_to)
        ids = similar_items.index.tolist()
        return ids

    """
    def Collab_Recommender_individual_movie(self):
        find_movie_similiar_to = int(input("Enter the id of the movie :"))
        similar_items = pd.read_pickle("Collab_SimMatrix.pkl").loc[find_movie_similiar_to]
        similar_items = similar_items.sort_values( ascending=False).head(20)
        similar_items = similar_items.drop(find_movie_similiar_to)
        ids = similar_items.index.tolist
        return ids
   """

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

        with open(self.movie_recommend, 'wb') as f:
             pickle.dump(ids,f)

    def add_to_watchlist(self,new_movies):
        with open(self.watchlist_name, "r+") as file:
            data = json.load(file)
            data.update(new_movies)
            file.seek(0)
            json.dump(data,file)

    def show(self):
        with open(self.movie_recommend, 'rb') as f:
            ids = pickle.load(f)
            
        ia = IMDb()
        data = []
        return ids
        for i in ids:
            movie = ia.get_movie(i)
            print(movie['cover url'], movie['title'] + '(' + str(movie['year']) + ')')
            data.append({"image": movie['cover url'], "title": movie['title'], "year": str(movie['year']), "imdbId": id})
            
        return data

class MovieRecommenderUserIdGenerator():
    
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
            l=[]
            with open(self.watchlist_name, 'w') as f:
                f.write(json.dumps(dictionary))
            with open(self.movie_recommend, 'wb') as f:
                pickle.dump(l,f)

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

        with open(self.movie_recommend, 'wb') as f:
             pickle.dump(ids,f)
        return self.id


# MovieRecommender().Content_Recommender()
app = Flask(__name__)
from bs4 import BeautifulSoup as soup
import requests
import csv
import imdb


# creating instance of IMDb
ia = imdb.IMDb()

defaultYoutubeLink = "https://youtu.be/QggJzZdIYPI"
def getMoviesYoutubeLink():
    movieYoutubeData = []
    with open('ml-youtube.csv', encoding="utf8") as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')
        line_count = 0
        for row in csv_reader:
            if line_count == 0:
                print(f'Column names are {", ".join(row)}')
                line_count += 1
            else:
                movieYoutubeData.append({
                    "movieId": row[1],
                    "youtubeLink": f"https://youtu.be/{row[0]}",
                })
    return movieYoutubeData

movieYoutubeData = getMoviesYoutubeLink()
allMoviesList = []
def getAllMovies():
    with open('movies.csv', encoding="utf8") as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')
        line_count = 0
        for row in csv_reader:
            if line_count == 0:
                print(f'Column names are {", ".join(row)}')
                line_count += 1
            else:
                youtubeLinkMoviesList = list(filter(lambda x:x["movieId"]==row[0],movieYoutubeData))
                if(len(youtubeLinkMoviesList) == 0):
                    allMoviesList.append({
                        "id": row[0],
                        "name": row[1],
                        "genre": str(row[2]).split("|"),
                        "link": defaultYoutubeLink,
                        "series": "",
                        "cover": ""
                    })
                else:
                    allMoviesList.append({
                        "id": row[0],
                        "name": row[1],
                        "genre": str(row[2]).split("|"),
                        "link": defaultYoutubeLink,
                        "series": "",
                        "cover": ""
                    })
                    
                line_count += 1
                print(row[0])
            if(line_count == 3000):
                break
getAllMovies()
@app.route('/movies')
def getMovies():
    data=pd.read_csv("movies.csv")
    return str(data)

@app.route('/')
def hello():
    data=pd.read_csv("movies.csv")
    return "Hello"

@app.route('/upcomingmovies', methods=['POST'])
def upcomingMovies():
    if request.method == 'GET':
        return make_response('failure')
    if request.method == 'POST':

        year = request.json['year']
        month =  request.json['month']
        url = "https://www.imdb.com/movies-coming-soon/"+year+"-"+month+"/"
        html_page = soup(requests.get(url).text , 'lxml')
        data = []
        for x in html_page.find_all('div',class_='image'):
            link = "https://www.imdb.com/"+x.a['href']+"?ref_=cs_ov_i"
            title = x.a.div.img['title']
            print('hello')
            poster = x.a.div.img['src']
            output = [title,link,poster]
            output = {
                "title": title,
                "link": link,
                "poster": poster
            }
            data.append(output)
            print(output)
        return jsonify({"data": data})

@app.route('/updateRating', methods=['POST'])
def updateRating():
    movieId = request.json['movieId']
    userId =  request.json['userId']
    ratings =  request.json['ratings']
    
    fields=[movieId,userId,ratings, ""]
    with open(r'ratings.csv', 'a') as f:
        writer = csv.writer(f)
        writer.writerow(fields)
    
    userIDGen = MovieRecommenderUserIdGenerator(userId)
    data = userIDGen.update_data()
    return jsonify({"data": "Suucessfull"})

@app.route('/getAllCategory', methods=['GET'])
def getAllCategories():
    moviesCount = 10000

    data = []
    with open('movies.csv', encoding="utf8") as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')
        line_count = 0
        for row in csv_reader:
            if line_count == 0:
                print(f'Column names are {", ".join(row)}')
                line_count += 1
            else:
                if(moviesCount < int(row[0])):
                    break
                else:
                    
                    categories = row[2].split("|")
                    for item in categories:
                        if item in data:
                            pass
                        else:
                            data.append(
                                item
                            )
                            
                        
                line_count += 1
    return jsonify({"data": data})

series = "https://media.istockphoto.com/photos/popcorn-and-clapperboard-picture-id1191001701?k=20&m=1191001701&s=612x612&w=0&h=uDszifNzvgeY5QrPwWvocFOUCw8ugViuw-U8LCJ1wu8="
cover = "https://media.istockphoto.com/photos/popcorn-and-clapperboard-picture-id1191001701?k=20&m=1191001701&s=612x612&w=0&h=uDszifNzvgeY5QrPwWvocFOUCw8ugViuw-U8LCJ1wu8="

@app.route('/getMovies', methods=['POST'])
def getAllMovies():
    if request.method == 'POST':
        moviesCount = request.json['count']
        # movieYoutubeData = getMoviesYoutubeLink()

        
        # data = []
        # with open('movies.csv', encoding="utf8") as csv_file:
        #     csv_reader = csv.reader(csv_file, delimiter=',')
        #     line_count = 0
        #     for row in csv_reader:
        #         if line_count == 0:
        #             print(f'Column names are {", ".join(row)}')
        #             line_count += 1
        #         else:
        #             if(moviesCount < int(row[0])):
        #                 break
        #             else:
        #                 # try:
        #                 #     # getting information
        #                 #     series = ia.get_movie(row[0])

        #                 #     # getting cover url of the series
        #                 #     cover = series.data['cover url']
        #                 # except print(0):
        #                 #     pass
                        

        #                 # # printing the object i.e name
        #                 # print(series)

        #                 # # print the cover
        #                 # print(cover)
                        
        #                 youtubeLinkMoviesList = list(filter(lambda x:x["movieId"]==row[0],movieYoutubeData))
        #                 if(len(youtubeLinkMoviesList) == 0):
        #                     data.append({
        #                         "id": row[0],
        #                         "name": row[1],
        #                         "genre": str(row[2]).split("|"),
        #                         "link": defaultYoutubeLink,
        #                         "series": str(series),
        #                         "cover": str(cover)
        #                     })
        #                 else:
        #                     data.append({
        #                         "id": row[0],
        #                         "name": row[1],
        #                         "genre": str(row[2]).split("|"),
        #                         "link": youtubeLinkMoviesList[0]['youtubeLink'],
        #                         "series": str(series),
        #                         "cover": str(cover)
        #                     })
                            
        #                 line_count += 1
        #                 print(row[0])

        return jsonify({"data": allMoviesList[0: moviesCount]})
    
@app.route('/getRatings', methods=['POST'])
def getAllRatings():
    if request.method == 'POST':
        data = []
        userIdCount = request.json['userId']
        with open('ratings.csv', encoding="utf8") as csv_file:
            csv_reader = csv.reader(csv_file, delimiter=',')
            line_count = 0
            for row in csv_reader:
                    if line_count == 0:
                        print(f'Column names are {", ".join(row)}')
                        line_count += 1
                    else:
                        if(int(row[0]) <= userIdCount):
                            data.append({
                                "userId": float(row[0]),
                                "movieId": float(row[1]),
                                "rating": float(row[2]),
                                "timestamp": float(row[3])
                            })
                            print(f'\t{row[0]}  {row[1]}  {row[2]}.')
                        else:
                            break
                        line_count += 1
            
        return jsonify({"data": data})
    
@app.route('/getRatingsByMovie', methods=['POST'])
def getRatingsByMovieId():
    if request.method == 'POST':
        data = []
        movieId = request.json['movieId']
        count = request.json['count']
        with open('ratings.csv', encoding="utf8") as csv_file:
            csv_reader = csv.reader(csv_file, delimiter=',')
            line_count = 0
            for row in csv_reader:
                    if line_count == 0:
                        print(f'Column names are {", ".join(row)}')
                        line_count += 1
                    elif line_count == int(count):
                        break;
                    else:
                        print("Line: " + str(line_count) + ", Count: " + count + ", MovieId: " + row[1], "Searching Movie: " + movieId)
                        if(int(row[1]) == int(movieId)):
                            data.append({
                                "userId": str(row[0]),
                                "movieId": str(row[1]),
                                "rating": str(row[2]),
                                "timestamp": str(row[3])
                            })
                            print(f'\t{row[0]}  {row[1]}  {row[2]}.')
                        line_count += 1
            
        return jsonify({"data": data})
    
@app.route('/getMoviesById', methods=["POST"])
def getMoviesById():
    if request.method == 'POST':
        id = request.json['id']
        movieYoutubeData = getMoviesYoutubeLink()

        data = []
        with open('movies.csv', encoding="utf8") as csv_file:
            csv_reader = csv.reader(csv_file, delimiter=',')
            line_count = 0
            for row in csv_reader:
                if line_count == 0:
                    print(f'Column names are {", ".join(row)}')
                    line_count += 1
                else:
                    youtubeLinkMoviesList = list(filter(lambda x:x["movieId"]==row[0],movieYoutubeData))
                    if(len(youtubeLinkMoviesList) == 0):
                        data.append({
                            "id": row[0],
                            "name": row[1],
                            "genre": str(row[2]).split("|"),
                            "link": defaultYoutubeLink,
                            "cover": str(cover),
                            "series": str(cover)
                        })
                    else:
                        data.append({
                            "id": row[0],
                            "name": row[1],
                            "genre": str(row[2]).split("|"),
                            "link": youtubeLinkMoviesList[0]['youtubeLink'],"cover": str(cover),
                            "series": str(cover)
                        })
                    line_count += 1
                    print(row[0])
        
        
        return jsonify({"data": list(filter(lambda x:x["id"]==row[0],data))})
def compare(qs, ip):
    al = 2
    v = 0
    for ii, letter in enumerate(ip):
        if letter == qs[ii]:
            v += al
        else:
            ac = 0
            for jj in range(al):
                if ii - jj < 0 or ii + jj > len(qs) - 1: 
                    break
                elif letter == qs[ii - jj] or letter == qs[ii + jj]:
                    ac += jj
                    break
            v += ac
    return v

@app.route('/searchMovie', methods=["POST"])
def searchMovie():
    if request.method == 'POST':
        moviesCount = request.json['count']
        movieName = request.json['name']
        print("Searching for ..." + movieName)
        # fav = ["Adventure"]
        data = []
        movieYoutubeData = getMoviesYoutubeLink()

        with open('movies.csv', encoding="utf8") as csv_file:
            csv_reader = csv.reader(csv_file, delimiter=',')
            line_count = 0
            for row in csv_reader:
                if line_count == 0:
                    print(f'Column names are {", ".join(row)}')
                    line_count += 1
                else:
                    if(moviesCount < len(data)):
                        break
                    else:
                        youtubeLinkMoviesList = list(filter(lambda x:x["movieId"]==row[0],movieYoutubeData))
                        if compare(str(row[1]).lower(), str(movieName).lower() ) >= 5:
                            if(len(youtubeLinkMoviesList) == 0):
                                data.append({
                                    "id": row[0],
                                    "name": row[1],
                                    "genre": str(row[2]).split("|"),
                                    "link": defaultYoutubeLink,"cover": str(cover),
                            "series": str(cover)
                                })
                                break
                            else:
                                data.append({
                                    "id": row[0],
                                    "name": row[1],
                                    "genre": str(row[2]).split("|"),
                                    "link": youtubeLinkMoviesList[0]['youtubeLink'],"cover": str(cover),
                            "series": str(cover)
                                })
                                break
                                
                        else:
                            pass

                        line_count += 1
            print(data)
        return jsonify({"data": data})
   
@app.route('/similarMovies', methods=["POST"])
def similarityScore():
    if request.method == 'POST':
        movieId = request.json['movieId']


        movies_df = pd.read_csv("movies.csv")
        find_movie_similiar_to = int(movieId) #int(input("Enter the id of the movie :"))
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
        data = []

        print(similiar_hybrid_df['movieId'])
        for i in range(0, len(similiar_hybrid_df['movieId']) - 1):
            data.append({
                "id": str(similiar_hybrid_df['movieId'][i]),
                "name": str(similiar_hybrid_df['title'][i]),
                "genre": str(similiar_hybrid_df['genres'][i]).split("|"),
                "link": str(defaultYoutubeLink),"cover": str(cover),
                            "series": str(cover)
            })
        print(data)
        return jsonify({"data": data})
        
@app.route('/genre', methods=["POST"])
def genre():
    if request.method == 'POST':
        moviesCount = request.json['count']
        fav = request.json['fav']
        # fav = ["Adventure"]
        data = []
        movieYoutubeData = getMoviesYoutubeLink()

        with open('movies.csv', encoding="utf8") as csv_file:
            csv_reader = csv.reader(csv_file, delimiter=',')
            line_count = 0
            for row in csv_reader:
                if line_count == 0:
                    print(f'Column names are {", ".join(row)}')
                    line_count += 1
                else:
                    if(moviesCount < len(data)):
                        break
                    else:
                        youtubeLinkMoviesList = list(filter(lambda x:x["movieId"]==row[0],movieYoutubeData))
                        categories = row[2].split("|")
                        for item in categories:
                            if item in fav:
                                if(len(youtubeLinkMoviesList) == 0):
                                    data.append({
                                        "id": row[0],
                                        "name": row[1],
                                        "genre": str(row[2]).split("|"),
                                        "link": defaultYoutubeLink,
                                        "cover": cover,
                                        "series": cover
                                    })
                                    break
                                else:
                                    data.append({
                                        "id": row[0],
                                        "name": row[1],
                                        "genre": str(row[2]).split("|"),
                                        "link": youtubeLinkMoviesList[0]['youtubeLink'],"cover": cover,
                                        "series": cover
                                    })
                                    break
                                    
                            else:
                                pass

                        line_count += 1
            print(data)
        return jsonify({"data": data})
    
    
@app.route('/getNewUserId', methods=["GET"])
def getNewUserId():
    if request.method == 'GET':
        userIDGen = MovieRecommenderUserIdGenerator(0)
        data = userIDGen.update_data()
        print(data)
        return jsonify({"data": data })

    
@app.route('/getMovieByRecommendation', methods=["POST"])
def getMovieByRecommendation():
    userId = request.json['userId']
    moviesCount = request.json['moviesCount']
    movies = MovieRecommender(userId)
    movies.update_data()
    data = []
    ids = movies.show()
    print(ids)
    with open('movies.csv', encoding="utf8") as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')
        line_count = 0
        for row in csv_reader:
            if line_count == 0:
                print(f'Column names are {", ".join(row)}')
                line_count += 1
            else:
                if(ids.__contains__(int(row[3]))) :
                    data.append({
                        "id": row[0],
                        "name": row[1],
                        "genre": str(row[2]).split("|"),
                        "link": defaultYoutubeLink,
                        "cover": cover,
                        "series": cover
                    })
                elif(moviesCount < int(row[0])):
                    break
                line_count += 1
                
        

    return jsonify({"data": data })
    
@app.route('/some', methods=["GET"])
def some():
    if request.method == 'GET':
        return jsonify({"data": "Hii" })


    
@app.route('/contentbasedmovie', methods=["POST"])
def contentbasedmovie():
    if request.method == 'POST':
        moviesCount = request.json['count']
        movieId = request.json['movieId']
        data = []
        # movieId = "30"
        imdbID = 0
        with open('movies.csv', encoding="utf8") as csv_file:
            csv_reader = csv.reader(csv_file, delimiter=',')
            line_count = 0
            for row in csv_reader:
                if line_count == 0:
                    print(f'Column names are {", ".join(row)}')
                    line_count += 1
                else:
                    if(str(row[0]) == str(movieId)) :
                        imdbID = row[3]
                        break
                    line_count += 1
        print("IMDB ID" + str(imdbID))
        if(imdbID == 0):
            imdbID = 114709
        movieRec = MovieRecommender(0)
        ids:list = movieRec.Content_Recommender_individual_movie(imdbID)
        print(ids)
        with open('movies.csv', encoding="utf8") as csv_file:
            csv_reader = csv.reader(csv_file, delimiter=',')
            line_count = 0
            for row in csv_reader:
                if line_count == 0:
                    print(f'Column names are {", ".join(row)}')
                    line_count += 1
                else:
                    if moviesCount == 0:
                        print("IMDB ID " + row[3])
                        if len(ids) <= 10:
                            if(len(ids) == len(data)):
                                break
                        elif len(data) == 10:
                            break
                        elif(ids.__contains__(int(row[3]))) :
                            data.append({
                                "id": row[0],
                                "name": row[1],
                                "genre": str(row[2]).split("|"),
                                "link": defaultYoutubeLink,
                                "cover": cover,
                                "series": cover
                            })
                        line_count += 1
                    elif(moviesCount < int(row[0])):
                        break
                    else:
                        print("IMDB ID " + row[3])
                        if len(ids) <= 10:
                            if(len(ids) == len(data)):
                                break
                        elif len(data) == 10:
                            break
                        elif(ids.__contains__(int(row[3]))) :
                            data.append({
                                "id": row[0],
                                "name": row[1],
                                "genre": str(row[2]).split("|"),
                                "link": defaultYoutubeLink,
                                "cover": cover,
                                "series": cover
                            })
                        line_count += 1
        


        
        return jsonify({"data": data})



if __name__ == '__main__':
    app.run(port=5050)