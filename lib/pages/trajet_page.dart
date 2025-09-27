import 'package:flutter/material.dart';
import 'classes_page.dart';

class TrajetPage extends StatelessWidget {
  final String trajetKey;
  final String destination;
  final String selectedPosition;
  final String fromEtage;

  const TrajetPage({
    required this.trajetKey,
    required this.destination,
    required this.selectedPosition,
    required this.fromEtage,
    super.key,
  });

  static const Map<String, String> trajetImages = {
    'Bloc A → Bloc C': 'assets/images/A-C.png',
    'Bloc C → Bloc A': 'assets/images/C-A.png',
    'Bloc A → Bloc B': 'assets/images/A-B.PNG',
    'Bloc C → Bloc D': 'assets/images/C-D.PNG',
    'Bloc B → Bloc A': 'assets/images/B-A.PNG',
    'Bloc A → Bloc D': 'assets/images/A-D.png',
    'Bloc D → Bloc A': 'assets/images/D-A.png',
    'Bloc D → Bloc C': 'assets/images/D-C.png',
    'Bloc A → Bloc G': 'assets/images/A-G.PNG',
    'Bloc G → Bloc A': 'assets/images/G-A.PNG',
    'Bloc A → Administration': 'assets/images/A-admi.png',
    'Bloc C → Administration': 'assets/images/C-admi.png',
    'Administration → Bloc A': 'assets/images/Admi-A.png',
    'Administration → Bloc C': 'assets/images/Admi-C.png',
    'Administration → Administration': 'assets/images/Administration.PNG',
    'Bloc A → Bloc A': 'assets/images/BlocA.PNG',
    'Bloc B → Bloc B': 'assets/images/BlocB.PNG',
    'Bloc C → Bloc C': 'assets/images/BlocC.PNG',
    'Bloc D → Bloc D': 'assets/images/BlocD.PNG',
    'Bloc G → Bloc G': 'assets/images/BlocG.PNG',
    'Bloc A → Bibliotheque': 'assets/images/A-bib.png',
    'Bibliotheque → Bloc A': 'assets/images/bib-A.png',
    'Bloc A → Dep_MEC': 'assets/images/A-mec.png',
    'Dep_MEC → Bloc A': 'assets/images/mec-A.png',
    'Dep_MEC → Bloc C': 'assets/images/mec-C.png',
    'Dep_MEC → Labo': 'assets/images/mec-labo.png',
    'Labo → Dep_MEC': 'assets/images/labo-mec.png',
    'Bibliotheque → Labo': 'assets/images/bib-labo.png',
    'Labo → Bibliotheque': 'assets/images/labo-bib.png',
    'Bloc A → Labo': 'assets/images/A-labo.png',
    'Bloc B → Bloc G': 'assets/images/B-G.png',
    'Bloc G → Bloc B': 'assets/images/G-B.png',
    'Administration → Bloc B': 'assets/images/admi-B.png',
    'Administration → Bloc G': 'assets/images/admi-G.png',
    'Bloc B → Administration': 'assets/images/B-admi.png',
    'Bloc G → Administration': 'assets/images/G-admi.png',
    'Administration → Bibliotheque': 'assets/images/Admi-bib.png',
    'Administration → Dep_MEC': 'assets/images/Admi-mec.png',
    'Bloc C → Dep_MEC': 'assets/images/C-mec.png',
    'Bloc C → Bibliotheque': 'assets/images/C-biblio.png',
    'Bibliotheque → Bloc C': 'assets/images/bib-C.png',
  };

  void _confirmArrival(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Confirmer l\'arrivée',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade900,
          ),
        ),
        content: Text(
          'Êtes-vous arrivé(e) à $destination ?',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Non',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade800,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClassesPage(
                    blocName: destination,
                    etage: fromEtage,
                  ),
                ),
              );
            },
            child: const Text(
              'Oui',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 8,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final trajetImage = trajetImages[trajetKey] ?? 'assets/images/default.png';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Trajet vers $destination',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Current Location Card
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.white.withOpacity(0.95),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade800,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Départ: Hall de $selectedPosition',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Map Image
                Expanded(
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: FutureBuilder(
                      future: precacheImage(AssetImage(trajetImage), context),
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
                          trajetImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: Colors.grey.shade200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.map_outlined,
                                  size: 60,
                                  color: Color(0xfffefbfb),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Trajet non disponible',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Action Buttons
                ElevatedButton(
                  onPressed: () => _confirmArrival(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    shadowColor: Colors.blue.shade300,
                  ),
                  child: Text(
                    'Confirmer l\'arrivée à $destination',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.blue.shade800, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Retour',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue.shade800,
                      fontWeight: FontWeight.w600,
                    ),
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
