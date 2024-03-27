import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mypod/pages/app_navigation_screen/app_navigation_screen.dart';
import 'package:mypod/pages/bdd/api_testeur.dart';
import 'package:mypod/pages/bdd/database.dart';
import 'package:mypod/pages/bdd/database_viewer.dart';
import 'package:mypod/pages/bluetooth/new_bluetooth.dart';
import 'package:mypod/pages/home.dart';
import 'package:mypod/pages/login_screen/login_screen.dart';
import 'package:mypod/pages/premiere_connexion/premiere_connexion.dart';
import 'package:mypod/pages/splash_screen/splash_screen.dart';
import 'package:mypod/utils/AppState.dart';
import 'package:mypod/utils/app_routes.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

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
    ChangeNotifierProvider<AppState>(
      create: (context) => AppState(),
      child: MyApp(database),
    ),
  );
}

Future<void> initPathProvider() async {
  WidgetsFlutterBinding.ensureInitialized();
  await getApplicationDocumentsDirectory();
}

class MyApp extends StatelessWidget {
  final Database database;

  const MyApp(this.database, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      initialRoute: '/',
      routes: {
        '/': (context) => const AppNavigationScreen(),
        AppRoutes.splashScreen: (context) => const SplashScreen(),
        AppRoutes.loginScreen: (context) => const LoginScreen(),
        AppRoutes.signupScreen: (context) => FirstConnectionScreen(),
        AppRoutes.accueilScreen: (context) => const HomePage(),
        AppRoutes.databaseViewerScreen: (context) => DatabaseViewerScreen(),
        AppRoutes.apiTesteur: (context) => const ApiTester(),
        AppRoutes.allBLuetooth: (context) => const FlutterBlueApp(),
      },
    );
  }
}
