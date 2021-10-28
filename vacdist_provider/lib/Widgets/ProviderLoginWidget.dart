import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:vacdist_provider/Widgets/ProviderChoiceWidget.dart';
import 'package:vacdist_provider/functions/API.dart';
import 'package:vacdist_shared/Widgets/DynamicContainer.dart';
import 'package:vacdist_shared/Widgets/SimpleAlertDialog.dart';

class ProviderLoginWidget extends StatefulWidget {
  ProviderLoginWidget();

  @override
  _ProviderLoginWidgetState createState() => _ProviderLoginWidgetState();
}

class _ProviderLoginWidgetState extends State<ProviderLoginWidget> {
  _ProviderLoginWidgetState();

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
        heightPct: 0.75,
        widthPct: 0.75,
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                controller: passwordController,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: ElevatedButton(
                onPressed: () {
                  login(
                    emailController.text,
                    sha512
                        .convert(utf8.encode(passwordController.text))
                        .toString(),
                  ).then((success) {
                    if (!success) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => SimpleAlertDialog(
                          title: 'Incorrect Credentials',
                          subtitles: [
                            'Your username, password, or both were incorrect. Please try again.',
                          ],
                        ),
                      );
                    } else {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => ProviderChoiceWidget(),
                        ),
                        (route) => false,
                      );
                    }
                  });
                },
                child: const Text('Login'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
