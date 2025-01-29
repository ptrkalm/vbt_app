import 'dart:async';
import 'dart:math';

import 'package:vbt_app/models/time_accel.dart';
import 'package:vbt_app/models/time_accel_velocity_rfd.dart';
import 'package:vbt_app/models/vbt_rep.dart';

class MovementDataProcessor {
  MovementDataProcessor({required this.weight});

  final double weight;

  final StreamController<TimeAccelVelocityRfd> _dataController = StreamController.broadcast();
  final StreamController<VBTRep> _lastRepController = StreamController.broadcast();

  Stream<TimeAccelVelocityRfd> get data => _dataController.stream;

  Stream<VBTRep> get lastRep => _lastRepController.stream;

  _MovementPhase _movementPhase = _MovementPhase.pause;

  bool _accelAlreadyCrossed0AxisAtMaxVelocity = false;

  final List<TimeAccelVelocityRfd> currentData = [];
  late double timeOffset;

  int? _startIndex;
  double? _velocityMax;
  double? _rfdMax;
  double? _timeToRfdMax;

  double _currTime = 0;
  double _currAccel = 0;
  double _currVelocity = 0;
  double _currRfd = 0;

  void registerTimeAccel(TimeAccel timeAccel) {
    if (currentData.isEmpty) {
      _registerFirstTimeAccel(timeAccel);
      return;
    }

    _currTime = timeAccel.time - timeOffset;
    if (_currTime == currentData.last.time) return;

    _currAccel = timeAccel.accel;
    _currVelocity = calculateCurrentVelocity(_currTime, _currAccel);
    _currRfd = calculateCurrentRfd(_currTime, _currAccel);

    _analyzeMovementPhase();

    currentData.add(TimeAccelVelocityRfd(_currTime, _currAccel, _currVelocity, _currRfd));
    _dataController.add(TimeAccelVelocityRfd(_currTime, _currAccel, _currVelocity, _currRfd));
  }

  void _analyzeMovementPhase() {
    switch (_movementPhase) {
      case _MovementPhase.pause:
        _analyzeMovementInPause();
        break;
      case _MovementPhase.eccentric:
        _analyzeMovementInEccentricPhase();
        break;
      case _MovementPhase.concentric:
        _analyzeMovementInConcentricPhase();
    }
  }

  void _analyzeMovementInPause() {
    if (_currAccel > 1) {
      var isMovingDown = _currVelocity < 0;
      if (isMovingDown) {
        _movementPhase = _MovementPhase.eccentric;
      } else {
        _movementPhase = _MovementPhase.concentric;
        _startIndex = currentData.lastIndexWhere((sample) => sample.accel < 0);
      }
    }
  }

  void _analyzeMovementInEccentricPhase() {
    var crossing0Axis = _currAccel < 0 && currentData.last.accel > 0;
    if (crossing0Axis) {
      if (_currVelocity > 0.5) {
        _velocityMax = max(_currVelocity, currentData.last.velocity);
        _startIndex = currentData.lastIndexWhere((sample) => sample.accel < 0);
        _findMaxRfd();
        _accelAlreadyCrossed0AxisAtMaxVelocity = true;
        _movementPhase = _MovementPhase.concentric;
      } else {
        _movementPhase = _MovementPhase.pause;
        _currVelocity = 0;
      }
    }
  }

  void _analyzeMovementInConcentricPhase() {
    if (!_accelAlreadyCrossed0AxisAtMaxVelocity) {
      var crossing0Axis = _currAccel < 0 && currentData.last.accel > 0;
      if (crossing0Axis) {
        _accelAlreadyCrossed0AxisAtMaxVelocity = true;
        _velocityMax = max(_currVelocity, currentData.last.velocity);
        _findMaxRfd();
      } // this is Velocity MAX
    } else {
      var crossing0AxisAgain = _currAccel > 0 && currentData.last.accel < 0;
      if (crossing0AxisAgain || _currVelocity.abs() < 0.01) {
        // this is T_end
        _movementPhase = _MovementPhase.pause;
        _accelAlreadyCrossed0AxisAtMaxVelocity = false;
        _broadcastRep();
      }
    }
  }

  void _broadcastRep() {
    _lastRepController.add(VBTRep(
        data: currentData
            .sublist(_startIndex!)
            .map((data) => TimeAccelVelocityRfd(
            double.parse(data.time.toStringAsFixed(2)),
            double.parse(data.accel.toStringAsFixed(2)),
            double.parse(data.velocity.toStringAsFixed(2)),
            double.parse((data.rfd / 1000).toStringAsFixed(2))))
            .toList(),
        velocityMax: double.parse(_velocityMax!.toStringAsFixed(2)),
        rfdMax: double.parse((_rfdMax! / 1000).toStringAsFixed(2)),
        timeToRfdMax: double.parse(_timeToRfdMax!.toStringAsFixed(2))));
  }

  void _findMaxRfd() {
    double currMaxRfd = -double.infinity;
    int maxRfdIndex = -1;

    for (int i = _startIndex!; i < currentData.length; i++) {
      if (currentData[i].rfd > currMaxRfd) {
        currMaxRfd = currentData[i].rfd;
        maxRfdIndex = i;
      }
    }

    _rfdMax = currMaxRfd;
    _timeToRfdMax = currentData[maxRfdIndex].time - currentData[_startIndex!].time;
  }

  void _registerFirstTimeAccel(TimeAccel timeAccel) {
    timeOffset = timeAccel.time;
    currentData.add(const TimeAccelVelocityRfd(0, 0, 0, 0));
    _dataController.add(const TimeAccelVelocityRfd(0, 0, 0, 0));
  }

  double calculateCurrentVelocity(double time, double accel) {
    return calculateVelocity(currentData, time, accel);
  }

  double calculateVelocity(List<TimeAccelVelocityRfd> data, double time, double accel) {
    var initialVelocity = data.last.velocity;
    var deltaTime = time - data.last.time;
    var finalVelocity = initialVelocity + accel * deltaTime;

    return finalVelocity;
  }

  double calculateCurrentRfd(double time, accel) {
    return calculateRfd(currentData, time, accel);
  }

  double calculateRfd(List<TimeAccelVelocityRfd> data, double time, double accel) {
    var deltaTime = time - data.last.time;
    var deltaAccel = accel - data.last.accel;
    var deltaForce = deltaAccel * weight;
    var rfd = deltaForce / deltaTime;

    return rfd;
  }

  void _resetCurrentData() {
    currentData.clear();
    _accelAlreadyCrossed0AxisAtMaxVelocity = false;
  }

  void reset() {
    _resetCurrentData();
    _movementPhase = _MovementPhase.pause;
  }
}

enum _MovementPhase { eccentric, pause, concentric }
