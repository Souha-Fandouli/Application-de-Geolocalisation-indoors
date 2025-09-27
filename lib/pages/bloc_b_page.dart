import 'package:flutter/material.dart';

class BlocBPage extends StatelessWidget {
  const BlocBPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bloc B',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade800,
        elevation: 10,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: InteractiveViewer(
                boundaryMargin: EdgeInsets.all(0), // Réduire les marges
                minScale: 0.5,
                maxScale: 4.0,
                scaleEnabled: true,
                panEnabled: true,
                child: Image.asset(
                  'assets/images/rez_de_chaussée_B.PNG', // Chemin de l'image du Bloc B
                  fit: BoxFit.contain, // Ajuster l'image dans le conteneur
                  errorBuilder: (context, error, stackTrace) {
                    return Text(
                      'Image non disponible',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red.shade600,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton.extended(
              onPressed: () {
                // Afficher une notification pour signaler l'escalier
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.directions_walk, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          'Montez l\'escalier',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    duration: Duration(seconds: 5), // Durée du message
                    backgroundColor: Colors.green.shade600,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );

                // Navigation vers la page du premier étage après un délai
                Future.delayed(Duration(seconds: 5), () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PremierEtageBlocBPage(),
                    ),
                  );
                });
              },
              icon: Icon(Icons.arrow_upward, color: Colors.white),
              label: Text(
                'Aller au Premier Étage',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              tooltip: 'Aller au premier étage',
              backgroundColor: Colors.blue.shade800,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Page du Premier Étage pour le Bloc B
class PremierEtageBlocBPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Premier Étage - Bloc B',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade800,
        elevation: 10,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          boundaryMargin: EdgeInsets.all(0), // Réduire les marges
          minScale: 0.5,
          maxScale: 4.0,
          scaleEnabled: true,
          panEnabled: true,
          child: Image.asset(
            'assets/images/premier_etage B-C.PNG', // Chemin de l'image du premier étage du Bloc B
            fit: BoxFit.contain, // Ajuster l'image dans le conteneur
            errorBuilder: (context, error, stackTrace) {
              return Text(
                'Image non disponible',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red.shade600,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
