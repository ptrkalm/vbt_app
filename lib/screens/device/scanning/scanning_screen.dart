import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vbt_app/screens/shared/alert_dialog.dart';
import 'package:vbt_app/services/bluetooth/bluetooth_providers.dart';
import 'package:vbt_app/screens/device/scanning/device_row.dart';
import 'package:vbt_app/services/bluetooth/bluetooth_service.dart';
import 'package:vbt_app/screens/shared/styled_text.dart';
import 'package:vbt_app/theme.dart';

class ScanningScreen extends ConsumerStatefulWidget {
  const ScanningScreen({super.key});

  @override
  ConsumerState<ScanningScreen> createState() => _ScanningScreenState();
}

class _ScanningScreenState extends ConsumerState<ScanningScreen> {
  late AsyncValue<List<ScanResult>> scanResults;
  late AsyncValue<bool> isScanning;
  late AsyncValue<bool> isBluetoothEnabled;

  void _showBluetoothAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return VBTAlertDialog(
              "Bluetooth disabled", "Please enable Bluetooth to start scanning.");
        });
  }

  void _startOrStopScan() {
    if (!_maybe(isBluetoothEnabled)) {
      _showBluetoothAlert();
    }

    if (_maybe(isScanning)) {
      VBTBluetoothService.stopScanning();
    } else {
      VBTBluetoothService.startScanning();
    }
  }

  bool _maybe(AsyncValue<bool> value) {
    return value.maybeWhen(data: (v) => v, orElse: () => false);
  }

  @override
  Widget build(BuildContext context) {
    scanResults = ref.watch(scanResultsProvider);
    isScanning = ref.watch(isScanningProvider);
    isBluetoothEnabled = ref.watch(isBluetoothEnabledProvider);

    return Scaffold(
      appBar: AppBar(
        title: const LargeTitle('Device'),
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Column(
          children: [
            const SizedBox(
              width: double.infinity,
              child: SmallHeadline(
                "Please scan and connect to your VBT Device",
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            ...scanResults.when(
              data: (scanResults) => scanResults.map((scanResult) => DeviceRow(
                    device: scanResult.device,
                    advertisementData: scanResult.advertisementData,
                  )),
              error: (error, stackTrace) => [const MediumText("Error occurred...")],
              loading: () => [],
            ),
            if (_maybe(isScanning))
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: SpinKitThreeBounce(
                  color: AppColors.textColor,
                  size: 20.0,
                ),
              ),
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton.extended(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        backgroundColor: _maybe(isScanning) ? AppColors.secondaryColor : AppColors.primaryColor,
        foregroundColor: AppColors.backgroundColorAccent,
        onPressed: _startOrStopScan,
        icon: const Icon(Icons.bluetooth_searching_rounded),
        label:
            MediumText(_maybe(isScanning) ? 'Stop' : 'Scan', color: AppColors.backgroundColorAccent),
      ),
    );
  }
}
