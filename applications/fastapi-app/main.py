from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from prometheus_fastapi_instrumentator import Instrumentator
from pydantic import BaseModel
from typing import List, Optional
import uvicorn
import os
import time
import logging
from datetime import datetime

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Create FastAPI app
app = FastAPI(
    title="Azure DevOps Platform - FastAPI Microservice",
    description="Sample microservice demonstrating modern API patterns",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# Enable CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize Prometheus metrics
instrumentator = Instrumentator(
    should_group_status_codes=False,
    should_ignore_untemplated=True,
    should_respect_env_var=True,
    should_instrument_requests_inprogress=True,
    excluded_handlers=["/metrics"],
    env_var_name="ENABLE_METRICS",
    inprogress_name="inprogress",
    inprogress_labels=True,
)
instrumentator.instrument(app).expose(app)

# Data models
class User(BaseModel):
    id: Optional[int] = None
    name: str
    email: str
    created_at: Optional[datetime] = None

class UserCreate(BaseModel):
    name: str
    email: str

class HealthCheck(BaseModel):
    status: str
    timestamp: datetime
    version: str
    uptime_seconds: int

# In-memory storage (replace with database in production)
users_db = []
app_start_time = time.time()

# Root endpoint
@app.get("/")
async def root():
    """Root endpoint with API information"""
    return {
        "service": "FastAPI Microservice",
        "version": "1.0.0",
        "description": "Sample microservice for Azure DevOps Platform",
        "docs_url": "/docs",
        "health_check": "/health",
        "metrics": "/metrics"
    }

# Health check endpoint
@app.get("/health", response_model=HealthCheck)
async def health_check():
    """Health check endpoint for monitoring and load balancers"""
    uptime = int(time.time() - app_start_time)
    return HealthCheck(
        status="healthy",
        timestamp=datetime.utcnow(),
        version="1.0.0",
        uptime_seconds=uptime
    )

# Readiness probe
@app.get("/ready")
async def readiness_check():
    """Readiness check for Kubernetes"""
    # Add any dependencies check here (database, external services)
    return {"status": "ready", "timestamp": datetime.utcnow()}

# Liveness probe
@app.get("/live")
async def liveness_check():
    """Liveness check for Kubernetes"""
    return {"status": "alive", "timestamp": datetime.utcnow()}

# User management endpoints
@app.get("/api/v1/users", response_model=List[User])
async def get_users():
    """Get all users"""
    logger.info(f"Retrieved {len(users_db)} users")
    return users_db

@app.post("/api/v1/users", response_model=User, status_code=201)
async def create_user(user: UserCreate):
    """Create a new user"""
    # Check if email already exists
    if any(u.email == user.email for u in users_db):
        raise HTTPException(status_code=400, detail="Email already registered")
    
    new_user = User(
        id=len(users_db) + 1,
        name=user.name,
        email=user.email,
        created_at=datetime.utcnow()
    )
    
    users_db.append(new_user)
    logger.info(f"Created user: {new_user.email}")
    return new_user

@app.get("/api/v1/users/{user_id}", response_model=User)
async def get_user(user_id: int):
    """Get user by ID"""
    user = next((u for u in users_db if u.id == user_id), None)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

@app.delete("/api/v1/users/{user_id}")
async def delete_user(user_id: int):
    """Delete user by ID"""
    global users_db
    user = next((u for u in users_db if u.id == user_id), None)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    users_db = [u for u in users_db if u.id != user_id]
    logger.info(f"Deleted user: {user.email}")
    return {"message": "User deleted successfully"}

# Application status endpoint
@app.get("/api/v1/status")
async def get_status():
    """Get application status and metrics"""
    uptime = int(time.time() - app_start_time)
    return {
        "service": "FastAPI Microservice",
        "version": "1.0.0",
        "status": "running",
        "uptime_seconds": uptime,
        "total_users": len(users_db),
        "environment": os.getenv("ENVIRONMENT", "development"),
        "timestamp": datetime.utcnow()
    }

# Simulate some load for demo purposes
@app.get("/api/v1/simulate-load")
async def simulate_load():
    """Simulate some CPU load for testing auto-scaling"""
    import hashlib
    data = "simulate-load" * 1000
    result = hashlib.sha256(data.encode()).hexdigest()
    return {"message": "Load simulation complete", "hash": result[:16]}

# Exception handler
@app.exception_handler(Exception)
async def general_exception_handler(request, exc):
    logger.error(f"Unhandled exception: {exc}")
    return JSONResponse(
        status_code=500,
        content={"detail": "Internal server error"}
    )

# Startup event
@app.on_event("startup")
async def startup_event():
    logger.info("FastAPI microservice starting up...")
    # Add startup logic here (database connections, etc.)

# Shutdown event
@app.on_event("shutdown")
async def shutdown_event():
    logger.info("FastAPI microservice shutting down...")
    # Add cleanup logic here

if __name__ == "__main__":
    port = int(os.getenv("PORT", 8000))
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=port,
        reload=False,
        log_level="info"
    )
