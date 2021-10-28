import 'package:flutter/material.dart';
import 'package:vacdist_shared/classes/VaccinationSite.dart';
import 'package:vacdist_provider/functions/API.dart';

class CreateVaccinationSiteDialog extends StatefulWidget {
  CreateVaccinationSiteDialog({required this.site});

  final VaccinationSite site;

  @override
  _CreateVaccinationSiteDialogState createState() =>
      _CreateVaccinationSiteDialogState();
}

class _CreateVaccinationSiteDialogState
    extends State<CreateVaccinationSiteDialog> {
  _CreateVaccinationSiteDialogState();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Site Creation'),
      content: Text('You are about to create or edit a vaccination site at ' +
          widget.site.address.toString() +
          '. Are you sure you want to proceed?'),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            var value = await createVaccinationSite(widget.site);
            if (value != '') {
              await showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: Text('Failed to create vaccination site'),
                  content: Text(value +
                      '. ' +
                      'If you have additional questions, please contact support.'),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: Text('Ok'))
                  ],
                ),
              );
            } else {
              await showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: Text('Created vaccination site'),
                  content:
                      Text('Creation of the vaccination site was successful.'),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: Text('Ok')),
                  ],
                ),
              );
            }
          },
          child: const Text('Confirm'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        )
      ],
    );
  }
}
