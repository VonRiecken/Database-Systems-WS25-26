from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
import configparser

config = configparser.ConfigParser()
config.read('config/config.ini')

db_config = config['mysql_4']
DATABASE_URL = f"mysql+pymysql://{db_config['user']}:{db_config['password']}@{db_config['host']}:{db_config['port']}/{db_config['database']}"
engine = create_engine(
                        DATABASE_URL, 
                        connect_args={"charset": "utf8mb4"},
                        pool_recycle=3600
                    )
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
