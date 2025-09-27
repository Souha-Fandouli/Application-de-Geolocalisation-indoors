import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  String? _errorMessage;

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loginUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        QuerySnapshot<Map<String, dynamic>> userQuery = await FirebaseFirestore
            .instance
            .collection('users')
            .where('email', isEqualTo: _emailController.text.trim())
            .get();

        if (userQuery.docs.isEmpty) {
          setState(() {
            _errorMessage = 'Cet e-mail n\'est pas enregistré.';
          });
          return;
        }

        try {
          UserCredential userCredential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim());

          if (userCredential.user != null) {
            DocumentSnapshot<Map<String, dynamic>> userDoc =
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userCredential.user!.uid)
                    .get();

            if (userDoc.exists) {
              final userData = userDoc.data()!;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Bonjour ${userData['name']}, vous êtes connecté(e) !'),
                ),
              );

              String role = userData['role'] ?? 'user';
              if (role == 'admin') {
                Navigator.pushReplacementNamed(
                    context, '/admin'); // Use named route
              } else {
                Navigator.pushReplacementNamed(
                    context, '/welcome'); // Use named route
              }
            }
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'wrong-password') {
            setState(() {
              _errorMessage = 'Mot de passe incorrect pour cet e-mail.';
            });
          } else if (e.code == 'invalid-email') {
            setState(() {
              _errorMessage = 'Adresse e-mail invalide.';
            });
          } else {
            setState(() {
              _errorMessage = 'Mot de passe incorrect ';
            });
          }
        }
      } catch (e) {
        setState(() {
          _errorMessage =
              'Une erreur inattendue est survenue. Veuillez réessayer.';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _resetPassword() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez entrer votre adresse e-mail.')),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Un lien de réinitialisation a été envoyé à votre e-mail.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Erreur lors de l\'envoi du lien de réinitialisation.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue.shade50, Colors.blue.shade200],
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.0),
                child: Card(
                  elevation: 12.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  shadowColor: Colors.blue.withOpacity(0.5),
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/logo.jpg',
                            height: 100.0,
                            width: 100.0,
                          ),
                          SizedBox(height: 20.0),
                          Text(
                            'Connexion',
                            style: TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                            ),
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email_outlined,
                                  color: Colors.blue.shade800),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer votre adresse e-mail.';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value)) {
                                return 'Veuillez entrer une adresse e-mail valide.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15.0),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Mot de passe',
                              prefixIcon: Icon(Icons.lock_outline,
                                  color: Colors.blue.shade800),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.blue.shade800,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            obscureText: !_isPasswordVisible,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer votre mot de passe.';
                              }
                              return null;
                            },
                          ),
                          if (_errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _resetPassword,
                              child: Text(
                                'Mot de passe oublié ?',
                                style: TextStyle(color: Colors.blue.shade800),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _isLoading ? null : _loginUser,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade800,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50.0, vertical: 15.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: _isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    'Se connecter',
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.white),
                                  ),
                          ),
                          SizedBox(height: 15.0),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/signup'); // Use named route
                            },
                            child: Text(
                              'Pas de compte ? S\'inscrire',
                              style: TextStyle(
                                color: Colors.blue.shade800,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
