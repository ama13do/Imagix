import 'package:flutter/material.dart';

class MedicalStudiesScreen extends StatefulWidget {
  const MedicalStudiesScreen({Key? key}) : super(key: key);

  @override
  State<MedicalStudiesScreen> createState() => _MedicalStudiesScreenState();
}

class _MedicalStudiesScreenState extends State<MedicalStudiesScreen> {
  bool _isZapoteco = false;
  final List<bool> _expandedPanels = List.generate(7, (_) => false);

  // Colores de la aplicación
  final Color primaryGreen = const Color(0xFF309F49);
  final Color lightCream = const Color(0xFFF7EED1);
  final Color seafoamGreen = const Color(0xFF41AE88);
  final Color goldYellow = const Color(0xFFFBC213);
  final Color softOrange = const Color(0xFFF08254);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightCream,
      
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              color: seafoamGreen,
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _isZapoteco
                          ? 'Ca estudiu ni riquiine para gaca imagen sti ndaani xcuérpunu'
                          : 'Estudios de diagnóstico por imagen',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 7,
                itemBuilder: (context, index) {
                  return _buildStudyCard(index);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            _isZapoteco = !_isZapoteco;
          });
        },
        backgroundColor: softOrange,
        icon: const Icon(Icons.translate),
        label: Text(
          _isZapoteco ? 'Traducir a español' : 'Traducir a zapoteco',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildStudyCard(int index) {
    // Títulos simplificados sin comillas especiales
    final studyTitles = [
      // Títulos en español
      [
        'RAYOS X (RADIOGRAFÍA)',
        'ULTRASONIDO',
        'RESONANCIA MAGNÉTICA',
        'TOMOGRAFÍA COMPUTARIZADA (CT)',
        'DENSITOMETRÍA ÓSEA',
        'MASTOGRAFÍA (MAMOGRAFÍA)',
        'PET CT (TOMOGRAFÍA POR EMISIÓN DE POSITRONES CON TAC)'
      ],
      // Títulos en zapoteco
      [
        'RAYOS X (RADIOGRAFÍA)',
        'ULTRASONIDO',
        'RESONANCIA MAGNÉTICA',
        'TOMOGRAFÍA COMPUTARIZADA (CT)',
        'DENSITOMETRÍA ÓSEA',
        'MASTOGRAFÍA (MAMOGRAFÍA)',
        'PET CT (TOMOGRAFÍA POR EMISIÓN DE POSITRONES CON TAC)'
      ]
    ];

    final icons = [
      Icons.radio,
      Icons.waves,
      Icons.medical_services,
      Icons.view_in_ar,
      Icons.accessibility_new,
      Icons.health_and_safety,
      Icons.biotech,
    ];

    final colors = [
      primaryGreen,
      seafoamGreen,
      softOrange,
      goldYellow,
      primaryGreen,
      seafoamGreen,
      softOrange,
    ];

    final lang = _isZapoteco ? 1 : 0;
    final studyTitle = studyTitles[lang][index];
    final iconData = icons[index];
    final color = colors[index];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          onExpansionChanged: (expanded) {
            setState(() {
              _expandedPanels[index] = expanded;
            });
          },
          initiallyExpanded: _expandedPanels[index],
          backgroundColor: Colors.white,
          collapsedBackgroundColor: Colors.white,
          leading: CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Icon(iconData, color: color),
          ),
          title: Text(
            studyTitle,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 16,
            ),
          ),
          trailing: Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(
              _expandedPanels[index] ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: color,
            ),
          ),
          children: [
            _buildStudyDetails(index),
          ],
        ),
      ),
    );
  }

  Widget _buildStudyDetails(int index) {
    // Descripción de los estudios - sin comillas especiales
    final queEs = [
      // Español
      [
        'La radiografía es una técnica de diagnóstico por imagen que utiliza una pequeña cantidad de radiación para crear imágenes del interior del cuerpo. Es uno de los estudios más comunes y rápidos en medicina.',
        'Es un estudio que utiliza ondas sonoras de alta frecuencia (no radiación) para obtener imágenes en tiempo real del interior del cuerpo. El médico puede ver órganos, vasos sanguíneos o estructuras en movimiento, como un bebé en el útero.',
        'La resonancia magnética es un estudio avanzado que usa un campo magnético y ondas de radio para generar imágenes muy detalladas del cuerpo, especialmente útil para ver tejidos blandos como el cerebro, músculos, ligamentos y órganos internos.',
        'La tomografía es un estudio que combina rayos X con tecnología informática para crear imágenes detalladas en cortes o secciones del cuerpo, como si fuera un "rebanado" digital del organismo.',
        'Es un estudio que mide la cantidad de minerales (como calcio) en los huesos. Se utiliza principalmente para diagnosticar enfermedades que debilitan los huesos, como la osteoporosis.',
        'Es una radiografía especializada que se utiliza para observar el tejido mamario y detectar posibles anomalías, como el cáncer de mama, en etapas muy tempranas, incluso antes de que haya síntomas.',
        'Es una combinación de dos estudios: uno muestra cómo funcionan los órganos (PET), y otro muestra su estructura (CT).'
      ],
      // Zapoteco
      [
        'Laani nga ti nagueenda ne sin yuuba ni riquiine ti ndaa huiini de en para gaca imagen sti ndaani xcuérpunu. Laani nga tobi de ca estudiu ni jma riquiine binni ne ni jma nagueenda raca lu medicina.',
        'Laani nga ti estudiu ni riquiine para guicaa imagen en tiempo real de ni nuu ndaani xcuérpunu. Doctor ca zanda guya ca órgano, ca vaso de rini o ca estructura ni rizá, casi ti baduhuiini ni nuu ndaani jñaa.',
        'Laani nga ti estudiu avanzadu ni riquiine ti gucaa imagen nabé detallada sti xcuérpunu, jmaru si racané ni para guidúyanu ca guielú nanda casi cerebru, músculo, ligamentu ne órgano interno.',
        'Laani nga ti estudiu ni riquiine ca rayos X ne jma instrumentu para gaca imagen detallada lu ca HA o ndaa sti xcuérpunu, casi ñaca ñácani ti rebanada digital sti xcuérpunu.',
        'Laani nga ti estudiu ni runi medirca pabia guié nuu ndaani ca guié ca. Jma riquiine ni para guihuinni pa napa binni xiixa guendahuará ni runi racaná ca guié ca, casi ma feu ma bixhiiñe huesu.',
        'Laani nga ti rayos X especializadu ni riquiine para guihuinni xi guirá nuu ndaani ca mama (mama), para guihuinni, casi ora napa binni cáncer de mama ora ma nahuiini, dede ante guihuinni ca síntoma stini.',
        'Laani nga ti combinación de chupa estudiu: tobi rusihuinni ximodo runi ca órganu dxiiña (PET) ne stobi rusihuinni ximodo nuu cani(CT).'
      ]
    ];

    // Para qué sirve - no comillas especiales
    final paraQueSirve = [
      // Español
      [
        ['Detectar fracturas o lesiones en los huesos.', 'Observar el tórax, como los pulmones y el corazón.', 'Evaluar el estado de articulaciones y columna vertebral.'],
        ['Observar el embarazo y el desarrollo del feto.', 'Estudiar órganos abdominales como el hígado, riñones, páncreas y vesícula.', 'Detectar quistes, tumores, inflamación o líquidos anormales.', 'Guiar procedimientos médicos, como biopsias.'],
        ['Analizar el cerebro y la médula espinal para detectar tumores, esclerosis múltiple o accidentes cerebrovasculares.', 'Evaluar lesiones en articulaciones (como rodilla u hombro).', 'Estudiar el corazón, hígado, riñones u otros órganos con gran detalle.'],
        ['Detectar tumores, infecciones, hemorragias, fracturas internas o coágulos.', 'Evaluar órganos del tórax, abdomen, cerebro y pelvis.', 'Se utiliza comúnmente en emergencias médicas por su rapidez y precisión.'],
        ['Detectar pérdida de masa ósea antes de que ocurra una fractura.', 'Evaluar el riesgo de fracturas, especialmente en mujeres posmenopáusicas y personas mayores.', 'Monitorear tratamientos para fortalecer los huesos.'],
        ['Diagnóstico temprano de cáncer de mama, lo que aumenta mucho las posibilidades de tratamiento exitoso.', 'Evaluación de síntomas como bultos o secreciones en los senos.'],
        ['Detectar o monitorear el cáncer y ver si se ha diseminado a otros órganos.', 'Evaluar cómo responde el cuerpo a tratamientos.', 'Diagnosticar enfermedades cerebrales como Alzheimer, epilepsia o Parkinson.']
      ],
      // Zapoteco
      [
        ['Biiya pa nuu racaná ladi binni lu ca dxita ladi binni', 'Biiya tórax, casi pulmón ne ladxidolo', 'Bini biiya ximodo nuu sti ca articulación ne columna vertebral', 'Lade xcaadxi cosa'],
        ['Biiya pabia nacaxiiñi binni ne pabia ma zidale xiiñi', 'Biinda ca órgano abdominal casi hígado, riñón, páncreas ne vejiga', 'libru ni lá modo guni tobi xiixa médico', 'Lade xcaadxi cosa'],
        ['Bini analizar cerebru ne médula espinal', 'ruuya ca lesión articular (casi rodilla u hombro)', 'Biinda chaahuii ladxidolo, hígado stilu, riñón stilu o xcaadxi órganu stilu', 'Lade xcaadxi cosa'],
        ['Biiya pa nuu tumor, infección, rini o gucaná ndaani', 'Biiya ca órgano sti tórax, abdomen, cerebru ne pelvis', 'Nabé riquiiñecabe ni ora guizaaca xiixa emergencia médica purti nagueenda rindá ni ne jneza ni', 'Lade xcaadxi cosa'],
        ['Biiya pa ma bininá ti huesu ante gaca ti racaná ladi binni', 'Bini medio riesgu de fractura, jmaru si ca gunaa ni ma ziné menopausia ne ca binni ni ma nagola', 'Biiya ca tratamientu ni racané para gaca stipa ca dxita ladi binni', 'Lade xcaadxi cosa'],
        ['Pa guidxela binni cáncer de mama tempranu, jmaru si zanda guicaa ti tratamientu galán', 'Evaluación sti ca síntoma casi ca tumor o ca secreción ni nuu ndaani ca seno', 'Lade xcaadxi cosa'],
        ['Detección o monitoreo sti cáncer', 'Evaluación sti respuesta sti cuerpu sti binni ora guicaa tratamientu', 'Diagnóstico de guendahuará cerebral casi Alzheimer, epilepsia o Parkinson', 'Lade xcaadxi cosa']
      ]
    ];

    // Duración - sin comillas especiales
    final duracion = [
      // Español
      [
        'Entre 5 y 10 minutos.',
        'De 15 a 30 minutos, según la zona del cuerpo.',
        'Entre 30 y 60 minutos, dependiendo de la zona a estudiar.',
        'Entre 10 y 20 minutos.',
        'De 10 a 15 minutos.',
        'Entre 15 y 20 minutos.',
        'Entre 1.5 y 2 horas.'
      ],
      // Zapoteco
      [
        'lhadjo 5 ne 10 minutu',
        'De quince hasta treinta minutu, según área sti xcuérpunu',
        'lhadjo 30 o 60 minutu, según lugar ra chiguni estudiar binni',
        'lhadjo 10 ne 20 minutu',
        '10 o 15 minutu',
        '15 ne 20 minutu',
        'Entre 1,5 ne 2 hora'
      ]
    ];

    final lang = _isZapoteco ? 1 : 0;
    final color = index % 2 == 0 ? primaryGreen : seafoamGreen;

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('¿Qué es?', seafoamGreen),
          const SizedBox(height: 8),
          Text(
            queEs[lang][index],
            style: const TextStyle(fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 16),
          
          _buildSectionTitle('¿Para qué sirve?', primaryGreen),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: paraQueSirve[lang][index].map((item) => 
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle, size: 20, color: goldYellow),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(fontSize: 15, height: 1.5),
                      ),
                    ),
                  ],
                ),
              )
            ).toList(),
          ),
          
          const SizedBox(height: 16),
          _buildSectionTitle('Duración', softOrange),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.access_time, color: softOrange),
              const SizedBox(width: 8),
              Text(
                duracion[lang][index],
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Lógica para mostrar más detalles
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.info_outline),
                  const SizedBox(width: 8),
                  Text(
                    _isZapoteco ? 'Jma información' : 'Más información',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
  }
}