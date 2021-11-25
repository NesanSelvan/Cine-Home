from bs4 import BeautifulSoup as soup
import requests


year = str(input("Enter the year : "))
month =  str(input("Enter the month :"))
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