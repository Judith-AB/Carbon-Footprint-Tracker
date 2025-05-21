// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/news_screen.dart';
import 'screens/create_post_screen.dart';
import 'services/auth_service.dart';
import 'services/post_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProxyProvider<AuthService, PostService>(
          create: (context) => PostService(Provider.of<AuthService>(context, listen: false)),
          update: (context, auth, previousPosts) =>
          previousPosts ?? PostService(auth),
        ),
      ],
      child: const EcoTrackApp(),
    ),
  );
}

class EcoTrackApp extends StatelessWidget {
  const EcoTrackApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoTrack',
      theme: ThemeData(
        primaryColor: const Color(0xFF2E7D32),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          secondary: const Color(0xFF81C784),
        ),
        fontFamily: 'Inter',
        scaffoldBackgroundColor: const Color(0xFFF5F7F5),
      ),
      home: AuthenticationWrapper(),
      routes: {
        '/main': (context) => const MainScreen(),
        '/create-post': (context) => const CreatePostScreen(),
      },
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    // Check if user is authenticated
    if (authService.isAuthenticated) {
      return const MainScreen();
    }

    // Show login screen if not authenticated
    return const LoginScreen();
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _screenOptions = <Widget>[
    const HomeScreen(),
    const ProfileScreen(),
    const NewsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.eco, color: Color(0xFF2E7D32)),
            const SizedBox(width: 8),
            Text(
              'EcoTrack',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
            color: Colors.black87,
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
            color: Colors.black87,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Show logout confirmation dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Logout user
                        Provider.of<AuthService>(context, listen: false).signOut();
                        Navigator.pop(context); // Close dialog
                        Navigator.pushReplacementNamed(context, '/'); // Go to login
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
            color: Colors.black87,
          ),
        ],
      ),
      body: _screenOptions.elementAt(_selectedIndex),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create-post');
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'News',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}