import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Home from './pages/Home';
import Assistance from './pages/Assistance';
import Status from './pages/Status';

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/assistance" element={<Assistance />} />
        <Route path="/status" element={<Status />} />
      </Routes>
    </Router>
  );
}

export default App;