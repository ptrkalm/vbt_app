import 'package:flutter/material.dart';
import 'package:vbt_app/models/vbt_set.dart';
import 'package:vbt_app/screens/shared/styled_text.dart';
import 'package:vbt_app/screens/home/workout/set/set_overview_screen.dart';
import 'package:vbt_app/theme.dart';

class SetRow extends StatefulWidget {
  final VBTSet set;
  final int index;

  const SetRow({super.key, required this.set, required this.index});

  @override
  State<SetRow> createState() => _DeviceRowState();
}

class _DeviceRowState extends State<SetRow> {
  Row _createMetricRow(String name, double average, double best, String unit, Color color) {
    return Row(
      children: [
        Container(width: 10, height: 2, color: color),
        const SizedBox(width: 5),
        SizedBox(width: 120, child: SmallHeadline("$name: ")),
        SizedBox(width: 54, child: SmallText("$average")),
        SizedBox(width: 70, child: SmallText("|     $best")),
        SmallText(unit),
      ],
    );
  }

  Widget _createWeightsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const SmallHeadline("Body weight: "),
            SmallText("${widget.set.bodyWeight} kg"),
          ],
        ),
        Row(
          children: [
            const SmallHeadline("Load weight: "),
            SmallText("${widget.set.loadWeight} kg"),
          ],
        )
      ],
    );
  }

  void _openSetOverview() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SetOverviewScreen(set: widget.set)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 3),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(color: AppColors.backgroundColor.withOpacity(0.8)),
      child: InkWell(
        onTap: _openSetOverview,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      MediumHeadline("#${widget.index + 1} SET"),
                      const SizedBox(width: 10),
                      const MediumText("(Average | Best)")
                    ],
                  ),
                  _createMetricRow("V MAX", widget.set.getAverageVelocityMax(), widget.set.getBestVelocityMax(), "m/s",
                      AppColors.primaryColor),
                  _createMetricRow("RFD MAX", widget.set.getAverageRfdMax(), widget.set.getBestRfdMax(), "kN/s",
                      AppColors.secondaryColor),
                  _createMetricRow("TT RFD MAX", widget.set.getAverageTimeToRfdMax(), widget.set.getBestTimeToRfdMax(), "s",
                      AppColors.tertiaryColor),
                  _createWeightsRow()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
