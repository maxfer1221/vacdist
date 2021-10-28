import 'package:flutter/material.dart';
import 'package:vacdist_provider/Widgets/ProviderLoginWidget.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(VacdistProvider());
}

class VacdistProvider extends StatelessWidget {
  VacdistProvider();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vacdist',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProviderLoginWidget(),
    );
  }
}
