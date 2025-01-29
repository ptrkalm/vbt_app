import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final scanResultsProvider = StreamProvider.autoDispose<List<ScanResult>>((_) async* {
  await for (final scanResults in FlutterBluePlus.onScanResults) {
    final sortedScanResults = scanResults..sort((a, b) => a.rssi.compareTo(b.rssi));
    yield sortedScanResults;
  }
});

final isScanningProvider = StreamProvider.autoDispose<bool>((_) async* {
  yield* FlutterBluePlus.isScanning;
});

final isBluetoothEnabledProvider = StreamProvider.autoDispose<bool>((_) async* {
  await for (final adapterState in FlutterBluePlus.adapterState) {
    yield adapterState == BluetoothAdapterState.on;
  }
});