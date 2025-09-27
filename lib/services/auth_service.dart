import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Connexion avec email et mot de passe
  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw e; // Gérer les erreurs dans l'UI
    }
  }

  // Inscription avec email, mot de passe, nom et rôle
  Future<User?> signup(
      String email, String password, String name, String role) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Enregistrer les informations supplémentaires dans Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'role': role, // Ajouter le rôle (par exemple, 'admin' ou 'user')
        'createdAt': Timestamp.now(),
      });

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw e; // Gérer les erreurs dans l'UI
    }
  }

  // Réinitialisation du mot de passe
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw e; // Gérer les erreurs dans l'UI
    }
  }

  // Récupérer le rôle de l'utilisateur
  Future<String?> getRole(String uid) async {
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(uid).get();
    return userDoc['role'];
  }
}
