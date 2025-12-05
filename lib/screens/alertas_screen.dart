import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../models/alertas_model.dart';
import '../services/alertas_service.dart';

class AlertasScreen extends StatefulWidget {
  const AlertasScreen({super.key});

  @override
  State<AlertasScreen> createState() => _AlertasScreenState();
}

class _AlertasScreenState extends State<AlertasScreen> {
  final AlertasService _service = AlertasService();
  GoogleMapController? _mapController;
  Timer? _timer;

  // 🏡 TU CASA REAL – URB. VALLE DEL SOL
  final Alerta zonaHogar = Alerta(
    nombre: "Hogar – Valle del Sol (Challuabamba)",
    lat: -2.904045,
    lng: -78.951750,
    radio: 50000, // 50 km
  );

  Position? ubicacionActual;
  double distanciaActual = 0;
  String estado = "Cargando ubicación...";

  @override
  void initState() {
    super.initState();
    _iniciarMonitoreo();
  }

  Future<void> _iniciarMonitoreo() async {
    await Geolocator.requestPermission();

    _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      await _actualizarEstado();
    });
  }

  Future<void> _actualizarEstado() async {
    try {
      final pos = await _service.obtenerUbicacion();
      final distancia = Geolocator.distanceBetween(
        pos.latitude,
        pos.longitude,
        zonaHogar.lat,
        zonaHogar.lng,
      );

      final dentro = distancia <= zonaHogar.radio;

      if (!mounted) return;

      setState(() {
        ubicacionActual = pos;
        distanciaActual = distancia;
        estado = dentro
            ? "✅ DENTRO DE LA ZONA\n${(distancia / 1000).toStringAsFixed(2)} km del hogar"
            : "❌ FUERA DE LA ZONA\nA ${(distancia / 1000).toStringAsFixed(2)} km";
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(pos.latitude, pos.longitude),
        ),
      );
    } catch (e) {
      setState(() => estado = "Error obteniendo ubicación");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade900,
      appBar: AppBar(
        title: const Text("Alertas GPS"),
        backgroundColor: Colors.indigo.shade900,
      ),
      body: ubicacionActual == null
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Column(
              children: [
                SizedBox(
                  height: 400,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        ubicacionActual!.latitude,
                        ubicacionActual!.longitude,
                      ),
                      zoom: 13,
                    ),
                    myLocationEnabled: true,
                    onMapCreated: (c) => _mapController = c,
                    markers: {
                      // 🏡 MARCACIÓN DE TU HOGAR
                      Marker(
                        markerId: const MarkerId("hogar"),
                        position: LatLng(zonaHogar.lat, zonaHogar.lng),
                        infoWindow: InfoWindow(title: zonaHogar.nombre),
                      ),
                    },
                    circles: {
                      Circle(
                        circleId: const CircleId("zonaHogar"),
                        center: LatLng(zonaHogar.lat, zonaHogar.lng),
                        radius: zonaHogar.radio,
                        fillColor: Colors.blue.withOpacity(0.15),
                        strokeColor: Colors.blue,
                        strokeWidth: 2,
                      )
                    },
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  estado,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
    );
  }
}
