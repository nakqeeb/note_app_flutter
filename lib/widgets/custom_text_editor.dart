/* // ignore_for_file: prefer_const_constructors

import 'dart:collection';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:super_editor/super_editor.dart';

class CustomTextEditor extends StatefulWidget {
  String? contentText;
  CustomTextEditor({Key? key, required this.contentText}) : super(key: key);

  @override
  State<CustomTextEditor> createState() => _CustomTextEditorState();
}

class _CustomTextEditorState extends State<CustomTextEditor> {
  //HtmlEditorController controller = HtmlEditorController();
  final controller = ScrollController();
  //QuillController _controller = QuillController.basic();
  QuillController? _controller;
  final FocusNode _focusNode = FocusNode();

  final myDoc = MutableDocument(
    nodes: [
      ParagraphNode(
        id: DocumentEditor.createNodeId(),
        text: AttributedText(text: 'This is a header'),
        metadata: {
          'blockType': header1Attribution,
        },
      ),
      ParagraphNode(
        id: DocumentEditor.createNodeId(),
        text: AttributedText(text: 'This is the first paragraph'),
      ),
    ],
  );

// With a MutableDocument, create a DocumentEditor, which knows how
// to apply changes to the MutableDocument.

  /* QuillController initQuillController(String? data) {
    if (data == null) {
      return QuillController.basic();
    }
    List<dynamic>? jsonData;
    try {
      jsonData = jsonDecode(data) as List;
    } on FormatException catch (e, stackTrace) {
      jsonData = null;
    } finally {}
    return jsonData == null
        ? QuillController.basic()
        : QuillController(
            document: Document.fromJson(jsonData),
            selection: const TextSelection.collapsed(offset: 0),
          );
  }

  Future<void> _loadFromAssets() async {
    try {
      final result = await rootBundle.loadString(widget.contentText as String);
      final doc = Document.fromJson(jsonDecode(result));
      setState(() {
        _controller = QuillController(
            document: doc, selection: const TextSelection.collapsed(offset: 0));
        _controller?.document.toPlainText();
      });
    } catch (error) {
      final doc = Document()..insert(0, 'Empty asset');
      setState(() {
        _controller = QuillController(
            document: doc, selection: const TextSelection.collapsed(offset: 0));
      });
    }
  } */
  var docEditor;
  @override
  void initState() {
    // TODO: implement initState

    final docEditor = DocumentEditor(document: myDoc);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: SuperEditor.custom(
        editor: docEditor,
        textStyleBuilder: /** INSERT CUSTOMIZATION **/ null,
        selectionStyle: /** INSERT CUSTOMIZATION **/ null,
        keyboardActions: /** INSERT CUSTOMIZATION **/ null,
        componentBuilders: /** INSERT CUSTOMIZATION **/ null,
      ),
    );
  }
}
 */