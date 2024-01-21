import 'package:mypod/models/bluetooth_manager.dart';
import 'pages/home.dart';
import 'package:flutter/material.dart';
import 'pages/setupPw.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<bool> checkAuthentication() async {
    return Future.delayed(Duration(seconds: 2),
        () => true); // Simule une authentification réussie après 2 secondes
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: FutureBuilder<bool>(
        future: checkAuthentication(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Gérer les erreurs ici
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final isUserAuthenticated = snapshot.data ?? false;
            final BluetoothManager bluetoothManager = BluetoothManager();
            return isUserAuthenticated
                ? HomePage(
                    bluetoothManager: bluetoothManager,
                  )
                : SetupPasswordPage();
          }
        },
      ),
    );
  }
}
