import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import '../services/qibla_service.dart';

class QiblaScreen extends StatelessWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        return QiblaService.buildCompass(snapshot);
      },
    );
  }
}