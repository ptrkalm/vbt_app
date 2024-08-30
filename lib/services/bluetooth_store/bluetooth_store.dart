import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothStore extends ChangeNotifier {
  final List<ScanResult> _scanResults = [];
  bool _isScanning = false;
  StreamSubscription<List<ScanResult>>? _scanSubscription;
  BluetoothDevice? _connectedDevice;
  BluetoothCharacteristic? _messageCharacteristic;
  late double _lastValue;
  final Queue<double> _lastValues = Queue();
  final Queue<double> _smoothedValues = Queue();
  final int _smoothness = 50;


  List<ScanResult> get scarResults => _scanResults;
  bool get isScanning => _isScanning;
  BluetoothDevice? get connectedDevice => _connectedDevice;
  double get lastValue => _lastValue;
  Iterable<double> get lastValues => _lastValues.toList().reversed;
  Iterable<double> get smoothedValues => _smoothedValues.toList().reversed;
  int get smoothness => _smoothness;

  static const int bufferSize = 200;

  Future<bool> checkBluetoothEnabled() async {
    var adapterState = await FlutterBluePlus.adapterState.first;
    return adapterState == BluetoothAdapterState.on;
  }

  Future<bool> startScan() async {
    bool isBluetoothEnabled = await checkBluetoothEnabled();
    if (!isBluetoothEnabled) {
      return false;
    }

    print('Started scanning...');
    _isScanning = true;
    notifyListeners();

    await FlutterBluePlus.adapterState.where((value) => value == BluetoothAdapterState.on).first;

    _scanSubscription = FlutterBluePlus.onScanResults.listen((scanResults) {
      for (var scanResult in scanResults) {
        if (!_scanResults.contains(scanResult)) {
          _scanResults.add(scanResult);
          notifyListeners();
        }
      }
    },
    onError: (error) {
      print(error);
      stopScan();
    });

    FlutterBluePlus.cancelWhenScanComplete(_scanSubscription!);

    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

    await FlutterBluePlus.isScanning.where((value) => value == false).first.then((_) {
      stopScan();
    });

    return true;
  }

  void stopScan() {
    _scanSubscription?.cancel();
    FlutterBluePlus.stopScan();
    _isScanning = false;
    notifyListeners();
  }

  Future<bool> connect(BluetoothDevice device) async {
    print('Connecting to ${device.advName}...');

    final subscription = device.connectionState.listen((state) {
      if (state == BluetoothConnectionState.connected) {
        print('Connected to ${device.advName}.');
        _connectedDevice = device;
        notifyListeners();
      }
    });

    device.cancelWhenDisconnected(subscription as StreamSubscription);

    await device.connect(timeout: const Duration(seconds: 5));

    if (device.isConnected) {
      return true;
    }

    return false;
  }

  Future<void> discover(BluetoothDevice device) async {
    resetValues();

    await device.discoverServices();

    BluetoothService service = device
        .servicesList.firstWhere((service) => service.serviceUuid == Guid('ffe0'));

    BluetoothCharacteristic characteristic = service
        .characteristics.firstWhere((characteristic) => characteristic.characteristicUuid == Guid('ffe1'));

    _messageCharacteristic = characteristic;

    final subscription =_messageCharacteristic?.onValueReceived.listen((bytes) {
      handleIncomingBytes(bytes);
    });


    device.cancelWhenDisconnected(subscription as StreamSubscription);

    _messageCharacteristic?.setNotifyValue(true);
  }

  void handleIncomingBytes(List<int> bytes) {
    registerValue(double.parse(utf8.decode(bytes).trim()));
  }

  void resetValues() {
    _lastValue = 0;
    _lastValues.clear();
    _smoothedValues.clear();
  }

  void registerValue(double value) {
    _lastValue = value;
    addValueToQueue(value, _lastValues);

    Iterable<double> lastN = _lastValues.take(_smoothness);
    double avarage = lastN.reduce((a, b) => a + b) / lastN.length;
    addValueToQueue(avarage, _smoothedValues);

    notifyListeners();
  }

  void addValueToQueue(double value, Queue<double> queue) {
    queue.addFirst(value);
    if (queue.length > bufferSize) {
      queue.removeLast();
    }
  }
}