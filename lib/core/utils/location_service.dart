import 'dart:convert';
import 'package:car_rental_app_clean_arch/core/secrets/app_secrets.dart';
import 'package:http/http.dart' as http;

class LocationService {

  static Future<List<String>> fetchSuggestions(String input) async {
    if (input.isEmpty) return [];

    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=${AppSecrets.googleAPI}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final predictions = data['predictions'] as List<dynamic>;

        return predictions
            .map((prediction) => prediction['description'] as String)
            .take(5)
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
