import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../models/IconItem.dart';
import '../../../models/category/category.dart';
import '../../../notifiers/categories_notifier.dart';
import '../../../notifiers/iconItems.dart';
import '../../../services/categoriesService.dart';

class EditCategoryModal extends StatefulWidget {
  final String? categoryId;

  const EditCategoryModal({Key? key, this.categoryId}) : super(key: key);

  @override
  State<EditCategoryModal> createState() => _EditCategoryModalState();
}

class _EditCategoryModalState extends State<EditCategoryModal> {
  final _categoryNameController = TextEditingController();
  String? _iconName;
  var _editedCategory = Category(name: '', icon: '');

  var _isInit = true;

  // lecture 232
  @override
  void didChangeDependencies() {
    final categoriesNotifier = Provider.of<CategoriesNotifier>(context);
    if (_isInit) {
      // important to add this if check. lecture 232
      if (widget.categoryId != null) {
        _editedCategory = CategoriesService.fetchCategoryById(
            widget.categoryId as String, categoriesNotifier);
        _categoryNameController.text = _editedCategory.name!;
        _iconName = _editedCategory.icon;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);
    final categoriesNotifier = Provider.of<CategoriesNotifier>(context);
    final category = widget.categoryId != null
        ? CategoriesService.fetchCategoryById(
            widget.categoryId as String, categoriesNotifier)
        : null;
    final iconsData = Provider.of<IconItems>(context);

    return Padding(
      padding: EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          widget.categoryId == null
              ? Text(
                  appLocale!.new_category,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blueGrey, fontSize: 30),
                )
              : Text(
                  appLocale!.edit + ' ${category?.name}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blueGrey, fontSize: 30),
                ),
          TextField(
            controller: _categoryNameController,
            /* onSubmitted: (value) {
                  Navigator.of(context).pop();
                }, */
            //autofocus: true,
            // textInputAction: TextInputAction.next,
            textAlign: TextAlign.center,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: appLocale.category_name,
              contentPadding: EdgeInsets.all(10.0),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            style: TextStyle(
              height: 2.0,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Consumer<IconItems>(
            builder: (context, itemData, _) =>
                DropdownButtonFormField<IconItem>(
              value: category?.icon != null
                  ? iconsData.iconItems
                      .firstWhere((i) => i.name == category?.icon)
                  : null,
              icon: Icon(
                Icons.arrow_drop_down_circle,
                color: Theme.of(context).colorScheme.secondary,
              ),
              //alignment: Alignment.center,
              decoration: InputDecoration(
                // prefixIcon: Icon(Icons.person),
                hintText: appLocale.choose_icon,
                contentPadding: EdgeInsets.all(10.0),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              iconSize: 30,
              elevation: 16,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
              onChanged: (newValue) {
                // print(newValue?.name);
                _iconName = newValue?.name;
              },
              items: itemData.iconItems.map((IconItem item) {
                return DropdownMenuItem(
                  value: item,
                  child: Row(
                    children: [
                      Icon(
                        item.icon,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        item.name,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.blueGrey,
            ),
            onPressed: () {
              if (_categoryNameController.text == '' || _iconName == null) {
                return;
              }
              if (widget.categoryId == null) {
                final newCategory = Category(
                  name: _categoryNameController.text,
                  color: 'primary',
                  icon: _iconName,
                );
                CategoriesService.addCategory(newCategory, categoriesNotifier);
                Navigator.of(context).pop();
              } else {
                final updatedCategory = Category(
                  id: category?.id,
                  name: _categoryNameController.text,
                  icon: _iconName,
                  color: category?.color,
                );
                CategoriesService.updateCategory(
                    widget.categoryId, updatedCategory, categoriesNotifier);

                Navigator.of(context).pop();
              }
            },
            child: widget.categoryId == null
                ? Text(
                    appLocale.add,
                    style: TextStyle(color: Theme.of(context).canvasColor),
                  )
                : Text(
                    appLocale.update,
                    style: TextStyle(color: Theme.of(context).canvasColor),
                  ),
          )
        ],
      ),
    );
  }
}
