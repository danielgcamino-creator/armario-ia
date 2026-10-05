import 'package:flutter/material.dart';

void main() {
  runApp(const ArmarioApp());
}

class ArmarioApp extends StatelessWidget {
  const ArmarioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Armario IA 3D',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _prendas = [
    {
      'id': '1',
      'nombre': 'Camiseta Blanca Oversize',
      'categoria': 'Camisetas',
      'ubicacion': 'Cajón 2 (Izquierda)',
      'enArmario': true,
    },
    {
      'id': '2',
      'nombre': 'Pantalón Vaquero Negro',
      'categoria': 'Pantalones',
      'ubicacion': 'Percha 4',
      'enArmario': true,
    },
    {
      'id': '3',
      'nombre': 'Sudadera Con Capucha',
      'categoria': 'Abrigos',
      'ubicacion': 'Estantería 1',
      'enArmario': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screens = [
      _buildHomeView(),
      _buildScanView(),
      _buildInventoryView(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Armario IA 3D', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.deepPurple,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person_3), label: 'Probador 3D'),
          BottomNavigationBarItem(icon: Icon(Icons.videocam), label: 'Escanear 360º'),
          BottomNavigationBarItem(icon: Icon(Icons.checkroom), label: 'Mi Armario'),
        ],
      ),
    );
  }

  Widget _buildHomeView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            height: 380,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.deepPurple.shade200, width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.accessibility_new, size: 100, color: Colors.deepPurple),
                const SizedBox(height: 10),
                const Text(
                  'Vista 360º de tu Avatar',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    'Aquí se renderiza tu modelo 3D con las prendas puestas.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Generando combinación recomendada...')),
                    );
                  },
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('Elegir conjunto del día'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const ListTile(
              leading: Icon(Icons.location_on, color: Colors.deepPurple, size: 30),
              title: Text('Ubicación de prenda seleccionada'),
              subtitle: Text('Haz toque en una prenda para ver en qué cajón/percha está guardada.'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.camera_front, size: 80, color: Colors.deepPurple),
            const SizedBox(height: 20),
            const Text(
              'Escanear en 360º',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Graba un vídeo girando 360º para crear tu Avatar 3D o añadir una prenda nueva a tu inventario.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.person_add),
              label: const Text('Escanear Mi Avatar 3D'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 15),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_a_photo),
              label: const Text('Escanear Prenda 360º'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryView() {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: _prendas.length,
      itemBuilder: (context, index) {
        final prenda = _prendas[index];
        final bool disponible = prenda['enArmario'];

        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: disponible ? Colors.green.shade100 : Colors.red.shade100,
              child: Icon(
                disponible ? Icons.checkroom : Icons.local_laundry_service,
                color: disponible ? Colors.green : Colors.red,
              ),
            ),
            title: Text(prenda['nombre'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Ubicación: ${prenda['ubicacion']}'),
            trailing: Switch(
              value: disponible,
              activeColor: Colors.green,
              inactiveThumbColor: Colors.red,
              onChanged: (val) {
                setState(() {
                  _prendas[index]['enArmario'] = val;
                });
              },
            ),
          ),
        );
      },
    );
  }
}
