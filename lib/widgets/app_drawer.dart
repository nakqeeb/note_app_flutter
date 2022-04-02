import 'package:flutter/material.dart';
import 'package:note_app_flutter/providers/auth.dart';
import 'package:note_app_flutter/screens/about_us_screen.dart';
import 'package:note_app_flutter/screens/categories_screen.dart';
import 'package:note_app_flutter/screens/notes_overview_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final username = Provider.of<Auth>(context).username;
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.only(top: mediaQuery.padding.top + 30),
              child: Column(
                children: [
                  Text(
                    'Mono Notes Pro',
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
                    'Welcome',
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
                  title: const Text('My notes'),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.category),
                  title: const Text('Categories'),
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(CategoriesScreen.routeName);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('About'),
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(AboutUsScreen.routeName);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed('/');
                    Provider.of<Auth>(context, listen: false).logout();
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
