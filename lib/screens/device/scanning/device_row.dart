import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vbt_app/services/bluetooth/bluetooth_service.dart';
import 'package:vbt_app/screens/shared/styled_text.dart';
import 'package:vbt_app/theme.dart';

class DeviceRow extends ConsumerStatefulWidget {
  final BluetoothDevice device;
  final AdvertisementData advertisementData;

  const DeviceRow({super.key, required this.device, required this.advertisementData});

  @override
  ConsumerState<DeviceRow> createState() => _DeviceRowState();
}

class _DeviceRowState extends ConsumerState<DeviceRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 3),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(color: AppColors.backgroundColor.withOpacity(0.8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MediumHeadline(widget.advertisementData.advName.isNotEmpty
                    ? widget.advertisementData.advName
                    : 'Unknown Device'),
                SmallText(widget.device.remoteId.str)
              ],
            ),
            if (widget.advertisementData.connectable)
              OutlinedButton(
                  onPressed: () async {
                    VBTBluetoothService.connect(widget.device, ref);
                  },
                  child: const Text('Connect'))
            else
              const OutlinedButton(onPressed: null, child: Text('Connect'))
          ],
        ));
  }
}
