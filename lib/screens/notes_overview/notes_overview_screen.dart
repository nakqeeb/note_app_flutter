import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:note_app/notifiers/categories_notifier.dart';
import 'package:note_app/notifiers/notes_notifier.dart';
import 'package:note_app/services/categoriesService.dart';
import 'package:note_app/services/notesService.dart';
import 'package:note_app/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';

import '../../widgets/app_drawer.dart';
import '../../widgets/categories_listview.dart';
import '../../widgets/filter_notes.dart';
import '../edit_note/edit_note_screen.dart';
import '../note_details/note_details_screen.dart';

class NotesOverviewScreen extends StatefulWidget {
  static const routeName = '/notes-overview';
  const NotesOverviewScreen({Key? key}) : super(key: key);

  @override
  State<NotesOverviewScreen> createState() => _NotesOverviewScreenState();
}

class _NotesOverviewScreenState extends State<NotesOverviewScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var _isInit =
      true; // used to prevent didChangeDependencies run mutiple time. lecture 248
  var _isLoading = false;
  var _isCatsLoading = false;
  var _isNotesLoading = false;
  int? _currentIndex;
  String? _categoryId;
  @override
  void didChangeDependencies() {
    final notesNotifier = Provider.of<NotesNotifier>(context);
    final categoriesNotifier = Provider.of<CategoriesNotifier>(context);
    if (_isInit) {
      // we use setState to update the ui once the property has been changed, otherwise the the ui will not be updated.
      setState(() {
        _isLoading = true;
        _isCatsLoading = true;
      });
      NotesService.fetchNotes(notesNotifier).then((_) {
        // print(res![0].sections?[0].content);
        setState(() {
          _isLoading = false;
          _categoryId = null;
        });
      });
      CategoriesService.fetchCategories(categoriesNotifier).then((_) {
        // print(res![0].sections?[0].content);
        setState(() {
          _isCatsLoading = false;
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
    final notesNotifier = Provider.of<NotesNotifier>(context);
    final notes = notesNotifier.notes;
    final cats = Provider.of<CategoriesNotifier>(context).cats;
    return Scaffold(
      key:
          scaffoldKey, // scaffoldKey for opening a drower from the icon button when we dont want to use an app bar
      drawer: AppDrawer(),
      body: Column(children: [
        Row(
          children: [
            CustomAppBar(scaffoldKey: scaffoldKey),
            Spacer(),
            FilterNotes(
                categoryId: _categoryId,
                callback: (val) => setState(() {
                      _isNotesLoading = val;
                    }))
          ],
        ),
        Text(
          appLocale!.categories,
          style: const TextStyle(
            color: Color(0xff515979),
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
        _isCatsLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 6.0, bottom: 8.0),
                child: SizedBox(
                    height: 60,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: cats.length,
                      itemBuilder: (context, index) => Center(
                        child: GestureDetector(
                          onTap: () {
                            cats[index].isSelected = true;
                            _currentIndex = cats.indexOf(cats[index]);
                            if (cats[index].isSelected &&
                                cats[index].id != null) {
                              setState(() {
                                _isNotesLoading = true;
                              });
                              NotesService.fetchNotesByCategoryId(
                                      cats[index].id as String, notesNotifier)
                                  .then((_) {
                                setState(() {
                                  _isNotesLoading = false;
                                  cats[index].isSelected = false;
                                  _categoryId = cats[index].id;
                                });
                              });
                            } else if (cats[index].isSelected &&
                                cats[index].id == null) {
                              setState(() {
                                _isNotesLoading = true;
                              });
                              NotesService.fetchNotes(notesNotifier).then((_) {
                                setState(() {
                                  _isNotesLoading = false;
                                  _categoryId = null;
                                });
                              });
                            }
                          },
                          child: CategoriesListView(
                            category: cats[index],
                            isSelected:
                                index == 0 ? true : index == _currentIndex,
                          ),
                        ),
                      ),
                    ))),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 6.0),
          child: Text(
            appLocale.notes,
            style: const TextStyle(
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
                : _isNotesLoading
                    ? const Center(
                        child: const CircularProgressIndicator(),
                      )
                    : !_isNotesLoading && notes.isEmpty
                        ? Center(
                            child: Text(
                              appLocale.no_notes_match_with_category,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: notes.length,
                            itemBuilder: (context, index) {
                              var reversedNotes = notes.reversed.toList();
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                        NoteDetailsScreen.routeName,
                                        arguments: reversedNotes[index].id,
                                      );
                                    },
                                    child: ListTile(
                                      title: Text(
                                          reversedNotes[index].title as String),
                                      subtitle: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            Text(
                                              '${appLocale.created_at}: ' +
                                                  //DateFormat('dd/MM/yyyy hh:mm')
                                                  DateFormat('dd/MM/yyyy')
                                                      .format(
                                                          reversedNotes[index]
                                                                  .createdAt
                                                              as DateTime),
                                            ),
                                            const SizedBox(
                                              width: 7,
                                            ),
                                            Text(
                                              '${appLocale.updated_at}: ' +
                                                  // DateFormat('dd/MM/yyyy hh:mm')
                                                  DateFormat('dd/MM/yyyy')
                                                      .format(
                                                          reversedNotes[index]
                                                                  .updatedAt
                                                              as DateTime),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Divider()
                                ],
                              );
                            }),
          ),
        ),
      ]),
      // OpenContainer from animation package
      // I knew this widget from Flutter Gallery app
      floatingActionButton: OpenContainer(
        transitionDuration: const Duration(milliseconds: 700),
        transitionType: ContainerTransitionType.fade,
        openBuilder: (context, openContainer) => const EditNoteScreen(),
        closedElevation: 6,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(56 / 2),
          ),
        ),
        closedColor: Theme.of(context).colorScheme.primary,
        closedBuilder: (context, openContainer) {
          return SizedBox(
            height: 56,
            width: 56,
            child: Center(
              child: Icon(
                Icons.add,
                color: Theme.of(context).canvasColor,
              ),
            ),
          );
        },
      ),
    );
  }
}
