class InternalServerError(Exception):
    pass

class SchemaValidationError(Exception):
    pass

class FieldAlreadyExistsError(Exception):
    pass

class UpdatingFieldError(Exception):
    pass

class DeletingFieldError(Exception):
    pass

class FieldNotExistsError(Exception):
    pass

class EmailAlreadyExistsError(Exception):
    pass

class UnauthorizedError(Exception):
    pass

errors = {
    "InternalServerError": {
        "message": "Er is iets misgegaan.",
        "status": 500
    },
     "SchemaValidationError": {
         "message": "Request ontbreekt verplichte velden",
         "status": 400
     },
     "FieldAlreadyExistsError": {
         "message": "Field met naam bestaat al",
         "status": 400
     },
     "UpdatingFieldError": {
         "message": "Updating field welke toegevoegd is door andere is verboden",
         "status": 403
     },
     "DeletingFieldError": {
         "message": "Deleting field welke toegevoegd is door andere is verboden",
         "status": 403
     },
     "FieldNotExistsError": {
         "message": "Field met gegeven uuid bestaat niet",
         "status": 400
     },
     "EmailAlreadyExistsError": {
         "message": "User met het opgegeven email bestaat al",
         "status": 400
     },
     "UnauthorizedError": {
         "message": "Ongeldige gebruikersnaam of wachtwoord",
         "status": 401
     }
}