import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:archive/archive.dart';
import 'dart:io';

class EstudiosGaleriaPage extends StatefulWidget {
  const EstudiosGaleriaPage({Key? key}) : super(key: key);

  @override
  _EstudiosGaleriaPageState createState() => _EstudiosGaleriaPageState();
}

class _EstudiosGaleriaPageState extends State<EstudiosGaleriaPage> {
  List<Estudio> estudios = [];
  List<Estudio> estudiosFiltrados = [];
  String tipoFiltroActual = 'reciente';

  // Definición de la paleta de colores actualizada
  final Color colorPrimario = const Color(0xFF309F49); // Verde principal
  final Color colorSecundario = const Color(0xFFF7EED1); // Crema claro
  final Color colorAcento = const Color(0xFF41AE88); // Verde secundario
  final Color colorTerciario = const Color(0xFFF08254); // Naranja

  @override
  void initState() {
    super.initState();
    cargarEstudios();
  }

  void cargarEstudios() {
    // Aquí se cargarían los estudios desde tu fuente de datos
    // Este es un ejemplo con datos de muestra de estudios médicos
    estudios = [
      Estudio(
        id: '1',
        nombre: 'Radiografía Tórax',
        tipo: 'Radiografía',
        fechaCreacion: DateTime.now().subtract(const Duration(days: 2)),
        miniatura: 'assets/estudio1_miniatura.dcm',
        archivos: [
          ArchivoEstudio(
            nombre: 'xray_frontal.dcm',
            ruta: 'assets/estudio1/xray_frontal.dcm',
            tipo: 'imagen',
          ),
          ArchivoEstudio(
            nombre: 'xray_lateral.dcm',
            ruta: 'assets/estudio1/xray_lateral.dcm',
            tipo: 'imagen',
          ),
        ],
      ),
      Estudio(
        id: '2',
        nombre: 'Ultrasonido Abdomen',
        tipo: 'Ultrasonido',
        fechaCreacion: DateTime.now().subtract(const Duration(days: 5)),
        miniatura: 'assets/estudio2_miniatura.dcm',
        archivos: [
          ArchivoEstudio(
            nombre: 'abdomen.mp4',
            ruta: 'assets/estudio2/abdomen.mp4',
            tipo: 'video',
          ),
          ArchivoEstudio(
            nombre: 'reporte_us.pdf',
            ruta: 'assets/estudio2/reporte_us.dcm',
            tipo: 'documento',
          ),
        ],
      ),
      Estudio(
        id: '3',
        nombre: 'Ecocardiograma',
        tipo: 'Ultrasonido',
        fechaCreacion: DateTime.now().subtract(const Duration(hours: 12)),
        miniatura: 'assets/estudio3_miniatura.dcm',
        archivos: [
          ArchivoEstudio(
            nombre: 'eco_doppler.mp4',
            ruta: 'assets/estudio3/eco_doppler.dcm',
            tipo: 'video',
          ),
          ArchivoEstudio(
            nombre: 'eco_modo_m.jpg',
            ruta: 'assets/estudio3/eco_modo_m.dcm',
            tipo: 'imagen',
          ),
        ],
      ),
      Estudio(
        id: '4',
        nombre: 'Tomografía Cerebral',
        tipo: 'Tomografía',
        fechaCreacion: DateTime.now().subtract(const Duration(days: 1)),
        miniatura: 'assets/estudio4_miniatura.dcm',
        archivos: [
          ArchivoEstudio(
            nombre: 'tac_cerebral.jpg',
            ruta: 'assets/estudio4/tac_cerebral.dcm',
            tipo: 'imagen',
          ),
          ArchivoEstudio(
            nombre: 'tac_series.zip',
            ruta: 'assets/estudio4/tac_series.zip',
            tipo: 'comprimido',
          ),
        ],
      ),
      Estudio(
        id: '5',
        nombre: 'Resonancia Lumbar',
        tipo: 'Resonancia',
        fechaCreacion: DateTime.now().subtract(const Duration(days: 3)),
        miniatura: 'assets/estudio5_miniatura.dcm',
        archivos: [
          ArchivoEstudio(
            nombre: 'rm_sagital.dcm',
            ruta: 'assets/estudio5/rm_sagital.dcm',
            tipo: 'imagen',
          ),
          ArchivoEstudio(
            nombre: 'rm_axial.dcm',
            ruta: 'assets/estudio5/rm_axial.dcm',
            tipo: 'imagen',
          ),
          ArchivoEstudio(
            nombre: 'informe_rm.pdf',
            ruta: 'assets/estudio5/informe_rm.pdf',
            tipo: 'documento',
          ),
        ],
      ),
    ];

    filtrarEstudios('reciente');
  }

  void filtrarEstudios(String tipo) {
    setState(() {
      tipoFiltroActual = tipo;
      if (tipo == 'reciente') {
        estudiosFiltrados = List.from(estudios)
          ..sort((a, b) => b.fechaCreacion.compareTo(a.fechaCreacion));
      } else {
        estudiosFiltrados = estudios
            .where((estudio) => estudio.tipo == tipo)
            .toList()
          ..sort((a, b) => b.fechaCreacion.compareTo(a.fechaCreacion));
      }
    });
  }

  Future<void> compartirEstudioComoZip(Estudio estudio) async {
    try {
      // En una implementación real, aquí se comprimiría el estudio en un ZIP
      // y se compartiría. Este es un ejemplo simulado.
      
      final tempDir = await getTemporaryDirectory();
      final zipPath = '${tempDir.path}/${estudio.nombre}.zip';
      
      // Simulación del proceso de compresión
      await Future.delayed(const Duration(seconds: 1));
      
      // Compartir el archivo (simulado)
      await Share.shareXFiles(
        [XFile(zipPath)],
        text: 'Compartiendo estudio médico: ${estudio.nombre}',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al compartir: $e'),
          backgroundColor: colorAcento,
        ),
      );
    }
  }

  Future<void> guardarEnDispositivo(Estudio estudio) async {
    try {
      // En una implementación real, aquí se guardarían los archivos en el dispositivo
      // Este es un ejemplo simulado para imágenes
      
      for (var archivo in estudio.archivos) {
        if (archivo.tipo == 'imagen') {
          // Simular guardado en la galería
          // Usando gallery_saver (en una app real necesitarías los archivos reales)
          // await GallerySaver.saveImage(archivo.ruta);
        }
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Archivos guardados en la galería'),
          backgroundColor: colorPrimario,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar: $e'),
          backgroundColor: colorAcento,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: colorSecundario,
      body: Column(
        children: [
          // Sección de filtros mejorada
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colorPrimario.withOpacity(0.1),
              border: Border(
                bottom: BorderSide(color: colorPrimario.withOpacity(0.2), width: 1),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.filter_list, color: colorPrimario),
                const SizedBox(width: 12),
                Text(
                  'Filtrar por:',
                  style: TextStyle(
                    color: colorPrimario,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('reciente', 'Recientes'),
                        _buildFilterChip('Radiografía', 'Radiografía'),
                        _buildFilterChip('Ultrasonido', 'Ultrasonido'),
                        _buildFilterChip('Tomografía', 'Tomografía'),
                        _buildFilterChip('Resonancia', 'Resonancia'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Encabezado de sección
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tipoFiltroActual == 'reciente' 
                      ? 'Estudios Recientes' 
                      : 'Estudios de $tipoFiltroActual',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorAcento,
                  ),
                ),
                Text(
                  '${estudiosFiltrados.length} ${estudiosFiltrados.length == 1 ? 'estudio' : 'estudios'}',
                  style: TextStyle(
                    fontSize: 14,
                    color: colorPrimario,
                  ),
                ),
              ],
            ),
          ),
          
          // Grid de estudios mejorado
          Expanded(
            child: estudiosFiltrados.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.medical_services_outlined,
                          size: 72,
                          color: colorPrimario.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay estudios disponibles',
                          style: TextStyle(
                            fontSize: 16,
                            color: colorPrimario,
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.85,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: estudiosFiltrados.length,
                      itemBuilder: (context, index) {
                        final estudio = estudiosFiltrados[index];
                        
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetalleCarpetaPage(
                                  estudio: estudio,
                                  colorPrimario: colorPrimario,
                                  colorSecundario: colorSecundario,
                                  colorAcento: colorAcento,
                                  colorTerciario: colorTerciario,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: colorPrimario.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Miniatura con color según tipo de estudio
                                Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: _getColorForEstudio(estudio.tipo),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      _getIconForEstudio(estudio.tipo),
                                      size: 48,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                
                                // Detalles del estudio
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        estudio.nombre,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: colorPrimario,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        estudio.tipo,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: colorAcento,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today,
                                            size: 12,
                                            color: Colors.grey[600],
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            _formatDate(estudio.fechaCreacion),
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorTerciario,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          // Acción para agregar nuevo estudio
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Función para agregar nuevo estudio'),
              backgroundColor: colorPrimario,
            ),
          );
        },
      ),
    );
  }
  
  Color _getColorForEstudio(String tipo) {
    switch (tipo) {
      case 'Radiografía':
        return colorPrimario;
      case 'Ultrasonido':
        return colorAcento;
      case 'Tomografía':
        return colorTerciario;
      case 'Resonancia':
        return const Color(0xFF2C8E40); // Verde más oscuro
      default:
        return colorPrimario;
    }
  }
  
  IconData _getIconForEstudio(String tipo) {
    switch (tipo) {
      case 'Radiografía':
        return Icons.broken_image_outlined;
      case 'Ultrasonido':
        return Icons.waves;
      case 'Tomografía':
        return Icons.view_in_ar;
      case 'Resonancia':
        return Icons.scanner;
      default:
        return Icons.folder_open;
    }
  }
  
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
  
  Widget _buildFilterChip(String value, String label) {
    final isSelected = tipoFiltroActual == value;
    
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: InkWell(
        onTap: () => filtrarEstudios(value),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? colorPrimario : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? colorPrimario : colorPrimario.withOpacity(0.5),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : colorPrimario,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

class DetalleCarpetaPage extends StatelessWidget {
  final Estudio estudio;
  final Color colorPrimario;
  final Color colorSecundario;
  final Color colorAcento;
  final Color colorTerciario;
  
  const DetalleCarpetaPage({
    Key? key, 
    required this.estudio,
    required this.colorPrimario,
    required this.colorSecundario,
    required this.colorAcento,
    required this.colorTerciario,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorSecundario,
      appBar: AppBar(
        title: Text(
          estudio.nombre,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colorPrimario,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              _compartirEstudioComoZip(context, estudio);
            },
          ),
          IconButton(
            icon: const Icon(Icons.save_alt),
            onPressed: () {
              _guardarEnDispositivo(context, estudio);
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado con información del estudio
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorPrimario.withOpacity(0.1),
              border: Border(
                bottom: BorderSide(
                  color: colorPrimario.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _getColorForEstudio(estudio.tipo),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getIconForEstudio(estudio.tipo),
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          estudio.tipo,
                          style: TextStyle(
                            fontSize: 16,
                            color: colorAcento,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Fecha: ${_formatDate(estudio.fechaCreacion)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Archivos (${estudio.archivos.length})',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorPrimario,
                  ),
                ),
              ],
            ),
          ),
          
          // Lista de archivos
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: estudio.archivos.length,
                itemBuilder: (context, index) {
                  final archivo = estudio.archivos[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: colorPrimario.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _getColorForArchivo(archivo.tipo).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getIconForArchivo(archivo.tipo),
                          color: _getColorForArchivo(archivo.tipo),
                          size: 28,
                        ),
                      ),
                      title: Text(
                        archivo.nombre,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorPrimario,
                        ),
                      ),
                      subtitle: Text(
                        _getFormatoArchivo(archivo.nombre),
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.visibility,
                              color: colorAcento,
                            ),
                            onPressed: () {
                              // Ver archivo
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Visualizando: ${archivo.nombre}'),
                                  backgroundColor: colorPrimario,
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.download,
                              color: colorTerciario,
                            ),
                            onPressed: () {
                              // Descargar archivo
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Descargando: ${archivo.nombre}'),
                                  backgroundColor: colorPrimario,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colorPrimario,
        onPressed: () {
          _compartirEstudioComoZip(context, estudio);
        },
        icon: const Icon(Icons.share),
        label: const Text('Compartir estudio'),
      ),
    );
  }
  
  Color _getColorForEstudio(String tipo) {
    switch (tipo) {
      case 'Radiografía':
        return colorPrimario;
      case 'Ultrasonido':
        return colorAcento;
      case 'Tomografía':
        return colorTerciario;
      case 'Resonancia':
        return const Color(0xFF2C8E40); // Verde más oscuro
      default:
        return colorPrimario;
    }
  }
  
  Color _getColorForArchivo(String tipo) {
    switch (tipo) {
      case 'imagen':
        return colorPrimario;
      case 'video':
        return colorAcento;
      case 'documento':
        return colorTerciario;
      case 'comprimido':
        return const Color(0xFF2C8E40);
      case 'audio':
        return const Color(0xFF777777);
      default:
        return Colors.grey;
    }
  }
  
  IconData _getIconForEstudio(String tipo) {
    switch (tipo) {
      case 'Radiografía':
        return Icons.broken_image_outlined;
      case 'Ultrasonido':
        return Icons.waves;
      case 'Tomografía':
        return Icons.view_in_ar;
      case 'Resonancia':
        return Icons.scanner;
      default:
        return Icons.folder_open;
    }
  }
  
  IconData _getIconForArchivo(String tipo) {
    switch (tipo) {
      case 'imagen':
        return Icons.image;
      case 'video':
        return Icons.videocam;
      case 'audio':
        return Icons.audiotrack;
      case 'documento':
        return Icons.description;
      case 'comprimido':
        return Icons.folder_zip_outlined;
      default:
        return Icons.insert_drive_file;
    }
  }
  
  String _getFormatoArchivo(String nombre) {
    if (nombre.endsWith('.DCM') || nombre.endsWith('.DCM')) {
      return 'Imagen JPEG';
    } else if (nombre.endsWith('.DCM')) {
      return 'Imagen PNG';
    } else if (nombre.endsWith('.mp4')) {
      return 'Video MP4';
    } else if (nombre.endsWith('.mp3')) {
      return 'Audio MP3';
    } else if (nombre.endsWith('.pdf')) {
      return 'Documento PDF';
    } else if (nombre.endsWith('.zip')) {
      return 'Archivo comprimido';
    } else {
      return 'Archivo';
    }
  }
  
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
  
  Future<void> _compartirEstudioComoZip(BuildContext context, Estudio estudio) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Preparando archivo ZIP para compartir...'),
          backgroundColor: colorPrimario,
        ),
      );
      
      // En una implementación real, aquí se comprimiría el estudio en un ZIP
      // y se compartiría. Este es un ejemplo simulado.
      await Future.delayed(const Duration(seconds: 1));
      
      // Simulación del proceso de compresión y compartir
      await Share.share('Compartiendo estudio: ${estudio.nombre}');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Estudio compartido exitosamente'),
          backgroundColor: colorPrimario,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al compartir: $e'),
          backgroundColor: colorTerciario,
        ),
      );
    }
  }

  Future<void> _guardarEnDispositivo(BuildContext context, Estudio estudio) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Guardando archivos en el dispositivo...'),
          backgroundColor: colorPrimario,
        ),
      );
      
      // En una implementación real, aquí se guardarían los archivos en el dispositivo
      await Future.delayed(const Duration(seconds: 1));
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Archivos guardados exitosamente'),
          backgroundColor: colorPrimario,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar: $e'),
          backgroundColor: colorTerciario,
        ),
      );
    }
  }
}

// Modelos de datos
class Estudio {
  final String id;
  final String nombre;
  final String tipo;
  final DateTime fechaCreacion;
  final String miniatura;
  final List<ArchivoEstudio> archivos;

  Estudio({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.fechaCreacion,
    required this.miniatura,
    required this.archivos,
  });
}

class ArchivoEstudio {
  final String nombre;
  final String ruta;
  final String tipo; // 'imagen', 'video', 'audio', 'documento', etc.

  ArchivoEstudio({
    required this.nombre,
    required this.ruta,
    required this.tipo,
  });
}