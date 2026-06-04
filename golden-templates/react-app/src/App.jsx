import React from 'react';

function App() {
  return (
    <div style={{
      backgroundColor: '#0a0e17',
      color: '#f8fafc',
      fontFamily: 'system-ui, sans-serif',
      minHeight: '100vh',
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      justifyContent: 'center',
      padding: '2rem',
      textAlign: 'center'
    }}>
      <header style={{
        background: 'linear-gradient(135deg, #1e293b 0%, #0f172a 100%)',
        padding: '3rem',
        borderRadius: '16px',
        boxShadow: '0 10px 25px rgba(0,0,0,0.5)',
        border: '1px solid #334155',
        maxWidth: '600px',
        width: '100%'
      }}>
        <h1 style={{
          fontSize: '2.5rem',
          margin: '0 0 1rem 0',
          background: 'linear-gradient(90deg, #38bdf8 0%, #818cf8 100%)',
          WebkitBackgroundClip: 'text',
          WebkitTextFillColor: 'transparent'
        }}>
          React Golden Template
        </h1>
        <p style={{ color: '#94a3b8', fontSize: '1.1rem', lineHeight: '1.6' }}>
          This is a cloud-native React SPA bootstrapped by the Platform Engineering Accelerator.
          Equipped with production-ready Nginx, security headers, and health endpoints.
        </p>
        <div style={{
          marginTop: '2rem',
          display: 'grid',
          gridTemplateColumns: '1fr 1fr',
          gap: '1rem'
        }}>
          <div style={{ background: '#1e293b', padding: '1rem', borderRadius: '8px', border: '1px solid #475569' }}>
            <h3 style={{ margin: '0 0 0.5rem 0', color: '#38bdf8' }}>Status</h3>
            <span style={{ display: 'inline-flex', alignItems: 'center', gap: '0.5rem', fontWeight: 'bold' }}>
              <span style={{ width: '10px', height: '10px', backgroundColor: '#10b981', borderRadius: '50%' }}></span>
              Healthy
            </span>
          </div>
          <div style={{ background: '#1e293b', padding: '1rem', borderRadius: '8px', border: '1px solid #475569' }}>
            <h3 style={{ margin: '0 0 0.5rem 0', color: '#818cf8' }}>Runtime</h3>
            <span style={{ fontWeight: 'bold' }}>Nginx + Alpine</span>
          </div>
        </div>
      </header>
    </div>
  );
}

export default App;
