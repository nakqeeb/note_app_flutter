import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../notifiers/auth_notifier.dart';
import '../screens/about_us/about_us_screen.dart';
import '../screens/categories/categories_screen.dart';
import '../screens/language/language_screen.dart';
import '../services/authService.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);
    final mediaQuery = MediaQuery.of(context);
    final authNotifier = Provider.of<AuthNotifier>(context);
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.only(top: mediaQuery.padding.top + 30),
              child: Column(
                children: [
                  Text(
                    appLocale!.mono_notes_pro,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    appLocale.welcome,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.note),
                  title: Text(appLocale.my_notes),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.category),
                  title: Text(appLocale.categories),
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(CategoriesScreen.routeName);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.translate),
                  title: Text(appLocale.change_langauge),
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(LanguageScreen.routeName);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: Text(appLocale.feedback),
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(AboutUsScreen.routeName);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: Text(appLocale.logout),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed('/');
                    AuthService.logout(authNotifier);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
