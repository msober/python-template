from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter()


class HealthResponse(BaseModel):
    """Health check response model."""

    status: str
    message: str


class MessageResponse(BaseModel):
    """Generic message response model."""

    message: str


@router.get("/health", response_model=HealthResponse)
async def health_check():
    """Health check endpoint."""
    return HealthResponse(status="ok", message="Service is healthy")


@router.get("/hello", response_model=MessageResponse)
async def hello():
    """Hello world endpoint."""
    return MessageResponse(message="Hello from Python Template API!")
