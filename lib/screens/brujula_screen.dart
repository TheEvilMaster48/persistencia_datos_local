import 'dart:math';
import 'package:flutter/material.dart';
import '../services/compass_service.dart';

class BrujulaScreen extends StatefulWidget {
  const BrujulaScreen({super.key});

  @override
  State<BrujulaScreen> createState() => _BrujulaScreenState();
}

class _BrujulaScreenState extends State<BrujulaScreen> {
  final CompassService _service = CompassService();
  double _heading = 0;

  String _direccionCardinal(double grados) {
    if (grados >= 337.5 || grados < 22.5) return "N";
    if (grados < 67.5) return "NE";
    if (grados < 112.5) return "E";
    if (grados < 157.5) return "SE";
    if (grados < 202.5) return "S";
    if (grados < 247.5) return "SO";
    if (grados < 292.5) return "O";
    return "NO";
  }

  @override
  void initState() {
    super.initState();
    _service.startListening().listen((data) {
      setState(() => _heading = data.heading);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Brújula"),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.rotate(
              angle: (-_heading) * pi / 180,
              child: const Icon(
                Icons.navigation,
                size: 180,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "${_heading.toStringAsFixed(0)}°  ${_direccionCardinal(_heading)}",
              style: const TextStyle(color: Colors.white, fontSize: 30),
            )
          ],
        ),
      ),
    );
  }
}
