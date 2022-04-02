import 'package:flutter/material.dart';
import '../models/IconItem.dart';

class IconItems with ChangeNotifier {
  // ignore: prefer_final_fields
  List<IconItem> _iconItems = [
    /* Icons.cake,
    Icons.add_location_sharp,
    Icons.zoom_in_outlined,
    Icons.auto_awesome_motion,
    Icons.call_end_sharp,
    Icons.equalizer_rounded,
    Icons.wifi_lock,
    Icons.mail, */
    IconItem('ac_unit', Icons.ac_unit),
    IconItem('access_alarm', Icons.access_alarm),
    IconItem('account_balance_wallet', Icons.account_balance_wallet),
    IconItem('account_circle', Icons.account_circle),
    IconItem('alternate_email', Icons.alternate_email),
    IconItem('backpack', Icons.backpack),
    IconItem('bookmark', Icons.bookmark),
    IconItem('business', Icons.business),
    IconItem('calculate', Icons.calculate),
    IconItem('calendar_today', Icons.calendar_today),
    IconItem('camera_alt', Icons.camera_alt),
    IconItem('campaign', Icons.campaign),
    IconItem('cases_sharp', Icons.cases_sharp),
    IconItem('celebration', Icons.celebration),
    IconItem('cloud', Icons.cloud),
    IconItem('comment', Icons.comment),
    IconItem('cake', Icons.cake),
    IconItem('call', Icons.call),
    IconItem('equalizer', Icons.equalizer),
    IconItem('family_restroom', Icons.family_restroom),
    IconItem('fastfood', Icons.fastfood),
    IconItem('folder_open', Icons.folder_open),
    IconItem('link', Icons.link),
    IconItem('location_pin', Icons.location_pin),
    IconItem('mail', Icons.mail),
    IconItem('menu_book', Icons.menu_book),
    IconItem('star', Icons.star),
    IconItem('wifi', Icons.wifi),
  ];

  List<IconItem> get iconItems {
    return [..._iconItems];
  }

  IconData? fetchIconByName(String name) {
    return _iconItems.firstWhere((i) => i.name == name).icon;
  }
}
