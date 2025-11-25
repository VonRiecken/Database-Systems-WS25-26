from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy import text

# UPDATE 'password' with your actual Postgres password
# DATABASE_URL = "postgresql://postgres:123ugofree@localhost/UniversityCanteen"
# DATABASE_URL = "postgresql://postgres:123ugofree@localhost/burgerproject"
DATABASE_URL = "postgresql://postgres:123ugofree@localhost/postgres"

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

