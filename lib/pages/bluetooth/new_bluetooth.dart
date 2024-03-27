import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mypod/utils/AppState.dart';
import 'package:provider/provider.dart';

class FlutterBlueApp extends StatelessWidget {
  const FlutterBlueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.lightBlue),
      home: StreamBuilder<BluetoothState>(
        stream: FlutterBlue.instance.state,
        initialData: BluetoothState.unknown,
        builder: (context, snapshot) {
          if (snapshot.data == BluetoothState.on) {
            return const FindDevicesScreen();
          }
          return BluetoothOffScreen(state: snapshot.data);
        },
      ),
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  final BluetoothState? state;

  const BluetoothOffScreen({super.key, this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.bluetooth_disabled,
                size: 200.0, color: Colors.black),
            Text(
              'Adaptateur Bluetooth est : ${state != null ? state.toString().substring(15) : 'pas disponible'}.',
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

class FindDevicesScreen extends StatelessWidget {
  const FindDevicesScreen({super.key});
  final String targetDeviceMacAddress = "80:07:94:3D:EB:C6";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Veuillez sélectionner le périphérique correspondant au Pod',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
            StreamBuilder<List<ScanResult>>(
              stream: FlutterBlue.instance.scanResults,
              initialData: const [],
              builder: (context, snapshot) {
                return Column(
                  children: snapshot.data!
                      .map((result) => Card(
                            color: result.device.id.toString().toUpperCase() ==
                                    targetDeviceMacAddress.toUpperCase()
                                ? Colors.red[100]
                                : Colors.white,
                            margin: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: Icon(Icons.bluetooth,
                                  color: result.device.id
                                              .toString()
                                              .toUpperCase() ==
                                          targetDeviceMacAddress.toUpperCase()
                                      ? Colors.red
                                      : null),
                              title: Text(result.device.name.isEmpty
                                  ? "Périphérique Inconnu"
                                  : result.device.name),
                              subtitle: Text(result.device.id.toString()),
                              trailing: ElevatedButton(
                                onPressed: () => _onConnectButtonPressed(
                                    context, result.device),
                                child: Text(result.device.state ==
                                        BluetoothDeviceState.connected
                                    ? 'Se déconnecter'
                                    : 'Se connecter'),
                              ),
                            ),
                          ))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => FlutterBlue.instance.isScanning.first.then(
            (isScanning) => isScanning
                ? FlutterBlue.instance.stopScan()
                : FlutterBlue.instance
                    .startScan(timeout: const Duration(seconds: 5))),
        backgroundColor: Colors.lightBlue,
        child: const Icon(Icons.bluetooth_searching),
      ),
    );
  }
}

void _onConnectButtonPressed(
    BuildContext context, BluetoothDevice device) async {
  final appState = Provider.of<AppState>(context, listen: false);
  // Se connecter au périphérique
  await device.connect();
  device.state.listen((state) async {
    if (state == BluetoothDeviceState.connected) {
      appState
          .updateConnectionStatus(true); // Mettre à jour l'état de connexion

      // Ici, vous appelez startInsulinScan après avoir vérifié que vous êtes connecté
      appState.startInsulinScan();

      // Découvrez les services une fois que la connexion est établie
      var services = await device.discoverServices();
      for (var service in services) {
        if (service.uuid == Guid("33cc5e8f-70cb-42ce-8735-e66069152830")) {
          for (var characteristic in service.characteristics) {
            if (characteristic.uuid ==
                Guid("be25802a-a0b1-4387-91ad-7734702b0ede")) {
              await characteristic
                  .setNotifyValue(true); // S'abonner à la caractéristique
              characteristic.value.listen((value) {
                // Traitement de la valeur reçue pour mise à jour de l'UI ou de l'état
                double insulinRemaining = convertBytesToDouble(
                    value); // Supposant que cette fonction existe
                appState.updateInsulinRemaining(insulinRemaining);
              });
            }
          }
        }
      }
    } else if (state == BluetoothDeviceState.disconnected) {
      appState.updateConnectionStatus(false); // Gérer la déconnexion
    }
  });
}

double convertBytesToDouble(List<int> bytes) {
  // Assurez-vous que le tableau de bytes a la bonne longueur (8 bytes pour un double)
  if (bytes.length < 8) {
    throw const FormatException(
        "Le tableau de bytes est trop court pour un double.");
  }

  // Créez un buffer de bytes à partir de votre liste d'entiers
  final byteBuffer = ByteData.sublistView(Uint8List.fromList(bytes));

  // Lisez la valeur double, en supposant un ordre d'octets Big Endian par défaut
  // Utilisez byteBuffer.getFloat64(0, Endian.little) pour Little Endian
  return byteBuffer.getFloat64(0, Endian.big);
}
