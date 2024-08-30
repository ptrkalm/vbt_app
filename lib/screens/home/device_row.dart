import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:vbt_app/screens/device/device_screen.dart';
import 'package:vbt_app/shared/styled_text.dart';
import 'package:vbt_app/theme.dart';

import 'package:vbt_app/services/bluetooth_store/bluetooth_store.dart';

class DeviceRow extends StatefulWidget {
  final BluetoothDevice device;
  final AdvertisementData advertisementData;

  const DeviceRow({
    super.key,
    required this.device,
    required this.advertisementData
  });

  @override
  State<DeviceRow> createState() => _DeviceRowState();
}

class _DeviceRowState extends State<DeviceRow> {
  @override
  Widget build(BuildContext context) {
    final bluetoothStore = Provider.of<BluetoothStore>(context, listen: false);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor.withOpacity(0.8)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StyledHeadline(widget.advertisementData.advName.isNotEmpty
                  ? widget.advertisementData.advName
                  : 'Unknown Device'
                ),
                StyledText(widget.device.remoteId.str)
              ],
          ),
          if (widget.advertisementData.connectable)
            ElevatedButton(
              onPressed: () async {
                if(await bluetoothStore.connect(widget.device)) {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => DeviceScreen(device: widget.device)
                  ));
                }
              },
              child: const Text('Connect')
            )
          else
            const OutlinedButton(
              onPressed: null,
              child: Text('Connect')
            )
        ],
      )
    );
  }
}
