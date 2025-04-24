import pydicom
import numpy as np

def load_dicom_image(file_path):
    """Carga un archivo DICOM y devuelve la imagen + metadatos."""
    try:
        ds = pydicom.dcmread(file_path)
        image = ds.pixel_array

        # Normalizar la imagen para visualización
        image = (image - np.min(image)) / (np.max(image) - np.min(image)) * 255
        image = image.astype(np.uint8)

        # Extraer metadatos relevantes
        info_text = (
            f"Paciente: {getattr(ds, 'PatientName', 'N/A')}\n"
            f"Estudio: {getattr(ds, 'StudyDescription', 'N/A')}\n"
            f"Modalidad: {getattr(ds, 'Modality', 'N/A')}"
        )

        return image, info_text

    except Exception as e:
        print(f"Error al cargar DICOM: {e}")
        return None, f"Error: {str(e)}"