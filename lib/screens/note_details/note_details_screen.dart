import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/notifiers/notes_notifier.dart';
import 'package:note_app/services/notesService.dart';
import 'package:provider/provider.dart';

import '../edit_note/edit_note_screen.dart';

class NoteDetailsScreen extends StatefulWidget {
  static const routeName = '/note-details';
  const NoteDetailsScreen({Key? key}) : super(key: key);

  @override
  State<NoteDetailsScreen> createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen> {
  Note? note;
  late String noteId;
  bool _isDeleting = false;
  bool _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      noteId =
          ModalRoute.of(context)?.settings.arguments as String; // is the id!
      final notesNotifier = Provider.of<NotesNotifier>(context);
      note = NotesService.fetchNoteById(noteId, notesNotifier);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    final notesNotifier = Provider.of<NotesNotifier>(context);
    final mediaQuery = MediaQuery.of(context);
    final appBar = AppBar();
    return Scaffold(
        body: Column(
      children: [
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
                  tooltip: 'Back',
                  onPressed: () => Navigator.of(context).pop('/'),
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
                    note?.title as String,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
              IconButton(
                  tooltip: 'Delete',
                  icon: const Icon(Icons.delete),
                  color: Theme.of(context).errorColor,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        backgroundColor: Theme.of(context).canvasColor,
                        title: Text('Delete ${note?.title}'),
                        content: Text('Do you want to delete ${note?.title}'),
                        actions: [
                          TextButton(
                            child: const Text('No'),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                          ),
                          TextButton(
                            child: Text(
                              'Yes',
                              style: TextStyle(
                                  color: Theme.of(context).errorColor),
                            ),
                            onPressed: () async {
                              Navigator.of(ctx).pop(); // closeing the dialog
                              setState(() {
                                _isDeleting = true;
                              });
                              await NotesService.deleteNote(
                                  noteId, notesNotifier);
                              Navigator.of(context)
                                  .pop(); // back to overview screen

                              scaffold.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Deleted successfully',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.of(context).canvasColor),
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
                            },
                          )
                        ],
                      ),
                    );
                  }),
              const SizedBox(
                width: 5,
              ),
              IconButton(
                tooltip: 'Edit',
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  final response = await Navigator.of(context)
                      .pushNamed(EditNoteScreen.routeName, arguments: note?.id);
                  if (response == true) {
                    setState(() {
                      _isInit = true;
                    });
                  }
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: _isDeleting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: note?.sections?.length,
                  itemBuilder: (context, index) => Column(
                    children: [
                      Card(
                        margin: const EdgeInsets.only(
                          top: 15,
                          bottom: 0,
                          left: 10,
                          right: 10,
                        ),
                        //color: Colors.blueGrey[50],
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                        ),
                        elevation: 8.0,
                        child: Stack(
                          alignment: AlignmentDirectional.topCenter,
                          children: [
                            GFAccordion(
                              margin: const EdgeInsets.all(0),
                              titleChild: SelectableText.rich(TextSpan(
                                text: '${note?.sections![index]!.sectionTitle}',
                              )),
                              contentChild: SelectableText.rich(
                                TextSpan(
                                  text: '${note?.sections![index]!.content}',
                                ),
                              ),
                              /* collapsedIcon: Icon(Icons.add),
                                      expandedIcon: Icon(Icons.minimize), */
                              /* collapsedIcon: const Text('Show'),
                                      expandedIcon: const Text('Hide'), */
                              collapsedTitleBackgroundColor:
                                  const Color(0xffb0bec5),
                              expandedTitleBackgroundColor:
                                  const Color(0xffb0bec5),
                              contentBackgroundColor:
                                  Theme.of(context).canvasColor,
                              titleBorderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                              /* margin:
                            const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 20), */
                            ),
                            /* Positioned(
                        top: 9,
                        right: 60,
                        child: IconButton(
                            onPressed: () {}, icon: const Icon(Icons.close)),
                      ) */
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    ));
  }
}



/* 
Container(
            padding: const EdgeInsets.only(
              top: 60.0,
              left: 30.0,
              right: 30.0,
              bottom: 30.0,
            ),
            child: SelectableText(
              note.title as String,
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            child: Column(
              children: [
                for (Section section in note.sections as List)
                  SelectableText.rich(
                    TextSpan(text: '${section.sectionTitle}\n', children: [
                      TextSpan(
                        text: '${section.content}\n\n',
                      ),
                    ]),
                  ),
              ],
            ),
          )
 */