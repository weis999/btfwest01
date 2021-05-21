import unittest
import mongoengine
from app import create_app as create_app_base

def create_app():
    return create_app_base(
        MONGODB_SETTINGS={'DB': 'db-btf-dev-01'},
        TESTING=True,
        CSRF_ENABLED=False,
    )

def test_create_app():
    app = create_app()
    assert app.config['TESTING']
    assert mongoengine.connection.get_db().name == 'db-btf-dev-01'