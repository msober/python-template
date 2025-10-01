from setuptools import setup, find_packages

setup(
    name="python-template",
    version="0.1.0",
    description="A full-stack Python template with FastAPI and React",
    author="Your Name",
    python_requires=">=3.9",
    packages=find_packages(),
    install_requires=[
        "fastapi>=0.104.0",
        "uvicorn[standard]>=0.24.0",
        "pydantic>=2.0.0",
        "pydantic-settings>=2.0.0",
        "python-dotenv>=1.0.0",
    ],
    extras_require={
        "dev": [
            "pytest>=7.4.0",
            "pytest-cov>=4.1.0",
            "pytest-asyncio>=0.21.0",
            "black>=23.0.0",
            "flake8>=6.0.0",
            "httpx>=0.25.0",
        ],
    },
)
