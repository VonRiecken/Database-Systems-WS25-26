from sqlalchemy import text
from database import SessionLocal

def seed_database():
    db = SessionLocal()
    try:
        print("🌱 Seeding Users...")
        # Insert a Student and an Employee
        db.execute(text("""
            INSERT INTO Users (FullName, Email, Role, PaymentMethod) VALUES 
            ('Alice Student', 'alice@uni.edu', 'Student', 'Credit Card'),
            ('Bob Employee', 'bob@uni.edu', 'Employee', 'Payroll Deduction');
        """))

        print("🌱 Seeding Menu...")
        # Insert Meals
        db.execute(text("""
            INSERT INTO Meals (Name, Category, DietType, BasePrice, IsAvailable) VALUES 
            ('Vegan Buddha Bowl', 'Lunch', 'Vegan', 8.50, TRUE),
            ('Cheeseburger & Fries', 'Lunch', 'Normal', 9.00, TRUE),
            ('Morning Pancakes', 'Breakfast', 'Vegetarian', 5.00, TRUE),
            ('Grilled Salmon', 'Dinner', 'Normal', 12.00, TRUE);
        """))
        
        db.commit()
        print("✅ Database populated successfully!")
    except Exception as e:
        print(f"❌ Error: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    seed_database()