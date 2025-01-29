import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vbt_app/models/vbt_workout.dart';
import 'package:vbt_app/screens/shared/styled_text.dart';
import 'package:vbt_app/screens/home/workout/ongoing_workout_overview_screen.dart';
import 'package:vbt_app/screens/home/workout/workout_overview_screen.dart';
import 'package:vbt_app/theme.dart';

class WorkoutRow extends StatefulWidget {
  final VBTWorkout workout;
  final bool isOngoing;

  const WorkoutRow({super.key, required this.workout, bool? isOngoing})
      : isOngoing = isOngoing ?? false;

  @override
  State<WorkoutRow> createState() => _DeviceRowState();
}

class _DeviceRowState extends State<WorkoutRow> {
  void _openWorkoutOverview() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => widget.isOngoing
                ? const OngoingWorkoutOverviewScreen()
                : WorkoutOverviewScreen(widget.workout)));
  }

  String _getFormattedDate(DateTime dateTime) {
    return DateFormat.yMMMMd().format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _openWorkoutOverview,
      child: Container(
        margin: const EdgeInsets.only(bottom: 3),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
            color: AppColors.backgroundColor.withOpacity(0.8),
            border: widget.isOngoing ? Border.all(color: AppColors.primaryColor) : null),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.isOngoing)
                    const SmallHeadline("ONGOING WORKOUT", color: AppColors.primaryColor),
                  MediumHeadline(widget.workout.name),
                  MediumText(
                    _getFormattedDate(widget.workout.dateTime),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
