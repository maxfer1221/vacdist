import 'package:flutter/services.dart';
import 'package:vacdist_shared/classes/Address.dart';
import 'package:vacdist_shared/classes/VaccinationSite.dart';
import 'package:vacdist_shared/functions/AuthToken.dart';
import 'package:vacdist_provider/classes/VaccinationSiteMarker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

Future<String> uri() async {
  return await rootBundle.loadString('assets/api_uri.txt');
}

Future<bool> login(String username, String passwordHash) async {
  var url = Uri.https(
    await uri(),
    '/users/login',
    {'email': username, 'pass': passwordHash},
  );
  var response = await http.get(url);

  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    var customToken = jsonResponse['customToken'];
    try {
      await FirebaseAuth.instance.signInWithCustomToken(customToken.toString());
      return true;
    } catch (e) {
      return false;
    }
  }

  print('Request failed with status: ${response.statusCode}');
  return false;
}

Future<VaccinationSiteMarker?> getOptimalSite(
  double latitude,
  double longitude,
  int radius,
) async {
  var authtoken = await getIdToken();
  var url = Uri.https(await uri(), '/sites/optimal_location', {
    'authtoken': authtoken,
    'latitude': latitude.toString(),
    'longitude': longitude.toString(),
    'radius': radius.toString(),
  });
  var response = await http.get(url);

  if (response.statusCode == 200) {
    var responsebody = convert.jsonDecode(response.body);

    return VaccinationSiteMarker(
      address: Address.fromJson(responsebody['address']),
      id: '',
      latitude: responsebody['optimalCoordinates']['latitude'],
      longitude: responsebody['optimalCoordinates']['longitude'],
    );
  }

  // Get request failed, return fake sites for testing purposes
  print('Request failed with status: ${response.statusCode}');
  return null;
}

Future<List<VaccinationSiteMarker>> getVaccinationSites() async {
  var authToken = await getIdToken();

  var url = Uri.https(await uri(), '/sites/provider', {'authtoken': authToken});
  var response = await http.get(url);

  if (response.statusCode == 200) {
    var sites = convert.jsonDecode(response.body);

    return List<VaccinationSiteMarker>.from(
        sites.map((site) => VaccinationSiteMarker.fromJson(site)));
  }

  // Failed get request, return fake site for testing purposes
  print('Request failed with status: ${response.statusCode}');
  return [
    VaccinationSiteMarker(
      id: '126358970',
      latitude: 28.6080441,
      longitude: -81.2006213,
      address: Address(
        street1: '4274 W Plaza Dr',
        city: 'Orlando',
        stateOrProvince: 'FL',
        postalCode: '32816',
        country: 'USA',
      ),
    ),
  ];
}

Future<String> createVaccinationSite(VaccinationSite site) async {
  var authtoken = await getIdToken();
  var url = Uri.https(await uri(), '/sites/create');
  var body = {'authtoken': authtoken, 'site': site.toJson()};
  var encodedBody = convert.jsonEncode(body);
  var response = await http.post(url, body: {'string': encodedBody});
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);

    return jsonResponse['error'];
  }
  return 'Creation failed with status code ${response.statusCode}';
}

Future<String> deleteVaccinationSite(VaccinationSite site) async {
  var authtoken = await getIdToken();
  var url = Uri.https(await uri(), '/sites/delete');
  var body = {'authtoken': authtoken, 'site': site.toJson()};
  var encodedBody = convert.jsonEncode(body);
  var response = await http.post(url, body: {'string': encodedBody});
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);

    return jsonResponse['error'];
  }
  return 'Creation failed with status code ${response.statusCode}';
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
