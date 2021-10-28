import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vacdist_shared/classes/Address.dart';
import 'package:vacdist_shared/classes/VaccinationSite.dart';

class VaccinationSiteMarker extends VaccinationSite {
  VaccinationSiteMarker({
    required String id,
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    required double latitude,
    required double longitude,
    required Address address,
    required String descriptor,
    required int spotsLeft,
  }) : super(
          id: id,
          name: name,
          startDate: startDate,
          endDate: endDate,
          latitude: latitude,
          longitude: longitude,
          address: address,
          descriptor: descriptor,
          spotsLeft: spotsLeft,
        );

  VaccinationSiteMarker.fromJson(Map<String, dynamic> json)
      : super.fromJson(json);

  Marker getMarker(void Function() onTap) {
    return Marker(
      markerId: MarkerId(id),
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(
        title: name,
        snippet: descriptor,
      ),
      onTap: onTap,
    );
  }
}
