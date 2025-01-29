import 'dart:convert';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vbt_app/models/time_accel.dart';
import 'package:vbt_app/services/bluetooth/device_providers.dart';

class VBTBluetoothService {
  static const String vbtServiceUuid = "fbd477dd-d0c8-484a-b288-632366d17750";
  static const String accelCharacteristicUuid = "fbd7ca0a-1d3f-4563-b4c7-6323802840d1";

  static BluetoothCharacteristic? _accelCharacteristic;

  static void startScanning() {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
  }

  static void stopScanning() {
    FlutterBluePlus.stopScan();
  }

  static void connect(BluetoothDevice device, WidgetRef ref) async {
    var vbtDeviceNotifier = ref.read(vbtDeviceStateProvider.notifier);

    device.connectionState.listen((state) {
      if (state == BluetoothConnectionState.connected) {
        vbtDeviceNotifier.connected(device);
      } else {
        vbtDeviceNotifier.disconnected();
      }
    });

    vbtDeviceNotifier.connecting(device);
    try {
      await device.connect(timeout: const Duration(seconds: 3));
    } catch (e) {
      vbtDeviceNotifier.disconnected();
    }
    vbtDeviceNotifier.stoppedConnecting();
  }

  static void disconnect(BluetoothDevice device) async {
    device.disconnect();
  }

  static Future<void> discover(BluetoothDevice device, WidgetRef ref) async {
    await device.discoverServices();

    BluetoothService service =
    device.servicesList.firstWhere((service) => service.serviceUuid == Guid(vbtServiceUuid));

    _accelCharacteristic = service.characteristics.firstWhere(
            (characteristic) => characteristic.characteristicUuid == Guid(accelCharacteristicUuid));

    if (_accelCharacteristic != null) {
      await _accelCharacteristic!.setNotifyValue(true);
    }
  }

  static Stream<TimeAccel> accelerationDataStream() {
    if (_accelCharacteristic != null) {
      return _accelCharacteristic!.onValueReceived.map((bytes) {
        var message = utf8.decode(bytes).trim();
        var parts = message.split(':');
        var time = double.parse(parts[0]);
        var accel = (double.parse(parts[1]));

        return TimeAccel(time: time, accel: accel);
      });
    }

    return const Stream.empty();
  }
}
