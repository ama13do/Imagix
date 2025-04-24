import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapaEstudiosPage extends StatefulWidget {
  const MapaEstudiosPage({Key? key}) : super(key: key);

  @override
  _MapaEstudiosPageState createState() => _MapaEstudiosPageState();
}

class _MapaEstudiosPageState extends State<MapaEstudiosPage> {
  GoogleMapController? _mapController;
  String _selectedEstudio = 'Todos';
  final List<String> _tiposEstudio = [
    'Todos',
    'Radiografía',
    'Ultrasonido',
    'Tomografía',
    'Resonancia Magnética',
  ];

  // Paleta de colores actualizada
  final Color _primaryColor = const Color(0xFF309F49); // Verde principal
  final Color _backgroundColor = const Color(0xFFF7EED1); // Crema claro
  final Color _secondaryColor = const Color(0xFF41AE88); // Verde secundario
  final Color _accentColor = const Color(0xFFFBC213); // Amarillo
  final Color _tertiaryColor = const Color(0xFFF08254); // Naranja

  // Posición inicial del mapa
  final CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(20.672941, -103.354776), 
    zoom: 12.0,
  );

  // Definir los marcadores para cada tipo de estudio
  final Map<String, List<Marker>> _marcadoresPorEstudio = {
    'Radiografía': [],
    'Ultrasonido': [],
    'Tomografía': [],
    'Resonancia Magnética': [],
  };

  // Iconos personalizados (usaremos diferentes colores para cada tipo)
  late BitmapDescriptor iconRadiografia;
  late BitmapDescriptor iconUltrasonido;
  late BitmapDescriptor iconTomografia;
  late BitmapDescriptor iconResonancia;

  Set<Marker> _marcadoresActuales = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarIconos().then((_) {
      _inicializarMarcadores();
      _actualizarMarcadores(_selectedEstudio);
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _cargarIconos() async {
    // Usamos los colores de la paleta para los marcadores
    iconRadiografia = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    iconUltrasonido = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
    iconTomografia = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
    iconResonancia = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
  }

  void _inicializarMarcadores() {
    // Radiografía
    _marcadoresPorEstudio['Radiografía'] = [
  Marker(
    markerId: const MarkerId('densitometria_1'),
    position: const LatLng(20.679783550167063, -103.37349804199599),
    infoWindow: const InfoWindow(
      title: 'Salud Digna Clínica Guadalajara Américas',
      snippet: 'Ofrece servicio de densitometría',
    ),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
  ),
  Marker(
    markerId: const MarkerId('densitometria_2'),
    position: const LatLng(20.69438341294884, -103.32360271769465),
    infoWindow: const InfoWindow(
      title: 'Clínica Salud Digna Circunvalación',
      snippet: 'Ofrece servicio de densitometría',
    ),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
  ),
  Marker(
    markerId: const MarkerId('densitometria_3'),
    position: const LatLng(20.673493720551747, -103.33282720420425),
    infoWindow: const InfoWindow(
      title: 'Salud Digna Clínica Guadalajara San Juan',
      snippet: 'Ofrece servicio de densitometría',
    ),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
  ),
  Marker(
    markerId: const MarkerId('densitometria_4'),
    position: const LatLng(20.65983769754567, -103.27646101955008),
    infoWindow: const InfoWindow(
      title: 'Clínica Guadalajara Salud Digna Tetlán',
      snippet: 'Ofrece servicio de densitometría',
    ),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
  ),
];


// MASTOGRAFÍA
_marcadoresPorEstudio['Mastografía'] = [
  Marker(
    markerId: const MarkerId('mastografia_1'),
    position: const LatLng(20.679783550167063, -103.37349804199599),
    infoWindow: const InfoWindow(
      title: 'Salud Digna Clínica Guadalajara Américas',
      snippet: 'Ofrece servicio de mastografía',
    ),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
  ),
  Marker(
    markerId: const MarkerId('mastografia_2'),
    position: const LatLng(20.69438341294884, -103.32360271769465),
    infoWindow: const InfoWindow(
      title: 'Clínica Salud Digna Circunvalación',
      snippet: 'Ofrece servicio de mastografía',
    ),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
  ),
  Marker(
    markerId: const MarkerId('mastografia_3'),
    position: const LatLng(20.673493720551747, -103.33282720420425),
    infoWindow: const InfoWindow(
      title: 'Salud Digna Clínica Guadalajara San Juan',
      snippet: 'Ofrece servicio de mastografía',
    ),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
  ),
  Marker(
    markerId: const MarkerId('mastografia_4'),
    position: const LatLng(20.65983769754567, -103.27646101955008),
    infoWindow: const InfoWindow(
      title: 'Clínica Guadalajara Salud Digna Tetlán',
      snippet: 'Ofrece servicio de mastografía',
    ),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
  ),
];

// RAYOS X
_marcadoresPorEstudio['Rayos X'] = [
  Marker(
    markerId: const MarkerId('rayosx_1'),
    position: const LatLng(20.679783550167063, -103.37349804199599),
    infoWindow: const InfoWindow(
      title: 'Salud Digna Clínica Guadalajara Américas',
      snippet: 'Ofrece servicio de rayos X',
    ),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
  ),
  Marker(
    markerId: const MarkerId('rayosx_2'),
    position: const LatLng(20.69438341294884, -103.32360271769465),
    infoWindow: const InfoWindow(
      title: 'Clínica Salud Digna Circunvalación',
      snippet: 'Ofrece servicio de rayos X',
    ),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
  ),
  Marker(
    markerId: const MarkerId('rayosx_3'),
    position: const LatLng(20.673493720551747, -103.33282720420425),
    infoWindow: const InfoWindow(
      title: 'Salud Digna Clínica Guadalajara San Juan',
      snippet: 'Ofrece servicio de rayos X',
    ),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
  ),
  Marker(
    markerId: const MarkerId('rayosx_4'),
    position: const LatLng(20.65983769754567, -103.27646101955008),
    infoWindow: const InfoWindow(
      title: 'Clínica Guadalajara Salud Digna Tetlán',
      snippet: 'Ofrece servicio de rayos X',
    ),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
  ),
];

// ULTRASONIDO
_marcadoresPorEstudio['Ultrasonido'] = [
  Marker(
    markerId: const MarkerId('ultrasonido_1'),
    position: const LatLng(20.679783550167063, -103.37349804199599),
    infoWindow: const InfoWindow(
      title: 'Salud Digna Clínica Guadalajara Américas',
      snippet: 'Ofrece servicio de ultrasonido',
    ),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
  ),
  Marker(
    markerId: const MarkerId('ultrasonido_2'),
    position: const LatLng(20.69438341294884, -103.32360271769465),
    infoWindow: const InfoWindow(
      title: 'Clínica Salud Digna Circunvalación',
      snippet: 'Ofrece servicio de ultrasonido',
    ),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
  ),
  Marker(
    markerId: const MarkerId('ultrasonido_3'),
    position: const LatLng(20.626485497244747, -103.38588923489638),
    infoWindow: const InfoWindow(
      title: 'Clínica Salud Digna Cristóbal Colón',
      snippet: 'Ofrece servicio de ultrasonido',
    ),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
  ),
  Marker(
    markerId: const MarkerId('ultrasonido_4'),
    position: const LatLng(20.673493720551747, -103.33282720420425),
    infoWindow: const InfoWindow(
      title: 'Salud Digna Clínica Guadalajara San Juan',
      snippet: 'Ofrece servicio de ultrasonido',
    ),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
  ),
  Marker(
    markerId: const MarkerId('ultrasonido_5'),
    position: const LatLng(20.65983769754567, -103.27646101955008),
    infoWindow: const InfoWindow(
      title: 'Clínica Guadalajara Salud Digna Tetlán',
      snippet: 'Ofrece servicio de ultrasonido',
    ),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
  ),
];

// TOMOGRAFÍA
_marcadoresPorEstudio['Tomografía'] = [
  Marker(
    markerId: const MarkerId('tomografia_1'),
    position: const LatLng(20.679783550167063, -103.37349804199599),
    infoWindow: const InfoWindow(
      title: 'Salud Digna Clínica Guadalajara Américas',
      snippet: 'Ofrece servicio de tomografía',
    ),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
  ),
  Marker(
    markerId: const MarkerId('tomografia_2'),
    position: const LatLng(20.69438341294884, -103.32360271769465),
    infoWindow: const InfoWindow(
      title: 'Clínica Salud Digna Circunvalación',
      snippet: 'Ofrece servicio de tomografía',
    ),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
  ),
  Marker(
    markerId: const MarkerId('tomografia_3'),
    position: const LatLng(20.65983769754567, -103.27646101955008),
    infoWindow: const InfoWindow(
      title: 'Clínica Guadalajara Salud Digna Tetlán',
      snippet: 'Ofrece servicio de tomografía',
    ),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
  ),
];

// RESONANCIA MAGNÉTICA
_marcadoresPorEstudio['Resonancia Magnética'] = [
  Marker(
    markerId: const MarkerId('resonancia_1'),
    position: const LatLng(20.679783550167063, -103.37349804199599),
    infoWindow: const InfoWindow(
      title: 'Salud Digna Clínica Guadalajara Américas',
      snippet: 'Ofrece servicio de resonancia magnética',
    ),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  ),
];

// ULTRASONIDO 4D
_marcadoresPorEstudio['Ultrasonido 4D'] = [
  Marker(
    markerId: const MarkerId('ultrasonido4d_1'),
    position: const LatLng(20.679783550167063, -103.37349804199599),
    infoWindow: const InfoWindow(
      title: 'Salud Digna Clínica Guadalajara Américas',
      snippet: 'Ofrece servicio de ultrasonido 4D',
    ),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  ),
  Marker(
    markerId: const MarkerId('ultrasonido4d_2'),
    position: const LatLng(20.69438341294884, -103.32360271769465),
    infoWindow: const InfoWindow(
      title: 'Clínica Salud Digna Circunvalación',
      snippet: 'Ofrece servicio de ultrasonido 4D',
    ),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  ),
  Marker(
    markerId: const MarkerId('ultrasonido4d_3'),
    position: const LatLng(20.626485497244747, -103.38588923489638),
    infoWindow: const InfoWindow(
      title: 'Clínica Salud Digna Cristóbal Colón',
      snippet: 'Ofrece servicio de ultrasonido 4D',
    ),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  ),
  Marker(
    markerId: const MarkerId('ultrasonido4d_4'),
    position: const LatLng(20.673493720551747, -103.33282720420425),
    infoWindow: const InfoWindow(
      title: 'Salud Digna Clínica Guadalajara San Juan',
      snippet: 'Ofrece servicio de ultrasonido 4D',
    ),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  ),
  Marker(
    markerId: const MarkerId('ultrasonido4d_5'),
    position: const LatLng(20.65983769754567, -103.27646101955008),
    infoWindow: const InfoWindow(
      title: 'Clínica Guadalajara Salud Digna Tetlán',
      snippet: 'Ofrece servicio de ultrasonido 4D',
    ),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  ),
];

  }

  void _actualizarMarcadores(String tipoEstudio) {
    setState(() {
      if (tipoEstudio == 'Todos') {
        _marcadoresActuales = {};
        _marcadoresPorEstudio.forEach((tipo, marcadores) {
          _marcadoresActuales.addAll(Set.from(marcadores));
        });
      } else {
        _marcadoresActuales = Set.from(_marcadoresPorEstudio[tipoEstudio] ?? []);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: _primaryColor,
              ),
            )
          : Column(
              children: [
                Container(
                  color: _backgroundColor,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¿Qué estudio vas a realizar?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _primaryColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _secondaryColor),
                          boxShadow: [
                            BoxShadow(
                              color: _primaryColor.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedEstudio,
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: _accentColor,
                              size: 28,
                            ),
                            isExpanded: true,
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedEstudio = newValue;
                                  _actualizarMarcadores(newValue);
                                });
                              }
                            },
                            items: _tiposEstudio.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    color: _primaryColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Añadimos una leyenda de colores para mejorar la visualización
                    
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _primaryColor.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      child: GoogleMap(
                        initialCameraPosition: _initialPosition,
                        markers: _marcadoresActuales,
                        onMapCreated: (GoogleMapController controller) {
                          _mapController = controller;
                        },
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                        mapType: MapType.normal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _tertiaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        onPressed: () {
          _mapController?.animateCamera(
            CameraUpdate.newCameraPosition(_initialPosition),
          );
        },
        child: const Icon(Icons.my_location, size: 26),
      ),
    );
  }

  Widget _buildColorLegend() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Leyenda:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _primaryColor,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          _legendItem('Radiografía', _primaryColor),
          _legendItem('Ultrasonido', _secondaryColor),
          _legendItem('Tomografía', _accentColor),
          _legendItem('Resonancia Magnética', _tertiaryColor),
        ],
      ),
    );
  }

  Widget _legendItem(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: _primaryColor.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}