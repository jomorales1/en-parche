import json
from textwrap import indent
from bs4 import BeautifulSoup
import os
import requests

cd = os.path.dirname(os.path.abspath(__file__))
images_path = cd + '/un_news_images'
base_url = 'https://unperiodico.unal.edu.co'

def save_image(image_url):
    try:
        request = requests.get(url=image_url)
    except Exception as e:
        print('Error while connecting to the server\n' + str(e))
        return

    # Check if image is already saved
    if os.path.exists(images_path + '/' + image_url.split('/')[-1]):
        os.remove(images_path + '/' + image_url.split('/')[-1])

    # Saving image
    try:
        with open(images_path + '/' + image_url.split('/')[-1], 'wb') as file:
            file.write(request.content)
        print(f'Photo {image_url.split("/")[-1]} saved')
    except Exception as e:
        print('Error while saving image\n' + str(e))

def get_news_image_url(url):
    soup = BeautifulSoup(requests.get(url).text, 'html.parser')
    if soup.find('img', {'class': 'image-embed-item'}):
        return base_url + soup.find('img', {'class': 'image-embed-item'})['src']
    text = soup.find('div', {'class': 'vjs-poster'})['style'].split('("')[1].replace('")', '')
    return base_url + text

def main():
    if not os.path.exists(images_path):
        os.mkdir(images_path)
    soup = BeautifulSoup(requests.get(base_url).text, 'html.parser')
    processed_news = []
    # this week
    week_news = soup.find('div', {'class': 'thisWeek'}).find('div', {'class': 'news-list-view'}).find_all('div', recursive=False)
    for news in week_news:
        image_url = base_url + news.find('div', {'class': 'news-img-wrap'}).find('img')['src']
        data = {
            'title': news.find('div', {'class': 'header'}).find('span').get_text().strip(),
            'category': news.find('div', {'class': 'footer'}).find('p').find('span').get_text().strip(),
            'date': news.find('div', {'class': 'footer'}).find('div').find_all('span')[0].find('time')['datetime'],
            'city': news.find('div', {'class': 'footer'}).find('div').find_all('span')[1].get_text().strip(),
            'author': news.select('p.news-authors.news-list-author')[0].get_text().strip(),
            'description': news.find('div', {'class': 'teaser-text'}).find('p').get_text().strip(),
            'image_url': image_url, 'image_name': image_url.split('/')[-1],
            'news_url': base_url + news.find('div', {'class': 'header'}).find('a')['href']
        }
        save_image(image_url)
        processed_news.append(data)
    # interest
    interest_news = soup.find('div', {'class': 'interest'}).select('div.news-list-view.news-list-interest')[0].find_all('div', recursive=False)
    for news in interest_news:
        image_url = get_news_image_url(base_url + news.find('div', {'class': 'header'}).find('a')['href'])
        data = {
            'title': news.find('div', {'class': 'header'}).find('span').get_text().strip(),
            'category': news.find('div', {'class': 'footer'}).find('p').find('span').get_text().strip(),
            'date': news.find('div', {'class': 'footer'}).find('div').find_all('span')[0].find('time')['datetime'],
            'city': news.find('div', {'class': 'footer'}).find('div').find_all('span')[1].get_text().strip(),
            'author': news.select('p.news-authors.news-list-author')[0].get_text().strip(),
            'description': news.find('div', {'class': 'teaser-text'}).find('p').get_text().strip(),
            'image_url': image_url, 'image_name': image_url.split('/')[-1],
            'news_url': base_url + news.find('div', {'class': 'header'}).find('a')['href']
        }
        save_image(image_url)
        processed_news.append(data)
    with open('a.html', 'w', encoding='utf-8') as html_file:
        html_file.write(soup.find('div', {'class': 'otherNews'}).prettify())
    # print(soup.find('div', {'class': 'otherNews'}).prettify())
    for div in soup.find('div', {'class': 'otherNews'}).find_all('div', {'class': 'news'}):
        other_news = div.find('div').find_all('div', recursive=False)
        for news in other_news:
            # print(news.prettify())
            image_url = get_news_image_url(base_url + news.find('div', {'class': 'header'}).find('a')['href'])
            data = {
                'title': news.find('div', {'class': 'header'}).find('span').get_text().strip(),
                'category': news.find('div', {'class': 'footer'}).find('p').find('span').get_text().strip(),
                'date': news.find('div', {'class': 'footer'}).find('div').find_all('span')[0].find('time')['datetime'],
                'city': news.find('div', {'class': 'footer'}).find('div').find_all('span')[1].get_text().strip(),
                'author': '',
                'description': news.find('div', {'class': 'teaser-text'}).find('p').get_text().strip(),
                'image_url': image_url, 'image_name': image_url.split('/')[-1],
                'news_url': base_url + news.find('div', {'class': 'header'}).find('a')['href']
            }
            save_image(image_url)
            processed_news.append(data)
    with open(cd + '/unal_results2.json', 'w', encoding='utf-8') as json_file:
        json_file.write(json.dumps(processed_news, indent=4, ensure_ascii=False))
    print('Completed')
    print(len(processed_news))

if __name__ == '__main__':
    main()
