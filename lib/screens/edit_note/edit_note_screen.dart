import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:getwidget/getwidget.dart';
import 'package:note_app/services/notesService.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../models/category.dart';
import '../../models/note.dart';
import '../../notifiers/categories_notifier.dart';
import '../../notifiers/iconItems.dart';
import '../../notifiers/notes_notifier.dart';

class EditNoteScreen extends StatefulWidget {
  static const routeName = '/edit-note';
  const EditNoteScreen({Key? key}) : super(key: key);

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  var _isInit = true;
  var _isLoading = false;
  var _editedNote = Note(id: null, title: null, sections: null, category: null);
  final _form = FormGroup({
    'title': FormControl(validators: [Validators.required]),
    'category': FormControl<String>(),
    'sections': FormArray([]),
  });

  FormArray get sectionsList => _form.control('sections') as FormArray;

  /* @override
  void initState() {
    sectionsList.add(FormGroup({
      'sectionTitle': FormControl<String>(),
      'content': FormControl<String>(),
    }));
    super.initState();
  } */

  @override
  void didChangeDependencies() {
    final notesNotifier = Provider.of<NotesNotifier>(context);
    final categoriesNotifier = Provider.of<CategoriesNotifier>(context);
    if (_isInit) {
      final noteId = ModalRoute.of(context)!.settings.arguments;
      if (noteId != null) {
        _editedNote =
            NotesService.fetchNoteById(noteId as String, notesNotifier);
        _form.controls['title']?.value = _editedNote.title;
        _form.controls['category']?.value = _editedNote.category;
        for (var section in _editedNote.sections as List<Section>) {
          _initFormArray(section);
        }
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _showErrorDialog(String message, AppLocalizations applocale) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        backgroundColor: Theme.of(context).canvasColor,
        title: Text(applocale.error_occurred),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text(applocale.okay),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _saveForm() async {
    final appLocale = AppLocalizations.of(context);
    var connectivityResult = await Connectivity().checkConnectivity();
    // check if the user is not connected to mobile network and wifi.
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      _showErrorDialog(appLocale!.no_connection, appLocale);
      return;
    }
    if (!_form.valid) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    //print('Category ${_form.value['category']}');
    try {
      final notesNotifier = Provider.of<NotesNotifier>(context, listen: false);
      if (_editedNote.id != null) {
        //print(_form.control('sections').value[0]['sectionTitle']);
        List<Object?> _updatedSection = _form.control('sections').value;

        final _updatedNote = {
          'title': _form.value['title'] as String,
          'category': _form.value['category'] != null
              ? _form.value['category'] as String
              : null,
          'sections': _updatedSection,
        };
        //print(_updatedNote);
        await NotesService.updateNote(
            _editedNote.id as String, _updatedNote, notesNotifier);
      } else {
        final scaffold = ScaffoldMessenger.of(context);
        List<Object?> _addedSection = _form.control('sections').value;
        final _addedNote = {
          'title': _form.value['title'] as String,
          'category': _form.value['category'] != null
              ? _form.value['category'] as String
              : null,
          'sections': _addedSection
        };
        print(_addedNote);
        await NotesService.addNote(_addedNote, notesNotifier);
        scaffold.showSnackBar(
          SnackBar(
            content: Text(
              appLocale!.note_added,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).canvasColor),
            ),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            width: 140,
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (error) {
      print(error);
      _showErrorDialog(appLocale!.opps_went_wrong, appLocale);
    }
    setState(() {
      _isLoading = false;
    });
    if (_editedNote.id != null) {
      Navigator.of(context).pop(true);
    } else {
      Navigator.of(context).pop();
    }
  }

  _initFormArray(Section section) {
    sectionsList.add(FormGroup({
      'sectionTitle': FormControl<String>(
          value: section.sectionTitle, validators: [Validators.required]),
      'content': FormControl<String>(
          value: section.content, validators: [Validators.required]),
    }));
  }

  _addFormArray() {
    sectionsList.add(FormGroup({
      'sectionTitle': FormControl<String>(validators: [Validators.required]),
      'content': FormControl<String>(validators: [Validators.required]),
    }));
    //setState(() {});
  }

  _removeFormArray(int index) {
    final currentForm = _form.control('sections') as FormArray;
    currentForm.removeAt(index);
  }

  _backButtonPressed() {
    final appLocale = AppLocalizations.of(context);
    if (_form.dirty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          backgroundColor: Theme.of(context).canvasColor,
          content: Text(
            _editedNote.id != null
                ? appLocale!.leave_without_saving_changes
                : appLocale!.leave_without_saving_note,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary),
          ),
          actions: [
            TextButton(
              child: Text(
                appLocale.leave,
                style: TextStyle(color: Theme.of(context).errorColor),
              ),
              onPressed: () {
                FocusManager.instance.primaryFocus
                    ?.unfocus(); //Hide Keyboard on Tap Outside Text Field
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(appLocale.stay,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
              onPressed: () {
                FocusManager.instance.primaryFocus
                    ?.unfocus(); //Hide Keyboard on Tap Outside Text Field
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);
    final mediaQuery = MediaQuery.of(context);
    final appBar = AppBar();
    return WillPopScope(
      onWillPop: () async {
        _backButtonPressed();
        return false;
      },
      child: Scaffold(
        body: Column(
          children: [
            Container(
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
                      tooltip: appLocale!.back,
                      onPressed: _backButtonPressed,
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    radius: 30,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        _editedNote.id != null
                            ? '${appLocale.edit} ${_editedNote.title}'
                            : appLocale.new_note,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: appLocale.save,
                    icon: const Icon(Icons.save),
                    onPressed: _saveForm,
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      padding: const EdgeInsets.all(15),
                      child: ReactiveForm(
                        formGroup: _form,
                        child: Column(
                          children: [
                            SizedBox(
                              width: mediaQuery.size.width * 0.8,
                              child: Card(
                                margin: const EdgeInsets.only(
                                  top: 15,
                                  bottom: 0,
                                ),
                                color: Theme.of(context).canvasColor,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0),
                                  ),
                                ),
                                elevation: 8.0,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 50, right: 50),
                                      child: ReactiveTextField(
                                        formControlName: 'title',
                                        textInputAction: TextInputAction.next,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        validationMessages: {
                                          'required': (error) =>
                                              appLocale.title_must_not_be_empty
                                        },
                                        decoration: InputDecoration(
                                          label: Text(appLocale.title),
                                          isDense: true, // Added this
                                          contentPadding:
                                              const EdgeInsets.all(8),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Consumer<CategoriesNotifier>(
                                      builder: (context, categoryData, child) =>
                                          Padding(
                                        padding: const EdgeInsets.only(
                                            left: 50, right: 50),
                                        child: ReactiveDropdownField<String>(
                                          formControlName: 'category',
                                          icon: Icon(
                                            Icons.arrow_drop_down_circle,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                          //alignment: Alignment.center,
                                          decoration: InputDecoration(
                                            // prefixIcon: Icon(Icons.person),
                                            label:
                                                Text(appLocale.choose_category),
                                            isDense: true, // Added this
                                            contentPadding:
                                                const EdgeInsets.all(8),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),
                                            ),
                                          ),
                                          iconSize: 30,
                                          elevation: 16,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                          items: categoryData.dropDownCats
                                              .map((Category cat) {
                                            return DropdownMenuItem(
                                              value: cat.id,
                                              child: Row(
                                                children: [
                                                  Consumer<IconItems>(
                                                    builder: (context,
                                                            iconsData, child) =>
                                                        Icon(cat.icon != null
                                                            ? iconsData
                                                                .fetchIconByName(
                                                                    cat.icon
                                                                        as String)
                                                            : null),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    cat.name as String,
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: ReactiveFormArray(
                                    formArrayName: 'sections',
                                    builder: (_, formArray, __) {
                                      final cities = sectionsList.controls
                                          .map(
                                              (control) => control as FormGroup)
                                          .map((currentform) {
                                        return ReactiveForm(
                                            formGroup: currentform,
                                            child: Column(
                                              children: <Widget>[
                                                Card(
                                                  key: ValueKey(
                                                      currentform), // to make every card unique. Here used to delete current chosen card
                                                  margin: const EdgeInsets.only(
                                                      top: 15,
                                                      bottom: 0,
                                                      left: 5,
                                                      right: 5),
                                                  color: Theme.of(context)
                                                      .canvasColor,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20.0),
                                                      topRight:
                                                          Radius.circular(20.0),
                                                    ),
                                                  ),
                                                  elevation: 8.0,
                                                  child: Stack(
                                                    children: [
                                                      GFAccordion(
                                                        margin: const EdgeInsets
                                                            .all(0),
                                                        titleChild: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 60),
                                                          child:
                                                              ReactiveTextField(
                                                            formControlName:
                                                                'sectionTitle',
                                                            textCapitalization:
                                                                TextCapitalization
                                                                    .sentences,
                                                            textInputAction:
                                                                TextInputAction
                                                                    .next,
                                                            validationMessages: {
                                                              'required': (error) =>
                                                                  appLocale
                                                                      .section_title_must_not_empty
                                                            },
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  appLocale
                                                                      .title,
                                                              isDense: true,
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .all(8),
                                                              enabledBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .secondary,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        contentChild:
                                                            ReactiveTextField(
                                                          formControlName:
                                                              'content',
                                                          minLines: 2,
                                                          maxLines: null,
                                                          textCapitalization:
                                                              TextCapitalization
                                                                  .sentences,
                                                          validationMessages: {
                                                            'required': (error) =>
                                                                appLocale
                                                                    .section_content_must_not_empty
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                            labelText: appLocale
                                                                .content,
                                                            isDense:
                                                                true, // Added this
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            enabledBorder:
                                                                UnderlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        collapsedTitleBackgroundColor:
                                                            const Color(
                                                                0xffb0bec5),
                                                        expandedTitleBackgroundColor:
                                                            const Color(
                                                                0xffb0bec5),
                                                        contentBackgroundColor:
                                                            Theme.of(context)
                                                                .canvasColor,
                                                        titleBorderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  20.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  20.0),
                                                        ),
                                                        showAccordion: true,
                                                      ),
                                                      Positioned(
                                                        top: 13,
                                                        right: 40,
                                                        child: IconButton(
                                                          tooltip: appLocale
                                                              .delete_this_section,
                                                          icon: const Icon(
                                                              Icons.close),
                                                          color:
                                                              Theme.of(context)
                                                                  .errorColor,
                                                          onPressed: () {
                                                            showDialog(
                                                              context: context,
                                                              builder: (ctx) =>
                                                                  AlertDialog(
                                                                shape:
                                                                    const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius
                                                                        .circular(
                                                                            10),
                                                                  ),
                                                                ),
                                                                backgroundColor:
                                                                    Theme.of(
                                                                            context)
                                                                        .canvasColor,
                                                                title: Text(
                                                                    appLocale
                                                                        .delete_section),
                                                                content: Text(
                                                                    appLocale
                                                                        .do_you_want_delete_section),
                                                                actions: [
                                                                  TextButton(
                                                                    child: Text(
                                                                        appLocale
                                                                            .no),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              ctx)
                                                                          .pop();
                                                                    },
                                                                  ),
                                                                  TextButton(
                                                                    child: Text(
                                                                      appLocale
                                                                          .yes,
                                                                      style: TextStyle(
                                                                          color:
                                                                              Theme.of(context).errorColor),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      _removeFormArray(sectionsList
                                                                          .controls
                                                                          .indexOf(
                                                                              currentform));
                                                                      Navigator.of(
                                                                              ctx)
                                                                          .pop();
                                                                    },
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ));
                                      });
                                      return Wrap(
                                        runSpacing: 20,
                                        children: cities.toList(),
                                      );
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: appLocale.new_section,
          child: const Icon(Icons.add_box),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          onPressed: _addFormArray,
        ),
      ),
    );
  }
}
