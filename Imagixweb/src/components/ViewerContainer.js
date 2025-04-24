// components/ViewerContainer.js
import React from 'react';
import ImageViewer from './ImageViewer';

function ViewerContainer({ images, layout, tool, patient }) {
  const getViewers = () => {
    switch(layout) {
      case '1x1':
        return (
          <div className="viewer-grid grid-1x1">
            <ImageViewer 
              imageSrc={images[0]} 
              tool={tool} 
              patientInfo={patient} 
              position="1"
            />
          </div>
        );
      case '1x2':
        return (
          <div className="viewer-grid grid-1x2">
            <ImageViewer 
              imageSrc={images[0]} 
              tool={tool} 
              patientInfo={patient} 
              position="1"
            />
            <ImageViewer 
              imageSrc={images[1] || images[0]} 
              tool={tool} 
              patientInfo={patient} 
              position="2"
            />
          </div>
        );
      case '2x2':
        return (
          <div className="viewer-grid grid-2x2">
            <ImageViewer 
              imageSrc={images[0]} 
              tool={tool} 
              patientInfo={patient} 
              position="1"
            />
            <ImageViewer 
              imageSrc={images[1] || images[0]} 
              tool={tool} 
              patientInfo={patient} 
              position="2"
            />
            <ImageViewer 
              imageSrc={images[2] || images[0]} 
              tool={tool} 
              patientInfo={patient} 
              position="3"
            />
            <ImageViewer 
              imageSrc={images[3] || images[0]} 
              tool={tool} 
              patientInfo={patient} 
              position="4"
            />
          </div>
        );
      default:
        return null;
    }
  };

  return (
    <div className="viewer-container">
      {getViewers()}
    </div>
  );
}

export default ViewerContainer;