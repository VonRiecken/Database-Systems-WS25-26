from fastapi import FastAPI, Depends, HTTPException, Request
from fastapi.templating import Jinja2Templates
from fastapi.responses import HTMLResponse
from sqlalchemy.orm import Session
from sqlalchemy import text
from pydantic import BaseModel
from database import get_db

app = FastAPI()
templates = Jinja2Templates(directory="templates")

# --- DATA MODELS (Data Validation) ---
class OrderRequest(BaseModel):
    user_id: int
    meal_id: int
    quantity: int
    pickup_time: str  # Format: "YYYY-MM-DD HH:MM:SS"

# --- ROUTES ---

# 1. UI: Serve the HTML page
@app.get("/", response_class=HTMLResponse)
def read_root(request: Request):
    return templates.TemplateResponse("index.html", {"request": request})

# 2. API: Get Users (For the dropdown)
@app.get("/api/users")
def get_users(db: Session = Depends(get_db)):
    # Note: "User" is a reserved word in Postgres, so we use quotes and full schema path
    query = text('SELECT user_id, name, role FROM postgres.canteen.User ORDER BY user_id')
    result = db.execute(query)
    
    users = []
    for row in result:
        users.append({
            "id": row.user_id,
            "name": row.name,
            "role": row.role
        })
    return users

# 3. API: Get Menu
@app.get("/api/menu")
def get_menu(db: Session = Depends(get_db)):
    # Fetching from your specific schema
    query = text("SELECT meal_id, name, description, price, category, type FROM postgres.canteen.Meal WHERE is_available = TRUE")
    result = db.execute(query)
    
    menu = []
    for row in result:
        menu.append({
            "id": row.meal_id,
            "name": row.name,
            "description": row.description,
            "price": row.price,
            "category": row.category,
            "type": row.type
        })
    return menu

# 4. API: Place Order (Triggers your Stored Procedure)
@app.post("/api/order")
def place_order(order: OrderRequest, db: Session = Depends(get_db)):
    try:
        # Construct the SQL to call the procedure
        # Note: Postgres uses 'CALL'
        # sql = text("CALL postgres.canteen.sp_place_order(:uid, :mid, :qty, :time)")
        sql = text("CALL postgres.canteen.sp_PlaceOrder(:uid, :mid, :qty, :time)")
        
        db.execute(sql, {
            "uid": order.user_id,
            "mid": order.meal_id,
            "qty": order.quantity,
            "time": order.pickup_time
        })
        db.commit() # Commit the transaction
        
        return {"message": "Order placed successfully!"}
        
    except Exception as e:
        db.rollback()
        print(f"Error: {e}")
        # Return the error to the UI (e.g., "Meal not available")
        raise HTTPException(status_code=400, detail=str(e).split('\n')[0])
    

# uvicorn main:app --reload