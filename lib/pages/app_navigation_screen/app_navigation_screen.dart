import 'package:flutter/material.dart';
import 'package:mypod/utils/app_constants.dart';
import 'package:mypod/utils/app_routes.dart';

class AppNavigationScreen extends StatelessWidget {
  const AppNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFFFFFFF),
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
                    screenTitle: "BDD Locale",
                    routeName: AppRoutes.databaseViewerScreen,
                  ),
                  _buildScreenTitle(
                    context,
                    screenTitle: "Testeur API",
                    routeName: AppRoutes.apiTesteur,
                  ),
                  _buildScreenTitle(
                    context,
                    screenTitle: "Bluetooth",
                    routeName: AppRoutes.allBLuetooth,
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
      color: const Color(0XFFFFFFFF),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            AppConstants.imageLogo,
            height: 160,
            width: 400,
          ),
          const Text(
            "Menu Debug",
            style: TextStyle(
              color: Color(0XFF888888),
              fontSize: 16,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
            ),
          ),
          const Divider(
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
        color: const Color(0XFFFFFFFF),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              screenTitle,
              style: const TextStyle(
                color: Color(0XFF000000),
                fontSize: 20,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
              ),
            ),
            const Divider(
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
