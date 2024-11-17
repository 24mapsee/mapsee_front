import 'package:flutter/material.dart';
import 'dart:async';

import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}

class GetPedometer extends StatefulWidget {
  const GetPedometer({super.key});

  @override
  State<GetPedometer> createState() => _PedometerState();
}

class _PedometerState extends State<GetPedometer> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    print(event);
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      // 상태를 한글로 변환
      if (event.status == 'walking') {
        _status = '걷는 중';
      } else if (event.status == 'stopped') {
        _status = '멈춤';
      } else {
        _status = '알 수 없음';
      }
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = '보행 상태를 사용할 수 없음';
    });
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = '걸음 수를 사용할 수 없음';
    });
  }

  Future<bool> _checkActivityRecognitionPermission() async {
    bool granted = await Permission.activityRecognition.isGranted;

    if (!granted) {
      granted = await Permission.activityRecognition.request() ==
          PermissionStatus.granted;
    }

    return granted;
  }

  Future<void> initPlatformState() async {
    bool granted = await _checkActivityRecognitionPermission();
    if (!granted) {
      // tell user, the app will not work
    }

    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    (await _pedestrianStatusStream.listen(onPedestrianStatusChanged))
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 100, // 너비를 고정하거나 필요에 맞게 조정할 수 있습니다
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '걸음수',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  _steps,
                  style: TextStyle(fontSize: 40),
                ),
              ],
            ),
          ),
          SizedBox(width: 20),
          Container(
            width: 100, // 너비를 고정하거나 필요에 맞게 조정할 수 있습니다
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '보행 상태',
                  style: TextStyle(fontSize: 20),
                ),
                Icon(
                  _status == '걷는 중'
                      ? Icons.directions_walk
                      : _status == '멈춤'
                          ? Icons.accessibility_new
                          : Icons.error,
                  size: 50,
                ),
                Text(
                  _status,
                  style: _status == '걷는 중' || _status == '멈춤'
                      ? TextStyle(fontSize: 20)
                      : TextStyle(fontSize: 20, color: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
