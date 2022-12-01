import json
from textwrap import indent
from bs4 import BeautifulSoup
import os
import requests

cd = os.path.dirname(os.path.abspath(__file__))
images_path = cd + '/un_events_images'
base_urls = [
    'https://ingenieria.bogota.unal.edu.co/es/facultad/calendario/eventos-culturales.html',
    'https://ingenieria.bogota.unal.edu.co/es/facultad/calendario/eventos-academicos'
]
names = set()

def format_date(text):
    elements = text.split()
    month = ''
    if elements[1] == 'Enero':
        month = '01'
    if elements[1] == 'Febrero':
        month = '02'
    if elements[1] == 'Marzo':
        month = '03'
    if elements[1] == 'Abril':
        month = '04'
    if elements[1] == 'Mayo':
        month = '05'
    if elements[1] == 'Junio':
        month = '06'
    if elements[1] == 'Julio':
        month = '07'
    if elements[1] == 'Agosto':
        month = '08'
    if elements[1] == 'Septiembre':
        month = '09'
    if elements[1] == 'Octubre':
        month = '10'
    if elements[1] == 'Noviembre':
        month = '11'
    if elements[1] == 'Diciembre':
        month = '12'
    return f'{elements[2]}-{month}-{elements[0]}'

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

def process_page(soup):
    events = soup.select('div.row.event')
    results = []
    for event in events:
        if not event.find('button'):
            continue
        image_url = 'https://ingenieria.bogota.unal.edu.co' + event.find('img')['src']
        save_image(image_url)
        elements = event.find_all('div', recursive=False)[-1].find_all('p')
        data = {
            'title': elements[0].get_text().strip(),
            'event_date': format_date(elements[2].find(text=True, recursive=False).strip()),
            'start_time': elements[4].find(text=True, recursive=False).strip(),
            'place': '', 'description': elements[3].find_all('p')[-1].get_text().strip(),
            'image_url': image_url, 'organizer': 'Facultad de Ingeniería',
            'image_name': image_url.split('/')[-1]
        }
        if data['title'] not in names:
            results.append(data)
            names.add(data['title'])
    return results

def events():
    if not os.path.exists(images_path):
        os.mkdir(images_path)
    for base_url in base_urls:
        main_soup = BeautifulSoup(requests.get(base_url).text, 'html.parser')
        pages = int(main_soup.find('div', {'class': 'pagination'}).find('ul').find_all('li')[-3].find('a').get_text().strip())
        processed_events = []
        processed_events.extend(process_page(main_soup))
        for index in range(10, pages * 10, 10):
            print(base_url + f'?start={str(index)}')
            page_soup = BeautifulSoup(requests.get(base_url + '?start=' + str(index)).text, 'html.parser')
            processed_events.extend(process_page(page_soup))
    with open(cd + '/unal_results.json', 'w', encoding='utf-8') as json_file:
        json_file.write(json.dumps(processed_events, indent=4, ensure_ascii=False))
    print('Completed')
    print(len(processed_events))

if __name__ == '__main__':
    events()
