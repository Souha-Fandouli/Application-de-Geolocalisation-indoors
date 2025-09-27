import 'package:flutter/material.dart';
import 'trajet_page.dart'; // Importez TrajetPage

class TrajetVersHallPage extends StatelessWidget {
  final String selectedPosition; // Bloc de départ
  final String selectedDestination; // Bloc de destination
  final String etage; // Étage actuel

  const TrajetVersHallPage({
    required this.selectedPosition,
    required this.selectedDestination,
    required this.etage,
    Key? key,
  }) : super(key: key);

  // Instructions pour atteindre le hall depuis l'étage actuel
  String _getInstructionsToHall(String etage) {
    const etagesOrder = [
      'Rez-de-chaussée',
      '1er étage',
      '2ème étage',
      '3ème étage',
    ];
    final fromIndex = etagesOrder.indexOf(etage);
    if (fromIndex == -1) return 'Étage non reconnu.';
    if (fromIndex == 0)
      return 'Vous êtes déjà au rez-de-chaussée.\nDirigez-vous vers le hall.';
    final steps = fromIndex;
    return 'Descendez $steps étage${steps > 1 ? "s" : ""}\npour atteindre le hall au rez-de-chaussée.';
  }

  // Confirmer l'arrivée au hall et passer à TrajetPage
  void _confirmArrival(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        elevation: 8,
        title: const Text(
          'Confirmer l\'arrivée',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
            fontSize: 20,
          ),
        ),
        content: Text(
          'Avez-vous atteint le hall de $selectedPosition ?',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Non',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade800,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TrajetPage(
                    trajetKey: '$selectedPosition → $selectedDestination',
                    destination: selectedDestination,
                    selectedPosition: selectedPosition,
                    fromEtage: 'Rez-de-chaussée',
                  ),
                ),
              );
            },
            child: const Text(
              'Oui',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Vers le hall de $selectedPosition',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
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
      extendBodyBehindAppBar: true, // Permet au contenu de passer sous l'AppBar
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
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Position actuelle avec animation
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.white.withOpacity(0.95),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blue.shade100,
                            child: Icon(
                              Icons.location_on,
                              color: Colors.blue.shade800,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Position actuelle',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '$selectedPosition, $etage',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Instructions avec animation
                Expanded(
                  child: AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(milliseconds: 800),
                    child: Container(
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.shade100.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.blue.shade100,
                            child: const Icon(
                              Icons.directions_walk,
                              size: 40,
                              color: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Instructions',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            _getInstructionsToHall(etage),
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Boutons avec animation
                Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                      child: ElevatedButton(
                        onPressed: () => _confirmArrival(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade800,
                          padding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 40,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 8,
                          shadowColor: Colors.blueAccent.withOpacity(0.5),
                        ),
                        child: const Text(
                          'Confirmer l\'arrivée au hall',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Colors.blue.shade800,
                            width: 2,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 40,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          'Retour',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
