// components/Header.js
import React from 'react';

function Header() {
  return (
    <header className="header">
      <div className="logo">
        <h1>IMAGIX</h1>
      </div>
      <div className="header-controls">
        <div className="user-info">
          <span>Dr. Usuario</span>
          
          <img src="/api/placeholder/40/40" alt="User Avatar" className="avatar" />
        </div>
      </div>
    </header>
  );
}

export default Header;






