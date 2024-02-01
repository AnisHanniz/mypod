import 'package:flutter/material.dart';
import 'package:mypod/utils/app_routes.dart';

class AppNavigationScreen extends StatelessWidget {
  const AppNavigationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFFFFFFF),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAppNavigation(context),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildScreenTitle(
                    context,
                    screenTitle: "Splash Screen",
                    routeName: AppRoutes.splashScreen,
                  ),
                  _buildScreenTitle(
                    context,
                    screenTitle: "Se Connecter",
                    routeName: AppRoutes.loginScreen,
                  ),
                  _buildScreenTitle(
                    context,
                    screenTitle: "S'enregistrer",
                    routeName: AppRoutes.signupScreen,
                  ),
                  _buildScreenTitle(
                    context,
                    screenTitle: "Accueil",
                    routeName: AppRoutes.accueilScreen,
                  ),
                  _buildScreenTitle(
                    context,
                    screenTitle: "Liste des Patients",
                    routeName: AppRoutes.patientsScreen,
                  ),
                  _buildScreenTitle(
                    context,
                    screenTitle: "Bluetooth",
                    routeName: AppRoutes.bluetoothScreen,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppNavigation(BuildContext context) {
    return Container(
      color: Color(0XFFFFFFFF),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "App Navigation",
            style: TextStyle(
              color: Color(0XFF000000),
              fontSize: 20,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "DEMO",
            style: TextStyle(
              color: Color(0XFF888888),
              fontSize: 16,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: Color(0XFF000000),
          ),
        ],
      ),
    );
  }

  Widget _buildScreenTitle(
    BuildContext context, {
    required String screenTitle,
    required String routeName,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Container(
        color: Color(0XFFFFFFFF),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              screenTitle,
              style: TextStyle(
                color: Color(0XFF000000),
                fontSize: 20,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: Color(0XFF888888),
            ),
          ],
        ),
      ),
    );
  }
}
