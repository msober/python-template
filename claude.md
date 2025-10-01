# Python Template - Claude Code Context

This document provides context for Claude Code when working on this project.

## Project Overview

A full-stack Python scaffold with FastAPI backend and React frontend, supporting both Docker and local development modes.

**Tech Stack:**
- Backend: FastAPI + Uvicorn (Python >= 3.9)
- Frontend: Vite + React
- Testing: pytest, black, flake8
- Deployment: Docker with multi-stage builds

## Project Architecture

```
python-template/
├── backend/
│   ├── app/
│   │   ├── main.py          # FastAPI application entry point
│   │   ├── config.py        # Settings and configuration
│   │   └── api/
│   │       ├── __init__.py
│   │       └── routes.py    # API route definitions
│   ├── tests/               # Backend tests
│   │   ├── __init__.py
│   │   └── test_main.py
│   ├── requirements.txt     # Python dependencies
│   └── Dockerfile
├── frontend/
│   ├── src/
│   │   ├── App.jsx          # Main React component
│   │   ├── main.jsx         # React entry point
│   │   └── index.css        # Global styles
│   ├── package.json         # Node dependencies
│   ├── vite.config.js       # Vite configuration
│   └── Dockerfile
├── scripts/                 # Shell scripts for development
├── pyproject.toml          # Python tools configuration
├── .flake8                 # Flake8 linting rules
└── .env                    # Environment variables
```

## Development Guidelines

### Backend Development

**Adding New API Endpoints:**
1. Define routes in `backend/app/api/routes.py`
2. Use Pydantic models for request/response validation
3. Add corresponding tests in `backend/tests/`
4. Follow RESTful conventions

**Example:**
```python
from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter()

class ItemResponse(BaseModel):
    id: int
    name: str

@router.get("/items/{item_id}", response_model=ItemResponse)
async def get_item(item_id: int):
    return ItemResponse(id=item_id, name="Example Item")
```

**Configuration:**
- Use `backend/app/config.py` for all configuration
- Environment variables via Pydantic Settings
- Access via `from app.config import settings`

### Frontend Development

**Component Structure:**
- Keep components in `frontend/src/`
- Main app logic in `App.jsx`
- API calls use proxy configured in `vite.config.js`

**API Communication:**
```javascript
// Vite proxy handles /api requests to backend
fetch('/api/endpoint')
  .then(response => response.json())
  .then(data => console.log(data))
```

### Testing

**Run tests before committing:**
```bash
./scripts/test.sh
```

**Backend tests:**
- Use pytest with TestClient
- Aim for high coverage
- Test both success and error cases

**Test structure:**
```python
def test_endpoint(client):
    """Test description."""
    response = client.get("/api/endpoint")
    assert response.status_code == 200
    assert "expected_key" in response.json()
```

## Code Style Guidelines

### Python

**Formatting:**
- Black (line length: 88)
- Run: `black backend/app backend/tests`

**Linting:**
- Flake8 configured in `.flake8`
- Run: `flake8 backend/app backend/tests`

**Best Practices:**
- Type hints for function parameters and returns
- Docstrings for public functions
- Async/await for I/O operations
- Pydantic models for data validation

**Example:**
```python
async def process_item(item_id: int) -> ItemResponse:
    """
    Process an item by its ID.

    Args:
        item_id: The unique identifier of the item

    Returns:
        ItemResponse: The processed item data
    """
    # Implementation
    pass
```

### JavaScript/React

**Best Practices:**
- Functional components with hooks
- Use `useState`, `useEffect` appropriately
- Keep components small and focused
- Handle loading and error states

## Common Tasks

### Adding a New Backend Endpoint

1. **Define the route in `backend/app/api/routes.py`:**
```python
@router.post("/items", response_model=ItemResponse)
async def create_item(item: ItemCreate):
    # Implementation
    return ItemResponse(...)
```

2. **Add Pydantic models if needed:**
```python
class ItemCreate(BaseModel):
    name: str
    description: str | None = None
```

3. **Write tests in `backend/tests/test_main.py`:**
```python
def test_create_item(client):
    response = client.post("/api/items", json={"name": "Test"})
    assert response.status_code == 200
```

4. **Run tests:**
```bash
./scripts/test.sh
```

### Adding a New React Component

1. **Create component file in `frontend/src/`:**
```javascript
function MyComponent({ prop1, prop2 }) {
  const [state, setState] = useState(null)

  return <div>Component content</div>
}

export default MyComponent
```

2. **Import and use in App.jsx:**
```javascript
import MyComponent from './MyComponent'

function App() {
  return (
    <div>
      <MyComponent prop1="value" />
    </div>
  )
}
```

### Modifying Configuration

**Environment variables (.env):**
- Add to `.env.example` first
- Document in `backend/app/config.py`
- Use Pydantic Settings for validation

**Example:**
```python
# In config.py
class Settings(BaseSettings):
    new_setting: str = "default_value"

    class Config:
        env_file = ".env"
```

## Deployment

### Local Development
```bash
./scripts/dev.sh
```

### Production
```bash
# With Docker
./scripts/prod-docker.sh

# Without Docker
./scripts/prod-local.sh
```

## Important Files to Modify

### When adding Python dependencies:
- `requirements.txt` (production)
- `setup.py` (optional dependencies)
- `pyproject.toml` (if tool-specific)

### When adding Node dependencies:
- `frontend/package.json`

### When modifying Docker setup:
- `backend/Dockerfile` or `frontend/Dockerfile`
- `docker-compose.yml` (production)
- `docker-compose.dev.yml` (development)

## Database Setup (Future)

**When adding database support:**
1. Add database URL to `backend/app/config.py`
2. Choose ORM (SQLAlchemy recommended)
3. Create models in `backend/app/models/`
4. Add migrations (Alembic)
5. Update tests with database fixtures

## Common Patterns

### Error Handling in FastAPI
```python
from fastapi import HTTPException

@router.get("/items/{item_id}")
async def get_item(item_id: int):
    item = await fetch_item(item_id)
    if not item:
        raise HTTPException(status_code=404, detail="Item not found")
    return item
```

### API State Management in React
```javascript
function App() {
  const [data, setData] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)

  useEffect(() => {
    fetch('/api/endpoint')
      .then(res => res.json())
      .then(data => {
        setData(data)
        setLoading(false)
      })
      .catch(err => {
        setError(err.message)
        setLoading(false)
      })
  }, [])

  if (loading) return <p>Loading...</p>
  if (error) return <p>Error: {error}</p>
  return <div>{/* render data */}</div>
}
```

## Quick Reference

### Start Development
```bash
./scripts/dev.sh
```

### Run Tests
```bash
./scripts/test.sh
```

### Format Code
```bash
black backend/app backend/tests
```

### Check Linting
```bash
flake8 backend/app backend/tests
```

### Initialize New Project
```bash
./scripts/init.sh project-name
```

## URLs

- Frontend (dev): http://localhost:5173
- Backend API: http://localhost:8000
- API Docs: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## Notes for Claude Code

- Always run tests after making changes: `./scripts/test.sh`
- Follow existing code style (Black formatting, type hints)
- Add tests for new functionality
- Update this file if adding major features
- Environment variables should be documented in `backend/app/config.py`
- CORS is configured in `backend/app/main.py` via settings
- Frontend proxy is configured in `frontend/vite.config.js`
