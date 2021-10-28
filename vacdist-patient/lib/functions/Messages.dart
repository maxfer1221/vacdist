import 'package:vacdist/classes/VaccinationSiteMarker.dart';
import 'package:vacdist/states/FlowtterState.dart';

String createVacSiteResponse(List<VaccinationSiteMarker> sites){
  var finalMessage;

  FlowtterState.appointments = sites;

  switch(sites.length){
    case 0:{
      FlowtterState.appointmentCount = 0;
      finalMessage =
      "I couldn't find any vaccination sites that close to you.\n";
    }
    break;

    case 1:{
      FlowtterState.appointmentCount = 1;
      finalMessage =
      'I found 1 vaccination site near you located at ';
      finalMessage +=
          sites[0].address.toString() + ' taking place on ';
      finalMessage +=
          sites[0].startDate.toString().substring(0, 19) +  '. Should I make the appointment?';
    }
    break;

    case 2:{
      FlowtterState.appointmentCount = 2;
      finalMessage =
      'I found 2 vaccination sites near you:\n';
      finalMessage +=
          '1. ' + sites[0].address.toString() + ' taking place on ';
      finalMessage +=
          sites[0].startDate.toString().substring(0, 19) + '\n';
      finalMessage +=
          '2. ' + sites[1].address.toString() + ' taking place on ';
      finalMessage +=
          sites[1].startDate.toString().substring(0, 19) + '.\n';
      finalMessage +=
          'Should I make an appointment for one of these?';
    }
    break;

    default:{
      FlowtterState.appointmentCount = 3;
      finalMessage =
      'I found multiple vaccination sites near you. The closest ones are:\n';
      finalMessage +=
          '1. ' + sites[0].address.toString() + ' taking place on ';
      finalMessage +=
          sites[0].startDate.toString().substring(0, 19) + '.\n';
      finalMessage +=
          '2. ' + sites[1].address.toString() + ' taking place on ';
      finalMessage +=
          sites[1].startDate.toString().substring(0, 19) + '.\n';
      finalMessage +=
          '3. ' + sites[2].address.toString() + ' taking place on ';
      finalMessage +=
          sites[2].startDate.toString().substring(0, 19) + '.\n';
      finalMessage +=
          'Should I make an appointment for one of these?\n';
      finalMessage +=
          'Reply with 1, 2, or 3 to select one of the appointments.';
    }
}

  return finalMessage;
}