import 'package:flutter/material.dart';
import 'package:vacdist_shared/classes/VaccinationSite.dart';
import 'package:vacdist_provider/functions/API.dart';

class DeleteVaccinationSiteDialog extends StatelessWidget {
  DeleteVaccinationSiteDialog({
    required this.site,
  });

  final VaccinationSite site;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete ' + site.name),
      content: Text('You are about to delete the vaccination site located at ' +
          site.address.toString() +
          '. Are you sure you would like to proceed?'),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            var value = await deleteVaccinationSite(site);
            if (value != '') {
              await showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: Text('Failed to delete vaccination site'),
                  content: Text(value + '. ' +
                      'If you have additional questions, please contact support.'
                  ),
                  actions: <Widget>[
                    TextButton(onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }, child: Text('Ok'))
                  ],
                ),
              );
            }
            else {
              await showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: Text('Deleted vaccination site'),
                  content: Text(
                      'Deletion of the vaccination site was successful.'
                  ),
                  actions: <Widget>[
                    TextButton(onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }, child: Text('Ok')),
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
