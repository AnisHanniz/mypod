import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mypod/pages/home.dart';
import 'package:mypod/pages/app_navigation_screen/app_navigation_screen.dart';
import 'package:mypod/pages/login_screen/login_screen.dart';
import 'package:mypod/pages/signup_screen/signup_screen.dart';
import 'package:mypod/pages/splash_screen/splash_screen.dart';
import 'package:mypod/utils/app_routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      initialRoute: '/', // Définissez votre route initiale si nécessaire
      routes: {
        '/': (context) =>
            AppNavigationScreen(), // Route pour votre écran de navigation
        AppRoutes.splashScreen: (context) =>
            SplashScreen(), // Route pour l'écran de splash
        AppRoutes.loginScreen: (context) =>
            LoginScreen(), // Route pour l'écran de connexion
        AppRoutes.signupScreen: (context) =>
            SignupScreen(), // Route pour l'écran d'inscription
        AppRoutes.accueilScreen: (context) =>
            HomePage(), // Route pour l'écran d'inscription
        // ... autres routes ...
      },
    );
  }
}
