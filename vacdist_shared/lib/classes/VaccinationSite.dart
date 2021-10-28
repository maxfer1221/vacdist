import 'package:vacdist_shared/classes/Address.dart';

class VaccinationSite {
  const VaccinationSite({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.descriptor,
    required this.spotsLeft,
  });

  VaccinationSite.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        startDate = DateTime.parse(json['startDate']),
        endDate = DateTime.parse(json['endDate']),
        latitude = json['latitude'].toDouble(),
        longitude = json['longitude'].toDouble(),
        address = Address.fromJson(json['address']),
        descriptor = json['descriptor'],
        spotsLeft = json['spotsLeft'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'startDate': startDate.toString(),
        'endDate': endDate.toString(),
        'latitude': latitude,
        'longitude': longitude,
        'address': address.toJson(),
        'descriptor': descriptor,
        'spotsLeft': spotsLeft,
      };

  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final double latitude;
  final double longitude;
  final Address address;
  final String descriptor;
  final int spotsLeft;
}
