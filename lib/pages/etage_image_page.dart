import 'package:flutter/material.dart';

class EtageImagePage extends StatefulWidget {
  final String blocName;
  final String etage;
  final String imagePath;

  const EtageImagePage({
    required this.blocName,
    required this.etage,
    required this.imagePath,
    super.key,
  });

  @override
  _EtageImagePageState createState() => _EtageImagePageState();
}

class _EtageImagePageState extends State<EtageImagePage> {
  final TransformationController _transformationController =
      TransformationController();
  double _scale = 1.0; // Échelle initiale
  static const double _minScale = 0.5; // Échelle minimale
  static const double _maxScale = 5.0; // Échelle maximale
  static const double _zoomStep = 0.5; // Pas de zoom par clic

  // Fonction pour zoomer en avant
  void _zoomIn() {
    setState(() {
      _scale = (_scale + _zoomStep).clamp(_minScale, _maxScale);
      _updateTransformation();
    });
  }

  // Fonction pour zoomer en arrière
  void _zoomOut() {
    setState(() {
      _scale = (_scale - _zoomStep).clamp(_minScale, _maxScale);
      _updateTransformation();
    });
  }

  // Met à jour la matrice de transformation pour appliquer le zoom
  void _updateTransformation() {
    _transformationController.value = Matrix4.identity()..scale(_scale);
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.blocName} - ${widget.etage}',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade900,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade900, Colors.blue.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.zoom_in),
            onPressed: _zoomIn,
            tooltip: 'Zoom',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Card(
                  elevation: 8,
                  margin: const EdgeInsets.all(16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InteractiveViewer(
                    transformationController: _transformationController,
                    panEnabled: true,
                    boundaryMargin: const EdgeInsets.all(20),
                    minScale: _minScale,
                    maxScale: _maxScale,
                    child: FutureBuilder(
                      future:
                          precacheImage(AssetImage(widget.imagePath), context),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.blue.shade800),
                            ),
                          );
                        }
                        return Image.asset(
                          widget.imagePath,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_not_supported,
                                    size: 60,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Image non disponible',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
              // Zoom Controls
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton.small(
                      onPressed: _zoomOut,
                      backgroundColor: Colors.blue.shade800,
                      child: const Icon(Icons.zoom_out),
                      tooltip: 'Zoom arrière',
                    ),
                    const SizedBox(width: 20),
                    FloatingActionButton.small(
                      onPressed: _zoomIn,
                      backgroundColor: Colors.blue.shade800,
                      child: const Icon(Icons.zoom_in),
                      tooltip: 'Zoom avant',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
