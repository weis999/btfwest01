from .data import ResultsApi, ResultApi
from .auth import SignupApi, SigninApi, personGet

# Initializes both endpoints into routes.
def initialize_routes(api):
    # Endpoint route for API '/api/v1/results/'
    api.add_resource(ResultsApi, '/api/v1/results')
    # Endpoint route for API '/api/v1/results/<id>'
    api.add_resource(ResultApi, '/api/v1/results/<id>')
    # Endpoint route for API '/api/v1/auth/signup/'
    api.add_resource(SignupApi, '/api/v1/auth/signup')
    # Endpoint route for API '/api/v1/auth/login/'
    api.add_resource(SigninApi, '/api/v1/auth/signin')
    # Endpoint route for API '/api/v1/auth/get/'
    api.add_resource(personGet, '/api/v1/auth/get')
