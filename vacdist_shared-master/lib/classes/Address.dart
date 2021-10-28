class Address {
  const Address({
    required this.street1,
    this.street2 = '',
    this.street3 = '',
    required this.city,
    required this.stateOrProvince,
    required this.postalCode,
    required this.country,
  });

  Address.fromJson(Map<String, dynamic> json)
      : street1 = json['street1'],
        street2 = json['street2'] ?? '',
        street3 = json['street3'] ?? '',
        city = json['city'],
        stateOrProvince = json['stateOrProvince'],
        postalCode = json['postalCode'],
        country = json['country'];

  Map<String, dynamic> toJson() => {
        'street1': street1,
        'street2': street2,
        'street3': street3,
        'city': city,
        'stateOrProvince': stateOrProvince,
        'postalCode': postalCode,
        'country': country,
      };

  final String street1;
  final String street2;
  final String street3;
  final String city;
  final String stateOrProvince;
  final String postalCode;
  final String country;

  @override
  String toString() {
    return street1 +
        (street2 == '' ? '' : ', ' + street2) +
        (street3 == '' ? '' : ', ' + street3) +
        ', ' +
        city +
        ', ' +
        stateOrProvince +
        ' ' +
        postalCode +
        ', ' +
        country;
  }
}
