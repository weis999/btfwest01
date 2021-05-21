from .db import db
from flask_bcrypt import generate_password_hash, check_password_hash
import datetime

"""
A Document for MongoDB, so that users cannot add other fields then what are 
defined here. 
- Name: is a field of type 'STRING', with two constraints 'REQUIRED' and 'UNIQUE' 
  - The constraint 'REQUIRED' means the user cannot create a new movie without 
    giving its title.
  - The constraint 'UNIQUE' means the movie name must be unique and cannot be repeated
- Casts: is a field of type 'LIST' which contains the value of type 'STRING'.
"""

# Document Result_progress, with fields and constraints
class result_progress(db.Document):
    # lenght_p = db.DecimalField(required=False)
    # weight_p = db.DecimalField(required=False)
    firstname = db.StringField()
    lastname = db.StringField()
    email = db.EmailField()
    password = db.StringField()
    added_by = db.ReferenceField('person')

# Document 'person' and with fields and constraints 'required' 'min_length', 'max_length', 'unique'
class person(db.Document):
    firstname = db.StringField()
    lastname = db.StringField()
    email = db.EmailField()
    password = db.StringField()
    # firstname = db.StringField(required=True)
    # lastname = db.StringField(required=True)
    # email = db.EmailField(required=True, unique=True)
    # password = db.StringField(required=True, min_length=6)
    results = db.ListField(db.ReferenceField('result_progress', reverse_delete_rule=db.PULL))

   # Method for hashing the password
    def hash_password(self):
        self.password = generate_password_hash(self.password).decode('utf8')

    # Method for checking if the password used by the user to login generates
    # the hash which is equal to the password saved in the database check_password_hash()
    def check_password(self, password):
        return check_password_hash(self.password, password)
        
person.register_delete_rule(result_progress, 'added_by', db.CASCADE)
