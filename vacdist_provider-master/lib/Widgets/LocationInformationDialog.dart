import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vacdist_provider/classes/VaccinationSiteMarker.dart';
import 'package:vacdist_provider/functions/API.dart';
import 'package:vacdist_provider/functions/LocationHelper.dart';
import 'package:vacdist_provider/Widgets/VaccinationSiteMapWidget.dart';

import 'CreateVaccinationSiteDialog.dart';
import 'CustomVaccinationSiteDialog.dart';

class LocationInformationDialog extends StatefulWidget {
  LocationInformationDialog({required this.countries, this.latlng});

  final List<String> countries;
  final LatLng? latlng;

  @override
  _LocationInformationDialogState createState() =>
      _LocationInformationDialogState(countries: countries);
}

class _LocationInformationDialogState extends State<LocationInformationDialog> {
  _LocationInformationDialogState({required this.countries});

  final List<String> countries;
  String country = 'United States';
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController radiusController = TextEditingController();

  @override
  void dispose() {
    postalCodeController.dispose();
    radiusController.dispose();
    super.dispose();
  }

  void _segue(LatLng latlng, int radius) {
    getOptimalSite(latlng.latitude, latlng.longitude, radius).then(
      (value) {
        late List<VaccinationSiteMarker> sites;
        if (value == null) {
          sites = [];
        } else {
          sites = [value];
        }

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VaccinationSiteMapWidget(
              vaccinationSites: sites,
              title: const Text('Create New Vaccination Site'),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CustomVaccinationSiteDialog(
                        title: 'Create new site',
                      ),
                      fullscreenDialog: true,
                    ),
                  );
                },
                backgroundColor: Colors.blue,
                child: const Icon(Icons.add),
              ),
              siteActionButtonBuilder: (context, vaccSite) {
                return TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => CreateVaccinationSiteDialog(
                        site: vaccSite,
                      ),
                    );
                  },
                  child: const Text(
                    'CREATE',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Text title;
    List<Widget> children;

    if (widget.latlng == null) {
      title = const Text('Please provide your location');
      children = [
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
            controller: postalCodeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter postal code',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 15,
            right: 15,
          ),
          child: TextField(
            controller: radiusController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText:
                  'Enter the radius (in miles) of the area you operate in',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 40, right: 40, top: 40),
          child: ElevatedButton(
            onPressed: () {
              getLocationFromPostalCode(
                      int.parse(postalCodeController.text), country)
                  .then(
                (value) => _segue(
                  value,
                  int.parse(radiusController.text),
                ),
              );
            },
            child: const Text('Continue'),
          ),
        ),
      ];
    } else {
      title = const Text('Please provide your operating radius');
      children = [
        TextField(
          controller: radiusController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter the radius (in miles) of the area you operate in',
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 40, right: 40, top: 40),
          child: ElevatedButton(
            onPressed: () {
              _segue(
                widget.latlng!,
                int.parse(radiusController.text),
              );
            },
            child: const Text('Continue'),
          ),
        ),
      ];
    }

    return SimpleDialog(
      title: title,
      children: children,
    );
  }
}
