import os
import sys
import numpy as np
import pydicom
from pydicom.pixel_data_handlers.util import apply_voi_lut
import matplotlib.pyplot as plt
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.figure import Figure
from PyQt5.QtWidgets import (QApplication, QMainWindow, QWidget, QVBoxLayout, QHBoxLayout,
                            QPushButton, QFileDialog, QLabel, QSlider, QTabWidget,
                            QListWidget, QSplitter, QComboBox, QGroupBox, QGridLayout,
                            QScrollArea, QAction, QMenu, QToolBar)
from PyQt5.QtCore import Qt, QSize
from PyQt5.QtGui import QIcon, QPixmap


class DicomImageCanvas(FigureCanvas):
    def __init__(self, parent=None, width=5, height=5, dpi=100):
        self.fig = Figure(figsize=(width, height), dpi=dpi)
        self.axes = self.fig.add_subplot(111)
        super(DicomImageCanvas, self).__init__(self.fig)
        self.setParent(parent)
        
        # Initialize with empty image
        self.image_data = None
        self.current_display = None
        self.contrast = 1.0
        self.brightness = 0.0
        
        # Enable mouse events
        self.fig.canvas.mpl_connect('scroll_event', self.on_scroll)
        self.fig.canvas.mpl_connect('button_press_event', self.on_press)
        self.fig.canvas.mpl_connect('motion_notify_event', self.on_motion)
        self.fig.canvas.mpl_connect('button_release_event', self.on_release)
        
        # Mouse tracking for panning
        self.pressed = False
        self.x_prev = 0
        self.y_prev = 0
        
        # Zoom/pan settings
        self.zoom_level = 1.0
        self.x_offset = 0
        self.y_offset = 0
        
    def on_scroll(self, event):
        """Handle mouse scroll for zoom"""
        if event.button == 'up':
            self.zoom_level *= 1.1
        else:
            self.zoom_level /= 1.1
            if self.zoom_level < 1.0:
                self.zoom_level = 1.0
                self.reset_view()
                
        self.update_display()
        
    def on_press(self, event):
        """Handle mouse press for panning"""
        if event.button == 1:  # Left button
            self.pressed = True
            self.x_prev = event.xdata
            self.y_prev = event.ydata
        
    def on_motion(self, event):
        """Handle mouse motion for panning"""
        if self.pressed and event.xdata and event.ydata:
            dx = event.xdata - self.x_prev
            dy = event.ydata - self.y_prev
            self.x_offset -= dx * 0.5
            self.y_offset -= dy * 0.5
            self.update_display()
            self.x_prev = event.xdata
            self.y_prev = event.ydata
            
    def on_release(self, event):
        """Handle mouse release"""
        self.pressed = False
            
    def reset_view(self):
        """Reset view parameters"""
        self.zoom_level = 1.0
        self.x_offset = 0
        self.y_offset = 0
        self.update_display()
    
    def set_image_data(self, image_data):
        """Set the DICOM image data"""
        self.image_data = image_data
        self.current_display = image_data.copy()
        self.reset_view()
        self.update_display()
    
    def adjust_contrast_brightness(self, contrast, brightness):
        """Adjust contrast and brightness of the image"""
        self.contrast = contrast
        self.brightness = brightness
        self.update_display()
    
    def update_display(self):
        """Update the displayed image with current settings"""
        if self.image_data is None:
            return
        
        # Apply contrast and brightness
        self.current_display = self.image_data * self.contrast + self.brightness
        
        # Clear and redraw
        self.axes.clear()
        
        # Calculate zoom and pan
        if self.zoom_level > 1.0:
            height, width = self.current_display.shape
            # Calculate new dimensions
            new_width = width / self.zoom_level
            new_height = height / self.zoom_level
            
            # Calculate center point considering offsets
            center_x = width / 2 + self.x_offset
            center_y = height / 2 + self.y_offset
            
            # Calculate extents with zoom
            x_min = max(0, center_x - new_width / 2)
            x_max = min(width, center_x + new_width / 2)
            y_min = max(0, center_y - new_height / 2)
            y_max = min(height, center_y + new_height / 2)
            
            # Set limits
            self.axes.set_xlim(x_min, x_max)
            self.axes.set_ylim(y_max, y_min)  # Reversed y-axis for image display
        
        # Display the image
        self.axes.imshow(self.current_display, cmap='gray')
        self.axes.set_axis_off()
        self.fig.tight_layout(pad=0)
        self.draw()


class DicomViewer(QMainWindow):
    def __init__(self):
        super(DicomViewer, self).__init__()
        self.setWindowTitle("PyDICOM Viewer")
        self.setMinimumSize(1000, 700)
        
        # Current DICOM dataset
        self.current_dataset = None
        self.current_filepath = None
        self.recent_files = []
        
        # Create central widget
        self.centralWidget = QWidget()
        self.setCentralWidget(self.centralWidget)
        self.mainLayout = QHBoxLayout(self.centralWidget)
        
        # Create splitter for resizable panels
        self.splitter = QSplitter(Qt.Horizontal)
        self.mainLayout.addWidget(self.splitter)
        
        # Left panel for file browser and metadata
        self.leftPanel = QWidget()
        self.leftLayout = QVBoxLayout(self.leftPanel)
        
        # File browser section
        self.browserGroupBox = QGroupBox("Recent Files")
        self.browserLayout = QVBoxLayout()
        self.fileList = QListWidget()
        self.fileList.itemClicked.connect(self.on_file_selected)
        self.browserLayout.addWidget(self.fileList)
        
        # Open file button
        self.openBtn = QPushButton("Open DICOM File")
        self.openBtn.clicked.connect(self.open_file_dialog)
        self.browserLayout.addWidget(self.openBtn)
        self.browserGroupBox.setLayout(self.browserLayout)
        self.leftLayout.addWidget(self.browserGroupBox)
        
        # Metadata section
        self.metadataGroupBox = QGroupBox("DICOM Metadata")
        self.metadataLayout = QVBoxLayout()
        self.metadataWidget = QWidget()
        self.metadataGridLayout = QGridLayout(self.metadataWidget)
        
        # Add a scroll area for metadata
        self.metadataScrollArea = QScrollArea()
        self.metadataScrollArea.setWidgetResizable(True)
        self.metadataScrollArea.setWidget(self.metadataWidget)
        self.metadataLayout.addWidget(self.metadataScrollArea)
        self.metadataGroupBox.setLayout(self.metadataLayout)
        self.leftLayout.addWidget(self.metadataGroupBox)
        
        # Right panel for image display and controls
        self.rightPanel = QWidget()
        self.rightLayout = QVBoxLayout(self.rightPanel)
        
        # Canvas for image display
        self.canvas = DicomImageCanvas(self.rightPanel, width=5, height=5, dpi=100)
        self.rightLayout.addWidget(self.canvas, 1)
        
        # Controls panel
        self.controlsGroupBox = QGroupBox("Image Controls")
        self.controlsLayout = QGridLayout()
        
        # Contrast slider
        self.contrastLabel = QLabel("Contrast:")
        self.contrastSlider = QSlider(Qt.Horizontal)
        self.contrastSlider.setMinimum(1)
        self.contrastSlider.setMaximum(300)
        self.contrastSlider.setValue(100)
        self.contrastSlider.valueChanged.connect(self.update_contrast_brightness)
        
        # Brightness slider
        self.brightnessLabel = QLabel("Brightness:")
        self.brightnessSlider = QSlider(Qt.Horizontal)
        self.brightnessSlider.setMinimum(-100)
        self.brightnessSlider.setMaximum(100)
        self.brightnessSlider.setValue(0)
        self.brightnessSlider.valueChanged.connect(self.update_contrast_brightness)
        
        # Add controls to layout
        self.controlsLayout.addWidget(self.contrastLabel, 0, 0)
        self.controlsLayout.addWidget(self.contrastSlider, 0, 1)
        self.controlsLayout.addWidget(self.brightnessLabel, 1, 0)
        self.controlsLayout.addWidget(self.brightnessSlider, 1, 1)
        
        # Reset view button
        self.resetViewBtn = QPushButton("Reset View")
        self.resetViewBtn.clicked.connect(self.canvas.reset_view)
        self.controlsLayout.addWidget(self.resetViewBtn, 2, 0, 1, 2)
        
        self.controlsGroupBox.setLayout(self.controlsLayout)
        self.rightLayout.addWidget(self.controlsGroupBox)
        
        # Add panels to splitter
        self.splitter.addWidget(self.leftPanel)
        self.splitter.addWidget(self.rightPanel)
        self.splitter.setSizes([300, 700])  # Initial sizes
        
        # Create menu bar
        self.create_menu_bar()
        
        # Initialize with a placeholder
        self.initialize_empty_view()
    
    def create_menu_bar(self):
        menubar = self.menuBar()
        
        # File menu
        fileMenu = menubar.addMenu('File')
        
        openAction = QAction('Open DICOM File', self)
        openAction.setShortcut('Ctrl+O')
        openAction.triggered.connect(self.open_file_dialog)
        fileMenu.addAction(openAction)
        
        saveAction = QAction('Save Screenshot', self)
        saveAction.setShortcut('Ctrl+S')
        saveAction.triggered.connect(self.save_screenshot)
        fileMenu.addAction(saveAction)
        
        fileMenu.addSeparator()
        
        exitAction = QAction('Exit', self)
        exitAction.setShortcut('Ctrl+Q')
        exitAction.triggered.connect(self.close)
        fileMenu.addAction(exitAction)
        
        # View menu
        viewMenu = menubar.addMenu('View')
        
        resetAction = QAction('Reset View', self)
        resetAction.triggered.connect(self.canvas.reset_view)
        viewMenu.addAction(resetAction)
        
        # Help menu
        helpMenu = menubar.addMenu('Help')
        
        aboutAction = QAction('About', self)
        aboutAction.triggered.connect(self.show_about)
        helpMenu.addAction(aboutAction)
    
    def initialize_empty_view(self):
        """Initialize with an empty view"""
        # Create a placeholder image
        placeholder = np.zeros((512, 512), dtype=np.float32)
        for i in range(512):
            for j in range(512):
                placeholder[i, j] = 0.5 * np.sin(i/30) + 0.5 * np.cos(j/30)
        
        # Set the placeholder to the canvas
        self.canvas.set_image_data(placeholder)
        
        # Add a message to the metadata panel
        self.clear_metadata()
        self.add_metadata_item("Welcome", "Open a DICOM file to begin")
    
    def open_file_dialog(self):
        """Open a file dialog to select a DICOM file"""
        options = QFileDialog.Options()
        filepath, _ = QFileDialog.getOpenFileName(
            self, "Open DICOM File", "", "DICOM Files (*.dcm);;All Files (*)", options=options
        )
        
        if filepath:
            self.load_dicom_file(filepath)
    
    def load_dicom_file(self, filepath):
        """Load a DICOM file and display it"""
        try:
            # Load the DICOM dataset
            self.current_dataset = pydicom.dcmread(filepath)
            self.current_filepath = filepath
            
            # Add to recent files if not already there
            filename = os.path.basename(filepath)
            if filename not in [self.fileList.item(i).text() for i in range(self.fileList.count())]:
                self.fileList.addItem(filename)
                self.recent_files.append(filepath)
            
            # Display the DICOM image
            self.display_dicom_image()
            
            # Show metadata
            self.display_metadata()
            
            # Update window title
            self.setWindowTitle(f"PyDICOM Viewer - {filename}")
            
        except Exception as e:
            self.show_error(f"Error loading DICOM file: {str(e)}")
    
    def display_dicom_image(self):
        """Process and display the DICOM image"""
        if self.current_dataset is None:
            return
        
        try:
            # Get pixel array
            img = self.current_dataset.pixel_array
            
            # Convert to appropriate data type
            if self.current_dataset.BitsStored <= 8:
                img = img.astype(np.uint8)
            else:
                img = img.astype(np.uint16)
            
            # Apply VOI LUT (if available)
            if hasattr(self.current_dataset, 'WindowCenter') and hasattr(self.current_dataset, 'WindowWidth'):
                img = apply_voi_lut(img, self.current_dataset)
            
            # Normalize to 0-1 for display
            img_min = img.min()
            img_max = img.max()
            if img_max != img_min:
                img = (img - img_min) / (img_max - img_min)
            
            # Set the image data to the canvas
            self.canvas.set_image_data(img)
            
            # Reset contrast and brightness sliders
            self.contrastSlider.setValue(100)
            self.brightnessSlider.setValue(0)
            
        except Exception as e:
            self.show_error(f"Error displaying image: {str(e)}")
    
    def display_metadata(self):
        """Display DICOM metadata"""
        if self.current_dataset is None:
            return
        
        # Clear previous metadata
        self.clear_metadata()
        
        # Add key metadata
        self.add_metadata_section("Patient Information")
        if hasattr(self.current_dataset, 'PatientName'):
            self.add_metadata_item("Patient Name", str(self.current_dataset.PatientName))
        if hasattr(self.current_dataset, 'PatientID'):
            self.add_metadata_item("Patient ID", self.current_dataset.PatientID)
        if hasattr(self.current_dataset, 'PatientBirthDate'):
            self.add_metadata_item("Birth Date", self.current_dataset.PatientBirthDate)
        if hasattr(self.current_dataset, 'PatientSex'):
            self.add_metadata_item("Sex", self.current_dataset.PatientSex)
        
        self.add_metadata_section("Study Information")
        if hasattr(self.current_dataset, 'StudyDescription'):
            self.add_metadata_item("Study", self.current_dataset.StudyDescription)
        if hasattr(self.current_dataset, 'StudyDate'):
            self.add_metadata_item("Date", self.current_dataset.StudyDate)
        if hasattr(self.current_dataset, 'StudyTime'):
            self.add_metadata_item("Time", self.current_dataset.StudyTime)
        if hasattr(self.current_dataset, 'Modality'):
            self.add_metadata_item("Modality", self.current_dataset.Modality)
        
        self.add_metadata_section("Image Information")
        if hasattr(self.current_dataset, 'Rows') and hasattr(self.current_dataset, 'Columns'):
            self.add_metadata_item("Dimensions", f"{self.current_dataset.Rows} x {self.current_dataset.Columns}")
        if hasattr(self.current_dataset, 'BitsAllocated'):
            self.add_metadata_item("Bits Allocated", str(self.current_dataset.BitsAllocated))
        if hasattr(self.current_dataset, 'WindowCenter') and hasattr(self.current_dataset, 'WindowWidth'):
            self.add_metadata_item("Window Center", str(self.current_dataset.WindowCenter))
            self.add_metadata_item("Window Width", str(self.current_dataset.WindowWidth))
    
    def clear_metadata(self):
        """Clear all metadata items"""
        # Clear the grid layout
        while self.metadataGridLayout.count():
            item = self.metadataGridLayout.takeAt(0)
            widget = item.widget()
            if widget is not None:
                widget.deleteLater()
        self.row_counter = 0
    
    def add_metadata_section(self, title):
        """Add a section header to metadata"""
        label = QLabel(title)
        font = label.font()
        font.setBold(True)
        label.setFont(font)
        self.metadataGridLayout.addWidget(label, self.metadataGridLayout.rowCount(), 0, 1, 2)
    
    def add_metadata_item(self, key, value):
        """Add a metadata key-value pair"""
        row = self.metadataGridLayout.rowCount()
        self.metadataGridLayout.addWidget(QLabel(key + ":"), row, 0)
        self.metadataGridLayout.addWidget(QLabel(value), row, 1)
    
    def update_contrast_brightness(self):
        """Update the contrast and brightness of the displayed image"""
        contrast = self.contrastSlider.value() / 100.0
        brightness = self.brightnessSlider.value() / 100.0
        self.canvas.adjust_contrast_brightness(contrast, brightness)
    
    def on_file_selected(self, item):
        """Handle file selection from the recent files list"""
        index = self.fileList.row(item)
        if 0 <= index < len(self.recent_files):
            self.load_dicom_file(self.recent_files[index])
    
    def save_screenshot(self):
        """Save a screenshot of the current view"""
        if self.current_dataset is None:
            return
            
        options = QFileDialog.Options()
        filename, _ = QFileDialog.getSaveFileName(
            self, "Save Screenshot", "", "PNG Images (*.png);;JPEG Images (*.jpg *.jpeg)", options=options
        )
        
        if filename:
            self.canvas.fig.savefig(filename, bbox_inches='tight', pad_inches=0)
    
    def show_about(self):
        """Show the about dialog"""
        from PyQt5.QtWidgets import QMessageBox
        QMessageBox.about(self, "About PyDICOM Viewer", 
                         """PyDICOM Viewer v1.0
                         
A DICOM image viewer built with Python, PyDICOM, and PyQt5.

Features:
- Open and view DICOM images
- Adjust contrast and brightness
- Zoom and pan
- View DICOM metadata
- Save screenshots
                         """)
    
    def show_error(self, message):
        """Show an error message"""
        from PyQt5.QtWidgets import QMessageBox
        QMessageBox.critical(self, "Error", message)


if __name__ == "__main__":
    app = QApplication(sys.argv)
    viewer = DicomViewer()
    viewer.show()
    sys.exit(app.exec_())