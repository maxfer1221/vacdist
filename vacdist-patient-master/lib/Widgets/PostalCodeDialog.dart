import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vacdist/functions/API.dart';
import 'package:vacdist/functions/LocationHelper.dart';
import 'package:vacdist/Widgets/VaccinationSiteMapWidget.dart';

class PostalCodeDialog extends StatefulWidget {
  PostalCodeDialog({required this.countries});

  final List<String> countries;

  @override
  _PostalCodeDialogState createState() =>
      _PostalCodeDialogState(countries: countries);
}

class _PostalCodeDialogState extends State<PostalCodeDialog> {
  _PostalCodeDialogState({required this.countries});

  final List<String> countries;
  String country = 'United States';
  String postalCode = '';

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Please provide your location'),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: 12,
            bottom: 16,
            left: 15,
            right: 15,
          ),
          child: DropdownButton(
            value: country,
            items: countries.map((String value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                country = value!;
              });
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 15,
            right: 15,
          ),
          child: TextField(
            onChanged: (value) => postalCode = value,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter postal code',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 40, right: 40, top: 40),
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'Please wait, we are searching for nearby vaccination sites...',
                  ),
                ),
              );
              getLocationFromPostalCode(postalCode, country).then((value) {
                getVaccinationSites(value.latitude, value.longitude, 300)
                    .then((sites) {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => VaccinationSiteMapWidget(
                        sites: sites,
                        centerPosition: value,
                      ),
                    ),
                    (route) => false,
                  );
                });
              });
            },
            child: const Text('Continue'),
          ),
        ),
      ],
    );
  }
}
