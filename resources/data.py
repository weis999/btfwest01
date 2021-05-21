from flask import Response, request
from database.models import result_progress, person
from flask_jwt_extended import jwt_required, get_jwt_identity
from flask_restful import Resource
from mongoengine.errors import FieldDoesNotExist, NotUniqueError, DoesNotExist, ValidationError, InvalidQueryError
from resources.errors import InternalServerError, SchemaValidationError, FieldAlreadyExistsError, UpdatingFieldError, DeletingFieldError, FieldNotExistsError, \
    EmailAlreadyExistsError, UnauthorizedError

# Endpoint which accepts 'GET' + 'POST' requests
class ResultsApi(Resource):
    def get(self):
        query = person.objects()
        results = person.objects().to_json()
        return Response(results, mimetype="application/json", status=200)

    @jwt_required
    def post(self):
        try:
            person_id = get_jwt_identity()
            body = request.get_json()
            person = person.objects.get(id=person_id, added_by=person)
            result =  result_progress(**body)
            result.save()
            person.update(push__results=result)
            person.save()
            id = result.id
            return {'id': str(id)}, 200
        # Error handling field not ext and validation error
        except (FieldDoesNotExist, ValidationError):
            # Given message from module errors.py
            raise SchemaValidationError
        # Error handling field not unique
        except NotUniqueError:
            # Given message from module errors.py
            raise FieldAlreadyExistsError
        # Error handling for everything that is not defined in error.py
        except Exception as error:
            # Given message from module errors.py
            raise InternalServerError

# Endpoint which accepts 'GET' + 'PUT' + 'DELETE' requests
class ResultApi(Resource):
    @jwt_required
    # Methode 'PUT'
    def put(self, id):
        try:
            person_id = get_jwt_identity()
            result = result_progress.objects.get(id=id, added_by=person_id)
            body = request.get_json()
            result_progress.objects.get(id=id).update(**body)
            return Response('Edit status: OK', status=200)
        # Error handling for invalid query
        except InvalidQueryError:
            # Given message from module errors.py
            raise SchemaValidationError
        # Error handling field not exist
        except DoesNotExist:
            # Given message from module errors.py
            raise UpdatingFieldError
        # Error handling for everything that is not defined in error.py
        except Exception:
            # Given message from module errors.py
            raise InternalServerError       
      
    @jwt_required
    # Methode 'DELETE'
    def delete(self, id):
        try:
            person_id = get_jwt_identity()
            result = result_progress.objects.get(id=id, added_by=person_id)
            result.delete()
            return Response('Delete status is: OK', status=200)
        except DoesNotExist:
            raise DeletingFieldError
        except Exception:
            raise InternalServerError       

    def get(self, id):
        try:
            results = result_progress.objects.get(id=id).to_json()
            return Response(results, mimetype="application/json", status=200)
        # Error handling field not exist
        except DoesNotExist:
            # Given message from module errors.py
            raise UpdatingFieldError 
        # Error handling for everything that is not defined in error.py
        except Exception:
            # Given message from module errors.py
            raise InternalServerError    
