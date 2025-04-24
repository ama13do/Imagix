// App.js - Componente principal de la aplicación IMAGIX

import React, { useState, useEffect } from 'react';
import './App.css';
import SideBar from './components/SideBar';
import ViewerContainer from './components/ViewerContainer';
import ScriptModal from './components/ScriptModal';
import Header from './components/Header';

function App() {
  const [activeView, setActiveView] = useState('single');
  const [scriptModalOpen, setScriptModalOpen] = useState(false);
  const [currentPatient, setCurrentPatient] = useState(null);
  const [loadedImages, setLoadedImages] = useState([]);
  const [viewerLayout, setViewerLayout] = useState('1x1');
  const [selectedTool, setSelectedTool] = useState('pan');

  // Datos de ejemplo para demostración
  const demoPatients = [
    {
      id: 'P001',
      name: 'Juan Pérez',
      age: 45,
      gender: 'M',
      studyDate: '2025-04-20',
      studyType: 'MRI',
      images: [
        '/images/image1.jpg',
        '/images/image2.jpg',
        '/images/image2¿3.jpg',
        
      ]
    },
    {
      id: 'P002',
      name: 'María López',
      age: 32,
      gender: 'F',
      studyDate: '2025-04-18',
      studyType: 'CT',
      images: [
        '/images/script.jpg',
        '/images/script2.jpg',
      ]
    }
  ];

  useEffect(() => {
    // Cargar el primer paciente por defecto
    setCurrentPatient(demoPatients[0]);
    setLoadedImages(demoPatients[0].images);
  }, []);

  const handleToolSelect = (tool) => {
    setSelectedTool(tool);
  };

  const handleChangeLayout = (layout) => {
    setViewerLayout(layout);
  };

  const handleOpenScriptModal = () => {
    setScriptModalOpen(true);
  };

  const handleCloseScriptModal = () => {
    setScriptModalOpen(false);
  };

  const handlePatientSelect = (patientId) => {
    const patient = demoPatients.find(p => p.id === patientId);
    setCurrentPatient(patient);
    setLoadedImages(patient.images);
  };

  return (
    <div className="app-container">
      <Header />
      <div className="main-content">
        <SideBar 
          patients={demoPatients}
          onPatientSelect={handlePatientSelect}
          currentPatient={currentPatient}
        />
        <main className="content">
          <div className="toolbar">
            <div className="tool-group">
              <button onClick={() => handleToolSelect('pan')} className={selectedTool === 'pan' ? 'active' : ''}>
                🖐 Pan
              </button>
              <button onClick={() => handleToolSelect('zoom')} className={selectedTool === 'zoom' ? 'active' : ''}>
                🔍 Zoom
              </button>
              <button onClick={() => handleToolSelect('window')} className={selectedTool === 'window' ? 'active' : ''}>
                📊 Window/Level
              </button>
              <button onClick={() => handleToolSelect('measure')} className={selectedTool === 'measure' ? 'active' : ''}>
                📏 Measure
              </button>
            </div>
            <div className="layout-group">
              <button onClick={() => handleChangeLayout('1x1')}>1x1</button>
              <button onClick={() => handleChangeLayout('1x2')}>1x2</button>
              <button onClick={() => handleChangeLayout('2x2')}>2x2</button>
            </div>
            <div className="script-group">
              <button onClick={handleOpenScriptModal} className="script-button">
                📝 Scripts
              </button>
            </div>
          </div>
          
          <ViewerContainer 
            images={loadedImages}
            layout={viewerLayout}
            tool={selectedTool}
            patient={currentPatient}
          />
        </main>
      </div>
      
      {scriptModalOpen && <ScriptModal onClose={handleCloseScriptModal} />}
    </div>
  );
}

export default App;