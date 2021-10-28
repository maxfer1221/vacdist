import 'package:flutter/material.dart';
import 'package:vacdist_shared/Widgets/DynamicContainer.dart';
import 'package:vacdist/Widgets/SignInWidget.dart';

class PatientLoginWidget extends StatefulWidget {
  @override
  _PatientLoginWidgetState createState() => _PatientLoginWidgetState();
}

class _PatientLoginWidgetState extends State<PatientLoginWidget> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return Center(
      child: DynamicContainer(
        heightPct: 1.0,
        widthPct: 1.0,
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.05,
          right: MediaQuery.of(context).size.width * 0.05,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'vacdist',
              style: Theme.of(context).textTheme.headline1!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                  ),
              textAlign: TextAlign.center,
            ),
            const Divider(),
            Text(
              'COVID-19 vaccination appointment scheduling system',
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    color: Colors.black,
                  ),
              textAlign: TextAlign.center,
            ),
            const Divider(),
            Container(
              alignment: Alignment.center,
              child: SignInWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
