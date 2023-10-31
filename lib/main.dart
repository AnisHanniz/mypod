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
          } else {
            final isUserAuthenticated = snapshot.data ?? false;
            return isUserAuthenticated ? HomePage() : SetupPasswordPage();
          }
        },
      ),
    );
  }
}
