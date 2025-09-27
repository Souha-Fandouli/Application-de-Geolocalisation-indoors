import 'package:flutter/material.dart';

class BIBLIOPAGE extends StatelessWidget {
  const BIBLIOPAGE({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bibliotheque',
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
          child: Image.asset(
            'assets/images/biblio.png', // Chemin de l'image du Bloc D
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
    );
  }
}
