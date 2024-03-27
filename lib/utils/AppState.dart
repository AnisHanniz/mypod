import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class AppState extends ChangeNotifier {
  double? _insulinRemaining;
  double? _podLifetime;
  String _nom = '';
  String _prenom = '';
  bool _isConnectedToPump = false;

  AppState() {
    //listenForInsulinData();
  }
  void startInsulinScan() {
    if (!_isConnectedToPump) {
      print(
          "Non connecté au serveur, le scan pour l'insuline n'est pas initié.");
      return;
    }
  }

  void listenForInsulinData() {
    FlutterBlue flutterBlue = FlutterBlue.instance;

    // Définir les UUIDs du service et de la caractéristique
    const String serviceUUID = "33cc5e8f-70cb-42ce-8735-e66069152830";
    const String characteristicUUID = "be25802a-a0b1-4387-91ad-7734702b0ede";

    // Début de scan pour trouver les dispositifs Bluetooth
    flutterBlue.startScan(timeout: const Duration(seconds: 4));

    flutterBlue.scanResults.listen((results) {
      for (ScanResult result in results) {
        var device = result.device;

        // Tente de se connecter uniquement si l'appareil a le service recherché
        if (result.advertisementData.serviceUuids.contains(serviceUUID)) {
          print(
              '${device.name} found with desired service! rssi: ${result.rssi}');

          // Se connecter au dispositif
          device.connect().then((_) {
            print("Connected to ${device.name}");

            // Découvrir les services après la connexion
            device.discoverServices().then((services) {
              for (var service in services) {
                if (service.uuid.toString() == serviceUUID) {
                  for (var characteristic in service.characteristics) {
                    if (characteristic.uuid.toString() == characteristicUUID) {
                      // S'abonner à la caractéristique
                      characteristic.setNotifyValue(true);
                      characteristic.value.listen((value) {
                        // Convertir les bytes en double
                        double insulinValue = convertBytesToDouble(value);
                        print("Insulin remaining: $insulinValue");
                        // Mettre à jour l'état avec la nouvelle valeur d'insuline
                        // (Assurez-vous que cette méthode existe et fait ce qu'il faut)
                        updateInsulinRemaining(insulinValue);
                      });
                    }
                  }
                }
              }
            });
          }).catchError((error) {
            print("Failed to connect to ${device.name}: $error");
          });

          // Arrêter le scan après la première connexion réussie pour simplifier
          flutterBlue.stopScan();
          break; // Sortie de la boucle for une fois connecté
        }
      }
    });
  }

  double convertBytesToDouble(List<int> valueBytes) {
    // Utilisez le même code que fourni précédemment pour la conversion
    final byteBuffer = ByteData.sublistView(Uint8List.fromList(valueBytes));
    return byteBuffer.getFloat64(0, Endian.little);
  }

  void updateInsulinRemaining(double targetRemaining) {
    insulinRemaining = targetRemaining;
  }

  // Rendre la méthode publique pour permettre les mises à jour de l'extérieur
  void updateConnectionStatus(bool isConnected) {
    if (_isConnectedToPump != isConnected) {
      _isConnectedToPump = isConnected;
      notifyListeners();
    }
  }

  // Les méthodes getter et setter pour _isConnectedToPump
  bool get isConnectedToPump => _isConnectedToPump;
  set isConnectedToPump(bool value) {
    if (_isConnectedToPump != value) {
      _isConnectedToPump = value;
      notifyListeners();
    }
  }

  // Les méthodes getter et setter pour _insulinRemaining
  double get insulinRemaining => _insulinRemaining ?? 200.0;
  set insulinRemaining(double value) {
    if (_insulinRemaining != value) {
      _insulinRemaining = value;
      notifyListeners();
    }
  }

  // Les méthodes getter et setter pour _podLifetime
  double get podLifetime => _podLifetime ?? 0.0;
  set podLifetime(double value) {
    if (_podLifetime != value) {
      _podLifetime = value;
      notifyListeners();
    }
  }

  // Les méthodes getter et setter pour _nom
  String get nom => _nom;
  set nom(String value) {
    if (_nom != value) {
      _nom = value;
      notifyListeners();
    }
  }

  // Les méthodes getter et setter pour _prenom
  String get prenom => _prenom;
  set prenom(String value) {
    if (_prenom != value) {
      _prenom = value;
      notifyListeners();
    }
  }
}
