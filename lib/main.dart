import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MoveMindApp());
}

class MoveMindApp extends StatelessWidget {
  const MoveMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MoveMind Senior',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
      // Envolvemos la pantalla principal en nuestro simulador de móvil
      home: const MobileFrame(child: MainScreen()),
    );
  }
}

// --- WIDGET NUEVO: SIMULADOR DE MARCO MÓVIL ---
class MobileFrame extends StatelessWidget {
  final Widget child;
  const MobileFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Si la pantalla es ancha (Escritorio/Web), simulamos el móvil
        if (constraints.maxWidth > 500) {
          return Scaffold(
            backgroundColor: const Color(0xFFECEFF1), // Fondo gris suave para el escritorio
            body: Center(
              child: Container(
                width: 380, // Ancho típico de celular
                height: 800, // Alto típico
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 30,
                      offset: const Offset(0, 20),
                    ),
                  ],
                  // Borde negro grueso simulando el marco físico
                  border: Border.all(color: const Color(0xFF2D2D2D), width: 12),
                ),
                // Recortamos el contenido para que respete las esquinas redondeadas
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: child,
                ),
              ),
            ),
          );
        }
        // Si ya estamos en un móvil (pantalla angosta), mostramos la app normal
        return child;
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; 

  final List<Widget> _pages = [
    const HomeTab(),
    const TripsTab(),
    const FamilyTab(), 
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ), 
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        selectedFontSize: 16,
        unselectedFontSize: 16,
        iconSize: 35,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'Viajes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            label: 'Familia',
          ),
        ],
      ),
    );
  }
}

// --- 1. PESTAÑA DE INICIO ---
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomHeader(title1: 'Move Mind', title2: 'Senior'),
        const Divider(height: 1, thickness: 1),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hola, Usuario!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 20),
                // Sección Viajes
                Row(
                  children: [
                    const Icon(Icons.notifications_active, size: 28, color: Colors.black87),
                    const SizedBox(width: 10),
                    Text(
                      'Tus proximos viajes',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildInfoCard(
                  title: 'Cita con el doctor',
                  subtitle: 'Hoy a las 12:30',
                  showButton: true,
                  buttonText: 'Iniciar viaje',
                ),
                const SizedBox(height: 30),
                // Sección Lugares
                Row(
                  children: [
                    const Icon(Icons.access_time_filled, size: 28, color: Colors.grey),
                    const SizedBox(width: 10),
                    const Text(
                      'Tus lugares habituales',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 1.4,
                  children: [
                    _buildPlaceButton(icon: Icons.home, label: 'Casa', color: const Color(0xFF009E4F)),
                    _buildPlaceButton(icon: Icons.shopping_cart_outlined, label: 'Tiendas', color: const Color(0xFF009E4F)),
                    _buildPlaceButton(icon: Icons.park_outlined, label: 'Parque', color: const Color(0xFF009E4F)),
                    _buildPlaceButton(icon: null, label: 'Nuevo\nlugar', color: Colors.black87, isDashed: true),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// --- 2. PESTAÑA DE VIAJES ---
class TripsTab extends StatefulWidget {
  const TripsTab({super.key});

  @override
  State<TripsTab> createState() => _TripsTabState();
}

class _TripsTabState extends State<TripsTab> {
  final List<Map<String, String>> _trips = [
    {'title': 'Hacer las compras', 'time': '12:30'},
    {'title': 'Hora al medico', 'time': '15:00'},
  ];

  void _showAddTripDialog() {
    String newTitle = '';
    String newTime = '';
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Nuevo Viaje"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "Nombre (ej. Ir al parque)"),
                onChanged: (value) => newTitle = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Hora (ej. 16:30)"),
                onChanged: (value) => newTime = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                if (newTitle.isNotEmpty && newTime.isNotEmpty) {
                  setState(() {
                    _trips.add({'title': newTitle, 'time': newTime});
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF009E4F), foregroundColor: Colors.white),
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.notifications_none, size: 35, color: Colors.black54),
              Text(
                'Viajes',
                style: GoogleFonts.openSans(fontSize: 26, fontWeight: FontWeight.bold, color: const Color(0xFF003366)),
              ),
              const SOSButton(),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                ..._trips.map((trip) => Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: _buildInfoCard(
                    title: trip['title']!,
                    subtitle: trip['time']!,
                    showButton: false,
                  ),
                )),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _showAddTripDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF009E4F),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 3,
                    ),
                    child: const Text('Añadir nuevo viaje', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// --- 3. PESTAÑA DE FAMILIA ---
class FamilyTab extends StatefulWidget {
  const FamilyTab({super.key});

  @override
  State<FamilyTab> createState() => _FamilyTabState();
}

class _FamilyTabState extends State<FamilyTab> {
  bool isDaughterSharing = true;
  bool isCaregiverSharing = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomHeader(title1: 'Move Mind', title2: 'Senior'),
        const Divider(height: 1, thickness: 1),
        
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Familia y cuidadores',
                    style: GoogleFonts.openSans(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                _buildFamilyCard(
                  name: "Hija",
                  isSharing: isDaughterSharing,
                  onToggle: () {
                    setState(() {
                      isDaughterSharing = !isDaughterSharing;
                    });
                  },
                ),

                const SizedBox(height: 20),

                _buildFamilyCard(
                  name: "Cuidador",
                  isSharing: isCaregiverSharing,
                  onToggle: () {
                    setState(() {
                      isCaregiverSharing = !isCaregiverSharing;
                    });
                  },
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Funcionalidad para agregar contacto")),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF009E4F),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 3,
                    ),
                    child: const Text(
                      'Añadir nuevo contacto',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFamilyCard({
    required String name,
    required bool isSharing,
    required VoidCallback onToggle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          
          GestureDetector(
            onTap: onToggle,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: isSharing ? const Color(0xFF00853E) : const Color(0xFFE53935),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                isSharing ? 'Compartiendo\nubicación' : 'No compartiendo\nubicación',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- WIDGETS COMUNES ---

class CustomHeader extends StatelessWidget {
  final String title1;
  final String title2;
  const CustomHeader({super.key, required this.title1, required this.title2});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title1, style: GoogleFonts.openSans(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
              Text(title2, style: GoogleFonts.openSans(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87)),
            ],
          ),
          const SOSButton(),
        ],
      ),
    );
  }
}

class SOSButton extends StatelessWidget {
  const SOSButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => print("LLAMANDO A EMERGENCIA..."),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE53935),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        elevation: 4,
      ),
      child: const Text('SOS', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    );
  }
}

Widget _buildInfoCard({required String title, required String subtitle, bool showButton = false, String? buttonText}) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: const Color(0xFF009E4F), width: 3),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))],
    ),
    padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
    child: Column(
      children: [
        Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        Text(subtitle, textAlign: TextAlign.center, style: showButton 
            ? TextStyle(fontSize: 18, color: Colors.grey[700])
            : const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
        if (showButton && buttonText != null) ...[
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF009E4F),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: Text(buttonText, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ],
      ],
    ),
  );
}

Widget _buildPlaceButton({IconData? icon, required String label, required Color color, bool isDashed = false}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: isDashed ? Border.all(color: Colors.grey, width: 2) : Border.all(color: Colors.grey.shade400, width: 1),
          boxShadow: isDashed ? [] : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isDashed) ...[
              Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            ] else ...[
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 5),
              Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            ]
          ],
        ),
      ),
    ),
  );
}