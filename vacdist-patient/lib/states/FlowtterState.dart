import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:get/get.dart';
import 'package:vacdist/functions/API.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as g;
import 'package:vacdist/functions/Messages.dart';

class FlowtterState extends GetxController {
  FlowtterState() {
    initSharedMessages();
    initFileInstance();
  }

  static late int appointmentCount;
  late String context;
  static late g.LatLng location;
  static late var appointments;

  // static late double distance;
  late RxList<Map> sharedMessages;
  late DialogFlowtter fileInstance;

  static void setLocation(g.LatLng loc) {
    location = loc;
  }

  static g.LatLng getLocation() {
    return location;
  }

  static Future<DialogFlowtter> instantiateDialogFlowtter() async {
    return await DialogFlowtter.fromFile(
        path: 'assets/dialogflow_services.json');
  }

  void initFileInstance() async {
    fileInstance = await instantiateDialogFlowtter();
  }

  void initSharedMessages() async {
    sharedMessages = List<Map>.from([
      {
        'data': 0,
        'message': 'Hello! I am an AI built to help you utilize Vacdist. How can I be of service?'
      }
    ]).obs;
  }

  void insertMessage(Map message) {
    sharedMessages.insert(0, message);
  }

  Future<void> insertResponse(query) async {
    var finalMessage;

    var response = await fileInstance.detectIntent(queryInput:
    QueryInput(
        text: TextInput(
          text: query,
          languageCode: 'en',
        )
    )
    );

    if (response.text != 'NO-TEXT') {
      insertMessage({
        'data': 0,
        'message': response.text
      });
    }

    // Action checker switch statement
    switch (response.queryResult!.action) {
    // Are we asking for a distance?
      case 'get-closest-sites':
        {
          // Check whether answer provided fits our format
          var apiResponse = await getVaccinationSites(
              FlowtterState
                  .getLocation()
                  .latitude,
              FlowtterState
                  .getLocation()
                  .longitude, 4000
          );

          finalMessage = createVacSiteResponse(apiResponse);
        }
        break;

      case 'file-complaint':
        {
          await fileComplaint(response.text!);
        }
        break;

      case 'create-appointment':
      {
        if (query == '1') {
          finalMessage = "Alright, I'll set up your reservation.";
          await setUserReservationStatus(FlowtterState.appointments[0]);
        } else if (query == '2') {
          finalMessage = "Alright, I'll set up your reservation.";
          await setUserReservationStatus(FlowtterState.appointments[1]);
        } else if (query == '3') {
          finalMessage = "Alright, I'll set up your reservation.";
          await setUserReservationStatus(FlowtterState.appointments[2]);
        } else {
          finalMessage = "Sorry, I didn't quite get that. If you'd like to make an appointment, say the number (1, 2, or 3). Otherwise say \"cancel\"";
        }
      }
      break;

      case 'get-user-reservation':
      {
        var reservation = await getUserReservationGeneral();
        print(reservation.toString());
        finalMessage = 'Your current reservation is located at\n';
        finalMessage +=
            reservation.address.toString();
        finalMessage += '\n and is happening on\n';
        finalMessage+=
            reservation.startDate.toString().substring(0, 19);
      }
      break;
    }

    if (finalMessage != null) {
      insertMessage(
        {
          'data': 0,
          'message': finalMessage
        }
      );
    }

  }
}