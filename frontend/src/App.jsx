import { useState, useEffect } from 'react'
import './index.css'

function App() {
  const [message, setMessage] = useState('')
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)

  useEffect(() => {
    fetch('/api/hello')
      .then(response => response.json())
      .then(data => {
        setMessage(data.message)
        setLoading(false)
      })
      .catch(err => {
        setError(err.message)
        setLoading(false)
      })
  }, [])

  return (
    <div className="container">
      <h1>Python Template</h1>
      <div className="card">
        <h2>Full-Stack Application</h2>
        <p>Frontend: Vite + React</p>
        <p>Backend: FastAPI + Python</p>

        <div className="api-response">
          <h3>API Response:</h3>
          {loading && <p>Loading...</p>}
          {error && <p className="error">Error: {error}</p>}
          {message && <p className="success">{message}</p>}
        </div>
      </div>

      <div className="info">
        <p>
          Edit <code>backend/app/main.py</code> or <code>frontend/src/App.jsx</code> to get started.
        </p>
      </div>
    </div>
  )
}

export default App
