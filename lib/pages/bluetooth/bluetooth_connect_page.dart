<<<<<<< Updated upstream
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
=======
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
>>>>>>> Stashed changes

class BluetoothConnectPage extends StatefulWidget {
  const BluetoothConnectPage({Key? key}) : super(key: key);
  @override
  _BluetoothConnectPageState createState() => _BluetoothConnectPageState();
}

class _BluetoothConnectPageState extends State<BluetoothConnectPage> {
<<<<<<< Updated upstream
  FlutterBluePlus flutterBlue = new FlutterBluePlus();
  List<BluetoothDevice> devicesList = [];
=======
  FlutterBluePlus flutterBlue = FlutterBluePlus();
  List<BluetoothDevice> devicesList = [];
  StreamSubscription? scanSubscription;
>>>>>>> Stashed changes

  @override
  void initState() {
    super.initState();
    _initBluetooth();
  }

<<<<<<< Updated upstream
  Future<void> _initBluetooth() async {
    try {
      List<BluetoothDevice> connectedDevices =
          await FlutterBluePlus.connectedDevices;
      setState(() {
        devicesList = connectedDevices;
      });
      FlutterBluePlus.scanResults.listen((results) {
        for (ScanResult r in results) {
          if (!devicesList.contains(r.device)) {
            setState(() => devicesList.add(r.device));
          }
        }
      });

      // Scan
      FlutterBluePlus.startScan();
    } catch (e) {
      print('Erreur lors de l\'initialisation de Bluetooth: $e');
=======
  @override
  void dispose() {
    FlutterBluePlus.stopScan();
    scanSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initBluetooth() async {
    try {
      PermissionStatus status = await Permission.bluetooth.request();

      if (status.isGranted) {
        List<BluetoothDevice> connectedDevices =
            await FlutterBluePlus.connectedDevices;
        setState(() {
          devicesList = connectedDevices;
        });

        scanSubscription = FlutterBluePlus.scanResults.listen((results) {
          for (ScanResult r in results) {
            if (!devicesList.any((device) => device.id == r.device.id)) {
              setState(() => devicesList.add(r.device));
            }
          }
        });

        FlutterBluePlus.startScan(timeout: Duration(seconds: 10));
      } else if (status.isPermanentlyDenied) {
      } else {
        print('Bluetooth permission denied');
      }
    } catch (e) {
      print('Error initializing Bluetooth: $e');
>>>>>>> Stashed changes
    }
  }

  ListView _buildListViewOfDevices() {
    List<Container> containers = [];
    for (BluetoothDevice device in devicesList) {
      containers.add(
        Container(
          height: 50,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
<<<<<<< Updated upstream
                    Text(device.name == '' ? '(unknown device)' : device.name),
=======
                    Text(
                        device.name.isEmpty ? '(unknown device)' : device.name),
>>>>>>> Stashed changes
                    Text(device.id.toString())
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.blue),
                child: Text(
                  'Connect',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
<<<<<<< Updated upstream
                  // TODO: Implémenter la fonction de connexion
=======
                  // Implement the connection logic here
>>>>>>> Stashed changes
                },
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[...containers],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Devices'),
      ),
      body: _buildListViewOfDevices(),
    );
  }
}
