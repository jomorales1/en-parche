from firebase_admin import firestore, credentials, storage, initialize_app
import os
import json

cd = os.path.dirname(os.path.abspath(__file__))

def main():
    cred = credentials.Certificate(cd + '/en-parche-firebase-adminsdk-2snsk-6ca8c23279.json')
    initialize_app(cred, {'storageBucket': 'en-parche.appspot.com'})
    db = firestore.client()
    bucket = storage.bucket()
    with open('unal_results2.json', 'r', encoding='utf-8') as json_file:
        data = json.loads(json_file.read())
    for index, news in enumerate(data):
        news_ref = db.collection(u'news').document(u'news' + str(index + 1))
        filename = news['image_name']
        file_path = cd + '/un_news_images/' + filename
        blob = bucket.blob(filename)
        blob.upload_from_filename(file_path)
        blob.make_public()
        news['image_url'] = blob.public_url
        news_ref.set(news)
        print('news' + str(index + 1) + ' saved')

if __name__ == '__main__':
    main()
