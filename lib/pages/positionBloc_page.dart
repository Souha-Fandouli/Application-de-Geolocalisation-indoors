import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'position.dart'; // Import the EtageSelectionPage
import 'app_drawer.dart'; // Import the AppDrawer

class PositionBlocPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Indiquer votre bloc',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade800,
      ),
      drawer: AppDrawer(currentPage: 'positionBloc'), // Ajoutez le Drawer ici
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Carte interactive de l'établissement
              Container(
                height: MediaQuery.of(context).size.height * 0.45,
                width: double.infinity,
                child: InteractiveViewer(
                  minScale: 1.5,
                  maxScale: 4.0,
                  boundaryMargin: const EdgeInsets.all(50),
                  child: Transform.scale(
                    scale: 1.5,
                    child: Image.asset(
                      'assets/images/map1.PNG',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red.shade600,
                                size: 50,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Carte non disponible',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red.shade600,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Grille des blocs
              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('blocs').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  var blocs = snapshot.data!.docs;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2,
                    ),
                    itemCount: blocs.length,
                    itemBuilder: (context, index) {
                      var bloc = blocs[index];
                      String blocName = bloc['name'];

                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.location_on,
                            color: Colors.blue.shade800,
                          ),
                          title: Text(
                            blocName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          tileColor: Colors.white.withOpacity(0.7),
                          onTap: () {
                            // Naviguer vers la page de sélection de l'étage
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PositionPage1(
                                  selectedPosition: blocName,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
