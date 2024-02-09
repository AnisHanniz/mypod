import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothState extends StatefulWidget {
  const BluetoothState({Key? key}) : super(key: key);

  @override
  State<BluetoothState> createState() => _BluetoothState();
}

class _BluetoothState extends State<BluetoothState> {
  bool isConnected = false;
  FlutterBluePlus flutterBlue = FlutterBluePlus();
  List<BluetoothDevice> devices = [];

  Future<void> requestBluetoothScanPermission() async {
    PermissionStatus status = await Permission.bluetoothScan.request();
    if (status.isDenied) {}
  }

  void scanBluetoothDevices() async {
    await requestBluetoothScanPermission();
    await FlutterBluePlus.startScan();
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (!devices.contains(result.device)) {
          setState(() {
            devices.add(result.device);
          });
        }
      }
    });
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Connexion Réussie"),
            content: Text("Vous êtes connécté à : ${device.platformName}"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Connexion Interrompue"),
            content: Text("Connexion à ${device.platformName} interrompue."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Périphériques Bluetooth'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: devices.isEmpty
                ? Center(
                    child: Text("Aucun périphérique"),
                  )
                : ListView.builder(
                    itemCount: devices.length,
                    itemBuilder: (context, index) {
                      final deviceName = devices[index].name;
                      final displayName =
                          deviceName != null && deviceName.isNotEmpty
                              ? deviceName
                              : "Périphérique inconnu";

                      return ListTile(
                        onTap: () {
                          connectToDevice(devices[index]);
                        },
                        title: Text(displayName),
                        subtitle: Text(devices[index].remoteId.toString()),
                      );
                    },
                  ),
          ),
          FloatingActionButton(
            onPressed: scanBluetoothDevices,
            child: const Icon(Icons.bluetooth_searching_rounded),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
