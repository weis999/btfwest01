from flask import Flask, render_template
from flask_bcrypt import Bcrypt
from flask_jwt_extended import JWTManager
from resources.errors import errors
from database.db import initialize_db
from flask_restful import Api
from resources.routes import initialize_routes
import os

## Check if env is present
def check():
    if 'COSMOSDB' in os.environ:
        uri = os.environ['COSMOSDB']
        return uri
    else:
        print("Please set the COSMOSDB environment variable!")
        exit()

def create_app(**config_overrides):
    app = Flask(__name__, static_url_path='', static_folder='static', template_folder='templates')
    api = Api(app, errors=errors)
    bcrypt = Bcrypt(app)
    jwt = JWTManager(app)
    # Load config.
    app.config['MONGODB_HOST'] = (check())
    # apply overrides
    app.config.update(config_overrides)
    # The database will be here initialized!
    initialize_db(app)
    # The routes will be here initialized!
    initialize_routes(api)
    
    @app.route('/')
    def main():
        return render_template('index.html')

    return app

if __name__ == '__main__':
    app = create_app()
    # With the app.run the flask server will be called into action
    app.run(host='0.0.0.0')