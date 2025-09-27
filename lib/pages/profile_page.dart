import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'app_drawer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _avatarSlideAnimation;
  final TextEditingController _nameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _avatarSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _updateProfileName(String newName) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(newName);
        await user.reload();
        setState(() {
          _isEditing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nom mis à jour avec succès !')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la mise à jour : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade800,
      ),
      drawer: AppDrawer(currentPage: 'profile'),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade800, Colors.blue.shade600],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                  ),
                  child: Center(
                    child: SlideTransition(
                      position: _avatarSlideAnimation,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        child: Text(
                          user?.email?.substring(0, 1).toUpperCase() ?? 'U',
                          style: TextStyle(
                            fontSize: 48,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _isEditing
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    hintText: 'Entrez votre nom',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _isEditing = false;
                                        });
                                      },
                                      child: Text('Annuler'),
                                    ),
                                    SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (_nameController.text.isNotEmpty) {
                                          await _updateProfileName(
                                              _nameController.text);
                                        }
                                      },
                                      child: Text('Enregistrer'),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : _buildInfoCard(
                              icon: Icons.person_outline,
                              label: 'Nom',
                              value: user?.displayName ?? 'Non défini',
                            ),
                      SizedBox(height: 16),
                      _buildInfoCard(
                        icon: Icons.email_outlined,
                        label: 'Email',
                        value: user?.email ?? 'Non défini',
                      ),
                      SizedBox(height: 24),
                      if (!_isEditing)
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isEditing = true;
                                _nameController.text = user?.displayName ?? '';
                              });
                            },
                            child: Text('Modifier le profil'),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue.shade800, size: 28),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 14, color: Colors.grey)),
              Text(value,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
