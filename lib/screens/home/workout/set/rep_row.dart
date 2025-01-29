import 'package:flutter/material.dart';
import 'package:vbt_app/models/vbt_rep.dart';
import 'package:vbt_app/screens/shared/styled_text.dart';
import 'package:vbt_app/theme.dart';

class RepRow extends StatefulWidget {
  final VBTRep rep;
  final int index;

  const RepRow({super.key, required this.rep, required this.index});

  @override
  State<RepRow> createState() => _DeviceRowState();
}

class _DeviceRowState extends State<RepRow> {

  Row _createMetricRow(String name, double value, String unit, Color color) {
    return Row(
      children: [
        Container(width: 10, height: 2, color: color),
        const SizedBox(width: 5),
        SizedBox(width: 120, child: SmallHeadline("$name: ")),
        SizedBox(width: 54, child: SmallText("$value")),
        SmallText(unit)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 3),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(color: AppColors.backgroundColor.withOpacity(0.8)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MediumHeadline("#${widget.index} REP"),
                _createMetricRow("V MAX", widget.rep.velocityMax, "m/s", AppColors.primaryColor),
                _createMetricRow("RFD MAX", widget.rep.rfdMax, "kN/s", AppColors.secondaryColor),
                _createMetricRow("TT RFD MAX", widget.rep.timeToRfdMax, "s", AppColors.tertiaryColor)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
