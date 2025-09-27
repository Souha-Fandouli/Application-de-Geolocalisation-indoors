import 'package:flutter/material.dart';

class AdministrationPage extends StatelessWidget {
  const AdministrationPage({Key? key}) : super(key: key);

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
        title: const Text(
          'Administration - Rez-de-chaussée',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade800,
        elevation: 10,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(100),
        minScale: 0.5,
        maxScale: 4.0,
        scaleEnabled: true,
        panEnabled: true,
        transformationController: _transformationController,
        child: SizedBox.expand(
          child: Image.asset(
            'assets/images/administration0.PNG',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Text(
                  'Image non disponible',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Affichage d'une notification
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Montez l\'escalier pour accéder au premier étage!'),
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AdministrationFirstFloorPage(),
            ),
          );
        },
        icon: const Icon(Icons.arrow_upward, color: Colors.white),
        label: const Text(
          'Aller au 1er étage',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        tooltip: 'Aller au premier étage',
        backgroundColor: Colors.green.shade600,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}

class AdministrationFirstFloorPage extends StatelessWidget {
  const AdministrationFirstFloorPage({Key? key}) : super(key: key);

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
        title: const Text(
          'Administration - Premier étage',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade800,
        elevation: 10,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(100),
        minScale: 0.5,
        maxScale: 4.0,
        scaleEnabled: true,
        panEnabled: true,
        transformationController: _transformationController,
        child: SizedBox.expand(
          child: Image.asset(
            'assets/images/administration1.PNG',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Text(
                  'Image non disponible',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
