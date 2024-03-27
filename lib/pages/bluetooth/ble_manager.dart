import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';

class BluetoothManager {
  final FlutterBlue _flutterBlue = FlutterBlue.instance;
  late final void Function(bool) onConnectionStatusChanged;
  String? _deviceAddress; // The address of the pump device.
  StreamSubscription<BluetoothDevice>? _deviceConnectionSubscription;

  BluetoothManager({required this.onConnectionStatusChanged}) {
    _initBluetoothState();
  }

  void setDeviceAddress(String address) {
    _deviceAddress = address;
    monitorConnection();
  }

  void _initBluetoothState() {
    _flutterBlue.state.listen((state) {
      if (state != BluetoothState.on) {
        // If Bluetooth is turned off, we assume the device gets disconnected
        onConnectionStatusChanged(false);
      }
    });
  }

  Future<bool> isConnected() async {
    return _deviceAddress != null &&
        await _flutterBlue.connectedDevices.then((devices) =>
            devices.any((device) => device.id.toString() == _deviceAddress));
  }

  void monitorConnection() {
    print("ici");
    _deviceConnectionSubscription?.cancel(); // Cancel any previous subscription
    _deviceConnectionSubscription = _flutterBlue.connectedDevices
        .asStream()
        .expand((devices) => devices)
        .listen((device) {
      final isConnected = device.id.toString() == _deviceAddress;
      onConnectionStatusChanged(isConnected);
    });
  }

  void dispose() {
    _deviceConnectionSubscription?.cancel(); // Prevent memory leaks
  }
}
