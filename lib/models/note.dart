import 'creator.dart';

class Section {
  final String? id;
  final String? sectionTitle;
  final String? content;

  Section({this.id, this.sectionTitle, this.content});

  factory Section.fromMap(Map<String, dynamic> json) => Section(
        id: json["_id"] as String,
        sectionTitle: json["sectionTitle"] as String,
        content: json["content"] as String,
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "sectionTitle": sectionTitle,
        "content": content,
      };
}

List<Note> notesFromJson(dynamic str) =>
    List<Note>.from((str).map((x) => Note.fromMap(x)));

class Note {
  String? id;
  String? title;
  List<Section?>? sections;
  String? category;
  Creator? creator;
  DateTime? createdAt;
  DateTime? updatedAt;

  Note({
    this.id,
    this.title,
    this.sections,
    this.category,
    this.creator,
    this.createdAt,
    this.updatedAt,
  });
  /* DateTime date = DateTime.parse("2020-08-02T18:30:00.000Z").toUtc();
  DateTime dateLocal = date.toLocal(); */

  Note.fromMap(Map<String, dynamic> json) {
    id = json["_id"];
    title = json["title"];
    sections = (json["sections"] as List)
        .map((data) => Section.fromMap(data))
        .toList();
    category = json["category"];
    creator = Creator.fromMap(json["creator"]);
    createdAt = DateTime.parse(json["createdAt"]).toUtc();
    updatedAt = DateTime.parse(json["updatedAt"]).toUtc();
  }

  Map<String, dynamic> toMap() => {
        "_id": id,
        "title": title,
        "sections": sections,
        "category": category,
        "creator": creator,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}
