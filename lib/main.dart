import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/home_screen.dart';
import 'screens/ozel_hesaplama.dart';
import 'screens/sure_ayet_esma.dart';
import 'screens/yildizname_screen.dart';
import 'screens/vefk_screen.dart';

void main() {
  runApp(const EbcedApp());
}

class EbcedApp extends StatelessWidget {
  const EbcedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Havass Hesaplama',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('tr', 'TR'),
        Locale('en', 'US'),
      ],
      locale: const Locale('tr', 'TR'),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Havass Hesaplama'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Hoş Geldiniz',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Kullanmak istediğiniz modülü seçin',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            _buildModulCard(
              context,
              icon: Icons.calculate,
              title: 'Ebced Hesaplama',
              subtitle: 'Ayet ebcedi, isim oluşturma, sure/ayet/esma',
              color: Colors.indigo,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const EbcedNavigation())),
            ),
            const SizedBox(height: 16),
            _buildModulCard(
              context,
              icon: Icons.auto_awesome,
              title: 'Yıldız Name Cifir',
              subtitle: 'İsim analizi, gezegen saatleri, evlilik cifiri',
              color: Colors.deepPurple,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const YildizNameScreen())),
            ),
            const SizedBox(height: 16),
            _buildModulCard(
              context,
              icon: Icons.grid_4x4,
              title: 'Vefk Hesaplama',
              subtitle: '3×3, 4×4, 5×5 vefk ve teksir',
              color: Colors.teal,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const VefkScreen())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModulCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      required Color color,
      required VoidCallback onTap}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class EbcedNavigation extends StatefulWidget {
  const EbcedNavigation({super.key});

  @override
  State<EbcedNavigation> createState() => _EbcedNavigationState();
}

class _EbcedNavigationState extends State<EbcedNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    OzelHesaplamaScreen(),
    SureAyetEsmaScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calculate_outlined),
            selectedIcon: Icon(Icons.calculate),
            label: 'Ebced',
          ),
          NavigationDestination(
            icon: Icon(Icons.numbers_outlined),
            selectedIcon: Icon(Icons.numbers),
            label: 'Özel',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_stories_outlined),
            selectedIcon: Icon(Icons.auto_stories),
            label: 'Sure/Ayet/Esma',
          ),
        ],
      ),
    );
  }
}
