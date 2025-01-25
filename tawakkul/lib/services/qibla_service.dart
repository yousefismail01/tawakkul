import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math' as math;

class QiblaService {
  static Widget buildCompass(AsyncSnapshot<CompassEvent> snapshot) {
    if (snapshot.hasError) {
      return const Center(child: Text('Error reading compass'));
    }

    if (!snapshot.hasData) {
      return const Center(child: CircularProgressIndicator());
    }

    double? direction = snapshot.data!.heading;
    if (direction == null) {
      return const Center(child: Text('Device does not have sensors'));
    }

    return Center(
      child: Transform.rotate(
        angle: (direction * (math.pi / 180) * -1),
        child: const Icon(Icons.explore, size: 100),
      ),
    );
  }
}