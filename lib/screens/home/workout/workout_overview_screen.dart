import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vbt_app/models/vbt_workout.dart';
import 'package:vbt_app/screens/shared/styled_text.dart';
import 'package:vbt_app/screens/home/workout/workout_overview.dart';

class WorkoutOverviewScreen extends ConsumerStatefulWidget {
  const WorkoutOverviewScreen(this.workout, {super.key});

  final VBTWorkout workout;

  @override
  ConsumerState<WorkoutOverviewScreen> createState() => WorkoutOverviewScreenState();
}

class WorkoutOverviewScreenState extends ConsumerState<WorkoutOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MediumTitle(widget.workout.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: WorkoutOverview(widget.workout),
        ),
      ),
    );
  }
}
