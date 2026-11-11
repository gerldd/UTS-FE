import 'package:flutter/material.dart';
import 'screens/calculator_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/tips_screen.dart';
import 'theme/app_theme.dart';
import 'screens/onboarding_screen.dart'; // Pastikan file onboarding di-import

void main() => runApp(const WattWiseApp());

/// Notifier global sederhana untuk mengontrol pergantian tema (Light/Dark Mode)
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

class WattWiseApp extends StatelessWidget {
  const WattWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'WattWise',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: currentMode,
          // Mulai aplikasi dari OnboardingScreen terlebih dahulu
          home: const OnboardingScreen(),
        );
      },
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  // Daftar navigasi aplikasi
  static const List<NavigationItem> _destinations = [
    NavigationItem(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: 'Beranda',
    ),
    NavigationItem(
      icon: Icons.calculate_outlined,
      selectedIcon: Icons.calculate,
      label: 'Kalkulator',
    ),
    NavigationItem(
      icon: Icons.lightbulb_outline,
      selectedIcon: Icons.lightbulb,
      label: 'Tips',
    ),
    NavigationItem(
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      label: 'Akun',
    ),
  ];

  void _onNavigationChanged(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(onStartCalc: () => _onNavigationChanged(1)),
      const CalculatorScreen(),
      const TipsScreen(),
      const ProfileScreen(),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        // Menggunakan NavigationRail jika lebar layar >= 720 (Tablet/Desktop)
        final bool useRail = constraints.maxWidth >= 720;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              '⚡ WattWise',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            actions: [
              // Tombol Toggle Tema reaktif
              ValueListenableBuilder<ThemeMode>(
                valueListenable: themeNotifier,
                builder: (context, currentMode, _) {
                  final bool isDarkMode = currentMode == ThemeMode.dark;
                  return IconButton(
                    tooltip: 'Ganti Tema',
                    icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
                    onPressed: () {
                      themeNotifier.value =
                          isDarkMode ? ThemeMode.light : ThemeMode.dark;
                    },
                  );
                },
              ),
              // Tombol Notifikasi
              IconButton(
                tooltip: 'Notifikasi',
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Belum ada notifikasi baru.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          ),
          body: Row(
            children: [
              if (useRail)
                NavigationRail(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: _onNavigationChanged,
                  labelType: NavigationRailLabelType.all,
                  destinations: _destinations
                      .map(
                        (dest) => NavigationRailDestination(
                          icon: Icon(dest.icon),
                          selectedIcon: Icon(dest.selectedIcon),
                          label: Text(dest.label),
                        ),
                      )
                      .toList(),
                ),
              Expanded(
                child: IndexedStack(
                  index: _currentIndex,
                  children: pages,
                ),
              ),
            ],
          ),
          bottomNavigationBar: useRail
              ? null
              : NavigationBar(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: _onNavigationChanged,
                  destinations: _destinations
                      .map(
                        (dest) => NavigationDestination(
                          icon: Icon(dest.icon),
                          selectedIcon: Icon(dest.selectedIcon),
                          label: dest.label,
                        ),
                      )
                      .toList(),
                ),
          floatingActionButton: _currentIndex == 1
              ? null
              : FloatingActionButton.extended(
                  onPressed: () => _onNavigationChanged(1),
                  icon: const Icon(Icons.calculate),
                  label: const Text('Mulai Hitung'),
                ),
        );
      },
    );
  }
}

class NavigationItem {
  const NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}