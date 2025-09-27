import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: BlocAPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class BlocAPage extends StatefulWidget {
  @override
  _BlocAPageState createState() => _BlocAPageState();
}

class _BlocAPageState extends State<BlocAPage>
    with SingleTickerProviderStateMixin {
  final List<String> rezDeChausseeClasses = [
    'A036',
    'A037',
    'A039.1',
    'A039.2',
    'A040',
    'A041.1',
    'A041.2',
    'A041',
    'A042',
    'A043',
    'A044',
    'A045',
    'premier étage',
  ];

  String? selectedClass;

  final Map<String, Rect> classPositions = {
    'A1': Rect.fromLTWH(290, 212, 50, 100),
    'A2': Rect.fromLTWH(175, 212, 88, 73),
    'A3': Rect.fromLTWH(96, 212, 86, 73),
    'A4': Rect.fromLTWH(254, 25, 94, 69),
    'A5': Rect.fromLTWH(178, 26, 86, 71),
    'A6': Rect.fromLTWH(96, 27, 86, 71),
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
      end: Colors.red.withOpacity(0.8),
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
            duration: Duration(seconds: 5),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        Future.delayed(Duration(seconds: 5), () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PremierEtagePage(),
            ),
          );
        });
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
          'Bloc A - Rez-de-Chaussée',
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
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
                            'assets/images/rez_de_chaussée_A.png',
                            fit: BoxFit.cover,
                            width: double.infinity,
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
                                    border: Border.all(
                                      color: _colorAnimation.value ??
                                          Colors.transparent,
                                      width: 3,
                                    ),
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
                    color: Colors.white,
                    border: Border.all(color: Colors.blue.shade800, width: 2),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
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
              ],
            ),
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
    'A139',
    'A140',
    'A143',
    'A144',
    'A145',
    'deuxieme etage',
  ];

  String? selectedClass;

  final Map<String, Rect> classPositions = {
    'A139': Rect.fromLTWH(175, 200, 80, 73),
    'A140': Rect.fromLTWH(96, 200, 80, 73),
    'A143': Rect.fromLTWH(96, 27, 86, 71),
    'A144': Rect.fromLTWH(178, 27, 86, 71),
    'deuxieme etage': Rect.fromLTWH(200, 27, 86, 71),
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
      end: Colors.red.withOpacity(0.8),
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
      if (newValue == 'deuxieme etage') {
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
            duration: Duration(seconds: 5),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        Future.delayed(Duration(seconds: 5), () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeuxiemeEtagePage(),
            ),
          );
        });
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
          'Premier Étage - Bloc A',
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
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
                            'assets/images/premier_etageA.PNG',
                            fit: BoxFit.cover,
                            width: double.infinity,
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
                                    border: Border.all(
                                      color: _colorAnimation.value ??
                                          Colors.transparent,
                                      width: 3,
                                    ),
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
                  'Classes du Premier Étage',
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
                    color: Colors.white,
                    border: Border.all(color: Colors.blue.shade800, width: 2),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DeuxiemeEtagePage extends StatefulWidget {
  @override
  _DeuxiemeEtagePageState createState() => _DeuxiemeEtagePageState();
}

class _DeuxiemeEtagePageState extends State<DeuxiemeEtagePage>
    with SingleTickerProviderStateMixin {
  final List<String> deuxiemeEtageClasses = [
    'A207',
    'A208',
    'A209',
    'A212',
    'A213',
    'troisieme etage',
  ];

  String? selectedClass;

  final Map<String, Rect> classPositions = {
    'A208': Rect.fromLTWH(175, 100, 80, 73),
    'A212': Rect.fromLTWH(85, 100, 76, 75),
    'A209': Rect.fromLTWH(96, 27, 86, 71),
    'A213': Rect.fromLTWH(20, 27, 30, 71),
    'A207': Rect.fromLTWH(200, 27, 75, 71),
    'troisieme etage': Rect.fromLTWH(215, 100, 20, 50),
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
      end: Colors.red.withOpacity(0.8),
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
      if (newValue == 'troisieme etage') {
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
            duration: Duration(seconds: 5),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        Future.delayed(Duration(seconds: 5), () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TroisiemeEtagePage(),
            ),
          );
        });
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
          'Deuxième Étage - Bloc A',
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
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
                            'assets/images/deuxieme_etageA.PNG',
                            fit: BoxFit.cover,
                            width: double.infinity,
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
                                    border: Border.all(
                                      color: _colorAnimation.value ??
                                          Colors.transparent,
                                      width: 3,
                                    ),
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
                  'Classes du Deuxième Étage',
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
                    color: Colors.white,
                    border: Border.all(color: Colors.blue.shade800, width: 2),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
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
                    items: deuxiemeEtageClasses.map((String value) {
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TroisiemeEtagePage extends StatefulWidget {
  @override
  _TroisiemeEtagePageState createState() => _TroisiemeEtagePageState();
}

class _TroisiemeEtagePageState extends State<TroisiemeEtagePage>
    with SingleTickerProviderStateMixin {
  final List<String> troisiemeEtageClasses = [
    'A301',
    'A302',
    'A303',
    'A304',
    'A305',
  ];

  String? selectedClass;

  final Map<String, Rect> classPositions = {
    'A301': Rect.fromLTWH(175, 200, 80, 73),
    'A302': Rect.fromLTWH(96, 200, 80, 73),
    'A303': Rect.fromLTWH(96, 27, 86, 71),
    'A304': Rect.fromLTWH(178, 27, 86, 71),
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
      end: Colors.red.withOpacity(0.8),
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

  @override
  Widget build(BuildContext context) {
    final selectedPosition =
        selectedClass != null ? classPositions[selectedClass] : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Troisième Étage - Bloc A',
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
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
                          offset: Offset(0, 5)),
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
                            'assets/images/troisieme_etageA.PNG',
                            fit: BoxFit.cover,
                            width: double.infinity,
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
                                    border: Border.all(
                                      color: _colorAnimation.value ??
                                          Colors.transparent,
                                      width: 3,
                                    ),
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
                  'Classes du Troisième Étage',
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
                    color: Colors.white,
                    border: Border.all(color: Colors.blue.shade800, width: 2),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: Offset(0, 3)),
                    ],
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
                    items: troisiemeEtageClasses.map((String value) {
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
