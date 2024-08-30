import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:vbt_app/screens/home/device_row.dart';
import 'package:vbt_app/services/bluetooth_store/bluetooth_store.dart';
import 'package:vbt_app/shared/styled_text.dart';
import 'package:vbt_app/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late BluetoothStore bluetoothStore;

  @override
  void initState() {
    bluetoothStore = Provider.of<BluetoothStore>(context, listen: false);
    super.initState();
  }

  void _startOrStopScan() async {
    if (bluetoothStore.isScanning) {
      bluetoothStore.stopScan();
    } else {
      bool success = await bluetoothStore.startScan();
      if (!success) {
        _showBluetoothAlert();
      }
    }
  }

  void _showBluetoothAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const StyledHeadline('Bluetooth Disabled'),
          content: const StyledText('Please enable Bluetooth to start scanning.'),
          actions: <Widget> [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK')
            )
          ]
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    final bluetoothStore = Provider.of<BluetoothStore>(context);

    return Scaffold(
      appBar: AppBar(
        title: const StyledTitle('Choose your device'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            children: [
              ...bluetoothStore.scarResults.map((scanResult) {
                return Column(
                  children: [
                    DeviceRow(
                      device: scanResult.device,
                      advertisementData: scanResult.advertisementData
                    ),
                    const SizedBox(height: 8)
                  ],
                );
              }),
              if (bluetoothStore.isScanning)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: SpinKitThreeBounce(
                    color: AppColors.textColor,
                    size: 20.0,
                  ),
                ),
            ],
          )
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: bluetoothStore.isScanning
          ? AppColors.primaryAccent
          : AppColors.primaryColor
        ,
        foregroundColor: Colors.white,
        onPressed: _startOrStopScan,
        child: Text(bluetoothStore.isScanning ? 'Stop' : 'Scan'),
      ),
    );
  }
}
