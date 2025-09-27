import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'app_drawer.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _newBlocName;
  String? _newClassName;

  @override
  void initState() {
    super.initState();
    _checkAdminAccess();
  }

  Future<void> _checkAdminAccess() async {
    final user = _auth.currentUser;
    const adminEmails = ['admin@example.com', 'admin2@example.com'];
    if (user == null || !adminEmails.contains(user.email)) {
      Navigator.pushReplacementNamed(
          context, '/home'); // Redirige vers '/home' (WelcomePage)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Accès réservé aux administrateurs')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      drawer: AppDrawer(currentPage: 'admin'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Ajouter un nouveau bloc',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Nom du bloc',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                      onChanged: (value) {
                        setState(() {
                          _newBlocName = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _addBloc,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Ajouter le bloc',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Blocs',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('blocs').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                var blocs = snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: blocs.length,
                  itemBuilder: (context, index) {
                    var bloc = blocs[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ExpansionTile(
                        title: Text(bloc['name']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _showEditBlocDialog(bloc.id, bloc['name']);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _deleteBloc(bloc.id);
                              },
                            ),
                          ],
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Nom de la classe',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _newClassName = value;
                                    });
                                  },
                                ),
                                SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    if (_newClassName != null &&
                                        _newClassName!.isNotEmpty) {
                                      _addClassToBloc(bloc.id);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Veuillez entrer un nom de classe')),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    'Ajouter la classe',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Classes existantes',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 16),
                                StreamBuilder<QuerySnapshot>(
                                  stream: _firestore
                                      .collection('classes')
                                      .where('blocId', isEqualTo: bloc.id)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData)
                                      return CircularProgressIndicator();
                                    var classes = snapshot.data!.docs;
                                    return Column(
                                      children: classes.map((doc) {
                                        return ListTile(
                                          title: Text(doc['name']),
                                          trailing: IconButton(
                                            icon: Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () {
                                              _deleteClass(doc.id);
                                            },
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addBloc() async {
    if (_newBlocName == null || _newBlocName!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez entrer un nom de bloc')),
      );
      return;
    }

    try {
      await _firestore.collection('blocs').add({
        'name': _newBlocName,
        'timestamp': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bloc ajouté avec succès!')),
      );
      setState(() {
        _newBlocName = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de l\'ajout du bloc: $e')),
      );
    }
  }

  Future<void> _deleteBloc(String blocId) async {
    try {
      await _firestore.collection('blocs').doc(blocId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bloc supprimé avec succès!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de la suppression du bloc: $e')),
      );
    }
  }

  void _showEditBlocDialog(String blocId, String currentName) {
    TextEditingController _controller =
        TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Modifier le bloc'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Nom du bloc',
            ),
          ),
          actions: [
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Enregistrer'),
              onPressed: () {
                _updateBloc(blocId, _controller.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateBloc(String blocId, String newName) async {
    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez entrer un nom de bloc')),
      );
      return;
    }

    try {
      await _firestore.collection('blocs').doc(blocId).update({
        'name': newName,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bloc mis à jour avec succès!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de la mise à jour du bloc: $e')),
      );
    }
  }

  Future<void> _addClassToBloc(String blocId) async {
    if (_newClassName == null || _newClassName!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez entrer un nom de classe')),
      );
      return;
    }

    try {
      await _firestore.collection('classes').add({
        'name': _newClassName,
        'blocId': blocId,
        'timestamp': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Classe ajoutée avec succès!')),
      );
      setState(() {
        _newClassName = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de l\'ajout de la classe: $e')),
      );
    }
  }

  Future<void> _deleteClass(String classId) async {
    try {
      await _firestore.collection('classes').doc(classId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Classe supprimée avec succès!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de la suppression de la classe: $e')),
      );
    }
  }

  Future<void> _logout() async {
    try {
      await _auth.signOut();
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de la déconnexion: $e')),
      );
    }
  }
}
