import os
from typing import Optional
from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    """Application settings."""

    app_name: str = "Python Template API"
    app_version: str = "0.1.0"
    debug: bool = False
    api_prefix: str = "/api"

    # CORS settings
    cors_origins: list[str] = ["http://localhost:5173", "http://localhost:3000"]

    # Server settings
    host: str = "0.0.0.0"
    port: int = 8000

    class Config:
        env_file = ".env"
        case_sensitive = False


settings = Settings()
