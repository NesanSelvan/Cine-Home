

import csv

# #Getting all Movies 
# defaultYoutubeLink = "https://youtu.be/QggJzZdIYPI"
# movieYoutubeData = []
# with open('ml-youtube.csv', encoding="utf8") as csv_file:
#     csv_reader = csv.reader(csv_file, delimiter=',')
#     line_count = 0
#     for row in csv_reader:
#         if line_count == 0:
#             print(f'Column names are {", ".join(row)}')
#             line_count += 1
#         else:
#             movieYoutubeData.append({
#                 "movieId": row[1],
#                 "youtubeLink": f"https://youtu.be/{row[0]}",
#             })

# data = []
# moviesCount = 300
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
#                 youtubeLinkMoviesList = list(filter(lambda x:x["movieId"]==row[0],movieYoutubeData))
#                 if(len(youtubeLinkMoviesList) == 0):
#                     data.append({
#                         "id": row[0],
#                         "name": row[1],
#                         "genre": str(row[2]).split("|"),
#                         "link": defaultYoutubeLink
#                     })
#                 else:
#                     data.append({
#                         "id": row[0],
#                         "name": row[1],
#                         "genre": str(row[2]).split("|"),
#                         "link": youtubeLinkMoviesList[0]['youtubeLink']
#                     })
#                 line_count += 1
#                 print(row[0])

# for i in range(0, 5):
#     print(data[i])

#Limiting Rating
# data = []
# userIdCount = 4
# with open('ratings.csv', encoding="utf8") as csv_file:
#     csv_reader = csv.reader(csv_file, delimiter=',')
#     line_count = 0
#     for row in csv_reader:
#             if line_count == 0:
#                 print(f'Column names are {", ".join(row)}')
#                 line_count += 1
#             else:
#                 if(int(row[0]) <= userIdCount):
#                     data.append({
#                         "userId": row[0],
#                         "movieId": row[1],
#                         "rating": row[2],
#                         "timestamp": row[3]
#                     })
#                     print(f'\t{row[0]}  {row[1]}  {row[2]}.')
#                 else:
#                     break
#                 line_count += 1

# Search Movie By ID
# with open('ml-youtube.csv', encoding="utf8") as csv_file:
#     csv_reader = csv.reader(csv_file, delimiter=',')
#     line_count = 0
#     print(csv_reader)
#     for column in csv_reader:
#         print(column[0])
#     # print(list(filter(lambda x:x["id"]=="1",csv_reader)))

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

defaultYoutubeLink = "https://youtu.be/QggJzZdIYPI"
moviesCount = 50
fav = ["Horror"];
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
                youtubeLinkMoviesList = list(filter(lambda x:x["movieId"]==row[0],movieYoutubeData))
                categories = row[2].split("|")
                for item in categories:
                    if item in fav:
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
                            
                    else:
                        pass
            line_count += 1

print(data)