import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vacdist/functions/API.dart';
import 'package:vacdist/states/FlowtterState.dart';

Future<bool> getLocationPermissions() async {
  if (!(await Geolocator.isLocationServiceEnabled())) {
    return false;
  }

  var perms = await Geolocator.checkPermission();
  if (perms == LocationPermission.denied) {
    perms = await Geolocator.requestPermission();
    if (perms == LocationPermission.deniedForever ||
        perms == LocationPermission.denied) {
      return false;
    }
  }
  return true;
}

Future<LatLng?> getCurrentLocation() async {
  if (!(await getLocationPermissions())) {
    return null;
  }

  try {
    final pos =
        await Geolocator.getCurrentPosition(timeLimit: Duration(seconds: 3));
    return LatLng(pos.latitude, pos.longitude);
  } on TimeoutException {
    return null;
  }
}

Future<LatLng> getLocationFromPostalCode(String code, String country) async {
  var location =
      (await locationFromAddress(code.toString() + ', ' + country))[0];
  await sendLocation(code);

  var finalLocation = LatLng(location.latitude, location.longitude);

  FlowtterState.setLocation(finalLocation);
  return finalLocation;
}
