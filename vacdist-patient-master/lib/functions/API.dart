import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:vacdist/classes/VaccinationSiteMarker.dart';
import 'dart:convert' as convert;
import 'package:vacdist_shared/functions/AuthToken.dart';

Future<String> uri() async {
  return 'api.vacdist.com';
}

Future<List<VaccinationSiteMarker>> getVaccinationSites(
  double latitude,
  double longitude,
  int dist,
) async {
  var authToken = await getIdToken();

  var url = Uri.https(await uri(), '/sites/nearby', {
    'authtoken': authToken,
    'dist': dist.toString(),
    'latitude': latitude.toString(),
    'longitude': longitude.toString(),
  });
  var response = await http.get(url);

  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    return List<VaccinationSiteMarker>.from(
      jsonResponse.map(
        (value) => VaccinationSiteMarker.fromJson(value),
      ),
    );
  }

  print('Request failed with status: ${response.statusCode}');
  return [];
}

Future<List<String>> getSupportedCountries() async {
  var authToken = await getIdToken();

  var url = Uri.https(
      await uri(), '/supported_countries/all', {'authtoken': authToken});
  var response = await http.get(url);

  if (response.statusCode == 200) {
    var decoded = convert.jsonDecode(response.body);
    return List<String>.from(decoded);
  }

  print('Request failed with status: ${response.statusCode}');
  return ['United States'];
}

Future<bool> getUserReservationStatus(VaccinationSiteMarker site) async {
  var authToken = await getIdToken();

  var url = Uri.https(await uri(), '/users/reservation_status', {
    'authtoken': authToken,
    'site': site.id,
  });
  var response = await http.get(url);

  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    var reservationStatus = jsonResponse['reservationStatus'];
    return reservationStatus;
  }

  print('Request failed with status: ${response.statusCode}');
  return false;
}

Future<dynamic> getUserReservationGeneral() async {
  var authToken = await getIdToken();

  var url = Uri.https(await uri(), '/users/reservation_site', {
    'authtoken': authToken,
  });
  var response = await http.get(url);

  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    return VaccinationSiteMarker.fromJson(jsonResponse);
  }

  print('Request failed with status: ${response.statusCode}');
  return null;
}

Future<String> setUserReservationStatus(VaccinationSiteMarker site) async {
  var authToken = await getIdToken();

  var url = Uri.https(await uri(), '/users/reservation_status');
  var body = {'authtoken': authToken, 'reservation': site.id};
  var response = await http.post(url, body: body);

  if (response.statusCode == 200) {
    var jsonResponse = response.body;
    return jsonResponse;
  }

  var err = 'Request failed with status: ${response.statusCode}';
  print(err);
  return err;
}

Future<void> sendLocation(String zip) async {
  var authToken = await getIdToken();

  var url = Uri.https(await uri(), '/logins/save');
  var body = {'authtoken': authToken, 'zip': zip};
  await http.post(url, body: body);
}

Future<void> fileComplaint(String msg) async {
  var authToken = await getIdToken();

  var email = FirebaseAuth.instance.currentUser!.email;

  var url = Uri.https(await uri(), '/complaints/file');
  var body = {'authtoken': authToken, 'complaint': msg, 'email': email};
  await http.post(url, body: body);
}
