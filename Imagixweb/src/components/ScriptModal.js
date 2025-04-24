
// components/ScriptModal.js
import React, { useState } from 'react';

function ScriptModal({ onClose }) {
  const [language, setLanguage] = useState('python');
  const [code, setCode] = useState('');

  const handleApplyScript = () => {
    console.log(`Applying ${language} script: `, code);
    // En una implementación real, este código se enviaría a un backend
    // que procesaría la imagen usando la biblioteca correspondiente
    alert('Script aplicado (simulación)');
  };

  return (
    <div className="script-modal-overlay">
      <div className="script-modal">
        <div className="modal-header">
          <h2>Editor de Scripts</h2>
          <button onClick={onClose} className="close-button">×</button>
        </div>
        
        <div className="language-selector">
          <button 
            className={language === 'python' ? 'selected' : ''} 
            onClick={() => setLanguage('python')}
          >
            Python
          </button>
          <button 
            className={language === 'matlab' ? 'selected' : ''} 
            onClick={() => setLanguage('matlab')}
          >
            MATLAB
          </button>
        </div>
        
        <div className="code-editor">
          <textarea
            value={code}
            onChange={(e) => setCode(e.target.value)}
            placeholder={language === 'python' ? 
              "# Ejemplo Python\nimport numpy as np\ndef process_image(img):\n  # Tu código aquí\n  return img" : 
              "% Ejemplo MATLAB\nfunction output = processImage(img)\n  % Tu código aquí\n  output = img;\nend"
            }
          />
        </div>
        
        <div className="modal-footer">
          <button onClick={handleApplyScript} className="apply-button">
            Aplicar Script
          </button>
        </div>
      </div>
    </div>
  );
}

export default ScriptModal;