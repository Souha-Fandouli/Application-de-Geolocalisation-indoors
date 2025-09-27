import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';
import 'admin_page.dart'; // Import the AdminPage

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _secretCodeController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  String? _selectedRole;

  // Password conditions
  bool _hasMinLength = false;
  bool _hasSpecialChar = false;
  bool _hasNumber = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Animation controllers
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    // Start animations
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Verify the secret code for admin signup
      if (_selectedRole == 'admin' &&
          _secretCodeController.text != 'ADMIN123') {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Invalid secret code for admin signup.';
        });
        return;
      }

      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Save user data to Firestore with role
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'role': _selectedRole ??
              'user', // Default to 'user' if no role is selected
          'createdAt': Timestamp.now(),
        });

        // Redirect to appropriate page based on role
        if (_selectedRole == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminPage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          if (e.code == 'email-already-in-use') {
            _errorMessage = 'Un compte existe déjà avec cet e-mail.';
          } else {
            _errorMessage = 'Une erreur s\'est produite. Veuillez réessayer.';
          }
        });
      } catch (e) {
        setState(() {
          _errorMessage = 'Une erreur s\'est produite. Veuillez réessayer.';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Check password conditions
  void _checkPasswordConditions(String password) {
    setState(() {
      _hasMinLength = password.length >= 8;
      _hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
      _hasNumber = password.contains(RegExp(r'[0-9]'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Image.asset(
                          'assets/images/logo.jpg',
                          height: 100.0,
                          width: 100.0,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          'Inscription',
                          style: TextStyle(
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      SlideTransition(
                        position: _slideAnimation,
                        child: TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Nom complet',
                            prefixIcon: Icon(Icons.person_outline,
                                color: Colors.blue.shade800),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  BorderSide(color: Colors.blue.shade800),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 10.0),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre nom complet.';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 15.0),
                      SlideTransition(
                        position: _slideAnimation,
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined,
                                color: Colors.blue.shade800),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  BorderSide(color: Colors.blue.shade800),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 10.0),
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
                      ),
                      SizedBox(height: 15.0),
                      SlideTransition(
                        position: _slideAnimation,
                        child: TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Mot de passe',
                            prefixIcon: Icon(Icons.lock_outline,
                                color: Colors.blue.shade800),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  BorderSide(color: Colors.blue.shade800),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 10.0),
                          ),
                          obscureText: true,
                          onChanged: (value) {
                            _checkPasswordConditions(value);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre mot de passe.';
                            }
                            if (value.length < 8) {
                              return 'Le mot de passe doit contenir au moins 8 caractères.';
                            }
                            if (!value
                                .contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                              return 'Le mot de passe doit contenir au moins un caractère spécial.';
                            }
                            if (!value.contains(RegExp(r'[0-9]'))) {
                              return 'Le mot de passe doit contenir au moins un chiffre.';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 10.0),
                      SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Le mot de passe doit contenir :',
                              style: TextStyle(
                                color: Colors.blue.shade800,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              '• Au moins 8 caractères',
                              style: TextStyle(
                                color:
                                    _hasMinLength ? Colors.green : Colors.red,
                              ),
                            ),
                            Text(
                              '• Au moins un caractère spécial',
                              style: TextStyle(
                                color:
                                    _hasSpecialChar ? Colors.green : Colors.red,
                              ),
                            ),
                            Text(
                              '• Au moins un chiffre',
                              style: TextStyle(
                                color: _hasNumber ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15.0),
                      SlideTransition(
                        position: _slideAnimation,
                        child: DropdownButtonFormField<String>(
                          value: _selectedRole,
                          hint: Text('Sélectionnez un rôle'),
                          items: ['user', 'admin'].map((String role) {
                            return DropdownMenuItem<String>(
                              value: role,
                              child: Text(role),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Veuillez sélectionner un rôle.';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 15.0),
                      if (_selectedRole == 'admin')
                        SlideTransition(
                          position: _slideAnimation,
                          child: TextFormField(
                            controller: _secretCodeController,
                            decoration: InputDecoration(
                              labelText: 'Secret Code',
                              prefixIcon:
                                  Icon(Icons.lock, color: Colors.blue.shade800),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:
                                    BorderSide(color: Colors.blue.shade800),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 10.0),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (_selectedRole == 'admin' &&
                                  (value == null || value.isEmpty)) {
                                return 'Veuillez entrer le code secret.';
                              }
                              return null;
                            },
                          ),
                        ),
                      SizedBox(height: 20.0),
                      if (_errorMessage != null)
                        SlideTransition(
                          position: _slideAnimation,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: 20.0),
                      SlideTransition(
                        position: _slideAnimation,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _registerUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade800,
                            padding: EdgeInsets.symmetric(
                                horizontal: 50.0, vertical: 15.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 5.0,
                            shadowColor: Colors.blue.withOpacity(0.5),
                          ),
                          child: _isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  'S\'inscrire',
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.white),
                                ),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      SlideTransition(
                        position: _slideAnimation,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          },
                          child: Text(
                            'Déjà un compte ? Se connecter',
                            style: TextStyle(
                              color: Colors.blue.shade800,
                              fontWeight: FontWeight.bold,
                            ),
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
    );
  }
}
