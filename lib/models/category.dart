List<Category> catsFromJson(dynamic str) =>
    List<Category>.from((str).map((x) => Category.fromMap(x)));

class Category {
  String? id;
  String? name;
  String? icon;
  String? color;
  String? creator;
  /* DateTime? createdAt;
  DateTime? updatedAt; */
  bool isSelected = false;

  Category({
    this.id,
    this.name,
    this.icon,
    this.color,
    this.creator,
    /* this.createdAt,
    this.updatedAt, */
  });

  Category.fromMap(Map<String, dynamic> json) {
    id = json["_id"];
    name = json["name"];
    icon = json["icon"];
    color = json["color"];
    creator = json["creator"];
    /* createdAt = DateTime.parse(json["createdAt"]).toUtc();
    updatedAt = DateTime.parse(json["updatedAt"]).toUtc(); */
  }

  Map<String, dynamic> toMap() => {
        "_id": id,
        "name": name,
        "icon": icon,
        "color": color,
        "creator": creator,
        /* "createdAt": createdAt,
        "updatedAt": updatedAt, */
      };
}
