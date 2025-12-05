import 'dart:convert';
import 'package:http/http.dart' as http;

class ClimaService {
  final String apiKey = "56f1541a467845c5899191015250512";

  final String lugar = "Challuabamba,Cuenca,Ecuador";

  // CLIMA ACTUAL (CORREGIDO)
  Future<Map<String, dynamic>> climaActual(double lat, double lon) async {
    final url =
        "https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$lugar&lang=es";

    print("URL CLIMA ACTUAL: $url");

    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      print("ERROR CLIMA ACTUAL: ${response.body}");
      throw Exception("Error en clima actual");
    }

    return json.decode(response.body);
  }

  // CLIMA POR HORAS (CORREGIDO)
  Future<List<dynamic>> climaPorHoras(double lat, double lon) async {
    final url =
        "https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$lugar&days=1&lang=es";

    print("URL FORECAST: $url");

    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      print("ERROR FORECAST: ${response.body}");
      throw Exception("Error en forecast");
    }

    final data = json.decode(response.body);

    return data["forecast"]["forecastday"][0]["hour"];
  }
}
