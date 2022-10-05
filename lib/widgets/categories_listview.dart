import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../notifiers/iconItems.dart';

class CategoriesListView extends StatelessWidget {
  final Category category;
  bool isSelected;
  CategoriesListView(
      {Key? key, required this.category, required this.isSelected})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final iconItem = Provider.of<IconItems>(context);
    final categoryIcon = category.id != null
        ? iconItem.fetchIconByName(category.icon as String)
        : Icons.all_inbox;
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected && category.id != null
              ? Color(0xff607d8b)
              : category.id == null
                  ? Colors.deepOrange[300]
                  : Theme.of(context).colorScheme.primary,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.3),
                      offset: Offset(0, 4),
                      blurRadius: 20),
                ]
              : [],
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            child: Row(
              children: [
                Icon(
                  categoryIcon,
                  color: Theme.of(context).canvasColor,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  category.name as String,
                  style: TextStyle(
                      color: Theme.of(context).canvasColor,
                      fontSize: 17,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
