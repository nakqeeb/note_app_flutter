import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../notifiers/categories_notifier.dart';
import '../../notifiers/iconItems.dart';
import '../../services/categoriesService.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/custom_app_bar.dart';
import 'components/edit_category_modal.dart';

class CategoriesScreen extends StatefulWidget {
  static const routeName = '/categories';

  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    final categoriesNotifier = Provider.of<CategoriesNotifier>(context);
    if (_isInit) {
      // we use setState to update the ui once the property has been changed, otherwise the the ui will not be updated.
      setState(() {
        _isLoading = true;
      });
      CategoriesService.fetchCategories(categoriesNotifier).then((_) {
        // print(res![0].sections?[0].content);
        setState(() {
          _isLoading = false;
        });
      });
      ;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);
    final scaffold = ScaffoldMessenger.of(context);
    final categoriesNotifier = Provider.of<CategoriesNotifier>(context);
    final categories = categoriesNotifier.cats;
    final iconsData = Provider.of<IconItems>(context);
    final mediaQuery = MediaQuery.of(context);
    final appBar = AppBar();
    return Scaffold(
      key: scaffoldKey,
      drawer: AppDrawer(),
      body: Column(children: [
        CustomAppBar(scaffoldKey: scaffoldKey),
        Padding(
          padding: EdgeInsets.only(top: 8.0, bottom: 6.0),
          child: Text(
            appLocale!.categories,
            style: TextStyle(
              color: Color(0xff515979),
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              color: Colors.blueGrey[300],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : categories.length - 1 <= 0
                    ? Center(
                        child: Text(
                          appLocale.no_category_added,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: categories.length - 1,
                        itemBuilder: (context, index) => Column(
                          children: [
                            Dismissible(
                              key: ValueKey(categories[index + 1].id),
                              resizeDuration: const Duration(milliseconds: 800),
                              background: Container(
                                color: Colors.redAccent,
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 20),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 4,
                                ),
                              ),
                              secondaryBackground: Container(
                                color: Colors.deepOrange[200],
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 4,
                                ),
                              ),
                              direction: DismissDirection.horizontal,
                              confirmDismiss: (direction) {
                                //print(direction);
                                if (direction == DismissDirection.startToEnd) {
                                  return showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      backgroundColor:
                                          Theme.of(context).canvasColor,
                                      title: Text(appLocale.delete +
                                          ' ${categories[index + 1].name}' +
                                          appLocale.question_mark),
                                      content: Text(
                                          appLocale.do_you_want_delete +
                                              ' ${categories[index + 1].name}' +
                                              appLocale.question_mark),
                                      actions: [
                                        TextButton(
                                          child: Text(appLocale.no),
                                          onPressed: () {
                                            Navigator.of(ctx).pop(false);
                                          },
                                        ),
                                        TextButton(
                                          child: Text(
                                            appLocale.yes,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .errorColor),
                                          ),
                                          onPressed: () {
                                            Navigator.of(ctx).pop(true);
                                          },
                                        )
                                      ],
                                    ),
                                  );
                                } else {
                                  return showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) => SingleChildScrollView(
                                      child: Container(
                                        // added to show the model when above the keyboard
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        child: EditCategoryModal(
                                          categoryId: categories[index + 1].id,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                              onDismissed: (direction) async {
                                // print(direction);
                                try {
                                  await CategoriesService.deleteCategory(
                                      categories[index + 1].id as String,
                                      categoriesNotifier);
                                  scaffold.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        appLocale.category_deleted,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).canvasColor),
                                      ),
                                      duration: const Duration(seconds: 2),
                                      behavior: SnackBarBehavior.floating,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      width: 180,
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  );
                                } catch (error) {
                                  await showDialog<void>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      backgroundColor:
                                          Theme.of(context).canvasColor,
                                      title: Text(appLocale.error_occurred),
                                      content: Text(
                                          appLocale.could_not_delete_category),
                                      actions: [
                                        TextButton(
                                          child: Text(appLocale.okay),
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                        )
                                      ],
                                    ),
                                  );
                                }
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  child: Icon(
                                    iconsData.fetchIconByName(
                                        categories[index + 1].icon as String),
                                    color: Theme.of(context).canvasColor,
                                  ),
                                ),
                                title:
                                    Text(categories[index + 1].name as String),
                              ),
                            ),
                            const Divider()
                          ],
                        ),
                      ),
          ),
        ),
      ]),
      // OpenContainer from animation package
      // I knew this widget from Flutter Gallery app
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Theme.of(context).canvasColor),
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            isScrollControlled: true,
            builder: (context) => SingleChildScrollView(
              child: Container(
                // added to show the model when above the keyboard
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: const EditCategoryModal(),
              ),
            ),
          );
        },
      ),
    );
  }
}
