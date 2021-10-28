import 'package:flutter/material.dart';
import 'package:vacdist_provider/Widgets/CustomVaccinationSiteDialog.dart';
import 'package:vacdist_provider/Widgets/DeleteVaccinationSiteDialog.dart';
import 'package:vacdist_shared/classes/VaccinationSite.dart';

class EditVaccinationSiteDialog extends StatelessWidget {
  EditVaccinationSiteDialog({
    required this.site,
  });

  final VaccinationSite site;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit ' + site.name),
      content:
          const Text('What would you like to do with this vaccination site?'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => CustomVaccinationSiteDialog(
                        title: 'Edit vaccination site',
                        existingVaccinationSite: site,
                      ),
                  fullscreenDialog: true),
            );
          },
          child: const Text('Edit Properties'),
        ),
        TextButton(
          onPressed: () {},
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (context) => DeleteVaccinationSiteDialog(
                  site: site,
                ),
              );
            },
            child: const Text('Delete Site'),
          ),
        ),
      ],
    );
  }
}
