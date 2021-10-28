import 'package:flutter/material.dart';
import 'package:vacdist_provider/Widgets/CreateVaccinationSiteDialog.dart';
import 'package:vacdist_shared/classes/Address.dart';
import 'package:vacdist_provider/functions/LocationHelper.dart';
import 'package:vacdist_shared/Widgets/SimpleAlertDialog.dart';
import 'package:vacdist_shared/classes/VaccinationSite.dart';
// import 'package:uuid/uuid.dart';

class CustomVaccinationSiteDialog extends StatefulWidget {
  CustomVaccinationSiteDialog({
    required this.title,
    this.existingVaccinationSite,
  });

  final String title;
  final VaccinationSite? existingVaccinationSite;

  @override
  _CustomVaccinationSiteDialogState createState() =>
      _CustomVaccinationSiteDialogState();
}

class _CustomVaccinationSiteDialogState
    extends State<CustomVaccinationSiteDialog> {
  final nameController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final streetAddress1Controller = TextEditingController();
  final streetAddress2Controller = TextEditingController();
  final streetAddress3Controller = TextEditingController();
  final cityController = TextEditingController();
  final stateProvinceController = TextEditingController();
  final postalCodeController = TextEditingController();
  final countryController = TextEditingController();
  final descriptorController = TextEditingController();
  final spotsLeftController = TextEditingController();

  @override
  void dispose() {
    [
      nameController,
      startDateController,
      endDateController,
      streetAddress1Controller,
      streetAddress2Controller,
      streetAddress3Controller,
      cityController,
      stateProvinceController,
      postalCodeController,
      countryController,
      descriptorController,
      spotsLeftController,
    ].forEach((element) => element.dispose());
    super.dispose();
  }

  @override
  void initState() {
    if (widget.existingVaccinationSite != null) {
      nameController.text = widget.existingVaccinationSite!.name;
      startDateController.text =
          widget.existingVaccinationSite!.startDate.toString();
      endDateController.text =
          widget.existingVaccinationSite!.endDate.toString();
      streetAddress1Controller.text =
          widget.existingVaccinationSite!.address.street1;
      streetAddress2Controller.text =
          widget.existingVaccinationSite!.address.street2;
      streetAddress3Controller.text =
          widget.existingVaccinationSite!.address.street3;
      cityController.text = widget.existingVaccinationSite!.address.city;
      stateProvinceController.text =
          widget.existingVaccinationSite!.address.stateOrProvince;
      postalCodeController.text =
          widget.existingVaccinationSite!.address.postalCode;
      countryController.text = widget.existingVaccinationSite!.address.country;
      descriptorController.text = widget.existingVaccinationSite!.descriptor;
      spotsLeftController.text =
          widget.existingVaccinationSite!.spotsLeft.toRadixString(10);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _content(context),
    );
  }

  Widget _padding(Widget child) {
    return Padding(
      padding: EdgeInsets.only(
        left: 15,
        right: 15,
      ),
      child: child,
    );
  }

  Widget _textField(
    TextInputType? keyboardType,
    String hintText,
    TextEditingController controller, {
    int? minLines,
    int? maxLines,
  }) {
    return TextField(
      keyboardType: keyboardType,
      decoration: InputDecoration(hintText: hintText),
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
    );
  }

  Widget _content(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: 12,
            bottom: 16,
            left: 15,
            right: 15,
          ),
          child: _textField(
            null,
            'Name',
            nameController,
          ),
        ),
        _padding(
          _textField(
            TextInputType.datetime,
            'When will this site begin operating? (YYYY/MM/DD)',
            startDateController,
            minLines: 2,
            maxLines: 2,
          ),
        ),
        _padding(
          _textField(
            TextInputType.datetime,
            'When will this site cease operations? (YYYY/MM/DD)',
            endDateController,
            minLines: 2,
            maxLines: 2,
          ),
        ),
        _padding(
          _textField(
            TextInputType.streetAddress,
            'Street address 1 (closest to vaccination site)',
            streetAddress1Controller,
          ),
        ),
        _padding(
          _textField(
            TextInputType.streetAddress,
            'Street address 2 (optional)',
            streetAddress2Controller,
          ),
        ),
        _padding(
          _textField(
            TextInputType.streetAddress,
            'Street address 3 (optional)',
            streetAddress3Controller,
          ),
        ),
        _padding(
          _textField(
            TextInputType.streetAddress,
            'City',
            cityController,
          ),
        ),
        _padding(
          _textField(
            TextInputType.streetAddress,
            'State or Province',
            stateProvinceController,
          ),
        ),
        _padding(
          _textField(
            TextInputType.number,
            'Postal code',
            postalCodeController,
          ),
        ),
        _padding(
          _textField(
            TextInputType.streetAddress,
            'Country',
            countryController,
          ),
        ),
        _padding(
          _textField(
            TextInputType.streetAddress,
            'Description (parking, exact location, etc.)',
            descriptorController,
          ),
        ),
        _padding(
          _textField(
            TextInputType.number,
            'Daily capacity',
            spotsLeftController,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 40, right: 40, bottom: 20, top: 20),
          child: ElevatedButton(
            onPressed: () {
              if ([
                streetAddress1Controller,
                cityController,
                stateProvinceController,
                postalCodeController,
                countryController
              ].any((value) => value.text == '')) {
                showDialog(
                  context: context,
                  builder: (context) => SimpleAlertDialog(
                    title: 'Invalid data',
                    subtitles: [
                      'One or more required form fields was unfilled.',
                      "Please fill all form fields not marked 'optional' and try again."
                    ],
                  ),
                );
                return;
              }

              var postalCode = postalCodeController.text;
              if (int.tryParse(postalCode) == null) {
                showDialog(
                  context: context,
                  builder: (context) => SimpleAlertDialog(
                    title: 'Invalid postal code',
                    subtitles: [
                      'The postal code you entered is not a valid number.',
                      'Please remove all dashes or other non-number characters and try again.'
                    ],
                  ),
                );
                return;
              }
              var startDate = DateTime.tryParse(
                  startDateController.text.replaceAll('/', '-'));
              var endDate = DateTime.tryParse(
                  endDateController.text.replaceAll('/', '-'));
              if (startDate == null || endDate == null) {
                showDialog(
                  context: context,
                  builder: (context) => SimpleAlertDialog(
                    title: 'Invalid date',
                    subtitles: [
                      'Either the start or end date you provided was not a valid date.',
                      'Please enter your dates in the format YYYY/MM/DD, for example, 2021/03/21 to indicate March 21st, 2021.'
                    ],
                  ),
                );
                return;
              }

              var spotsLeft = int.tryParse(spotsLeftController.text);
              if (spotsLeft == null) {
                showDialog(
                  context: context,
                  builder: (context) => SimpleAlertDialog(
                    title: 'Invalid availability',
                    subtitles: [
                      'The daily capacity you provided was not a valid number.',
                      'Please enter a valid number in the area provided and try again.'
                    ],
                  ),
                );
                return;
              }

              var address = Address(
                street1: streetAddress1Controller.text,
                street2: streetAddress2Controller.text,
                street3: streetAddress3Controller.text,
                city: cityController.text,
                stateOrProvince: stateProvinceController.text,
                postalCode: postalCode,
                country: countryController.text,
              );

              getLocationFromAddress(address).then(
                (value) {
                  var site = VaccinationSite(
                    id: widget.existingVaccinationSite?.id ?? '',
                    name: nameController.text,
                    startDate: startDate,
                    endDate: endDate,
                    latitude: value.latitude,
                    longitude: value.longitude,
                    address: address,
                    descriptor: descriptorController.text,
                    spotsLeft: spotsLeft,
                  );

                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (context) =>
                        CreateVaccinationSiteDialog(site: site),
                  );
                },
              );
            },
            child: const Text('Continue'),
          ),
        ),
      ],
    );
  }
}
