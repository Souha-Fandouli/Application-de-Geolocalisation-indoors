import 'package:flutter/material.dart';

class BlocGPage extends StatelessWidget {
  const BlocGPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TransformationController _transformationController =
        TransformationController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      const double scale = 2.0;
      final Size screenSize = MediaQuery.of(context).size;
      final double imageWidth = screenSize.width * 0.9;
      final double imageHeight = screenSize.height * 0.7;

      final double offsetX = (screenSize.width - imageWidth * scale) / 2;
      final double offsetY = (screenSize.height - imageHeight * scale) / 2;

      _transformationController.value = Matrix4.identity()
        ..scale(scale)
        ..translate(offsetX, offsetY);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bloc G',
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
                boundaryMargin: EdgeInsets.all(20),
                minScale: 0.5,
                maxScale: 4.0,
                scaleEnabled: true,
                panEnabled: true,
                transformationController: _transformationController,
                child: Image.asset(
                  'assets/images/rez_de_chaussée_G.PNG', // Chemin de l'image du Bloc G
                  fit: BoxFit.contain,
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
                      builder: (context) => PremierEtageBlocGPage(),
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

// Page du Premier Étage pour le Bloc G
class PremierEtageBlocGPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TransformationController _transformationController =
        TransformationController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      const double scale = 2.0;
      final Size screenSize = MediaQuery.of(context).size;
      final double imageWidth = screenSize.width * 0.9;
      final double imageHeight = screenSize.height * 0.7;

      final double offsetX = (screenSize.width - imageWidth * scale) / 2;
      final double offsetY = (screenSize.height - imageHeight * scale) / 2;

      _transformationController.value = Matrix4.identity()
        ..scale(scale)
        ..translate(offsetX, offsetY);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Premier Étage - Bloc G',
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
          boundaryMargin: EdgeInsets.all(20),
          minScale: 0.5,
          maxScale: 4.0,
          scaleEnabled: true,
          panEnabled: true,
          transformationController: _transformationController,
          child: Image.asset(
            'assets/images/premier_etageG.png', // Chemin de l'image du premier étage du Bloc G
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
