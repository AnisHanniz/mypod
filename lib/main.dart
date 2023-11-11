import 'package:mypod/models/bluetooth_manager.dart';
import 'package:mypod/pages/authManager.dart';
import 'package:mypod/pages/home.dart';
import 'package:mypod/pages/setupPw.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: FutureBuilder<bool>(
        future: AuthManager().isUserAuthenticated(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Handle error when authentication fails
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final isUserAuthenticated = snapshot.data ?? false;
            final BluetoothManager bluetoothManager =
                BluetoothManager(); // Create an instance
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
