import 'package:flutter/material.dart';
import 'package:vacdist_provider/Widgets/EditVaccinationSiteDialog.dart';
import 'package:vacdist_provider/Widgets/VaccinationSiteMapWidget.dart';
import 'package:vacdist_provider/functions/API.dart';
import 'package:vacdist_provider/functions/LocationHelper.dart';
import 'package:vacdist_shared/Widgets/DynamicContainer.dart';
import 'package:vacdist_shared/Widgets/SimpleAlertDialog.dart';

import 'LocationInformationDialog.dart';

class ProviderChoiceWidget extends StatelessWidget {
  ProviderChoiceWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vacdist'),
      ),
      body: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return Center(
      child: DynamicContainer(
        heightPct: 0.75,
        widthPct: 0.75,
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15),
              child: ElevatedButton(
                onPressed: () {
                  getCurrentLocation().then(
                    (currentLocation) {
                      if (currentLocation == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                                'We could not determine your current location. Please enter it manually in the dialog above.'),
                          ),
                        );
                        getSupportedCountries().then(
                          (list) => showDialog(
                            context: context,
                            builder: (_) => LocationInformationDialog(
                              countries: list,
                            ),
                            barrierDismissible: false,
                          ),
                        );
                      } else {}
                    },
                  );
                },
                child: const Text('Create New Vaccination Site'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: ElevatedButton(
                onPressed: () {
                  getVaccinationSites().then(
                    (value) {
                      if(value.isEmpty){
                        showDialog(
                          context: context,
                          builder: (context) => SimpleAlertDialog(
                            title: 'No Vaccination Sites',
                            subtitles: [
                              'You do not have any Vaccination Sites set up.',
                              'Create a new site and then return to view it.'
                            ],
                          )
                        );
                      }
                      else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                VaccinationSiteMapWidget(
                                  vaccinationSites: value,
                                  title: const Text('Edit Vaccination Sites'),
                                  siteActionButtonBuilder: (context, vaccSite) {
                                    return TextButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              EditVaccinationSiteDialog(
                                                site: vaccSite,
                                              ),
                                        );
                                      },
                                      child: const Text(
                                        'EDIT',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                          ),
                        );
                      }
                    },
                  );
                },
                child: const Text('Show Vaccination Sites'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
