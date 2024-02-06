import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mypod/pages/bdd/database_viewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mypod/pages/bdd/database.dart';
import 'package:mypod/pages/bluetooth/bluetooth_connect_page.dart';
import 'package:mypod/pages/home.dart';
import 'package:mypod/pages/app_navigation_screen/app_navigation_screen.dart';
import 'package:mypod/pages/login_screen/login_screen.dart';
import 'package:mypod/pages/signup_screen/signup_screen.dart';
import 'package:mypod/pages/splash_screen/splash_screen.dart';
import 'package:mypod/utils/app_routes.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await initPathProvider();
  final databaseProvider = DatabaseProvider();
  final database = await databaseProvider.initDB();
  initializeDateFormatting('fr', null);
  runApp(
    MyApp(database),
  );
}

Future<void> initPathProvider() async {
  WidgetsFlutterBinding.ensureInitialized();
  await getApplicationDocumentsDirectory();
}

class MyApp extends StatelessWidget {
  final Database database;

  const MyApp(this.database, {Key? key}) : super(key: key);

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
            FirstConnectionScreen(), // Route pour l'écran d'inscription
        AppRoutes.accueilScreen: (context) =>
            HomePage(), // Route pour l'écran d'accueil
        AppRoutes.bluetoothScreen: (context) => BluetoothConnectPage(),
        AppRoutes.databaseViewerScreen: (context) => DatabaseViewerScreen(),
      },
    );
  }
}
