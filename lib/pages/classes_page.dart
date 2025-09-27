import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'etage_image_page.dart';

class ClassesPage extends StatefulWidget {
  final String blocName;
  final String etage;

  const ClassesPage({
    required this.blocName,
    required this.etage,
    super.key,
  });

  @override
  _ClassesPageState createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage>
    with SingleTickerProviderStateMixin {
  List<String> filteredClasses = [];
  List<String> allClasses = [];
  bool isLoading = true;
  String? errorMessage;
  String? _blocId;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final Map<String, Map<String, String>> blocEtageImages = {
    'Bloc A': {
      'Rez-de-chaussée': 'assets/images/rez_de_chaussée_A.png',
      '1er étage': 'assets/images/premier_etageA.PNG',
      '2ème étage': 'assets/images/deuxieme_etageA.PNG',
      '3ème étage': 'assets/images/troisieme_etageA.PNG',
    },
    'Bloc B': {
      'Rez-de-chaussée': 'assets/images/BlocB.PNG',
      '1er étage': 'assets/images/BlocB1.PNG',
    },
    'Bloc C': {
      'Rez-de-chaussée': 'assets/images/rez_de_chaussée_c.PNG',
      '1er étage': 'assets/images/premier_etage.PNG',
    },
    'Bloc D': {
      'Rez-de-chaussée': 'assets/images/BlocD.PNG',
      '1er étage': 'assets/images/BlocD1.PNG',
    },
    'Bloc G': {
      'Rez-de-chaussée': 'assets/images/BlocB.PNG',
      '1er étage': 'assets/images/BlocB1.PNG',
    },
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _fetchBlocIdAndClasses();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchBlocIdAndClasses() async {
    try {
      final blocSnapshot = await FirebaseFirestore.instance
          .collection('blocs')
          .where('name', isEqualTo: widget.blocName)
          .limit(1)
          .get();

      if (blocSnapshot.docs.isEmpty) {
        setState(() {
          errorMessage = 'Aucun bloc trouvé pour ${widget.blocName}';
          isLoading = false;
        });
        return;
      }

      _blocId = blocSnapshot.docs.first.id;

      final classesSnapshot = await FirebaseFirestore.instance
          .collection('classes')
          .where('blocId', isEqualTo: _blocId)
          .get();

      setState(() {
        allClasses =
            classesSnapshot.docs.map((doc) => doc['name'] as String).toList();
        filteredClasses = allClasses;
        isLoading = false;
        _animationController.forward();
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Erreur lors du chargement : $e';
        isLoading = false;
      });
    }
  }

  List<String> _filterClasses(String query) {
    if (query.isEmpty) return allClasses;
    return allClasses
        .where((classe) => classe.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  String _getEtageFromClasse(String classe) {
    if (classe.length >= 2) {
      final etageChar = classe[1];
      switch (etageChar) {
        case '0':
          return 'Rez-de-chaussée';
        case '1':
          return '1er étage';
        case '2':
          return '2ème étage';
        case '3':
          return '3ème étage';
        default:
          return 'Rez-de-chaussée';
      }
    }
    return 'Rez-de-chaussée';
  }

  void _showFloorChangeInstructions(BuildContext context, String classe) {
    final etageCible = _getEtageFromClasse(classe);
    String instructions = etageCible == widget.etage
        ? 'Vous êtes déjà à l\'étage correct.'
        : '''
• Prenez les escaliers vers $etageCible
• Suivez les panneaux indiquant $classe
• Consultez la carte si nécessaire''';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Directions vers $classe',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade900,
          ),
        ),
        content: Text(
          instructions,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Annuler',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade800,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(context);
              _confirmArrival(context, etageCible);
            },
            child: const Text(
              'Voir la carte',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmArrival(BuildContext context, String etage) {
    final imagePath =
        blocEtageImages[widget.blocName]?[etage] ?? 'assets/images/default.png';

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => EtageImagePage(
          blocName: widget.blocName,
          etage: etage,
          imagePath: imagePath,
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Classes - ${widget.blocName}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
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
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.blue.shade800),
                ),
              )
            : errorMessage != null
                ? Center(
                    child: Text(
                      errorMessage!,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SearchAnchor(
                            builder: (context, controller) => SearchBar(
                              controller: controller,
                              padding: const MaterialStatePropertyAll(
                                  EdgeInsets.symmetric(horizontal: 16.0)),
                              hintText: 'Rechercher une classe...',
                              leading: Icon(
                                Icons.search,
                                color: Colors.blue.shade800,
                              ),
                              elevation:
                                  const MaterialStatePropertyAll<double>(4),
                              backgroundColor: MaterialStatePropertyAll(
                                  Colors.white.withOpacity(0.95)),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onTap: () => controller.openView(),
                              onChanged: (query) {
                                setState(() {
                                  filteredClasses = _filterClasses(query);
                                });
                              },
                            ),
                            suggestionsBuilder: (context, controller) {
                              final query = controller.text;
                              final suggestions = _filterClasses(query);
                              return suggestions.map((classe) => ListTile(
                                    title: Text(classe),
                                    onTap: () {
                                      controller.closeView(classe);
                                      setState(() {
                                        filteredClasses = [classe];
                                      });
                                    },
                                  ));
                            },
                          ),
                        ),
                        Expanded(
                          child: filteredClasses.isEmpty
                              ? Center(
                                  child: Text(
                                    'Aucune classe trouvée',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: filteredClasses.length,
                                  itemBuilder: (context, index) {
                                    final classe = filteredClasses[index];
                                    return AnimatedOpacity(
                                      opacity: 1.0,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      child: Card(
                                        elevation: 6,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: ListTile(
                                          leading: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.blue.shade800,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.meeting_room,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                          title: Text(
                                            classe,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          trailing: const Icon(
                                            Icons.arrow_forward_ios,
                                            size: 16,
                                          ),
                                          onTap: () =>
                                              _showFloorChangeInstructions(
                                                  context, classe),
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
    );
  }
}
