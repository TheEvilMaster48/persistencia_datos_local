import 'package:flutter/material.dart';
import '../services/altitud_service.dart';

class AltitudScreen extends StatefulWidget {
  const AltitudScreen({super.key});

  @override
  State<AltitudScreen> createState() => _AltitudScreenState();
}

class _AltitudScreenState extends State<AltitudScreen> {
  final AltitudService _service = AltitudService();

  double? altitud;
  double? latitud;
  double? longitud;
  String mensaje = "Obteniendo datos...";

  @override
  void initState() {
    super.initState();
    _loadAltitud();
  }

  Future<void> _loadAltitud() async {
    try {
      final data = await _service.obtenerAltitud();
      setState(() {
        altitud = data.altitud;
        latitud = data.latitud;
        longitud = data.longitud;
        mensaje = "";
      });
    } catch (e) {
      setState(() {
        mensaje = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade900,
      appBar: AppBar(
        title: const Text("Altitud (GPS)"),
        backgroundColor: Colors.deepPurple.shade900,
      ),
      body: Center(
        child: mensaje.isNotEmpty
            ? Text(
                mensaje,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Altitud: ${altitud?.toStringAsFixed(2)} m",
                    style: const TextStyle(color: Colors.white, fontSize: 28),
                  ),
                  Text(
                    "Latitud: $latitud",
                    style: const TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  Text(
                    "Longitud: $longitud",
                    style: const TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                ],
              ),
      ),
    );
  }
}
