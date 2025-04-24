// components/ImageViewer.js
import React, { useState, useEffect, useRef } from 'react';

function ImageViewer({ imageSrc, tool, patientInfo, position }) {
  const [zoom, setZoom] = useState(1);
  const [pan, setPan] = useState({ x: 0, y: 0 });
  const [isDragging, setIsDragging] = useState(false);
  const [startDragPos, setStartDragPos] = useState({ x: 0, y: 0 });
  const [startPanPos, setStartPanPos] = useState({ x: 0, y: 0 });
  const [windowWidth, setWindowWidth] = useState(400);
  const [windowCenter, setWindowCenter] = useState(200);
  const viewerRef = useRef(null);

  useEffect(() => {
    // Reset view when image source changes
    setZoom(1);
    setPan({ x: 0, y: 0 });
  }, [imageSrc]);

  const handleMouseDown = (e) => {
    if (tool === 'pan') {
      setIsDragging(true);
      setStartDragPos({ x: e.clientX, y: e.clientY });
      setStartPanPos({ ...pan });
    }
  };

  const handleMouseMove = (e) => {
    if (isDragging && tool === 'pan') {
      const deltaX = e.clientX - startDragPos.x;
      const deltaY = e.clientY - startDragPos.y;
      setPan({
        x: startPanPos.x + deltaX,
        y: startPanPos.y + deltaY
      });
    }
  };

  const handleMouseUp = () => {
    setIsDragging(false);
  };

  const handleWheel = (e) => {
    e.preventDefault();
    if (tool === 'zoom') {
      const zoomFactor = e.deltaY > 0 ? 0.9 : 1.1;
      setZoom(prevZoom => prevZoom * zoomFactor);
    } else if (tool === 'window') {
      // Window width/level adjustment
      const widthDelta = e.deltaX * 5;
      const centerDelta = e.deltaY * 2;
      setWindowWidth(prevWidth => Math.max(1, prevWidth + widthDelta));
      setWindowCenter(prevCenter => prevCenter + centerDelta);
    }
  };

  return (
    <div 
      className="image-viewer"
      ref={viewerRef}
      onMouseDown={handleMouseDown}
      onMouseMove={handleMouseMove}
      onMouseUp={handleMouseUp}
      onMouseLeave={handleMouseUp}
      onWheel={handleWheel}
    >
      <div className="viewer-controls">
        <div className="viewer-info">
          {patientInfo && (
            <>
              <span>{patientInfo.name} ({patientInfo.id})</span>
              <span>{patientInfo.studyType}</span>
            </>
          )}
        </div>
        <div className="viewer-position">Viewer {position}</div>
      </div>

      <div className="image-container">
        <img
          src={imageSrc}
          alt="Medical Image"
          style={{
            transform: `translate(${pan.x}px, ${pan.y}px) scale(${zoom})`,
            filter: `contrast(${windowWidth / 400}) brightness(${(windowCenter + 200) / 400})`
          }}
          draggable="false"
        />
      </div>

      <div className="image-info">
        <span>Zoom: {(zoom * 100).toFixed(0)}%</span>
        <span>WW: {windowWidth.toFixed(0)} | WL: {windowCenter.toFixed(0)}</span>
      </div>
    </div>
  );
}

export default ImageViewer;