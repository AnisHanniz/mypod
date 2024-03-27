import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:mypod/utils/app_constants.dart';
import 'package:permission_handler/permission_handler.dart';

class NewBluetooth extends StatefulWidget {
  final Function(bool isConnected, double insulinRemaining, double podLifetime)
      onDeviceConnected;

  const NewBluetooth(
      {super.key,
      required this.onDeviceConnected,
      required Null Function(bool isConnected) onConnectionStatusChanged});

  @override
  State<NewBluetooth> createState() => _NewBluetoothState();
}

class DeviceInfo {
  BluetoothDevice device;
  DeviceConnectionState state;

  DeviceInfo(
      {required this.device, this.state = DeviceConnectionState.notConnected});
}

enum DeviceConnectionState { connected, notConnected, connecting }

class _NewBluetoothState extends State<NewBluetooth> {
  final _scannedDevices = ValueNotifier<List<DeviceInfo>>([]);
  BluetoothAdapterState? _bluetoothAdapterState;
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;
  StreamSubscription<List<ScanResult>>? _scanResultsSubscription;
  bool _isConnecting = false;

  final String SERVICE_UUID = "12345678-1234-1234-1234-1234567890ab";
  final String INSULIN_REMAINING_CHARACTERISTIC_UUID =
      "12345678-1234-1234-1234-1234567890ac";
  final String POD_LIFETIME_CHARACTERISTIC_UUID =
      "12345678-1234-1234-1234-1234567890ad";

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _listenToBluetoothState();
  }

  Future<void> _requestPermissions() async {
    var status = await Permission.bluetoothScan.request();
    if (status != PermissionStatus.granted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Bluetooth Permission"),
          content:
              const Text("This app needs Bluetooth permission to function."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  void _listenToBluetoothState() {
    _adapterStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      setState(() => _bluetoothAdapterState = state);
    });
  }

  void _startScan() {
    _scannedDevices.value = [];
    _scanResultsSubscription?.cancel();
    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      if (!mounted) return;
      setState(() {
        _scannedDevices.value =
            results.map((result) => DeviceInfo(device: result.device)).toList();
      });
    });
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
  }

  Future<void> _connectToDevice(DeviceInfo deviceInfo) async {
    if (_isConnecting) return;

    setState(() {
      _isConnecting = true;
      deviceInfo.state = DeviceConnectionState.connecting;
    });

    try {
      await deviceInfo.device.connect(autoConnect: false);
      if (!mounted) return;

      final insulinRemaining = await fetchDataFromDevice(
          deviceInfo.device, INSULIN_REMAINING_CHARACTERISTIC_UUID);
      final podLifetime = await fetchDataFromDevice(
          deviceInfo.device, POD_LIFETIME_CHARACTERISTIC_UUID);

      setState(() {
        deviceInfo.state = DeviceConnectionState.connected;
        _isConnecting = false;
      });

      widget.onDeviceConnected(true, insulinRemaining, podLifetime);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        deviceInfo.state = DeviceConnectionState.notConnected;
        _isConnecting = false;
      });

      widget.onDeviceConnected(false, 0.0, 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan des appareils Bluetooth'),
        backgroundColor: AppConstants.violet, // Exemple de personnalisation
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text(
                _bluetoothAdapterState == BluetoothAdapterState.on
                    ? "Bluetooth ACTIVÉ"
                    : "Bluetooth DÉSACTIVÉ",
                style: TextStyle(
                    color: _bluetoothAdapterState == BluetoothAdapterState.on
                        ? Colors.green
                        : Colors.red),
              ),
            ),
            ElevatedButton(
              onPressed: _bluetoothAdapterState == BluetoothAdapterState.on
                  ? _startScan
                  : null,
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.deepPurple), // Personnalisation du bouton
              child: const Text("Connecter à la pompe"),
            ),
            ValueListenableBuilder<List<DeviceInfo>>(
              valueListenable: _scannedDevices,
              builder: (context, devices, child) {
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: devices.length,
                  itemBuilder: (context, index) {
                    final deviceInfo = devices[index];
                    return Card(
                      // Utilisation de Card pour chaque dispositif
                      elevation: 4.0,
                      child: ListTile(
                        leading: const Icon(Icons.bluetooth,
                            color: Colors.deepPurple), // Ajout d'une icône
                        title: Text(deviceInfo.device.platformName.isEmpty
                            ? 'Unknown device'
                            : deviceInfo.device.platformName),
                        subtitle: Text(
                            '${deviceInfo.device.remoteId} - ${_getConnectionStatusText(deviceInfo.state)}'),
                        trailing:
                            deviceInfo.state == DeviceConnectionState.connecting
                                ? const CircularProgressIndicator()
                                : null,
                        onTap: _isConnecting
                            ? null
                            : () => _connectToDevice(deviceInfo),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getConnectionStatusText(DeviceConnectionState state) {
    switch (state) {
      case DeviceConnectionState.connected:
        return "Connected";
      case DeviceConnectionState.connecting:
        return "Connecting";
      case DeviceConnectionState.notConnected:
      default:
        return "Not connected";
    }
  }

  @override
  void dispose() {
    _scannedDevices.dispose();
    _adapterStateSubscription?.cancel();
    _scanResultsSubscription?.cancel();
    FlutterBluePlus.stopScan();
    super.dispose();
  }

  Future<double> fetchDataFromDevice(
      BluetoothDevice device, String characteristicUuid) async {
    try {
      List<BluetoothService> services = await device.discoverServices();
      for (BluetoothService service in services) {
        if (service.uuid.toString() == SERVICE_UUID) {
          for (BluetoothCharacteristic characteristic
              in service.characteristics) {
            if (characteristic.uuid.toString() == characteristicUuid) {
              List<int> value = await characteristic.read();
              // Convert the characteristic value to your data format
              // This is just an example conversion; adjust according to your actual data format
              double dataValue = convertValueToDouble(value);
              return dataValue;
            }
          }
        }
      }
    } catch (e) {
      print("Error fetching data from device: $e");
    }
    return 0.0; // Return a default value in case of failure
  }

  double convertValueToDouble(List<int> value) {
    if (value.isEmpty) return 0.0;
    return value.first.toDouble();
  }
}
