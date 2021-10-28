import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:vacdist/classes/VaccinationSiteMarker.dart';
import 'package:vacdist/functions/API.dart';
import 'package:vacdist/functions/LocationHelper.dart';
import 'package:vacdist/functions/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'PostalCodeDialog.dart';
import 'VaccinationSiteMapWidget.dart';

class SignInWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
      padding: EdgeInsets.all(15),
      child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            return SignInButton(
              Buttons.Google,
              text: 'Sign in with Google',
              onPressed: () {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Please wait...',
                    ),
                  ),
                );
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.login().then((_) {
                  getCurrentLocation().then((currentLocation) {
                    if (currentLocation == null) {
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'We could not determine your current location. Please enter it manually in the dialog above.',
                          ),
                        ),
                      );
                      getSupportedCountries().then(
                        (list) => showDialog(
                          context: context,
                          builder: (_) => PostalCodeDialog(
                            countries: list,
                          ),
                          barrierDismissible: false,
                        ),
                      );
                    } else {
                      late List<VaccinationSiteMarker> sites;

                      getVaccinationSites(currentLocation.latitude,
                              currentLocation.longitude, 300)
                          .then((value) => sites = value)
                          .then(
                        (_) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => VaccinationSiteMapWidget(
                                sites: sites,
                                centerPosition: currentLocation,
                              ),
                            ),
                            (route) => false,
                          );
                        },
                      );
                    }
                  });
                });
              },
            );
          }));
}
