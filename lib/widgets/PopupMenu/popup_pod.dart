import 'package:flutter/material.dart';
import 'package:mypod/pages/bluetooth/pod_dialog.dart';
import 'package:mypod/utils/AppState.dart';
import 'package:provider/provider.dart';

class PodPage extends StatefulWidget {
  const PodPage({super.key});

  @override
  _PodPageState createState() => _PodPageState();
}

class _PodPageState extends State<PodPage> {
  final AppState appState = AppState();
/*
  void launchBluetoothState(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewBluetooth(
          onConnectionStatusChanged: (bool isConnected) {
            // Ajoutez votre logique ici pour gérer le changement de connexion
            // Par exemple : imprimer un message lorsque la connexion change
            print("Connexion Bluetooth: $isConnected");
          },
          onDeviceConnected: (bool isConnected, double insulinRemaining,
              double podLifetime) {},
        ),
      ),
    );
  }
*/
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    bool isConnected = appState.isConnectedToPump;
    double insulinRemaining = appState.insulinRemaining;
    double podLifetimeRemaining = appState.podLifetime;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pod'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32.0),
          margin: const EdgeInsets.all(32.0),
          decoration: BoxDecoration(
            color: Colors.deepPurple.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                isConnected ? Icons.check_circle : Icons.error,
                color: isConnected ? Colors.deepPurple : Colors.red,
                size: 64.0,
              ),
              const SizedBox(height: 10.0),
              Text(
                isConnected ? 'Connecté' : 'Déconnecté',
                style: TextStyle(
                  fontSize: 24.0,
                  color: isConnected ? Colors.deepPurple : Colors.red,
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Quantité d\'insuline restante:',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 10.0),
              Text(
                '$insulinRemaining unités',
                style: const TextStyle(fontSize: 24.0),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Durée de vie restante du pod:',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 10.0),
              Text(
                '$podLifetimeRemaining jours',
                style: const TextStyle(fontSize: 24.0),
              ),
              ElevatedButton(
                onPressed: () {
                  showChangePodDialog(context, launchBluetoothState);
                },
                child: const Text("Changer le Pod"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
