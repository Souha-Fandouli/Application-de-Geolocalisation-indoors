import 'package:flutter/material.dart';
import 'bloc_selection_page.dart'; // Importez BlocSelectionPage

class PositionPage1 extends StatelessWidget {
  final String selectedPosition; // Bloc de départ

  // Map des étages disponibles pour chaque bloc
  final Map<String, List<String>> blocEtages = {
    'Bloc A': ['Rez-de-chaussée', '1er étage', '2ème étage', '3ème étage'],
    'Bloc B': ['Rez-de-chaussée', '1er étage'],
    'Bloc C': ['Rez-de-chaussée', '1er étage'],
    'Bloc D': ['Rez-de-chaussée'],
    'Bloc G': ['Rez-de-chaussée', '1er étage'],
    'Administration': ['Rez-de-chaussée', '1er étage'],
    'Bibliotheque': ['Rez-de-chaussée'],
    'Labo': ['Rez-de-chaussée'],
    'Dep_MEC': ['Rez-de-chaussée'],
  };

  PositionPage1({
    required this.selectedPosition,
    Key? key,
  }) : super(key: key);

  // Méthode pour naviguer vers BlocSelectionPage avec animation
  void _navigateToBlocSelection(BuildContext context, String etage) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            BlocSelectionPage(
          selectedPosition: selectedPosition,
          fromEtage: etage,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Récupérer les étages disponibles pour le bloc de départ
    List<String> availableEtages = blocEtages[selectedPosition] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Étages de $selectedPosition',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade900, Colors.blue.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade50.withOpacity(0.8),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Titre introductif
                AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(milliseconds: 800),
                  child: Text(
                    'Sélectionnez votre étage',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Choisissez l\'étage où vous vous trouvez dans $selectedPosition',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Liste des étages
                Expanded(
                  child: ListView.builder(
                    itemCount: availableEtages.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final etage = availableEtages[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                          child: Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: Colors.white.withOpacity(0.95),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 10.0,
                              ),
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue.shade100,
                                child: Icon(
                                  Icons.stairs,
                                  color: Colors.blue.shade800,
                                  size: 28,
                                ),
                              ),
                              title: Text(
                                etage,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade900,
                                ),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.blue.shade800,
                                size: 20,
                              ),
                              onTap: () =>
                                  _navigateToBlocSelection(context, etage),
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
        ),
      ),
    );
  }
}
