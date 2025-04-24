// components/SideBar.js
import React, { useState } from 'react';

function SideBar({ patients, onPatientSelect, currentPatient }) {
  const [activeTab, setActiveTab] = useState('patients');

  return (
    <div className="sidebar">
      <div className="sidebar-tabs">
        <button 
          className={activeTab === 'patients' ? 'tab-active' : ''}
          onClick={() => setActiveTab('patients')}
        >
          Pacientes
        </button>
        <button 
          className={activeTab === 'studies' ? 'tab-active' : ''}
          onClick={() => setActiveTab('studies')}
        >
          Estudios
        </button>
        <button 
          className={activeTab === 'dicomdir' ? 'tab-active' : ''}
          onClick={() => setActiveTab('dicomdir')}
        >
          DICOMDIR
        </button>
      </div>

      <div className="sidebar-content">
        {activeTab === 'patients' && (
          <div className="patient-list">
            <h3>Lista de Pacientes</h3>
            {patients.map(patient => (
              <div 
                key={patient.id} 
                className={`patient-item ${currentPatient && currentPatient.id === patient.id ? 'selected' : ''}`}
                onClick={() => onPatientSelect(patient.id)}
              >
                <div className="patient-info">
                  <h4>{patient.name}</h4>
                  <p>ID: {patient.id} | {patient.age} años | {patient.gender}</p>
                  <p>{patient.studyType} - {patient.studyDate}</p>
                </div>
              </div>
            ))}
          </div>
        )}

        {activeTab === 'studies' && (
          <div className="studies-list">
            <h3>Estudios Recientes</h3>
            <p>No hay estudios cargados</p>
            <button className="load-button">Cargar Estudio</button>
          </div>
        )}

        {activeTab === 'dicomdir' && (
          <div className="dicomdir-browser">
            <h3>Explorador DICOMDIR</h3>
            <p>Ningún DICOMDIR cargado</p>
            <button className="load-button">Seleccionar Archivo</button>
          </div>
        )}
      </div>
    </div>
  );
}

export default SideBar;