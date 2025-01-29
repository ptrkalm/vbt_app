import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vbt_app/models/vbt_set.dart';
import 'package:vbt_app/screens/shared/alert_dialog.dart';
import 'package:vbt_app/screens/shared/floating_action_button.dart';
import 'package:vbt_app/screens/home/workout/set/new_set_screen.dart';
import 'package:vbt_app/screens/home/workout/workout_overview.dart';
import 'package:vbt_app/screens/shared/styled_text.dart';
import 'package:vbt_app/services/workout/workout_providers.dart';
import 'package:vbt_app/theme.dart';

class OngoingWorkoutOverviewScreen extends ConsumerStatefulWidget {
  const OngoingWorkoutOverviewScreen({super.key});

  @override
  ConsumerState<OngoingWorkoutOverviewScreen> createState() => OngoingWorkoutOverviewScreenState();
}

class OngoingWorkoutOverviewScreenState extends ConsumerState<OngoingWorkoutOverviewScreen> {
  late WorkoutState _workoutState;
  late WorkoutStateNotifier _workoutStateNotifier;

  final _workoutNameController = TextEditingController(text: "Workout");
  final _workoutNameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _workoutNameController.text = ref.read(workoutStateProvider).ongoingWorkout!.name;
    _workoutNameFocusNode.addListener(() {
      if (!_workoutNameFocusNode.hasFocus) {
        _updateWorkoutName(_workoutNameController.text);
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _workoutNameFocusNode.dispose();
    _workoutNameController.dispose();
    super.dispose();
  }

  void _updateWorkoutName(String name) {
    _workoutStateNotifier.updateName(name);
  }

  void _createNewSet() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NewSetScreen(VBTSet(name: "Set #${_workoutState.ongoingWorkout!.sets.length + 1}"))));
  }

  void _finishWorkout() {
    if (_workoutState.ongoingWorkout!.sets.isEmpty) {
      _showNoSetAlert();
      return;
    }

    _workoutStateNotifier.finishWorkout();
    Navigator.pop(context);
  }

  void _discardWorkout() {
    _workoutStateNotifier.discardWorkout();
    Navigator.pop(context);
  }

  void _showNoSetAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return VBTAlertDialog(
            "Empty list of sets",
            "There is no set yet performed. Please, perform at least one set or discard workout.",
            buttons: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _discardWorkout();
                  },
                  child: const MediumHeadline(
                    'Discard workout',
                    color: Colors.red,
                  )),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const MediumHeadline(
                    'OK',
                    color: AppColors.backgroundColorAccent,
                  ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    _workoutState = ref.watch(workoutStateProvider);
    _workoutStateNotifier = ref.watch(workoutStateProvider.notifier);

    return Scaffold(
        appBar: AppBar(
          title: TextField(
            textAlign: TextAlign.center,
            controller: _workoutNameController,
            focusNode: _workoutNameFocusNode,
            style: Theme.of(context).textTheme.titleLarge,
            decoration: _workoutNameFocusNode.hasFocus ? const InputDecoration() : null,
          ),
          actions: [
            IconButton(
                icon:
                    _workoutNameFocusNode.hasFocus ? const Icon(Icons.save) : const Icon(Icons.edit),
                onPressed: () => _workoutNameFocusNode.hasFocus
                    ? _workoutNameFocusNode.unfocus()
                    : _workoutNameFocusNode.requestFocus())
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: _workoutState.isOngoing()
                  ? WorkoutOverview(_workoutState.ongoingWorkout!)
                  : Container()),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            PrimaryFloatingActionButton(
                label: "New set",
                icon: const Icon(Icons.add_circle_outline),
                onPressed: _createNewSet,
                heroTag: "new_set"),
            PrimaryOutlinedFloatingActionButton(
                label: "Finish workout",
                icon: const Icon(Icons.check_circle_outline),
                onPressed: _finishWorkout,
                heroTag: "finish_workout")
          ],
        ));
  }
}
