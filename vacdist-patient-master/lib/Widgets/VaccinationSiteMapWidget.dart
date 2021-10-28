import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vacdist/Widgets/ChatDialog.dart';
import 'package:vacdist/states/FlowtterState.dart';
import 'package:vacdist_shared/Widgets/SimpleAlertDialog.dart';
import 'package:vacdist/classes/VaccinationSiteMarker.dart';
import 'package:vacdist/Widgets/ReservationDialog.dart';
import 'package:vacdist_shared/Widgets/DynamicContainer.dart';
import 'package:vacdist/functions/API.dart';
import 'package:indexed_list_view/indexed_list_view.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:get/get.dart';

class VaccinationSiteMapWidget extends StatefulWidget {
  VaccinationSiteMapWidget(
      {Key? key, required this.sites, required this.centerPosition})
      : super(key: key ?? GlobalKey<_VaccinationSiteMapWidgetState>());

  final List<VaccinationSiteMarker> sites;
  final LatLng centerPosition;

  @override
  _VaccinationSiteMapWidgetState createState() =>
      _VaccinationSiteMapWidgetState(
        sites: sites,
        centerPosition: centerPosition,
      );
}

class _VaccinationSiteMapWidgetState extends State<VaccinationSiteMapWidget> {
  _VaccinationSiteMapWidgetState(
      {required this.sites, required this.centerPosition});

  final List<VaccinationSiteMarker> sites;
  final LatLng centerPosition;
  late GoogleMapController controller;

  final GlobalKey<_VaccinationSiteListWidgetState> listKey = GlobalKey();

  void selectSite(String id) {
    controller.showMarkerInfoWindow(MarkerId(id));
    final site = sites.firstWhere((site) => site.id == id);
    controller.moveCamera(
        CameraUpdate.newLatLng(LatLng(site.latitude, site.longitude)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            DynamicContainer(
              heightPct: 0.5,
              widthPct: 1.0,
              child: GoogleMap(
                onMapCreated: (controller) => this.controller = controller,
                initialCameraPosition: CameraPosition(
                  target: centerPosition,
                  zoom: 12.0,
                ),
                markers: sites
                    .map(
                      (site) => site.getMarker(
                        () => listKey.currentState!.selectSite(site.id),
                      ),
                    )
                    .toSet(),
              ),
            ),
            DynamicContainer(
              heightPct: 0.5,
              widthPct: 1.0,
              child: _VaccinationSiteListWidget(
                key: listKey,
                sites: sites,
                mapKey:
                    widget.key! as GlobalKey<_VaccinationSiteMapWidgetState>,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VaccinationSiteListWidget extends StatefulWidget {
  _VaccinationSiteListWidget(
      {Key? key, required this.sites, required this.mapKey})
      : super(key: key);

  final List<VaccinationSiteMarker> sites;
  final GlobalKey<_VaccinationSiteMapWidgetState> mapKey;

  @override
  _VaccinationSiteListWidgetState createState() =>
      _VaccinationSiteListWidgetState(sites: sites);
}

class _VaccinationSiteListWidgetState
    extends State<_VaccinationSiteListWidget> {
  _VaccinationSiteListWidgetState({required this.sites});

  final List<VaccinationSiteMarker> sites;
  final IndexedScrollController controller = IndexedScrollController();
  final FlowtterState flowtterState = Get.put(FlowtterState());
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.offset < controller.initialScrollOffset ||
          _currentIndex < 0) {
        controller.jumpToIndex(0);
      } else if (_currentIndex >= sites.length) {
        controller.jumpToIndex(sites.length - 1);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void selectSite(String id) => controller.jumpToIndex(
        sites.indexWhere((site) => site.id == id),
      );

  @override
  Widget build(BuildContext context) {
    _currentIndex = 0;

    return Scaffold(
      body: IndexedListView.separated(
        minItemCount: 0,
        maxItemCount: sites.length - 1,
        itemBuilder: (BuildContext context, int index) {
          late Widget reservationButton;
          if (sites[index].spotsLeft > 0) {
            reservationButton = TextButton(
              onPressed: () async {
                if (await getUserReservationStatus(sites[index])) {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) => SimpleAlertDialog(
                      title: 'Already Reserved',
                      subtitles: [
                        'You already reserved a spot at this vaccination site.'
                      ],
                    ),
                  );
                } else {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) => ReservationDialog(
                      site: sites[index],
                    ),
                  );
                }
              },
              child: const Text(
                'RESERVE',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            );
          } else {
            reservationButton = TextButton(
              onPressed: () {},
              child: const Text(
                'RESERVE',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            );
          }

          return VisibilityDetector(
            key: Key(sites[index].id),
            onVisibilityChanged: (VisibilityInfo info) {
              if (info.visibleFraction == 1) {
                setState(() {
                  _currentIndex = index;
                });
              }
            },
            child: ListTile(
              title: Text(
                sites[index].name,
                style: Theme.of(context).textTheme.headline6,
              ),
              subtitle: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      sites[index].address.toString() +
                          '\n' +
                          sites[index].descriptor +
                          '\nSpots Left: ' +
                          sites[index].spotsLeft.toString(),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: reservationButton,
                  ),
                ],
              ),
              isThreeLine: true,
              onTap: () =>
                  widget.mapKey.currentState!.selectSite(sites[index].id),
            ),
          );
        },
        separatorBuilder: (BuildContext context, _) => const Divider(),
        emptyItemBuilder: (BuildContext context, int index) =>
            VisibilityDetector(
          key: Key(index.toString()),
          onVisibilityChanged: (VisibilityInfo info) {
            if (info.visibleFraction == 1) {
              setState(() {
                _currentIndex = index;
              });
            }
          },
          child: ListTile(),
        ),
        controller: controller,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
            return ChatDialog(flowtterState);
          }));
        },
        child: Icon(Icons.chat),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
