import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomAppBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const CustomAppBar({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);
    final appBar = AppBar();
    final mediaQuery = MediaQuery.of(context);
    return Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.2,
      padding: const EdgeInsets.only(left: 10, top: 20, right: 10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: IconButton(
              tooltip: appLocale!.menu,
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
            appLocale.mono_notes_pro,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w700,
              fontSize: 30,
            ),
          ),
        ],
      ),
    );
  }
}
