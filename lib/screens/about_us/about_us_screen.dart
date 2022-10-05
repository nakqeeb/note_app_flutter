import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/app_drawer.dart';
import '../../widgets/custom_app_bar.dart';

// from url_launcher package
String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

class AboutUsScreen extends StatelessWidget {
  static const routeName = '/aboutus';
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'nakqeeb@gmail.com',
    query: encodeQueryParameters(<String, String>{
      'subject': 'Feedback for Mono Note Pro',
    }),
  );
  AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);
    final mediaQuery = MediaQuery.of(context);
    final appBar = AppBar();
    return Scaffold(
      key: scaffoldKey,
      drawer: AppDrawer(),
      body: Column(
        children: [
          CustomAppBar(scaffoldKey: scaffoldKey),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 6.0),
            child: Text(
              appLocale!.feedback,
              style: const TextStyle(
                color: Color(0xff515979),
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.only(
                top: 20, bottom: 200, left: 20, right: 20),
            color: Theme.of(context).canvasColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            elevation: 8.0,
            child: Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              decoration: BoxDecoration(
                color: Colors.blueGrey[300],
                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Column(
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${appLocale.feedback_message}\n\n',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                        TextSpan(
                          text: 'nakqeeb@gmail.com',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl(emailLaunchUri);
                            },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
