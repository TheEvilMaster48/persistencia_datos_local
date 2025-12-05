import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/clima_service.dart';

class ClimaScreen extends StatefulWidget {
  const ClimaScreen({super.key});

  @override
  State<ClimaScreen> createState() => _ClimaScreenState();
}

class _ClimaScreenState extends State<ClimaScreen> {
  final ClimaService _service = ClimaService();

  String ciudad = "";
  double temp = 0;
  String desc = "";
  String icono = "";
  List<dynamic> horas = [];

  bool cargando = true;
  String error = "";

  @override
  void initState() {
    super.initState();
    cargarClima();
  }

  Future<void> cargarClima() async {
    try {
      await Geolocator.requestPermission();
      final pos = await Geolocator.getCurrentPosition();

      final actual = await _service.climaActual(pos.latitude, pos.longitude);
      final porHoras = await _service.climaPorHoras(pos.latitude, pos.longitude);

      if (!mounted) return;

      setState(() {
        ciudad = actual["location"]["name"];
        temp = actual["current"]["temp_c"];
        desc = actual["current"]["condition"]["text"];

        final iconPath = actual["current"]["condition"]["icon"] ?? "";
        icono = iconPath.isNotEmpty
            ? "https:$iconPath"
            : "https://cdn.weatherapi.com/weather/64x64/day/113.png";

        horas = porHoras;
        cargando = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        ciudad = "ERROR";
        desc = "No se pudo obtener el clima";
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade900,
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade900,
        title: const Text("Clima por horas"),
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Column(
              children: [
                const SizedBox(height: 20),

                // ERROR DETALLADO
                if (error.isNotEmpty)
                  Text(
                    error,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),

                Text(
                  ciudad,
                  style: const TextStyle(color: Colors.white, fontSize: 26),
                ),

                Image.network(icono, width: 80),

                Text(
                  "$temp°C",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),

                Text(
                  desc.toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: horas.length,
                    itemBuilder: (context, i) {
                      final h = horas[i];

                      final hora = h["time"].substring(11, 16);
                      final t = h["temp_c"];

                      final iconPath = h["condition"]["icon"] ?? "";
                      final iconUrl = iconPath.isNotEmpty
                          ? "https:$iconPath"
                          : "https://cdn.weatherapi.com/weather/64x64/day/113.png";

                      return Container(
                        width: 120,
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              hora,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                            const SizedBox(height: 6),
                            Image.network(iconUrl, width: 50),
                            Text(
                              "$t°C",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
