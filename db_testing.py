from sqlalchemy import create_engine, text
from sqlalchemy.exc import OperationalError

DATABASE_URL = "postgresql://postgres:123ugofree@localhost/postgres"

engine = create_engine(DATABASE_URL)

try:
    with engine.connect() as connection:
        # result = connection.execute(text("SELECT 1"))
        result = connection.execute(text("select meal_id, name, description, price, category from canteen.meal"))# WHERE is_available = TRUE"))
        print(result)
        print("Connection successful!")
except OperationalError as e:
    print(f"Connection failed: {e}")