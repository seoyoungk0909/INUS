#%%
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

import fire


def main(path_to_credential='/Users/synch/apdi-aus-firebase-adminsdk-u2m9e-d427378380.json'):
    # Use the application default credentials
    cred = credentials.Certificate(path_to_credential)
    firebase_admin.initialize_app(cred)
    DB = firestore.client()

    for doc_ref in DB.collection('post').list_documents():
        snapshot = doc_ref.get()
        try:
            # try if the 'deleted' field exists
            deleted = snapshot.get('deleted')
        except:
            # if not, update with deleted = false
            doc_ref.update({'deleted': False})
        try:
            # try if the 'reportCount' field exists
            reportCount = snapshot.get('reportCount')
        except:
            # if not, update with reportCount = 0
            doc_ref.update({'reportCount': 0})
        try:
            # try if the 'points' field exists
            points = snapshot.get('points')
        except:
            # if not, update with points = viewCount + 10*saveCount - 20*reportCount
            point = int(snapshot.get('viewCount')) + 10* int(snapshot.get('saveCount')) - 20 * snapshot.get('reportCount')
            doc_ref.update({'points': point})


if __name__ == "__main__":
    fire.Fire(main)
