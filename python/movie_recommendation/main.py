from flask.helpers import flash
from flask.scaffold import _endpoint_from_view_func
import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity
import matplotlib.pyplot as plt
from scipy.sparse import csr_matrix
from flask import Flask
from flask import jsonify,request,make_response,url_for,redirect

class MovieRecommender():

    def __init__(self):
        self.content_similiarity_matrix_df = pd.read_pickle("Content_SimMatrix.pkl")
        # self.collaborative_similiarity_matrix_df = pd.read_pickle("Collab_SimMatrix.pkl")
        self.movies_df = pd.read_csv("movies.csv")
        self.ratings_df= pd.read_csv("ratings.csv")

    def lookup_movie_id_by_title(movie_title):
        print(movies[movies.title.str.contains(movie_title)])

    def create_similiarity_matrix():
         similarity_matrix = pd.DataFrame(cosine_similarity(genome, genome), index=ids)
         similarity_matrix.columns = ids

    def Content_Recommender(self):
        find_movie_similiar_to = input("Enter the id of the movie :")
        similar_items = pd.DataFrame(self.content_similiarity_matrix_df.loc[find_movie_similiar_to])
        similar_items.columns = ["content_similarity_score"]
        similar_items = similar_items.sort_values('content_similarity_score', ascending=False)
        similar_items = similar_items.head(10)
        similar_items.reset_index(inplace=True)
        similar_items = similar_items.rename(index=str, columns={"index": "movieId"})
        similar_movies_content = pd.merge(self.movies_df, similar_items, on="movieId")
        self.similar_movies_content = similar_movies_content
        return similar_movies_content

    def Collab_Recommender(self):
        find_movie_similiar_to = int(input("Enter the id of the movie :"))
        similar_items = pd.DataFrame(self.collaborative_similiarity_matrix_df.loc[find_movie_similiar_to])
        similar_items.columns = ["collab_similarity_score"]
        similar_items = similar_items.sort_values('collab_similarity_score', ascending=False)
        similar_items = similar_items.head(10)
        similar_items.reset_index(inplace=True)
        similar_items = similar_items.rename(index=str, columns={"index": "movieId"})
        similar_movies_collab = similar_items
        similar_movies_collab = pd.merge(self.movies_df, similar_movies_collab, on="movieId")
        similar_movies_collab = similar_movies_collab.sort_values('collab_similarity_score', ascending=False)
        self.similar_movies_collab = similar_movies_collab
        return similar_movies_collab

    def Hybird_Recommender(self):
        find_movie_similiar_to = int(input("Enter the id of the movie :"))
        similar_items = pd.DataFrame(self.content_similiarity_matrix_df.loc[find_movie_similiar_to])
        similar_items.columns = ["content_similarity_score"]
        similar_items = similar_items.sort_values('content_similarity_score', ascending=False)
        similar_items = similar_items.head(10)
        similar_items.reset_index(inplace=True)
        similar_items = similar_items.rename(index=str, columns={"index": "movieId"})
        similar_movies_content = pd.merge(self.movies_df, similar_items, on="movieId")

        similar_items = pd.DataFrame(self.collaborative_similiarity_matrix_df.loc[find_movie_similiar_to])
        similar_items.columns = ["collaborative_similarity_score"]
        similar_items = similar_items.sort_values('collaborative_similarity_score', ascending=False)
        similar_items = similar_items.head(10)
        similar_items.reset_index(inplace=True)
        similar_items = similar_items.rename(index=str, columns={"index": "movieId"})
        similar_movies_collab = similar_items
        similar_movies_collab = pd.merge(self.movies_df, similar_movies_collab, on="movieId")
        similar_movies_collab = similar_movies_collab.sort_values('collaborative_similarity_score', ascending=False)

        similiar_hybrid_df = pd.merge(similar_movies_collab, pd.DataFrame(similar_movies_content['content_similarity_score']), left_index=True, right_index=True)
        similiar_hybrid_df['average_similarity_score'] = (similiar_hybrid_df['content_similarity_score'] + similiar_hybrid_df['collaborative_similarity_score']) / 2
        similiar_hybrid_df.drop("collaborative_similarity_score", axis=1, inplace=True)
        similiar_hybrid_df.drop("content_similarity_score", axis=1, inplace=True)
        similiar_hybrid_df.sort_values('average_similarity_score', ascending=False, inplace=True)
        return similiar_hybrid_df

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
                        "link": defaultYoutubeLink
                    })
                else:
                    allMoviesList.append({
                        "id": row[0],
                        "name": row[1],
                        "genre": str(row[2]).split("|"),
                        "link": youtubeLinkMoviesList[0]['youtubeLink']
                    })
                    
                line_count += 1
                print(row[0])
# getAllMovies()
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
                    if(moviesCount < int(row[0])):
                        break
                    else:
                        # try:
                        #     # getting information
                        #     series = ia.get_movie(row[0])

                        #     # getting cover url of the series
                        #     cover = series.data['cover url']
                        # except print(0):
                        #     pass
                        

                        # # printing the object i.e name
                        # print(series)

                        # # print the cover
                        # print(cover)
                        
                        youtubeLinkMoviesList = list(filter(lambda x:x["movieId"]==row[0],movieYoutubeData))
                        if(len(youtubeLinkMoviesList) == 0):
                            data.append({
                                "id": row[0],
                                "name": row[1],
                                "genre": str(row[2]).split("|"),
                                "link": defaultYoutubeLink,
                                "series": str(series),
                                "cover": str(cover)
                            })
                        else:
                            data.append({
                                "id": row[0],
                                "name": row[1],
                                "genre": str(row[2]).split("|"),
                                "link": youtubeLinkMoviesList[0]['youtubeLink'],
                                "series": str(series),
                                "cover": str(cover)
                            })
                            
                        line_count += 1
                        print(row[0])

        return jsonify({"data": data})
    
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
                            "link": defaultYoutubeLink
                        })
                    else:
                        data.append({
                            "id": row[0],
                            "name": row[1],
                            "genre": str(row[2]).split("|"),
                            "link": youtubeLinkMoviesList[0]['youtubeLink']
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

app.run(port=5050)

# # # {
# # #     "movies": [
# # #         {
# # #             "id": 10,
# # #             "name": "Movie Name",
# # #             "category": []
# # #         },
# # #         {
# # #             "id": 10,
# # #             "name": "Movie Name",
# # #             "category": []
# # #         },
# # #     ]
# # # }       