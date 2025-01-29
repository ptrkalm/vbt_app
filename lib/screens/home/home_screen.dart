import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vbt_app/screens/shared/alert_dialog.dart';
import 'package:vbt_app/screens/shared/floating_action_button.dart';
import 'package:vbt_app/screens/home/workout/ongoing_workout_overview_screen.dart';
import 'package:vbt_app/screens/home/workout/workout_row.dart';
import 'package:vbt_app/services/bluetooth/device_providers.dart';
import 'package:vbt_app/screens/shared/styled_text.dart';
import 'package:vbt_app/services/user/user_service.dart';
import 'package:vbt_app/services/workout/workout_providers.dart';
import 'package:vbt_app/theme.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late VBTDeviceState deviceState;
  late WorkoutState workoutState;
  late WorkoutStateNotifier workoutStateNotifier;
  bool isLoading = false;

  void _loadWorkouts() async {
    isLoading = true;
    await workoutStateNotifier.loadWorkouts();
    isLoading = false;
  }

  void _startNewOrResumeWorkout() {
    if (!deviceState.isReallyConnected()) {
      _showBluetoothAlert();
      return;
    }

    if (!workoutState.isOngoing()) {
      workoutStateNotifier.startNewWorkout();
    }

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const OngoingWorkoutOverviewScreen()));
  }

  void _showAlert(String headline, String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return VBTAlertDialog(headline, text);
        });
  }

  void _showBluetoothAlert() {
    _showAlert("VBT Device not connected", "Please connect to your VBT Device.");
  }

  void _showAccountDeletionAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return VBTAlertDialog(
            "Are you sure?",
            "With deletion of account you will lose access to all performed workouts. Are you sure you want to delete account?.",
            buttons: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _deleteAccount();
                  },
                  child: const MediumHeadline(
                    'Yes',
                    color: Colors.red,
                  )),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const MediumHeadline(
                    'No',
                    color: AppColors.backgroundColorAccent,
                  ))
            ],
          );
        });
  }

  void _logout() {
    UserService.signOut();
  }

  void _deleteAccount() {
    UserService.deleteAccount();
  }

  @override
  Widget build(BuildContext context) {
    deviceState = ref.watch(vbtDeviceStateProvider);
    workoutState = ref.watch(workoutStateProvider);
    workoutStateNotifier = ref.watch(workoutStateProvider.notifier);

    if (workoutState.workouts.isEmpty) _loadWorkouts();

    return Scaffold(
        appBar: AppBar(
          title: const LargeTitle("Home"),
          actions: [
            PopupMenuButton<String>(
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  onTap: _logout,
                  child: const MediumText('Logout', color: AppColors.backgroundColorAccent),
                ),
                PopupMenuItem(
                  onTap: _showAccountDeletionAlert,
                  child: const MediumText('Delete account', color: Colors.red),
                ),
              ],
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                if (!workoutState.isOngoing() && workoutState.workouts.isEmpty)
                  const MediumText("There is no workouts yet")
                else
                  const MediumText("Workouts"),
                  const SizedBox(height: 5),
                if (workoutState.isOngoing())
                  WorkoutRow(workout: workoutState.ongoingWorkout!, isOngoing: true),
                ...workoutState.workouts.reversed.map((workout) => WorkoutRow(workout: workout))
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: PrimaryFloatingActionButton(
            label: workoutState.isOngoing() ? "Resume workout" : "New workout",
            icon: workoutState.isOngoing()
                ? const Icon(Icons.play_circle_outline)
                : const Icon(Icons.not_started_outlined),
            onPressed: _startNewOrResumeWorkout,
            heroTag: "new_resume_workout_action_button"));
  }
}
