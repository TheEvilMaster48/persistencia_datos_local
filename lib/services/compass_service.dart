import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';
import '../models/compass_model.dart';

class CompassService {
  Stream<CompassData> startListening() {
    return magnetometerEvents.map((event) {
      double heading = _calculateHeading(event.x, event.y);
      return CompassData(heading: heading);
    });
  }

  double _calculateHeading(double x, double y) {
    double angle = (180 / pi) * atan2(y, x);
    return (angle + 360) % 360;
  }
}
