import 'package:flutter/material.dart';
import 'package:mypod/utils/AppState.dart';
import 'package:mypod/utils/app_constants.dart';
import 'package:provider/provider.dart';

class StatePod extends StatelessWidget {
  const StatePod({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    Icon connectionIcon = appState.isConnectedToPump
        ? const Icon(Icons.check_circle, color: Colors.white)
        : const Icon(Icons.error, color: Colors.red);

    return Padding(
      padding: const EdgeInsets.all(22.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          connectionIcon,
          Text(
            appState.isConnectedToPump ? 'Connecté' : 'Déconnecté',
            style: TextStyle(
              color:
                  appState.isConnectedToPump ? AppConstants.violet : Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
