import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vbt_app/screens/shared/styled_button.dart';
import 'package:vbt_app/screens/shared/styled_text.dart';
import 'package:vbt_app/services/bluetooth/bluetooth_service.dart';

class ConnectedDeviceScreen extends ConsumerStatefulWidget {
  const ConnectedDeviceScreen({super.key, required this.device});

  final BluetoothDevice device;

  @override
  ConsumerState<ConnectedDeviceScreen> createState() => _ConnectedDeviceScreenState();
}

class _ConnectedDeviceScreenState extends ConsumerState<ConnectedDeviceScreen> {
  @override
  void initState() {
    super.initState();
    VBTBluetoothService.discover(widget.device, ref);
  }

  Future<void> _disconnect() async {
    VBTBluetoothService.disconnect(widget.device);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MediumTitle(widget.device.advName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MediumHeadline("You are connected to ${widget.device.advName}!"),
              const SizedBox(height: 16),
              StyledButton(
                  onPressed: _disconnect,
                  text: "Disconnect",
                  icon: const Icon(Icons.bluetooth_disabled)),
            ],
          ),
        ),
      ),
    );
  }
}
