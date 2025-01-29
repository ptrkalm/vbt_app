import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vbt_app/screens/device/connected_device_screen.dart';
import 'package:vbt_app/screens/device/scanning/scanning_screen.dart';
import 'package:vbt_app/services/bluetooth/device_providers.dart';

class DeviceScreen extends ConsumerStatefulWidget {
  const DeviceScreen({super.key});

  @override
  ConsumerState<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends ConsumerState<DeviceScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceState = ref.watch(vbtDeviceStateProvider);

    if (deviceState.isReallyConnected()) {
      return ConnectedDeviceScreen(device: deviceState.connectedDevice!);
    } else {
      return const ScanningScreen();
    }
  }
}
