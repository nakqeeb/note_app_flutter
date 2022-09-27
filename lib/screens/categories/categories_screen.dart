import 'package:flutter/material.dart';
import 'package:note_app/screens/categories/components/edit_category_modal.dart';
import 'package:note_app/services/categoriesService.dart';
import 'package:provider/provider.dart';

import '../../notifiers/categories_notifier.dart';
import '../../notifiers/iconItems.dart';
import '../../widgets/app_drawer.dart';

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
            "Categories",
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
                          'No Category has been added yet.',
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
                                      title: Text(
                                          'Delete ${categories[index + 1].name}'),
                                      content: Text(
                                          'Do you want to delete ${categories[index + 1].name}?'),
                                      actions: [
                                        TextButton(
                                          child: const Text('No'),
                                          onPressed: () {
                                            Navigator.of(ctx).pop(false);
                                          },
                                        ),
                                        TextButton(
                                          child: Text(
                                            'Yes',
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
                                        'Category deleted',
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
                                      title: const Text('An error occurred!'),
                                      content: const Text(
                                          'Could not delete the category. Try again later.'),
                                      actions: [
                                        TextButton(
                                          child: const Text('Okay'),
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