import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VBTDeviceState {
  const VBTDeviceState(
      {required this.connectedDevice,
      required this.connectingDevice,
      required this.isConnected,
      required this.isConnecting});

  final BluetoothDevice? connectedDevice;
  final BluetoothDevice? connectingDevice;
  final bool isConnected;
  final bool isConnecting;

  bool isReallyConnected() {
    return !isConnecting && isConnected;
  }
}

class VBTDeviceStateNotifier extends StateNotifier<VBTDeviceState> {
  VBTDeviceStateNotifier()
      : super(const VBTDeviceState(
            connectedDevice: null,
            connectingDevice: null,
            isConnected: false,
            isConnecting: false));

  void setConnectedDevice(VBTDeviceState deviceConnection) {
    state = deviceConnection;
  }

  void setConnectingDevice(VBTDeviceState deviceConnection) {
    state = deviceConnection;
  }

  void connecting(BluetoothDevice device) {
    state = VBTDeviceState(
        connectedDevice: null,
        connectingDevice: device,
        isConnected: false,
        isConnecting: true);
  }

  void connected(BluetoothDevice device) {
    state = VBTDeviceState(
        connectedDevice: device,
        connectingDevice: state.connectingDevice,
        isConnected: true,
        isConnecting: state.isConnecting);
  }

  void stoppedConnecting() {
    state = VBTDeviceState(
        connectedDevice: state.connectedDevice,
        connectingDevice: null,
        isConnected: state.isConnected,
        isConnecting: false);
  }

  void disconnected() {
    state = const VBTDeviceState(
        connectedDevice: null,
        connectingDevice: null,
        isConnected: false,
        isConnecting: false);
  }
}

final vbtDeviceStateProvider = StateNotifierProvider<VBTDeviceStateNotifier, VBTDeviceState>((ref) {
  return VBTDeviceStateNotifier();
});