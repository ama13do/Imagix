import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/scheduler.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:imagix/screens/EstudiosGaleriaPage.dart';
import 'package:imagix/screens/MapaEstudioPage.dart';
import 'package:imagix/screens/MedicalStudiesScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppThemeProvider()),
        ChangeNotifierProvider(create: (context) => ImageProvider()),
      ],
      child: MyApp(),
    ),
  );
}

// Provider para gestionar imágenes
class ImageProvider extends ChangeNotifier {
  List<ImageItem> _imagesList = [];
  
  List<ImageItem> get imagesList => _imagesList;
  
  void loadImagesFromDirectory() async {
    // Aquí cargaremos las imágenes reales en lugar de generar ejemplos
    
    // Para probar con imágenes estáticas (reemplaza con tus nombres de archivo reales)
    final imageNames = [
    'IMG-20250423-WA0381.jpg',
    'IMG-20250423-WA0382.jpg',
    'IMG-20250423-WA0378.jpg',
    'IMG-20250423-WA0379.jpg',
    'IMG-20250423-WA0380.jpg',
    'IMG-20250423-WA0374.jpg',
    'IMG-20250423-WA0375.jpg',
    'IMG-20250423-WA0376.jpg',
    'IMG-20250423-WA0377.jpg',
    'IMG-20250423-WA0371.jpg',
    'IMG-20250423-WA0372.jpg',
    'IMG-20250423-WA0373.jpg',
    'IMG-20250423-WA0370.jpg',
    // Puedes seguir añadiendo más nombres de archivo si lo necesitas
];
    
    _imagesList = imageNames.asMap().entries.map((entry) {
      int index = entry.key;
      String imageName = entry.value;
      
      return ImageItem(
        id: 'img_$index',
        name: 'Imagen ${index + 1}',
        path: 'images/$imageName',
        date: DateTime.now().subtract(Duration(days: index)),
      );
    }).toList();
    
    notifyListeners();
  }
}

class ImageItem {
  final String id;
  final String name;
  final String path;
  final DateTime date;
  
  ImageItem({
    required this.id,
    required this.name,
    required this.path,
    required this.date,
  });
}

class AppThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _highContrast = false;
  double _fontSize = 1.0;
  String _language = 'es';

  ThemeMode get themeMode => _themeMode;
  bool get highContrast => _highContrast;
  double get fontSize => _fontSize;
  String get language => _language;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void toggleHighContrast() {
    _highContrast = !_highContrast;
    notifyListeners();
  }

  void setFontSize(double size) {
    _fontSize = size;
    notifyListeners();
  }

  void setLanguage(String lang) {
    _language = lang;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<AppThemeProvider>(context);

    // Nueva paleta de colores más sobria y profesional
    const Color primaryColor = Color(0xFF309F49);       // Verde principal
const Color secondaryColor = Color(0xFFF7EED1);     // Crema claro
const Color accentColor = Color(0xFF41AE88);        // Verde secundario
const Color tertiaryColor = Color(0xFFF08254);      // Naranja
const Color highlightColor = Color(0xFFFBC213);

// Tema claro
final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    primary: primaryColor,
    onPrimary: Colors.white,
    secondary: accentColor,
    onSecondary: Colors.white,
    tertiary: tertiaryColor,
    surface: Color(0xFFF7F5EF),  // Versión más clara del crema para fondos
    background: Colors.white,
  ),
  scaffoldBackgroundColor: Color(0xFFF7F5EF),
  appBarTheme: AppBarTheme(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
  ),
  textTheme: TextTheme(
    bodyMedium: TextStyle(
      fontSize: 14 * themeProvider.fontSize,
      color: Colors.black87,
    ),
    titleMedium: TextStyle(
      fontSize: 16 * themeProvider.fontSize,
      color: Colors.black87,
    ),
    titleLarge: TextStyle(
      fontSize: 20 * themeProvider.fontSize,
      color: Colors.black87,
    ),
  ),
);

// Tema oscuro
final darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    primary: primaryColor,
    onPrimary: Colors.white,
    secondary: accentColor,
    onSecondary: Colors.white,
    tertiary: tertiaryColor,
    surface: Color(0xFF235736),  // Versión más oscura del verde principal
    background: Color(0xFF1A402A),  // Versión muy oscura del verde principal
  ),
  scaffoldBackgroundColor: Color(0xFF1A402A),
  appBarTheme: AppBarTheme(
    backgroundColor: accentColor,
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
  ),
  textTheme: TextTheme(
    bodyMedium: TextStyle(
      fontSize: 14 * themeProvider.fontSize,
      color: Colors.white,
    ),
    titleMedium: TextStyle(
      fontSize: 16 * themeProvider.fontSize,
      color: Colors.white,
    ),
    titleLarge: TextStyle(
      fontSize: 20 * themeProvider.fontSize,
      color: Colors.white,
    ),
  ),
);

    return MaterialApp(
      title: 'DICOM Viewer',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es'),
        const Locale('en'),
      ],
      locale: Locale(themeProvider.language),
      home: MainLayout(),
    );
  }
}

// Layout principal para mantener sidebar y navbar en todas las páginas
class MainLayout extends StatefulWidget {
  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Páginas disponibles en la aplicación
  final List<Widget> _pages = [
    DicomViewerPage(),
    EstudiosGaleriaPage(),
    MapaEstudiosPage(),
    MedicalStudiesScreen(),
 
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

 @override
Widget build(BuildContext context) {
  final themeProvider = Provider.of<AppThemeProvider>(context);
  final theme = Theme.of(context);

  return Scaffold(
    key: _scaffoldKey,
    drawer: _buildSidebar(context),
    appBar: AppBar(
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          _scaffoldKey.currentState!.openDrawer();
        },
      ),
      title: Row(
        children: [
          Expanded(
            child: _selectedIndex == 0
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Rodriguez García, Juan",
                        style: TextStyle(
                          fontSize: 16 * themeProvider.fontSize,
                        ),
                      ),
                      Text(
                        "22/04/2025",
                        style: TextStyle(
                          fontSize: 12 * themeProvider.fontSize,
                          color: theme.colorScheme.onPrimary.withOpacity(0.7),
                        ),
                      ),
                    ],
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
      actions: [
        if (_selectedIndex == 0)
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              _shareImage(context);
            },
          ),
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
          },
        ),
      ],
    ),
    body: _pages[_selectedIndex],
    bottomNavigationBar: _buildBottomNavBar(),
  );
}


  Widget _buildSidebar(BuildContext context) {
    final themeProvider = Provider.of<AppThemeProvider>(context);
    final theme = Theme.of(context);

    return Drawer(
      child: Container(
        color: theme.colorScheme.surface,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiary,
              ),
              accountName: Text("Dr. Ana Martínez"),
              accountEmail: Text("ana.martinez@saluddigna.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  "AM",
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            _buildDrawerItem(Icons.home, "Inicio", onTap: () {
              Navigator.pop(context);
              _onItemTapped(0);
            }),
            _buildDrawerItem(Icons.folder, "Archivos", onTap: () {
              Navigator.pop(context);
              _onItemTapped(1);
            }),
            _buildDrawerItem(Icons.location_on, "Ubicaciones", onTap: () {
              Navigator.pop(context);
              
              _onItemTapped(2);
            }),
            _buildDrawerItem(Icons.document_scanner_rounded, "Lista de estudios",onTap: () {
              Navigator.pop(context);
              
              _onItemTapped(3);
            }),
          
            Expanded(child: SizedBox()),
            Divider(color: theme.dividerColor),
            _buildDrawerItem(Icons.settings, "Configuración", onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            }),
            _buildDrawerItem(Icons.info, "Acerca de"),
            _buildDrawerItem(Icons.help, "Soporte"),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "SALUD",
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16 * themeProvider.fontSize,
                    ),
                  ),
                  Text(
                    "DIGNA",
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      fontWeight: FontWeight.bold,
                      fontSize: 16 * themeProvider.fontSize,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, {VoidCallback? onTap}) {
    final themeProvider = Provider.of<AppThemeProvider>(context);
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(
        title,
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: 14 * themeProvider.fontSize,
        ),
      ),
      onTap: onTap ?? () {
        Navigator.pop(context);
      },
    );
  }

  Widget _buildBottomNavBar() {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<AppThemeProvider>(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.preview),
            
            label: "Visualizador",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: "Archivos",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: "Ubicaciones",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.transcribe),
            label: "Informacion",
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: theme.colorScheme.onSurface,
        unselectedItemColor: theme.colorScheme.onSurface,
        onTap: _onItemTapped,
        backgroundColor: theme.colorScheme.primary,
        selectedFontSize: 12 * themeProvider.fontSize,
        unselectedFontSize: 12 * themeProvider.fontSize,
      ),
    );
  }

  void _shareImage(BuildContext context) {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Compartir imagen'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildShareOption(context, 'Compartir DICOM', Icons.file_present),
              _buildShareOption(context, 'Compartir JPG', Icons.image),
              _buildShareOption(context, 'Compartir PNG', Icons.image_outlined),
              _buildShareOption(context, 'Compartir PDF', Icons.picture_as_pdf),
              _buildShareOption(context, 'Compartir RAW', Icons.raw_on),
              _buildShareOption(context, 'Compartir TIFF', Icons.image_search),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

 Widget _buildShareOption(BuildContext context, String title, IconData icon, {String? content, String? subject}) {
  final theme = Theme.of(context);
  
  return ListTile(
    leading: Icon(icon, color: theme.colorScheme.primary),
    title: Text(title),
    onTap: () {
      Navigator.pop(context);
      
      // Usar el paquete share_plus para compartir contenido
      Share.share(
        content ?? 'Contenido para compartir', 
        subject: subject ?? 'Compartido desde mi aplicación'
      );
    },
  );
}
}

// Página principal del visualizador DICOM
class DicomViewerPage extends StatefulWidget {
  @override
  _DicomViewerPageState createState() => _DicomViewerPageState();
}

class _DicomViewerPageState extends State<DicomViewerPage> {
  XFile? _selectedImageFile;
  Uint8List? _webImage;
  double _zoomLevel = 1.0;
  double _brightness = 0;
  double _contrast = 1;

  @override
  void initState() {
    super.initState();
    // Cargar imágenes de ejemplo DESPUÉS de la construcción inicial
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final imageProvider = Provider.of<ImageProvider>(context, listen: false);
      imageProvider.loadImagesFromDirectory();
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImageFile = image;

        // Para plataforma web
        if (kIsWeb) {
          image.readAsBytes().then((value) {
            setState(() {
              _webImage = value;
            });
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildToolbar(),
        Expanded(
          child: _buildImageViewer(),
        ),
        _buildImageCarousel(),
      ],
    );
  }

  Widget _buildToolbar() {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<AppThemeProvider>(context);
    
    // Organizamos las herramientas por categorías
    final List<ToolCategory> toolCategories = [
      ToolCategory(
        "Archivo",
        [
          ToolItem(Icons.file_open, "Abrir", _pickImage),
          ToolItem(Icons.download, "Descargar", _showNotImplemented),
          ToolItem(Icons.upload, "Exportar", _showNotImplemented),
          ToolItem(Icons.print, "Imprimir", _showNotImplemented),
        ],
      ),
      ToolCategory(
        "Visualización",
        [
          ToolItem(Icons.zoom_in, "Zoom", () => _showZoomControls()),
          ToolItem(Icons.brightness_6, "Brillo/Contraste", () => _showBrightnessContrastControls()),
          ToolItem(Icons.crop, "Recortar", _showNotImplemented),
          ToolItem(Icons.flip, "Voltear", _showNotImplemented),
          ToolItem(Icons.rotate_right, "Rotar", _showNotImplemented),
        ],
      ),
      ToolCategory(
        "Análisis",
        [
          ToolItem(Icons.straighten, "Medir", _showNotImplemented),
          ToolItem(Icons.format_paint, "Anotar", _showNotImplemented),
          ToolItem(Icons.text_fields, "Texto", _showNotImplemented),
          ToolItem(Icons.grid_on, "Cuadrícula", _showNotImplemented),
        ],
      ),
      ToolCategory(
        "Avanzado",
        [
          ToolItem(Icons.view_agenda, "División", _showNotImplemented),
          ToolItem(Icons.animation, "Animación", _showNotImplemented),
          ToolItem(Icons.view_in_ar, "Volumen 3D", _showNotImplemented),
          ToolItem(Icons.compare, "Fusión", _showNotImplemented),
          ToolItem(Icons.remove, "Sustracción", _showNotImplemented),
        ],
      ),
    ];

    return Container(
  height: 90,
  color: theme.colorScheme.surface,
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: toolCategories.length,
    itemBuilder: (context, categoryIndex) {
      final category = toolCategories[categoryIndex];
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 4), // Eliminar o reducir el padding vertical
        child: Card(
          elevation: 4,
          color: theme.colorScheme.surface,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8), // Reducir o eliminar el padding vertical
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 10 * themeProvider.fontSize,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: category.tools.map((tool) {
                    return _buildToolbarItem(tool.icon, tool.name, tool.onTap);
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      );
    },
  ),
);
  }

  void _showNotImplemented() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Función en desarrollo')),
    );
  }

  Widget _buildToolbarItem(IconData icon, String label, VoidCallback? onTap) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<AppThemeProvider>(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(icon, color: theme.colorScheme.primary),
            onPressed: onTap,
            tooltip: label,
            constraints: BoxConstraints(minWidth: 40, minHeight: 40),
            iconSize: 20,
            padding: EdgeInsets.zero,
          ),
          Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 10 * themeProvider.fontSize,
            ),
          ),
        ],
      ),
    );
  }

  void _showZoomControls() {
    final theme = Theme.of(context);
    
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Nivel de zoom: ${(_zoomLevel * 100).toInt()}%',
                  style: theme.textTheme.titleMedium,
                ),
                Slider(
                  value: _zoomLevel,
                  min: 0.5,
                  max: 3.0,
                  divisions: 25,
                  activeColor: theme.colorScheme.primary,
                  onChanged: (value) {
                    setState(() {
                      _zoomLevel = value;
                    });
                    this.setState(() {});
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      child: Text('-'),
                      onPressed: () {
                        setState(() {
                          _zoomLevel = (_zoomLevel - 0.1).clamp(0.5, 3.0);
                        });
                        this.setState(() {});
                      },
                    ),
                    ElevatedButton(
                      child: Text('Restablecer'),
                      onPressed: () {
                        setState(() {
                          _zoomLevel = 1.0;
                        });
                        this.setState(() {});
                      },
                    ),
                    ElevatedButton(
                      child: Text('+'),
                      onPressed: () {
                        setState(() {
                          _zoomLevel = (_zoomLevel + 0.1).clamp(0.5, 3.0);
                        });
                        this.setState(() {});
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        });
      },
    );
  }

  void _showBrightnessContrastControls() {
    final theme = Theme.of(context);
    
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Brillo: ${_brightness.toStringAsFixed(2)}',
                  style: theme.textTheme.titleMedium,
                ),
                Slider(
                  value: _brightness,
                  min: -1.0,
                  max: 1.0,
                  activeColor: theme.colorScheme.primary,
                  onChanged: (value) {
                    setState(() {
                      _brightness = value;
                    });
                    this.setState(() {});
                  },
                ),
                Text(
                  'Contraste: ${_contrast.toStringAsFixed(2)}',
                  style: theme.textTheme.titleMedium,
                ),
                Slider(
                  value: _contrast,
                  min: 0.5,
                  max: 2.0,
                  activeColor: theme.colorScheme.primary,
                  onChanged: (value) {
                    setState(() {
                      _contrast = value;
                    });
                    this.setState(() {});
                  },
                ),
                ElevatedButton(
                  child: Text('Restablecer'),
                  onPressed: () {
                    setState(() {
                      _brightness = 0;
                      _contrast = 1;
                    });
                    this.setState(() {});
                  },
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildImageViewer() {
    final theme = Theme.of(context);
    
    return Container(
      color: theme.brightness == Brightness.light 
          ? Color(0xFFEEEEEE) 
          : Color(0xFF212121),
      child: Center(
        child: _hasImage()
            ? InteractiveViewer(
                minScale: 0.5,
                maxScale: 3.0,
                boundaryMargin: EdgeInsets.all(20),
                child: Transform.scale(
                  scale: _zoomLevel,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.matrix([
                      _contrast, 0, 0, 0, _brightness * 255,
                      0, _contrast, 0, 0, _brightness * 255,
                      0, 0, _contrast, 0, _brightness * 255,
                      0, 0, 0, 1, 0,
                    ]),
                    child: _getImageWidget(),
                  ),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image, 
                    size: 80, 
                    color: theme.colorScheme.onSurface.withOpacity(0.4)
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: Icon(Icons.file_open),
                    label: Text('Seleccionar imagen'),
                    onPressed: _pickImage,
                  ),
                ],
              ),
      ),
    );
  }

  bool _hasImage() {
    if (kIsWeb) {
      return _webImage != null;
    } else {
      return _selectedImageFile != null;
    }
  }

  Widget _getImageWidget() {
    if (kIsWeb) {
      return _webImage != null ? Image.memory(_webImage!) : Container();
    } else {
      return _selectedImageFile != null
          ? Image.file(File(_selectedImageFile!.path))
          : Container();
    }
  }

 Widget _buildImageCarousel() {
  final theme = Theme.of(context);
  final imageProvider = Provider.of<ImageProvider>(context);
  
  return Container(
    height: 100,
    color: theme.colorScheme.surface, // Usando un color más sobrio para el fondo
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16, top: 4),
          child: Text(
            "Imágenes recientes",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: imageProvider.imagesList.length,
            itemBuilder: (context, index) {
              final image = imageProvider.imagesList[index];
              return GestureDetector(
                onTap: () {
                  // Aquí puedes implementar la carga de la imagen seleccionada
                  setState(() {
                    // En una implementación real, cargarías la imagen en el visor
                    // Por ejemplo, podrías cargar la imagen como:
                    // _selectedImagePath = image.path;
                  });
                  
                },
                child: Container(
                  width: 80,
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                          child: Image.asset(
                            image.path,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            // Si la imagen no carga, muestra un icono como fallback
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.image,
                                color: theme.colorScheme.primary,
                                size: 28,
                              );
                            },
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(8),
                          ),
                        ),
                        child: Text(
                          image.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: theme.colorScheme.onPrimary,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
} 
}


class PlaceholderPage extends StatelessWidget {
  final String title;
  
  const PlaceholderPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 80,
              color: theme.colorScheme.primary.withOpacity(0.7),
            ),
            SizedBox(height: 16),
            Text(
              "Página de $title",
              style: theme.textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            Text(
              "Esta sección está en desarrollo",
              style: theme.textTheme.bodyMedium,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Funcionalidad en desarrollo")),
                );
              },
              child: Text("Volver al visualizador"),
            ),
          ],
        ),
      ),
    );
  }
}

// Implementación mejorada de la página de configuración
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<AppThemeProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        children: [
          _buildSectionHeader(context, 'Apariencia'),
          _buildSettingCard(
            context,
            child: Column(
              children: [
                SwitchListTile(
                  title: Text('Tema oscuro'),
                  subtitle: Text('Activar modo oscuro para reducir fatiga visual'),
                  value: themeProvider.themeMode == ThemeMode.dark,
                  onChanged: (value) {
                    themeProvider.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                  },
                  secondary: Icon(
                    themeProvider.themeMode == ThemeMode.dark
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: theme.colorScheme.primary,
                  ),
                ),
                SwitchListTile(
                  title: Text('Alto contraste'),
                  subtitle: Text('Aumentar contraste para mejor accesibilidad'),
                  value: themeProvider.highContrast,
                  onChanged: (value) {
                    themeProvider.toggleHighContrast();
                  },
                  secondary: Icon(
                    Icons.contrast,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          
          _buildSectionHeader(context, 'Texto'),
          _buildSettingCard(
            context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text('Tamaño de fuente'),
                  subtitle: Text('Ajustar el tamaño del texto en la aplicación'),
                  leading: Icon(
                    Icons.format_size,
                    color: theme.colorScheme.primary,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Text('A', style: TextStyle(fontSize: 14)),
                      Expanded(
                        child: Slider(
                          value: themeProvider.fontSize,
                          min: 0.8,
                          max: 1.4,
                          divisions: 3,
                          label: _getFontSizeLabel(themeProvider.fontSize),
                          activeColor: theme.colorScheme.primary,
                          onChanged: (value) {
                            themeProvider.setFontSize(value);
                          },
                        ),
                      ),
                      Text('A', style: TextStyle(fontSize: 22)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          _buildSectionHeader(context, 'Idioma'),
          _buildSettingCard(
            context,
            child: Column(
              children: [
                ListTile(
                  title: Text('Seleccionar idioma'),
                  subtitle: Text('Cambiar el idioma de la aplicación'),
                  leading: Icon(
                    Icons.language,
                    color: theme.colorScheme.primary,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    children: [
                      _buildLanguageOption('es', 'Español', themeProvider),
                      SizedBox(height: 8),
                      _buildLanguageOption('en', 'English', themeProvider),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          _buildSectionHeader(context, 'Visualización DICOM'),
          _buildSettingCard(
            context,
            child: Column(
              children: [
                ListTile(
                  title: Text('Calidad de imagen'),
                  subtitle: Text('Alta (consume más recursos)'),
                  leading: Icon(
                    Icons.high_quality,
                    color: theme.colorScheme.primary,
                  ),
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {
                      // Implementación pendiente
                    },
                  ),
                ),
                ListTile(
                  title: Text('Prefetch de imágenes'),
                  subtitle: Text('Precarga imágenes para navegación más rápida'),
                  leading: Icon(
                    Icons.download,
                    color: theme.colorScheme.primary,
                  ),
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {
                      // Implementación pendiente
                    },
                  ),
                ),
                ListTile(
                  title: Text('Mostrar metadatos'),
                  subtitle: Text('Visualizar información DICOM completa'),
                  leading: Icon(
                    Icons.info_outline,
                    color: theme.colorScheme.primary,
                  ),
                  trailing: Switch(
                    value: false,
                    onChanged: (value) {
                      // Implementación pendiente
                    },
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 32),
          Center(
            child: TextButton(
              onPressed: () {
                // Restablecer configuración predeterminada
                themeProvider.setThemeMode(ThemeMode.light);
                themeProvider.setFontSize(1.0);
                themeProvider.setLanguage('es');
                if (themeProvider.highContrast) {
                  themeProvider.toggleHighContrast();
                }
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Configuración restablecida')),
                );
              },
              child: Text('Restablecer configuración predeterminada'),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildSettingCard(BuildContext context, {required Widget child}) {
    final theme = Theme.of(context);
    
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 1,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  Widget _buildLanguageOption(String code, String name, AppThemeProvider provider) {
    return InkWell(
      onTap: () {
        provider.setLanguage(code);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: provider.language == code 
              ? provider.themeMode == ThemeMode.dark 
                  ? Colors.blueGrey.shade700 
                  : Colors.blue.shade50
              : Colors.transparent,
        ),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Text(
              code == 'es' ? '🇪🇸' : '🇺🇸',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(width: 16),
            Expanded(child: Text(name)),
            if (provider.language == code)
              Icon(Icons.check, color: Colors.blue),
          ],
        ),
      ),
    );
  }

  String _getFontSizeLabel(double size) {
    if (size <= 0.8) return 'Pequeño';
    if (size <= 1.0) return 'Normal';
    if (size <= 1.2) return 'Grande';
    return 'Muy grande';
  }
}

// Clases auxiliares para las herramientas
class ToolCategory {
  final String name;
  final List<ToolItem> tools;
  
  ToolCategory(this.name, this.tools);
}

class ToolItem {
  final IconData icon;
  final String name;
  final VoidCallback onTap;
  
  ToolItem(this.icon, this.name, this.onTap);
}