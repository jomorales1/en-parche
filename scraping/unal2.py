from firebase_admin import firestore, credentials, storage, initialize_app
import os
import json

cd = os.path.dirname(os.path.abspath(__file__))

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

def update():
    cred = credentials.Certificate(cd + '/en-parche-firebase-adminsdk-2snsk-6ca8c23279.json')
    initialize_app(cred, {'storageBucket': 'en-parche.appspot.com'})
    db = firestore.client()
    for event in db.collection(u'events').get():
        print(event)
        event_data = event.to_dict()
        if '-' in event_data['event_date']:
            continue
        try:
            new_date = format_date(event_data['event_date'])
            event_data['event_date'] = new_date
            db.collection(u'events').document(event.id).set(event_data)
            print(f'{event.id} updated')
        except Exception as error:
            print(f'Error while updating record {event.id}: {str(error)}')
            break

def main():
    cred = credentials.Certificate(cd + '/en-parche-firebase-adminsdk-2snsk-6ca8c23279.json')
    initialize_app(cred, {'storageBucket': 'en-parche.appspot.com'})
    db = firestore.client()
    bucket = storage.bucket()
    with open('unal_results.json', 'r', encoding='utf-8') as json_file:
        data = json.loads(json_file.read())
    for index, event in enumerate(data):
        event_ref = db.collection(u'events').document(u'event' + str(index + 1))
        if event_ref.get():
            event = event_ref.get().to_dict()
            if '-' not in event['event_date']:
                event['event_date'] = format_date(event['event_date'])
                event_ref.set(event)
                print('event' + str(index + 1) + ' updated')
        else:
            filename = event['image_name']
            file_path = cd + '/un_events_images/' + filename
            blob = bucket.blob(filename)
            blob.upload_from_filename(file_path)
            blob.make_public()
            event['image_url'] = blob.public_url
            event_ref.set(event)
            print('event' + str(index + 1) + ' saved')

if __name__ == '__main__':
    main()
    # update()