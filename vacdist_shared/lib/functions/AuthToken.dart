import 'package:firebase_auth/firebase_auth.dart';

Future<String> getIdToken() async {
  var currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    var idtoken = await currentUser.getIdToken(true);
    return idtoken;
  }
  return '';
}
