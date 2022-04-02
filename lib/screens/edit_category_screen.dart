// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:note_app_flutter/models/IconItem.dart';
import 'package:note_app_flutter/models/category.dart';
import 'package:note_app_flutter/providers/categories.dart';
import 'package:note_app_flutter/providers/iconItems.dart';
import 'package:provider/provider.dart';

class EditCategoryScreen extends StatefulWidget {
  static const routeName = '/edit-category';
  final String? categoryId;

  const EditCategoryScreen({Key? key, this.categoryId}) : super(key: key);

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  final _categoryNameController = TextEditingController();
  String? _iconName;
  var _editedCategory = Category(name: '', icon: '');

  var _isInit = true;

  // lecture 232
  @override
  void didChangeDependencies() {
    if (_isInit) {
      // important to add this if check. lecture 232
      if (widget.categoryId != null) {
        _editedCategory = Provider.of<Categories>(context, listen: false)
            .fetchCategoryById(widget.categoryId as String);
        _categoryNameController.text = _editedCategory.name!;
        _iconName = _editedCategory.icon;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final categoryData = Provider.of<Categories>(context);
    final category = widget.categoryId != null
        ? categoryData.fetchCategoryById(widget.categoryId as String)
        : null;
    final iconsData = Provider.of<IconItems>(context);

    return Container(
      color: Color(0xff404A4F),
      child: Container(
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            widget.categoryId == null
                ? Text(
                    'New Category',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.blueGrey, fontSize: 30),
                  )
                : Text(
                    'Edit ${category?.name}',
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
                hintText: 'Category Name',
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
                  hintText: 'Choose Icon',
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
                  categoryData.addCategory(newCategory);
                  Navigator.of(context).pop();
                } else {
                  final updatedCategory = Category(
                    id: category?.id,
                    name: _categoryNameController.text,
                    icon: _iconName,
                    color: category?.color,
                  );
                  categoryData.updateCategory(
                    widget.categoryId,
                    updatedCategory,
                  );

                  Navigator.of(context).pop();
                }
              },
              child: widget.categoryId == null
                  ? Text(
                      'Add',
                      style: TextStyle(color: Theme.of(context).canvasColor),
                    )
                  : Text(
                      'Update',
                      style: TextStyle(color: Theme.of(context).canvasColor),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
