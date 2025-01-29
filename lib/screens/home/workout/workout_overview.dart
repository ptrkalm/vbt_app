import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:vbt_app/models/vbt_workout.dart';
import 'package:vbt_app/screens/shared/styled_text.dart';
import 'package:vbt_app/screens/home/workout/set_row.dart';
import 'package:vbt_app/theme.dart';

class WorkoutOverview extends StatefulWidget {
  const WorkoutOverview(this.workout, {super.key});

  final VBTWorkout workout;

  @override
  State<WorkoutOverview> createState() => WorkoutOverviewState();
}

class WorkoutOverviewState extends State<WorkoutOverview> {
  final List<bool> _selectedMetricType = [true, false];

  List<FlSpot> _getAverageVelocityMaxSpots() {
    return widget.workout.sets
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key + 1, entry.value.getAverageVelocityMax()))
        .toList();
  }

  List<FlSpot> _getAverageRfdMaxSpots() {
    return widget.workout.sets
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key + 1, entry.value.getAverageRfdMax()))
        .toList();
  }

  List<FlSpot> _getAverageTimeToRfdMaxSpots() {
    return widget.workout.sets
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key + 1, entry.value.getAverageTimeToRfdMax()))
        .toList();
  }

  List<FlSpot> _getBestVelocityMaxSpots() {
    return widget.workout.sets
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key + 1, entry.value.getBestVelocityMax()))
        .toList();
  }

  List<FlSpot> _getBestRfdMaxSpots() {
    return widget.workout.sets
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key + 1, entry.value.getBestRfdMax()))
        .toList();
  }

  List<FlSpot> _getBestTimeToRfdMaxSpots() {
    return widget.workout.sets
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key + 1, entry.value.getBestTimeToRfdMax()))
        .toList();
  }

  Widget _createKeyMetricsChart() {
    late String name;
    late List<LineChartBarData> data;
    if (_selectedMetricType.first) {
      name = "Average of key metrics per set";
      data = [
        LineChartBarData(spots: _getAverageTimeToRfdMaxSpots(), color: AppColors.tertiaryColor),
        LineChartBarData(spots: _getAverageRfdMaxSpots(), color: AppColors.secondaryColor),
        LineChartBarData(spots: _getAverageVelocityMaxSpots(), color: AppColors.primaryColor)
      ];
    } else {
      name = "Best of key metrics per set";
      data = [
        LineChartBarData(spots: _getBestTimeToRfdMaxSpots(), color: AppColors.tertiaryColor),
        LineChartBarData(spots: _getBestRfdMaxSpots(), color: AppColors.secondaryColor),
        LineChartBarData(spots: _getBestVelocityMaxSpots(), color: AppColors.primaryColor)
      ];
    }

    return SizedBox(
      height: 170,
      child: LineChart(LineChartData(
          lineBarsData: data,
          titlesData: FlTitlesData(
            topTitles: AxisTitles(
                axisNameWidget: MediumHeadline(name),
                axisNameSize: 30,
                sideTitles: const SideTitles(showTitles: false)),
            bottomTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: true, interval: 1, reservedSize: 30)),
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 35)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          minY: 0,
          lineTouchData: const LineTouchData(enabled: false))),
    );
  }

  ToggleButtons _createMetricsTypeToggle() {
    return ToggleButtons(
      isSelected: _selectedMetricType,
      onPressed: (int index) {
        setState(() {
          for (int i = 0; i < _selectedMetricType.length; i++) {
            _selectedMetricType[i] = i == index;
          }
        });
      },
      borderRadius: const BorderRadius.all(Radius.circular(100)),
      borderColor: AppColors.primaryColor,
      selectedBorderColor: AppColors.primaryColor,
      fillColor: AppColors.primaryColor,
      color: AppColors.textColor,
      selectedColor: AppColors.backgroundColorAccent,
      constraints: const BoxConstraints(
        minHeight: 30.0,
        minWidth: 100.0,
      ),
      children: const [
        Text("Average"),
        Text("Best"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.workout.sets.isNotEmpty)
          Column(
            children: [
              _createKeyMetricsChart(),
              _createMetricsTypeToggle(),
            ],
          )
        else
          const MediumText("There is no set yet"),
        const SizedBox(height: 10),
        ...widget.workout.sets
            .asMap()
            .entries
            .map((entry) => SetRow(set: entry.value, index: entry.key))
      ],
    );
  }
}
