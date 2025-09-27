import 'package:flutter/material.dart';
import 'classes_page.dart'; // Importez ClassesPage
import 'TrajetVersHallPage.dart'; // Importez TrajetVersHallPage

class BlocSelectionPage extends StatelessWidget {
  final String selectedPosition; // Bloc de départ
  final String fromEtage; // Étage actuel

  const BlocSelectionPage({
    required this.selectedPosition,
    required this.fromEtage,
    Key? key,
  }) : super(key: key);

  // Liste des destinations possibles
  static const List<String> destinations = [
    'Bloc A',
    'Bloc B',
    'Bloc C',
    'Bloc D',
    'Bloc G',
    'Administration',
    'Bibliotheque',
    'Dep_MEC',
    'Labo',
  ];

  // Map des images pour chaque bloc/département
  static const Map<String, String> departmentImages = {
    'Bloc A': 'assets/images/BlocA.PNG',
    'Bloc B': 'assets/images/BlocB.PNG',
    'Bloc C': 'assets/images/BlocC.PNG',
    'Bloc D': 'assets/images/BlocD.PNG',
    'Bloc G': 'assets/images/BlocG.PNG',
    'Administration': 'assets/images/Administration.PNG',
    'Bibliotheque': 'assets/images/bib.PNG',
    'Dep_MEC': 'assets/images/dep_mec.png',
    'Labo': 'assets/images/atelier.PNG',
  };

  @override
  Widget build(BuildContext context) {
    final imagePath =
        departmentImages[selectedPosition] ?? 'assets/images/default.png';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sélectionnez votre destination',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade800, Colors.blue.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Image du bloc de départ avec animation
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    imagePath,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 50,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Texte indiquant la position actuelle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Position actuelle : $selectedPosition, $fromEtage',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            // Grille des destinations
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 colonnes
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2, // Largeur/hauteur des tuiles
                ),
                itemCount: destinations.length,
                itemBuilder: (context, index) {
                  final destination = destinations[index];

                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      onTap: () {
                        if (destination == selectedPosition) {
                          // Si la destination est le même bloc, aller à ClassesPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ClassesPage(
                                blocName: destination,
                                etage: fromEtage,
                              ),
                            ),
                          );
                        } else {
                          // Sinon, guider vers le hall puis vers la destination
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TrajetVersHallPage(
                                selectedPosition: selectedPosition,
                                selectedDestination: destination,
                                etage: fromEtage,
                              ),
                            ),
                          );
                        }
                      },
                      borderRadius: BorderRadius.circular(15),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.blue.shade800,
                              size: 28,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                destination,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
