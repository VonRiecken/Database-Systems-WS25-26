
from fastapi import FastAPI, Depends, HTTPException, Request
from fastapi.templating import Jinja2Templates
from fastapi.responses import HTMLResponse, JSONResponse
from sqlalchemy.orm import Session
from sqlalchemy import text
from pydantic import BaseModel
from database import get_db

app = FastAPI()
templates = Jinja2Templates(directory="templates")

# --- DATA MODELS ---
class LoginRequest(BaseModel):
    email: str
    password: str

class SignupRequest(BaseModel):
    name: str
    email: str
    password: str
    role: str = "Student" # Default role

class OrderRequest(BaseModel):
    user_id: int
    meal_id: int
    quantity: int
    pickup_time: str 

# --- PAGE ROUTES (Return HTML) ---
@app.get("/", response_class=HTMLResponse)
def page_login(request: Request):
    return templates.TemplateResponse("login.html", {"request": request})

@app.get("/signup", response_class=HTMLResponse)
def page_signup(request: Request):
    return templates.TemplateResponse("signup.html", {"request": request})

@app.get("/menu", response_class=HTMLResponse)
def page_menu(request: Request):
    return templates.TemplateResponse("menu.html", {"request": request})

@app.get("/my-orders", response_class=HTMLResponse)
def page_orders(request: Request):
    return templates.TemplateResponse("orders.html", {"request": request})


# --- API ROUTES (JSON Logic) ---

# 1. Login API
@app.post("/api/login")
def login(creds: LoginRequest, db: Session = Depends(get_db)):
    # WARNING: In production, hash passwords! This is simple text for demo.
    query = text("SELECT user_id, name, role FROM dbsysgr4.User WHERE email = :email AND password_hash = :pass")
    result = db.execute(query, {"email": creds.email, "pass": creds.password}).fetchone()
    
    if not result:
        raise HTTPException(status_code=401, detail="Invalid credentials")
    
    return {"user_id": result.user_id, "name": result.name, "role": result.role}

# 2. Signup API
@app.post("/api/signup")
def signup(user: SignupRequest, db: Session = Depends(get_db)):
    try:
        # Assuming ID is auto-increment
        query = text("INSERT INTO dbsysgr4.User (name, email, password_hash, role) VALUES (:name, :email, :pass, :role)")
        db.execute(query, {"name": user.name, "email": user.email, "pass": user.password, "role": user.role})
        db.commit()
        return {"message": "User created successfully"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=400, detail="User already exists or error")

# 3. Get Menu
@app.get("/api/menu")
def get_menu(role: str = "Student", db: Session = Depends(get_db)):
    query = text(""" SELECT meal_id, name, description, price, category, type, is_available, 
                 image_url, fn_get_dynamic_price(price, :role) as price 
                 FROM dbsysgr4.Meal""")# WHERE is_available = 1 """)
    result = db.execute(query, {"role" : role})
    # Convert to dictionary list
    return [dict(row._mapping) for row in result]

# 4. Place Order (Using your Stored Procedure)
@app.post("/api/order")
def place_order(order: OrderRequest, db: Session = Depends(get_db)):
    try:
        # Note: MySQL uses CALL
        sql = text("CALL dbsysgr4.sp_place_order(:mid, :uid, :qty, :time)")
        db.execute(sql, {
            "mid": order.meal_id,
            "uid": order.user_id,
            "qty": order.quantity,
            "time": order.pickup_time # Format "HH:MM:SS" usually suffices for Time type, but match DB
        })
        db.commit()
        return {"message": "Order placed successfully!"}
    except Exception as e:
        db.rollback()
        print(f"Error: {e}")
        raise HTTPException(status_code=400, detail=str(e))

# 5. Get My Orders
@app.get("/api/orders/{user_id}")
def get_my_orders(user_id: int, db: Session = Depends(get_db)):
    # Join Order and Order_Item and Meal to get full details
    sql = text("""
        SELECT o.order_id, o.order_date, o.pickup_time, o.total_amount, m.name as meal_name, oi.quantity
        FROM dbsysgr4.`Order` o
        JOIN dbsysgr4.Order_Item oi ON o.order_id = oi.order_id
        JOIN dbsysgr4.Meal m ON oi.meal_id = m.meal_id
        WHERE o.user_id = :uid
        ORDER BY o.order_date DESC
    """)
    result = db.execute(sql, {"uid": user_id})
    return [dict(row._mapping) for row in result]

@app.get("/api/users")
def get_users(db: Session = Depends(get_db)):
    # Fetch simple user list for the dropdown
    query = text("SELECT user_id as id, name, role FROM dbsysgr4.User")
    result = db.execute(query)
    return [dict(row._mapping) for row in result]

# --- Add this to PAGE ROUTES section ---
@app.get("/reports", response_class=HTMLResponse)
def page_reports(request: Request):
    return templates.TemplateResponse("reports.html", {"request": request})

# --- Add this to API ROUTES section ---

# Get Weekly Report
@app.get("/api/reports/weekly")
def get_weekly_report(db: Session = Depends(get_db)):
    try:
        result = db.execute(text("CALL sp_get_weekly_sales()"))
        return [dict(row._mapping) for row in result]
    except Exception as e:
        print(e)
        return []

# Get Monthly Report
@app.get("/api/reports/monthly")
def get_monthly_report(db: Session = Depends(get_db)):
    try:
        result = db.execute(text("CALL sp_get_monthly_sales()"))
        print(f"Monthly report = {result}")
        return [dict(row._mapping) for row in result]
    except Exception as e:
        print(e)
        return []
    
## uvicorn main:app --reload
