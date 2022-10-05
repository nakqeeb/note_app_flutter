import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../notifiers/locale_notifier.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/custom_app_bar.dart';

class LanguageScreen extends StatelessWidget {
  static const routeName = '/language';
  var scaffoldKey = GlobalKey<ScaffoldState>();
  LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localeNotifier = Provider.of<LocaleNotifier>(context);
    final appLocale = AppLocalizations.of(context);
    final locale = localeNotifier.locale ?? const Locale('en');
    return Scaffold(
      key: scaffoldKey,
      drawer: AppDrawer(),
      body: Column(
        children: [
          CustomAppBar(
            scaffoldKey: scaffoldKey,
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0, bottom: 6.0),
            child: Text(
              appLocale!.change_langauge,
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
                  RadioListTile(
                    value: const Locale('ar'),
                    groupValue: locale,
                    onChanged: (Locale? value) {
                      print(value);
                      localeNotifier.setLocal = 'ar';
                    },
                    title: const Text('عربي'),
                  ),
                  RadioListTile(
                    value: const Locale('en'),
                    groupValue: locale,
                    onChanged: (Locale? value) {
                      localeNotifier.setLocal = 'en';
                    },
                    title: const Text('English'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
