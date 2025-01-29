import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vbt_app/models/vbt_set.dart';
import 'package:vbt_app/models/vbt_workout.dart';
import 'package:vbt_app/services/workout/workout_service.dart';

class WorkoutState {
  const WorkoutState({required this.ongoingWorkout, required this.workouts, required this.fetched});

  final VBTWorkout? ongoingWorkout;
  final List<VBTWorkout> workouts;
  final bool fetched;

  bool isOngoing() {
    return ongoingWorkout != null;
  }

  WorkoutState withOngoingWorkout(VBTWorkout workout) {
    return WorkoutState(ongoingWorkout: workout, workouts: workouts, fetched: fetched);
  }

  WorkoutState withWorkouts(List<VBTWorkout> workouts) {
    return WorkoutState(ongoingWorkout: ongoingWorkout, workouts: workouts, fetched: fetched);
  }

  WorkoutState withFetched(bool fetched) {
    return WorkoutState(ongoingWorkout: ongoingWorkout, workouts: workouts, fetched: fetched);
  }
}

class WorkoutStateNotifier extends StateNotifier<WorkoutState> {
  WorkoutStateNotifier()
      : super(const WorkoutState(ongoingWorkout: null, workouts: [], fetched: false));

  void startNewWorkout() {
    state = WorkoutState(ongoingWorkout: VBTWorkout(name: "Workout #${state.workouts.length + 1}"), workouts: state.workouts, fetched: state.fetched);
  }

  void updateName(String name) {
    state = state.withOngoingWorkout(state.ongoingWorkout!.withName(name));
  }

  void finishSet(VBTSet set) {
    state = state.withOngoingWorkout(state.ongoingWorkout!.withSet(set));
  }

  void finishWorkout() {
    WorkoutService.addWorkout(state.ongoingWorkout!);

    state = WorkoutState(
        ongoingWorkout: null, workouts: List.from(state.workouts)..add(state.ongoingWorkout!), fetched: state.fetched);
  }

  Future<void> loadWorkouts() async {
    if (state.fetched) return;

    List<VBTWorkout> workouts = await WorkoutService.loadWorkouts();
    state = state.withWorkouts(workouts);
  }

  void discardWorkout() {
    state = WorkoutState(ongoingWorkout: null, workouts: state.workouts, fetched: state.fetched);
  }
}

final workoutStateProvider = StateNotifierProvider<WorkoutStateNotifier, WorkoutState>((ref) {
  return WorkoutStateNotifier();
});
