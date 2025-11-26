from sqlalchemy import create_engine, text
from sqlalchemy.exc import OperationalError
import configparser

config = configparser.ConfigParser()
config.read('config/config.ini')
db_config = config['postgres']

DATABASE_URL = f"postgresql://{db_config['user']}:{db_config['password']}@{db_config['host']}/{db_config['database']}"
engine = create_engine(DATABASE_URL)

try:
    with engine.connect() as connection:
        result = connection.execute(text("SELECT 1"))
        print("Connection successful!")
except OperationalError as e:
    print(f"Connection failed: {e}")
