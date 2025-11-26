from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
import configparser

config = configparser.ConfigParser()
config.read('config/config.ini')
db_config = config['postgres']

DATABASE_URL = f"postgresql://{db_config['user']}:{db_config['password']}@{db_config['host']}/{db_config['database']}"
engine = create_engine(DATABASE_URL)

# db_config = config['mysql']
# DATABASE_URL = "mysql+pymysql://root:xxxxxxxxxxxx@reddata.m.hs-offenburg.de:3306/dbsysgr1"
# DATABASE_URL = f"mysql+pymysql://{db_config['user']}:{db_config['password']}@{db_config['host']}:{db_config['port']}/{db_config['database']}"
# SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
# engine = create_engine(
#     DATABASE_URL, 
#     # Optional but recommended for MySQL to handle encoding correctly:
#     connect_args={"charset": "utf8mb4"},
#     # Optional: MySQL closes connections after 8 hours. 
#     # This prevents "MySQL server has gone away" errors by recycling connections every hour.
#     pool_recycle=3600
# )

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


