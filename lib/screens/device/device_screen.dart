import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' hide BluetoothService;
import 'package:provider/provider.dart';
import 'package:vbt_app/services/bluetooth_store/bluetooth_store.dart';
import 'package:vbt_app/shared/styled_text.dart';

class DeviceScreen extends StatefulWidget {
  final BluetoothDevice device;

  const DeviceScreen({
    super.key,
    required this.device
  });

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  late BluetoothStore bluetoothStore;

  @override
  void initState() {
    super.initState();
    bluetoothStore = Provider.of<BluetoothStore>(context, listen: false);
    bluetoothStore.discover(widget.device);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StyledTitle(widget.device.advName),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Consumer<BluetoothStore>(
                builder: (context, bluetoothStore, child) {
                  return LineChart(LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: bluetoothStore.lastValues.indexed.map((spot) {
                          return FlSpot(spot.$1.toDouble(), spot.$2);
                        }).toList()
                      ),
                      LineChartBarData(
                        spots: bluetoothStore.smoothedValues.indexed.map((spot) {
                          return FlSpot(spot.$1.toDouble(), spot.$2);
                        }).toList(),
                        color: Colors.amber
                      ),
                    ]
                  ));
                },
              ),
            ),
          ],
        )
      ),
    );
  }
}
