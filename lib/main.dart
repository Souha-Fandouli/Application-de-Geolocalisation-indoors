import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/admin_page.dart';
import 'pages/welcome_page.dart';
import 'pages/profile_page.dart';
import 'pages/settings_page.dart';
import 'pages/positionBloc_page.dart';
import 'pages/position.dart';
import 'pages/bloc_selection_page.dart';
import 'pages/classes_page.dart';
import 'pages/etage_image_page.dart';
import 'pages/TrajetVersHallPage.dart';
import 'pages/trajet_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ISET Navigation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login', // Commence par la page de connexion
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/admin': (context) => AdminPage(),
        '/welcome': (context) => WelcomePage(),
        '/profile': (context) => ProfilePage(),
        '/settings': (context) => SettingsPage(),
        '/positionBloc': (context) => PositionBlocPage(),
        '/positionEtage': (context) => PositionPage1(
              selectedPosition:
                  ModalRoute.of(context)?.settings.arguments as String? ??
                      'Bloc A',
            ),
        '/blocSelection': (context) => BlocSelectionPage(
              selectedPosition:
                  ModalRoute.of(context)?.settings.arguments as String? ??
                      'Bloc A',
              fromEtage:
                  ModalRoute.of(context)?.settings.arguments as String? ??
                      'Rez-de-chaussée',
            ),
        '/classes': (context) => ClassesPage(
              blocName: ModalRoute.of(context)?.settings.arguments as String? ??
                  'Bloc A',
              etage: ModalRoute.of(context)?.settings.arguments as String? ??
                  'Rez-de-chaussée',
            ),
        '/etageImage': (context) => EtageImagePage(
              blocName: ModalRoute.of(context)?.settings.arguments as String? ??
                  'Bloc A',
              etage: ModalRoute.of(context)?.settings.arguments as String? ??
                  'Rez-de-chaussée',
              imagePath:
                  ModalRoute.of(context)?.settings.arguments as String? ??
                      'assets/images/default.png',
            ),
        '/trajetVersHall': (context) => TrajetVersHallPage(
              selectedPosition:
                  ModalRoute.of(context)?.settings.arguments as String? ??
                      'Bloc A',
              selectedDestination:
                  ModalRoute.of(context)?.settings.arguments as String? ??
                      'Bloc C',
              etage: ModalRoute.of(context)?.settings.arguments as String? ??
                  'Rez-de-chaussée',
            ),
        '/trajet': (context) => TrajetPage(
              trajetKey:
                  ModalRoute.of(context)?.settings.arguments as String? ??
                      'Bloc A → Bloc C',
              destination:
                  ModalRoute.of(context)?.settings.arguments as String? ??
                      'Bloc C',
              selectedPosition:
                  ModalRoute.of(context)?.settings.arguments as String? ??
                      'Bloc A',
              fromEtage:
                  ModalRoute.of(context)?.settings.arguments as String? ??
                      'Rez-de-chaussée',
            ),
      },
    );
  }
}
