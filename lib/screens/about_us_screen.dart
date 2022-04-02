import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:note_app_flutter/widgets/app_drawer.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  static const routeName = '/aboutus';
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'nakqeeb@gmail.com',
  );
  AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final appBar = AppBar();
    return Scaffold(
      key: scaffoldKey,
      drawer: AppDrawer(),
      body: Column(
        children: [
          Container(
            height: (mediaQuery.size.height -
                    appBar.preferredSize.height -
                    mediaQuery.padding.top) *
                0.2,
            padding: const EdgeInsets.only(left: 10, top: 20),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: IconButton(
                    tooltip: 'Menu',
                    onPressed: () => scaffoldKey.currentState!.openDrawer(),
                    icon: const Icon(
                      Icons.menu,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  radius: 30,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Mono Notes Pro',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 30,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8.0, bottom: 6.0),
            child: Text(
              "About",
              style: TextStyle(
                color: Color(0xff515979),
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
          ),
          Expanded(
              child: Card(
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
                          text:
                              'For any feedback, please feel free to drop me a message \n\n',
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
                              launch(emailLaunchUri.toString());
                            },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
