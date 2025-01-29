import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vbt_app/models/time_accel.dart';
import 'package:vbt_app/models/time_accel_velocity_rfd.dart';
import 'package:vbt_app/models/vbt_rep.dart';
import 'package:vbt_app/models/vbt_set.dart';
import 'package:vbt_app/screens/home/workout/ongoing_workout_overview_screen.dart';
import 'package:vbt_app/screens/shared/alert_dialog.dart';
import 'package:vbt_app/screens/shared/floating_action_button.dart';
import 'package:vbt_app/screens/home/workout/set/set_overview_screen.dart';
import 'package:vbt_app/services/bluetooth/bluetooth_service.dart';
import 'package:vbt_app/services/bluetooth/device_providers.dart';
import 'package:vbt_app/screens/shared/styled_text.dart';
import 'package:vbt_app/services/workout/movement_data_processor.dart';
import 'package:vbt_app/services/workout/workout_providers.dart';
import 'package:vbt_app/theme.dart';

class OngoingSetScreen extends ConsumerStatefulWidget {
  const OngoingSetScreen(this.set, {super.key});

  final VBTSet set;

  @override
  ConsumerState<OngoingSetScreen> createState() => _OngoingSetScreenState();
}

class _OngoingSetScreenState extends ConsumerState<OngoingSetScreen> {
  late MovementDataProcessor _movementDataProcessor;

  final List<FlSpot> _accelSpots = [const FlSpot(0, 0)];
  final List<FlSpot> _velocitySpots = [const FlSpot(0, 0)];
  final List<FlSpot> _rfdSpots = [const FlSpot(0, 0)];

  final double _timeWindow = 1.5;

  bool _isStopped = false;
  bool _isAfterRep = false;

  double? _velocityMax;
  double? _rfdMax;
  double? _timeToRfdMax;

  StreamSubscription<String>? _lastMovementPhaseSubscription;
  StreamSubscription<TimeAccelVelocityRfd>? _workoutDataSubscription;
  StreamSubscription<TimeAccel>? _dataStreamSubscription;
  StreamSubscription<VBTRep>? _lastRepSubscription;

  @override
  void initState() {
    super.initState();
    _discover();
    _movementDataProcessor = MovementDataProcessor(weight: widget.set.getFullWeight());

    _workoutDataSubscription = _movementDataProcessor.data.listen((timeAccelVelocityRfd) {
      var time = double.parse(timeAccelVelocityRfd.time.toStringAsFixed(2));
      var accel = double.parse(timeAccelVelocityRfd.accel.toStringAsFixed(2));
      var velocity = double.parse(timeAccelVelocityRfd.velocity.toStringAsFixed(2));
      var kRFD = double.parse((timeAccelVelocityRfd.rfd / 1000).toStringAsFixed(2));

      setState(() {
        _accelSpots.add(FlSpot(time, accel));
        _velocitySpots.add(FlSpot(time, velocity));
        _rfdSpots.add(FlSpot(time, kRFD));

        if (timeAccelVelocityRfd.time - _accelSpots.first.x > _timeWindow) {
          _accelSpots.removeAt(0);
          _velocitySpots.removeAt(0);
          _rfdSpots.removeAt(0);
        }
      });
    });

    _dataStreamSubscription = VBTBluetoothService.accelerationDataStream().listen((timeAccel) {
      if (_isStopped || _isAfterRep) return;
      _movementDataProcessor.registerTimeAccel(timeAccel);
    });

    _lastRepSubscription = _movementDataProcessor.lastRep.listen((lastRep) {
      widget.set.add(lastRep);
      setState(() {
        _velocityMax = lastRep.velocityMax;
        _rfdMax = lastRep.rfdMax;
        _timeToRfdMax = lastRep.timeToRfdMax;
        _isAfterRep = true;
      });

      Timer(const Duration(seconds: 3), () {
        setState(() {
          _resetRep();
        });
      });
    });
  }

  @override
  void dispose() {
    _lastMovementPhaseSubscription?.cancel();
    _workoutDataSubscription?.cancel();
    _dataStreamSubscription?.cancel();
    _lastRepSubscription?.cancel();
    super.dispose();
  }

  Future<void> _discover() async {
    await VBTBluetoothService.discover(ref.read(vbtDeviceStateProvider).connectedDevice!, ref);
  }

  void _restartSet() {
    setState(() {
      _resetRep();
      widget.set.clear();
    });
  }

  void _resetRep() {
    setState(() {
      _movementDataProcessor.reset();
      resetSpots();
      _isAfterRep = false;
      _isStopped = false;
    });
  }

  void _stopSet() {
    setState(() {
      _isStopped = true;
    });
  }

  void resetSpots() {
    setState(() {
      _accelSpots
        ..clear()
        ..add(const FlSpot(0, 0));
      _velocitySpots
        ..clear()
        ..add(const FlSpot(0, 0));
      _rfdSpots
        ..clear()
        ..add(const FlSpot(0, 0));
    });
  }

  void _showNoRepsAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return VBTAlertDialog(
            "Empty list of reps",
            "There is no rep yet performed. Please, perform at least one rep or discard set.",
            buttons: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _discardSet();
                  },
                  child: const MediumHeadline(
                    'Discard set',
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

  void _discardSet() {
    Navigator.pop(context);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const OngoingWorkoutOverviewScreen()));
  }

  void _finishSet() {
    if (widget.set.reps.isEmpty) {
      _showNoRepsAlert();
      return;
    }

    ref.read(workoutStateProvider.notifier).finishSet(widget.set);
    Navigator.pop(context);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SetOverviewScreen(set: widget.set)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MediumTitle("Perform an exercise!"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: Center(
            child: Stack(
          children: [
            LineChart(
                duration: Duration.zero,
                LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                          spots: _accelSpots,
                          dotData: const FlDotData(show: false),
                          color: Colors.white30),
                      LineChartBarData(
                        spots: _velocitySpots,
                        dotData: const FlDotData(show: false),
                        color: AppColors.primaryColor,
                      ),
                      LineChartBarData(
                          spots: _rfdSpots,
                          dotData: const FlDotData(show: false),
                          color: AppColors.secondaryColor),
                    ],
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              minIncluded: false,
                              maxIncluded: false,
                              reservedSize: 30)),
                      bottomTitles: const AxisTitles(
                          axisNameWidget: Text("Time [s]"),
                          axisNameSize: 30,
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(
                          axisNameWidget: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  const Text("Velocity [m/s]"),
                                  const SizedBox(width: 20),
                                  Container(width: 70, height: 2, color: AppColors.primaryColor)
                                ],
                              ),
                              Row(
                                children: [
                                  const Text("RFD [kN/s]"),
                                  const SizedBox(width: 20),
                                  Container(width: 70, height: 2, color: AppColors.secondaryColor)
                                ],
                              )
                            ],
                          ),
                          axisNameSize: 30,
                          sideTitles: const SideTitles(showTitles: false)),
                    ),
                    minY: -0.5,
                    maxY: 2.0,
                    clipData: const FlClipData.all(),
                    lineTouchData: const LineTouchData(enabled: false))),
            if (_velocityMax != null)
              Positioned(
                  left: 60,
                  top: 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const LargeHeadline("V MAX: ", color: AppColors.primaryColor),
                          LargeText("$_velocityMax m/s", color: AppColors.primaryColor)
                        ],
                      ),
                      Row(
                        children: [
                          const LargeHeadline("RFD MAX: ", color: AppColors.secondaryColor),
                          LargeText("$_rfdMax kN/s", color: AppColors.secondaryColor)
                        ],
                      ),
                      Row(
                        children: [
                          const LargeHeadline("TT RFD MAX: ", color: AppColors.tertiaryColor),
                          LargeText("$_timeToRfdMax s", color: AppColors.tertiaryColor)
                        ],
                      ),
                    ],
                  )),
          ],
        )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _isStopped
          ? Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              PrimaryFloatingActionButton(
                  label: "Restart set",
                  icon: const Icon(Icons.restart_alt_outlined),
                  onPressed: _restartSet,
                  heroTag: "restart_set"),
              PrimaryOutlinedFloatingActionButton(
                  label: "Finish set",
                  icon: const Icon(Icons.check_circle_outline),
                  onPressed: _finishSet,
                  heroTag: "finish_set")
            ])
          : SecondaryFloatingActionButton(
              label: "Stop",
              icon: const Icon(Icons.stop_circle_outlined),
              onPressed: _stopSet,
              heroTag: "stop_set"),
    );
  }
}
