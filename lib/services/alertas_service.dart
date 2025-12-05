import 'package:geolocator/geolocator.dart';
import '../models/alertas_model.dart';

class AlertasService {

  Future<Position> obtenerUbicacion() async {
    bool enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) throw Exception("GPS desactivado");

    LocationPermission permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) {
        throw Exception("Permiso de ubicación denegado");
      }
    }

    if (permiso == LocationPermission.deniedForever) {
      throw Exception("Permiso de ubicación bloqueado");
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<double> distanciaAAlerta(Alerta alerta) async {
    final pos = await obtenerUbicacion();

    return Geolocator.distanceBetween(
      pos.latitude,
      pos.longitude,
      alerta.lat,
      alerta.lng,
    );
  }

  Future<bool> verificarZona(Alerta alerta) async {
    final distancia = await distanciaAAlerta(alerta);
    print("DISTANCIA REAL A LA CASA: $distancia metros");

    return distancia <= alerta.radio;
  }
}
