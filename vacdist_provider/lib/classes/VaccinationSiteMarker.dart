import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vacdist_shared/classes/Address.dart';
import 'package:vacdist_shared/classes/VaccinationSite.dart';

class VaccinationSiteMarker extends VaccinationSite {
  VaccinationSiteMarker({
    required String id,
    required double latitude,
    required double longitude,
    Address address = const Address(
      street1: 'Street address 1',
      city: 'City',
      stateOrProvince: 'State',
      postalCode: 'Postal Code',
      country: 'Country',
    ),
  }) : super(
          id: id,
          name: 'Suggested Vaccination Site',
          startDate: DateTime.now(),
          endDate: DateTime.now(),
          latitude: latitude,
          longitude: longitude,
          address: address,
          descriptor: 'Based on requests and logins over the past 30 days',
          spotsLeft: 0,
        );

  VaccinationSiteMarker.fromJson(Map<String, dynamic> json)
      : super.fromJson(json);

  Marker getMarker() {
    return Marker(
      markerId: MarkerId(id),
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(
        title: name,
        snippet: descriptor,
      ),
    );
  }
}
