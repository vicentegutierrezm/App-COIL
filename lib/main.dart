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
        // Color primario verde como solicitaste
        primarySwatch: Colors.green,
        primaryColor: const Color(0xFF009E4F),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        // Usamos Roboto para legibilidad
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
      // La app inicia ahora en el Login, envuelto en el marco móvil
      home: const MobileFrame(child: LoginScreen()),
    );
  }
}

// --- WIDGET SIMULADOR DE MARCO MÓVIL (Mantenido de tu código) ---
class MobileFrame extends StatelessWidget {
  final Widget child;
  const MobileFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 500) {
          return Scaffold(
            backgroundColor: const Color(0xFFECEFF1),
            body: Center(
              child: Container(
                width: 380,
                height: 800,
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
                  border: Border.all(color: const Color(0xFF2D2D2D), width: 12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: child,
                ),
              ),
            ),
          );
        }
        return child;
      },
    );
  }
}

// --- 0. PANTALLA DE LOGIN (NUEVA) ---
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  void _login() {
    // Aquí iría la lógica real de autenticación.
    // Por ahora, pasamos directamente al menú principal.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              // LOGO: Usamos un contenedor con borde para que se vea limpio
              Container(
                height: 180,
                width: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)
                  ],
                ),
                padding: const EdgeInsets.all(15),
                // NOTA: Asegúrate de tener 'assets/image_79b1db.png' en tu pubspec.yaml
                // Si la imagen falla, mostramos un ícono de respaldo.
                child: Image.asset(
                  'assets/image_79b1db.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_pin_circle, size: 60, color: Color(0xFF009E4F)),
                        Text("MoveMind", style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
              Text(
                "Bienvenido",
                style: GoogleFonts.openSans(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF003366),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Ingresa tus datos para continuar",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              
              // Campos de texto grandes para accesibilidad
              TextField(
                controller: _userController,
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  labelText: "Usuario o Correo",
                  prefixIcon: const Icon(Icons.person, color: Color(0xFF009E4F)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passController,
                obscureText: true,
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  labelText: "Contraseña",
                  prefixIcon: const Icon(Icons.lock, color: Color(0xFF009E4F)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF009E4F),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    "INICIAR SESIÓN",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- PANTALLA PRINCIPAL (Con Drawer y Navegación) ---
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
      // Drawer (Sidebar) añadido aquí
      drawer: const SidebarDrawer(),
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
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF009E4F), // Verde activo
        unselectedItemColor: Colors.black54,
        selectedFontSize: 16,
        unselectedFontSize: 14,
        iconSize: 32,
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

// --- WIDGET SIDEBAR (DRAWER) ---
class SidebarDrawer extends StatelessWidget {
  const SidebarDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF009E4F),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: Icon(Icons.person, size: 40, color: Color(0xFF009E4F)),
                ),
                const SizedBox(height: 10),
                Text(
                  'Configuraciones',
                  style: GoogleFonts.openSans(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Estándares de accesibilidad
          ListTile(
            leading: const Icon(Icons.accessibility_new, size: 30),
            title: const Text('Accesibilidad', style: TextStyle(fontSize: 18)),
            subtitle: const Text('Estándares WCAG 2.1'),
            onTap: () {
              // Solo mostrar, no funcional
              Navigator.pop(context);
            },
          ),
          const Divider(),
          // Ajuste de tamaño de letra
          ListTile(
            leading: const Icon(Icons.format_size, size: 30),
            title: const Text('Tamaño de letra', style: TextStyle(fontSize: 18)),
            trailing: const Text('Grande', style: TextStyle(color: Colors.grey)),
            onTap: () {
              // Solo mostrar
              Navigator.pop(context);
            },
          ),
          const Divider(),
          // Modo oscuro
          ListTile(
            leading: const Icon(Icons.dark_mode, size: 30),
            title: const Text('Modo oscuro', style: TextStyle(fontSize: 18)),
            trailing: Switch(value: false, onChanged: (val){}), // Switch inactivo visual
          ),
          const Divider(),
          // Configuración de Perfil (Navega a otra pantalla)
          ListTile(
            leading: const Icon(Icons.settings, size: 30, color: Color(0xFF003366)),
            title: const Text('Perfil y Datos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pop(context); // Cierra el drawer primero
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileSettingsScreen()),
              );
            },
          ),
          const SizedBox(height: 50),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red, size: 30),
            title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red, fontSize: 18)),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context, 
                MaterialPageRoute(builder: (context) => const LoginScreen()), 
                (route) => false
              );
            },
          ),
        ],
      ),
    );
  }
}

// --- PANTALLA DE CONFIGURACIÓN DE PERFIL ---
class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  // Controladores para simular la edición
  final _nameController = TextEditingController(text: "Juan Pérez");
  final _addressController = TextEditingController(text: "Av. Siempre Viva 123");
  final _phoneController = TextEditingController(text: "+56 9 1234 5678");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mi Perfil"),
        backgroundColor: const Color(0xFF009E4F),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.account_circle, size: 100, color: Colors.grey),
            const SizedBox(height: 20),
            _buildEditField("Nombre Completo", _nameController, Icons.person),
            const SizedBox(height: 20),
            _buildEditField("Domicilio", _addressController, Icons.home),
            const SizedBox(height: 20),
            _buildEditField("Teléfono Emergencia", _phoneController, Icons.phone),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Datos guardados correctamente")),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003366),
                  foregroundColor: Colors.white,
                ),
                child: const Text("GUARDAR CAMBIOS", style: TextStyle(fontSize: 18)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEditField(String label, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF009E4F)),
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
      style: const TextStyle(fontSize: 18),
    );
  }
}

// --- PESTAÑA DE INICIO ---
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // CustomHeader ahora incluye el botón del menú
        const CustomHeader(title1: 'Move Mind', title2: 'Senior'),
        const Divider(height: 1, thickness: 1),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hola, Juan!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 20),
                // Sección Viajes
                Row(
                  children: [
                    const Icon(Icons.directions_walk, size: 30, color: Colors.black87),
                    const SizedBox(width: 10),
                    Text(
                      'Tus proximos viajes',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildInfoCard(
                  title: 'Cita con el doctor',
                  subtitle: 'Hoy a las 12:30',
                  showButton: true,
                  buttonText: 'Iniciar viaje',
                  onButtonPressed: () {
                    // Acción de iniciar viaje
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const TripProgressScreen())
                    );
                  }
                ),
                const SizedBox(height: 30),
                // Sección Lugares
                Row(
                  children: [
                    const Icon(Icons.favorite, size: 30, color: Colors.redAccent),
                    const SizedBox(width: 10),
                    const Text(
                      'Tus lugares habituales',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
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
                  childAspectRatio: 1.3,
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

// --- PANTALLA DE VIAJE EN PROGRESO (Simulación) ---
class TripProgressScreen extends StatelessWidget {
  const TripProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Viaje en curso"),
        backgroundColor: const Color(0xFF009E4F),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.navigation, size: 100, color: Color(0xFF003366)),
            const SizedBox(height: 20),
            const Text(
              "Navegando al destino...",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text("Siga las instrucciones por voz", style: TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)
              ),
              child: const Text("FINALIZAR VIAJE", style: TextStyle(color: Colors.white, fontSize: 18)),
            )
          ],
        ),
      ),
    );
  }
}

// --- PESTAÑA DE VIAJES ---
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
          title: const Text("Nuevo Viaje", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: "Nombre (ej. Ir al parque)",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.edit)
                ),
                onChanged: (value) => newTitle = value,
              ),
              const SizedBox(height: 15),
              TextField(
                decoration: const InputDecoration(
                  labelText: "Hora (ej. 16:30)",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.access_time)
                ),
                onChanged: (value) => newTime = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar", style: TextStyle(fontSize: 18)),
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
              child: const Text("Guardar", style: TextStyle(fontSize: 18)),
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
              Text(
                'Lista de Viajes',
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
                  child: ElevatedButton.icon(
                    onPressed: _showAddTripDialog,
                    icon: const Icon(Icons.add_circle, size: 28),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF009E4F),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 3,
                    ),
                    label: const Text('Añadir nuevo viaje', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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

// --- PESTAÑA DE FAMILIA ---
class FamilyTab extends StatefulWidget {
  const FamilyTab({super.key});

  @override
  State<FamilyTab> createState() => _FamilyTabState();
}

class _FamilyTabState extends State<FamilyTab> {
  // Lista dinámica de contactos
  final List<Map<String, dynamic>> _contacts = [
    {'name': 'Hija', 'isSharing': true},
    {'name': 'Cuidador', 'isSharing': false},
  ];

  void _showAddContactDialog() {
    String newName = '';
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Nuevo Contacto"),
          content: TextField(
            decoration: const InputDecoration(
              labelText: "Nombre (ej. Nieto)",
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => newName = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar", style: TextStyle(fontSize: 18)),
            ),
            ElevatedButton(
              onPressed: () {
                if (newName.isNotEmpty) {
                  setState(() {
                    _contacts.add({'name': newName, 'isSharing': false});
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF009E4F), foregroundColor: Colors.white),
              child: const Text("Agregar", style: TextStyle(fontSize: 18)),
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

                // Lista de contactos generada dinámicamente
                ..._contacts.map((contact) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _buildFamilyCard(
                      name: contact['name'],
                      isSharing: contact['isSharing'],
                      onToggle: () {
                        setState(() {
                          contact['isSharing'] = !contact['isSharing'];
                        });
                      },
                    ),
                  );
                }),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _showAddContactDialog,
                    icon: const Icon(Icons.person_add, size: 28),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF009E4F),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 3,
                    ),
                    label: const Text(
                      'Añadir contacto',
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
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.account_circle, size: 40, color: Colors.grey),
              const SizedBox(width: 10),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: isSharing ? const Color(0xFF00853E) : const Color(0xFFE53935),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 2))
                ]
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(isSharing ? Icons.check_circle : Icons.cancel, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    isSharing ? 'Compartiendo\nubicación' : 'No compartiendo\nubicación',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
}

// --- WIDGETS COMUNES (Header, Botones) ---

class CustomHeader extends StatelessWidget {
  final String title1;
  final String title2;
  const CustomHeader({super.key, required this.title1, required this.title2});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Botón de menú para abrir el Sidebar
          IconButton(
            icon: const Icon(Icons.menu, size: 40, color: Color(0xFF003366)),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title1, style: GoogleFonts.openSans(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                Text(title2, style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87)),
              ],
            ),
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
    return GestureDetector(
      onTap: () {
        // Simulación de llamada
        ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(
             backgroundColor: Colors.red,
             content: Text("Llamando a contacto de emergencia...", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
             duration: Duration(seconds: 3),
           )
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFE53935),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
             BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 5, offset: const Offset(0, 3))
          ]
        ),
        child: const Row(
          children: [
            Icon(Icons.phone_in_talk, color: Colors.white),
            SizedBox(width: 5),
            Text('SOS', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

// Tarjeta informativa (Viajes, Citas)
Widget _buildInfoCard({
    required String title, 
    required String subtitle, 
    bool showButton = false, 
    String? buttonText,
    VoidCallback? onButtonPressed,
  }) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: const Color(0xFF009E4F), width: 3),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))],
    ),
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
    child: Column(
      children: [
        Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        Text(subtitle, textAlign: TextAlign.center, style: showButton 
            ? TextStyle(fontSize: 18, color: Colors.grey[700])
            : const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
        if (showButton && buttonText != null) ...[
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: onButtonPressed ?? () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF009E4F),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 4,
            ),
            child: Text(buttonText, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ],
      ],
    ),
  );
}

// Botones de lugares (Grid)
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
              Icon(icon, size: 45, color: color),
              const SizedBox(height: 5),
              Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            ]
          ],
        ),
      ),
    ),
  );
}