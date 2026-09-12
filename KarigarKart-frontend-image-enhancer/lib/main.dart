import 'package:flutter/material.dart';
import 'services/app_state.dart';
import 'theme.dart';
import 'screens/auth_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/add_product_screen.dart';
import 'screens/ai_flow_screens.dart';
import 'screens/catalog_screen.dart';
import 'screens/profile_screen.dart';

void main() => runApp(KarigarKartApp(state: AppState()));

class KarigarKartApp extends StatelessWidget {
  const KarigarKartApp({super.key, required this.state});
  final AppState state;
  @override
  Widget build(BuildContext context) => AppScope(
        state: state,
        child: MaterialApp(
          title: 'KarigarKart',
          debugShowCheckedModeBanner: false,
          theme: buildTheme(),
          home: const EntryGate(),
          routes: {
            '/home': (_) => const MainShell(),
            '/add': (_) => const AddProductScreen(),
            '/preview': (_) => const ImagePreviewScreen(),
            '/listing': (_) => const ListingScreen(),
            '/publish': (_) => const PublishScreen(),
            '/catalog': (_) => const CatalogScreen(),
            '/profile': (_) => const ProfileScreen(),
          },
        ),
      );
}

class EntryGate extends StatelessWidget {
  const EntryGate({super.key});
  @override
  Widget build(BuildContext context) =>
      AppScope.of(context).isLoggedIn ? const MainShell() : const AuthScreen();
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final pages = [
      const DashboardScreen(),
      const CatalogScreen(embedded: true),
      const ProfileScreen(embedded: true)
    ];
    return Scaffold(
      body: pages[index],
      floatingActionButton: index == 0
          ? FloatingActionButton.extended(
              backgroundColor: AppColors.clay,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add_a_photo_outlined),
              label: const Text('Add product'),
              onPressed: () => Navigator.pushNamed(context, '/add'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.grid_view_outlined),
              selectedIcon: Icon(Icons.grid_view),
              label: 'Catalog'),
          NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile'),
        ],
      ),
    );
  }
}
