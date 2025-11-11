import { useState, useEffect } from 'react'
import './App.css'

function App() {
  const [users, setUsers] = useState([])
  const [backendInfo, setBackendInfo] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)

  // Get backend URL from environment variable or use default
  const BACKEND_URL = import.meta.env.VITE_BACKEND_URL || 'http://localhost:8080'

  useEffect(() => {
    fetchData()
  }, [])

  const fetchData = async () => {
    setLoading(true)
    setError(null)
    try {
      // Fetch backend info
      const infoResponse = await fetch(`${BACKEND_URL}/api/info`)
      const infoData = await infoResponse.json()
      setBackendInfo(infoData)

      // Fetch users
      const usersResponse = await fetch(`${BACKEND_URL}/api/users`)
      const usersData = await usersResponse.json()
      setUsers(usersData)
    } catch (err) {
      setError('Failed to connect to backend. Make sure backend is running.')
      console.error('Error fetching data:', err)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="App">
      <header className="App-header">
        <h1>🐳 Docker Assignment</h1>
        <p>Frontend ↔️ Backend Communication Demo</p>
      </header>

      <main className="App-main">
        {loading && <div className="loading">Loading...</div>}
        
        {error && (
          <div className="error-box">
            <h3>❌ Error</h3>
            <p>{error}</p>
            <button onClick={fetchData} className="retry-button">
              Retry Connection
            </button>
          </div>
        )}

        {!loading && !error && (
          <>
            <section className="info-section">
              <h2>✅ Backend Connected</h2>
              {backendInfo && (
                <div className="info-card">
                  <p><strong>Message:</strong> {backendInfo.message}</p>
                  <p><strong>Details:</strong> {backendInfo.timestamp}</p>
                </div>
              )}
            </section>

            <section className="users-section">
              <h2>👥 Users from Backend</h2>
              <div className="users-grid">
                {users.map(user => (
                  <div key={user.id} className="user-card">
                    <h3>{user.name}</h3>
                    <p>📧 {user.email}</p>
                    <p className="user-id">ID: {user.id}</p>
                  </div>
                ))}
              </div>
            </section>

            <section className="connection-info">
              <h3>🔗 Connection Details</h3>
              <p>Backend URL: <code>{BACKEND_URL}</code></p>
              <button onClick={fetchData} className="refresh-button">
                🔄 Refresh Data
              </button>
            </section>
          </>
        )}
      </main>

      <footer className="App-footer">
        <p>Built with React + Vite | Spring Boot Backend</p>
      </footer>
    </div>
  )
}

export default App

