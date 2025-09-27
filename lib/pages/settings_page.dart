import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'app_drawer.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _isPasswordVisible = false;
  bool _isCurrentPasswordVisible = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _emailController.text = user?.email ?? '';
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _newPasswordController.dispose();
    _currentPasswordController.dispose();
    super.dispose();
  }

  Future<void> _sendEmailVerification() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vérification envoyée à votre email')),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur : $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateEmail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateEmail(_emailController.text.trim());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email mis à jour')),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updatePassword() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && _currentPasswordController.text.isNotEmpty) {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: _currentPasswordController.text.trim(),
        );
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(_newPasswordController.text.trim());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Mot de passe mis à jour')),
        );
        _currentPasswordController.clear();
        _newPasswordController.clear();
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade800,
      ),
      drawer: AppDrawer(currentPage: 'settings'),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Paramètres',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Nouvel email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _sendEmailVerification,
                        child: Text('Vérifier l\'email'),
                      ),
                      SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _updateEmail,
                        child: Text('Mettre à jour l\'email'),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: _currentPasswordController,
                        obscureText: !_isCurrentPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe actuel',
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(_isCurrentPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isCurrentPasswordVisible =
                                    !_isCurrentPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      TextField(
                        controller: _newPasswordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Nouveau mot de passe',
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(_isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _updatePassword,
                        child: Text('Mettre à jour le mot de passe'),
                      ),
                    ],
                  ),
                ),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
