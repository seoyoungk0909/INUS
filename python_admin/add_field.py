#%%
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

# Use the application default credentials
path_to_credential = '/Users/synch/apdi-aus-firebase-adminsdk-u2m9e-d427378380.json'
cred = credentials.Certificate(path_to_credential)
firebase_admin.initialize_app(cred)
DB = firestore.client()

#%%
for doc_ref in DB.collection('post').list_documents():
    doc_ref.update({'deleted': False})

# %%
