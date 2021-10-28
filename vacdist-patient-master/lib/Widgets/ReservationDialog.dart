import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vacdist/functions/API.dart';
import 'package:vacdist_shared/Widgets/SimpleAlertDialog.dart';
import 'package:vacdist/classes/VaccinationSiteMarker.dart';

class ReservationDialog extends StatefulWidget {
  ReservationDialog({required this.site});

  final VaccinationSiteMarker site;

  @override
  _ReservationDialogState createState() => _ReservationDialogState(site: site);
}

class _ReservationDialogState extends State<ReservationDialog> {
  _ReservationDialogState({required this.site});

  final VaccinationSiteMarker site;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Reservation'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              "Are you sure you'd like to reserve a spot at the " +
                  site.name +
                  '?',
            ),
            const Text(
              'An email reminder will be sent to your address on file two days before the vaccination site opens and two days before it closes.',
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            var result = await setUserReservationStatus(site);
            Navigator.of(context).pop();

            if (result == '') {
              await showDialog(
                context: context,
                builder: (context) => SimpleAlertDialog(
                  title: 'Spot Reserved',
                  subtitles: ['You reserved a spot at this vaccination site.'],
                ),
              );
            } else {
              await showDialog(
                context: context,
                builder: (context) => SimpleAlertDialog(
                  title: 'Failed to Reserve Spot',
                  subtitles: [
                    "We couldn't reserve you a spot at this vaccination site.",
                    'Error code: ' + result
                  ],
                ),
              );
            }
          },
          child: const Text('YES'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('NO'),
        ),
      ],
    );
  }
}
