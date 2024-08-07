import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:coco_ai_assistant/MODELS/constants.dart';

Future<String> getDistanceInMiles(
  Map<String, double> coords1,
  Map<String, double> coords2,
) async {
  String apiUrl = "https://maps.googleapis.com/maps/api/distancematrix/json";
  String origin = "${coords1['latitude']},${coords1['longitude']}";
  String destination = "${coords2['latitude']},${coords2['longitude']}";
  String requestUrl =
      "$apiUrl?origins=$origin&destinations=$destination&key=$googleApiKey";

  print("Request URL: $requestUrl");

  try {
    http.Response response = await http.get(Uri.parse(requestUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      if (data['status'] == "OK" &&
          data['rows'] != null &&
          data['rows'].isNotEmpty &&
          data['rows'][0]['elements'] != null &&
          data['rows'][0]['elements'].isNotEmpty) {
        int distanceInMeters =
            data['rows'][0]['elements'][0]['distance']['value'];
        double distanceInMiles = (distanceInMeters * 0.000621371).toDouble();
        return distanceInMiles.toStringAsFixed(2);
      } else {
        throw Exception("Error fetching distance data");
      }
    } else {
      throw Exception(
          "Failed to load data, status code: ${response.statusCode}");
    }
  } catch (error) {
    print("Error: $error");
    rethrow;
  }
}

Future<String> getDistanceInKilometers(
  Map<String, double> coords1,
  Map<String, double> coords2,
) async {
  String apiUrl = "https://maps.googleapis.com/maps/api/distancematrix/json";
  String origin = "${coords1['latitude']},${coords1['longitude']}";
  String destination = "${coords2['latitude']},${coords2['longitude']}";
  String requestUrl =
      "$apiUrl?origins=$origin&destinations=$destination&key=$googleApiKey";

  try {
    http.Response response = await http.get(Uri.parse(requestUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      if (data['status'] == "OK" &&
          data['rows'] != null &&
          data['rows'].isNotEmpty &&
          data['rows'][0]['elements'] != null &&
          data['rows'][0]['elements'].isNotEmpty) {
        int distanceInMeters =
            data['rows'][0]['elements'][0]['distance']['value'];
        double distanceInKilometers = (distanceInMeters / 1000).toDouble();
        return distanceInKilometers.toStringAsFixed(2);
      } else {
        throw Exception("Error fetching distance data");
      }
    } else {
      throw Exception(
          "Failed to load data, status code: ${response.statusCode}");
    }
  } catch (error) {
    print("Error: $error");
    rethrow;
  }
}

double haversineDistance(double lat1, double lon1, double lat2, double lon2) {
  const double R = 6371; // Radius of the Earth in kilometers

  // Convert degrees to radians
  double dLat = _toRadians(lat2 - lat1);
  double dLon = _toRadians(lon2 - lon1);
  double lat1Rad = _toRadians(lat1);
  double lat2Rad = _toRadians(lat2);

  // Haversine formula
  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);

  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  // Distance in kilometers
  double distance = R * c;

  return distance;
}

double _toRadians(double degrees) {
  return degrees * (pi / 180);
}

double milesToLat(double miles) {
  return miles / 69.172; // Approximate degrees of latitude per mile
}

double milesToLon(double miles, double longitude) {
  double milesPerDegreeLon = 69.172 * cos(longitude * (pi / 180));
  return miles / milesPerDegreeLon;
}

double kmToLat(double km) {
  return km / 110.574; // Approximate degrees of latitude per kilometer
}

double kmToLon(double km, double latitude) {
  double kmPerDegreeLon = 111.32 * cos(latitude * (pi / 180));
  return km / kmPerDegreeLon;
}

double fahrenheitToCelsius(double fahrenheit) {
  return (5 / 9) * (fahrenheit - 32);
}

double celsiusToFahrenheit(double celsius) {
  return (9 / 5) * celsius + 32;
}
