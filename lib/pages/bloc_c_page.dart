import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bloc C',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DestinationPage(),
    );
  }
}

class DestinationPage extends StatefulWidget {
  @override
  _DestinationPageState createState() => _DestinationPageState();
}

class _DestinationPageState extends State<DestinationPage>
    with SingleTickerProviderStateMixin {
  final List<String> rezDeChausseeClasses = [
    'CO1',
    'CO2',
    'CO3',
    'CO4',
    'CO5',
    'CO6',
    'premier étage',
  ];

  String? selectedClass;

  // Positions des classes sur l'image (ajustez ces valeurs en fonction de votre image)
  final Map<String, Rect> classPositions = {
    'CO1': Rect.fromLTWH(290, 212, 50, 100),
    'CO2': Rect.fromLTWH(175, 212, 88, 73),
    'CO3': Rect.fromLTWH(96, 212, 86, 73),
    'CO4': Rect.fromLTWH(254, 25, 94, 69),
    'CO5': Rect.fromLTWH(178, 26, 86, 71),
    'CO6': Rect.fromLTWH(96, 27, 86, 71),
    'premier étage': Rect.fromLTWH(280, 120, 50, 60),
  };

  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: Colors.transparent,
      end: Colors.red.withOpacity(0.5),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onClassSelected(String? newValue) {
    setState(() {
      selectedClass = newValue;
    });
    if (newValue != null) {
      if (newValue == 'premier étage') {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Instructions'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/escalier.png', // Ajoutez une image de l'escalier
                    height: 100,
                    width: 100,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Montez l\'escalier pour accéder au premier étage.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PremierEtagePage(),
                      ),
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$newValue sélectionnée',
              style: TextStyle(fontSize: 16),
            ),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedPosition =
        selectedClass != null ? classPositions[selectedClass] : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Destination',
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
        actions: [
          IconButton(
            icon: Icon(Icons.help, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Aide'),
                    content: Text(
                      'Sélectionnez votre classe dans la liste déroulante. '
                      'Si vous allez au premier étage, suivez les instructions pour monter l\'escalier.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      InteractiveViewer(
                        boundaryMargin: EdgeInsets.all(20),
                        minScale: 0.5,
                        maxScale: 4.0,
                        child: Image.asset(
                          'assets/images/rez_de_chaussée_c.PNG',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text(
                                'Image non disponible',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.red.shade600,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      if (selectedPosition != null)
                        Positioned.fromRect(
                          rect: selectedPosition,
                          child: AnimatedBuilder(
                            animation: _colorAnimation,
                            builder: (context, child) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: _colorAnimation.value,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Classes du Rez-de-Chaussée',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue.shade800, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButton<String>(
                  value: selectedClass,
                  hint: Text(
                    'Sélectionnez une classe',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  isExpanded: true,
                  underline: SizedBox(),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.blue.shade800,
                  ),
                  items: rezDeChausseeClasses.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: _onClassSelected,
                ),
              ),
              if (selectedClass != null)
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedClass = null;
                    });
                  },
                  child: Text(
                    'Réinitialiser la sélection',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class PremierEtagePage extends StatefulWidget {
  @override
  _PremierEtagePageState createState() => _PremierEtagePageState();
}

class _PremierEtagePageState extends State<PremierEtagePage>
    with SingleTickerProviderStateMixin {
  final List<String> premierEtageClasses = [
    'C101',
    'C102',
    'C103',
    'C104',
  ];

  String? selectedClass;

  // Positions des classes sur l'image du premier étage (ajustez ces valeurs)
  final Map<String, Rect> classPositions = {
    'C101': Rect.fromLTWH(175, 200, 80, 73),
    'C102': Rect.fromLTWH(96, 200, 80, 73),
    'C103': Rect.fromLTWH(96, 27, 86, 71),
    'C104': Rect.fromLTWH(178, 27, 86, 71),
  };

  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: Colors.transparent,
      end: Colors.red.withOpacity(0.5),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onClassSelected(String? newValue) {
    setState(() {
      selectedClass = newValue;
    });
    if (newValue != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$newValue sélectionnée',
            style: TextStyle(fontSize: 16),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedPosition =
        selectedClass != null ? classPositions[selectedClass] : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Premier Étage',
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      InteractiveViewer(
                        boundaryMargin: EdgeInsets.all(20),
                        minScale: 0.5,
                        maxScale: 4.0,
                        child: Image.asset(
                          'assets/images/premier_etage.PNG',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text(
                                'Image non disponible',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.red.shade600,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      if (selectedPosition != null)
                        Positioned.fromRect(
                          rect: selectedPosition,
                          child: AnimatedBuilder(
                            animation: _colorAnimation,
                            builder: (context, child) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: _colorAnimation.value,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Bienvenue au premier étage !',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Choisissez votre classe :',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue.shade800, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButton<String>(
                  value: selectedClass,
                  hint: Text(
                    'Sélectionnez une classe',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  isExpanded: true,
                  underline: SizedBox(),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.blue.shade800,
                  ),
                  items: premierEtageClasses.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: _onClassSelected,
                ),
              ),
              if (selectedClass != null)
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedClass = null;
                    });
                  },
                  child: Text(
                    'Réinitialiser la sélection',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Retour au Rez-de-Chaussée',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
