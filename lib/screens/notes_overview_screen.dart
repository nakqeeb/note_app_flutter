import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app_flutter/providers/categories.dart';
import 'package:note_app_flutter/providers/notes.dart';
import 'package:note_app_flutter/screens/edit_note_screen.dart';
import 'package:note_app_flutter/screens/note_details_screen.dart';
import 'package:note_app_flutter/widgets/app_drawer.dart';
import 'package:note_app_flutter/widgets/categories_listview.dart';
import 'package:note_app_flutter/widgets/filter_notes.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';

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
    if (_isInit) {
      // we use setState to update the ui once the property has been changed, otherwise the the ui will not be updated.
      setState(() {
        _isLoading = true;
        _isCatsLoading = true;
      });
      Provider.of<Notes>(context).fetchNotes().then((_) {
        // print(res![0].sections?[0].content);
        setState(() {
          _isLoading = false;
          _categoryId = null;
        });
      });
      Provider.of<Categories>(context).fetchCategories().then((_) {
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
    final mediaQuery = MediaQuery.of(context);
    final notes = Provider.of<Notes>(context).notes;
    final noteData = Provider.of<Notes>(context);
    final cats = Provider.of<Categories>(context).cats;
    final appBar = AppBar();
    return Scaffold(
      key:
          scaffoldKey, // scaffoldKey for opening a drower from the icon button when we dont want to use an app bar
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
              FilterNotes(
                  categoryId: _categoryId,
                  callback: (val) => setState(() {
                        _isNotesLoading = val;
                      })),
            ],
          ),
        ),
        const Text(
          "Categories",
          style: TextStyle(
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
                              noteData
                                  .fetchNotesByCategoryId(
                                      cats[index].id as String)
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
                              noteData.fetchNotes().then((_) {
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
        const Padding(
          padding: EdgeInsets.only(top: 8.0, bottom: 6.0),
          child: Text(
            "Notes",
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
                : _isNotesLoading
                    ? const Center(
                        child: const CircularProgressIndicator(),
                      )
                    : !_isNotesLoading && notes.isEmpty
                        ? Center(
                            child: Text(
                              'No notes match with this category. Start adding some.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: notes.length,
                            itemBuilder: (context, index) => Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                      NoteDetailsScreen.routeName,
                                      arguments: notes[index].id,
                                    );
                                  },
                                  child: ListTile(
                                    title: Text(notes[index].title as String),
                                    subtitle: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          Text(
                                            'Created At: ' +
                                                //DateFormat('dd/MM/yyyy hh:mm')
                                                DateFormat('dd/MM/yyyy').format(
                                                    notes[index].createdAt
                                                        as DateTime),
                                          ),
                                          const SizedBox(
                                            width: 7,
                                          ),
                                          Text(
                                            'Updated At: ' +
                                                // DateFormat('dd/MM/yyyy hh:mm')
                                                DateFormat('dd/MM/yyyy').format(
                                                    notes[index].updatedAt
                                                        as DateTime),
                                          )
                                        ],
                                      ),
                                    ),
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
