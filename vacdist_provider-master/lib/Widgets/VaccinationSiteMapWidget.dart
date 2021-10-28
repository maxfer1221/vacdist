import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vacdist_provider/classes/VaccinationSiteMarker.dart';
import 'package:vacdist_shared/Widgets/DynamicContainer.dart';
import 'package:vacdist_shared/classes/VaccinationSite.dart';

class VaccinationSiteMapWidget extends StatefulWidget {
  VaccinationSiteMapWidget({
    required this.vaccinationSites,
    required this.title,
    required this.siteActionButtonBuilder,
    this.floatingActionButton,
  });

  final List<VaccinationSiteMarker> vaccinationSites;
  final Text title;
  final FloatingActionButton? floatingActionButton;
  final TextButton Function(BuildContext, VaccinationSite)
      siteActionButtonBuilder;

  @override
  _VaccinationSiteMapWidgetState createState() =>
      _VaccinationSiteMapWidgetState();
}

class _VaccinationSiteMapWidgetState extends State<VaccinationSiteMapWidget> {
  _VaccinationSiteMapWidgetState();

  late GoogleMapController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.title,
      ),
      floatingActionButton: widget.floatingActionButton,
      body: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          DynamicContainer(
            heightPct: 0.5,
            widthPct: 1.0,
            child: GoogleMap(
              onMapCreated: (controller) => this.controller = controller,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  widget.vaccinationSites[0].latitude,
                  widget.vaccinationSites[0].longitude,
                ),
                zoom: 10.0,
              ),
              markers: widget.vaccinationSites
                  .map((site) => site.getMarker())
                  .toSet(),
            ),
          ),
          Expanded(
            child: DynamicContainer(
              heightPct: 0.5,
              widthPct: 1.0,
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: _VaccinationSiteListWidget(
                sites: widget.vaccinationSites,
                siteActionButtonBuilder: widget.siteActionButtonBuilder,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VaccinationSiteListWidget extends StatefulWidget {
  _VaccinationSiteListWidget({
    required this.sites,
    required this.siteActionButtonBuilder,
  });

  final List<VaccinationSiteMarker> sites;
  final TextButton Function(BuildContext, VaccinationSite)
      siteActionButtonBuilder;

  @override
  _VaccinationSiteListWidgetState createState() =>
      _VaccinationSiteListWidgetState();
}

class _VaccinationSiteListWidgetState
    extends State<_VaccinationSiteListWidget> {
  _VaccinationSiteListWidgetState();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(
            widget.sites[index].name,
            style: Theme.of(context).textTheme.headline6,
          ),
          subtitle: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.sites[index].address
                          .toString()
                          .split(', ')
                          .join(', ') +
                      '\n' +
                      widget.sites[index].descriptor,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: widget.siteActionButtonBuilder(
                  context,
                  widget.sites[index],
                ),
              ),
            ],
          ),
          isThreeLine: true,
        );
      },
      itemCount: widget.sites.length,
      separatorBuilder: (BuildContext context, _) => const Divider(),
    );
  }
}
