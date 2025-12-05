import 'package:geolocator/geolocator.dart';
import '../models/altitud_model.dart';

class AltitudService {
  Future<AltitudData> obtenerAltitud() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verificar si GPS está activado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("GPS desactivado");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Permiso denegado");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Permiso denegado permanentemente");
    }

    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return AltitudData(
      altitud: pos.altitude,
      latitud: pos.latitude,
      longitud: pos.longitude,
    );
  }
}
