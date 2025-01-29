import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:vbt_app/models/vbt_set.dart';
import 'package:vbt_app/screens/shared/floating_action_button.dart';
import 'package:vbt_app/screens/home/workout/set/rep_row.dart';
import 'package:vbt_app/screens/shared/styled_text.dart';
import 'package:vbt_app/theme.dart';

class SetOverviewScreen extends StatefulWidget {
  const SetOverviewScreen({super.key, required this.set});

  final VBTSet set;

  @override
  State<SetOverviewScreen> createState() => SetOverviewScreenState();
}

class SetOverviewScreenState extends State<SetOverviewScreen> {
  List<FlSpot> _getVelocityMaxSpots() {
    return [
      ...widget.set
          .getVelocityMaxes()
          .asMap()
          .entries
          .map((entry) => FlSpot(entry.key.toDouble() + 1, entry.value))
    ];
  }

  List<FlSpot> _getRfdMaxSpots() {
    return [
      ...widget.set
          .getRfdMaxes()
          .asMap()
          .entries
          .map((entry) => FlSpot(entry.key.toDouble() + 1, entry.value))
    ];
  }

  List<FlSpot> _getTimeToMaxRfdSpots() {
    return [
      ...widget.set
          .getTimeToRfdMaxes()
          .asMap()
          .entries
          .map((entry) => FlSpot(entry.key.toDouble() + 1, entry.value))
    ];
  }

  Widget _createKeyMetricsChart() {
    return SizedBox(
      height: 170,
      child: LineChart(LineChartData(
          lineBarsData: [
            LineChartBarData(spots: _getTimeToMaxRfdSpots(), color: AppColors.tertiaryColor),
            LineChartBarData(spots: _getRfdMaxSpots(), color: AppColors.secondaryColor),
            LineChartBarData(spots: _getVelocityMaxSpots(), color: AppColors.primaryColor)
          ],
          titlesData: const FlTitlesData(
            topTitles: AxisTitles(
                axisNameWidget: MediumHeadline("Key metrics per rep"),
                axisNameSize: 30,
                sideTitles: SideTitles(showTitles: false)),
            bottomTitles:
                AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 1, reservedSize: 30)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 35)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          minY: 0,
          lineTouchData: const LineTouchData(enabled: false))),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const LargeTitle("Set overview")),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                _createWeightsRow(),
                _createKeyMetricsChart(),
                const SizedBox(height: 10),
                ...widget.set.reps
                    .asMap()
                    .entries
                    .map((entry) => RepRow(rep: entry.value, index: entry.key + 1)),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: PrimaryFloatingActionButton(
            label: "Workout overview",
            icon: const Icon(Icons.restart_alt_outlined),
            onPressed: () => Navigator.pop(context),
            heroTag: "workout_overview"));
  }
}
