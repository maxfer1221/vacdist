import 'package:flutter/material.dart';
import 'package:vacdist/Widgets/PatientLoginWidget.dart';
import 'package:vacdist/functions/auth.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: ChangeNotifierProvider(
            create: (context) => GoogleSignInProvider(),
            child: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                  } else {
                    return PatientLoginWidget();
                  }
                  return PatientLoginWidget();
                })),
      );
}
