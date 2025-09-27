import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppDrawer extends StatelessWidget {
  final String currentPage;

  const AppDrawer({required this.currentPage, Key? key}) : super(key: key);

  static const List<String> adminEmails = [
    'admin@example.com', // Remplacez par les vrais emails des admins
    'admin2@example.com',
  ];

  bool _isAdmin() {
    final user = FirebaseAuth.instance.currentUser;
    return user != null && adminEmails.contains(user.email);
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la déconnexion : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final bool isAdmin = _isAdmin();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.displayName ?? 'Utilisateur'),
            accountEmail: Text(user?.email ?? 'Non connecté'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.blue.shade800,
              child: Text(
                user?.email?.substring(0, 1).toUpperCase() ?? 'U',
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade800, Colors.blue.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Option principale selon le rôle
          ListTile(
            leading: Icon(isAdmin ? Icons.admin_panel_settings : Icons.home),
            title: Text(isAdmin ? 'Gérer les blocs' : 'Accueil'),
            selected: currentPage == (isAdmin ? 'admin' : 'welcome'),
            onTap: () {
              if (currentPage != (isAdmin ? 'admin' : 'welcome')) {
                Navigator.pushReplacementNamed(
                  context,
                  isAdmin ? '/admin' : '/welcome',
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profil'),
            selected: currentPage == 'profile',
            onTap: () {
              if (currentPage != 'profile') {
                Navigator.pushReplacementNamed(context, '/profile');
              } else {
                Navigator.pop(context);
              }
            },
          ),
          // Option "Gérer les blocs" supplémentaire pour admins uniquement
          if (isAdmin)
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text('Gérer les blocs (Admin)'),
              selected: currentPage == 'admin',
              onTap: () {
                if (currentPage != 'admin') {
                  Navigator.pushReplacementNamed(context, '/admin');
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Paramètres'),
            selected: currentPage == 'settings',
            onTap: () {
              if (currentPage != 'settings') {
                Navigator.pushReplacementNamed(context, '/settings');
              } else {
                Navigator.pop(context);
              }
            },
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Déconnexion'),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}
