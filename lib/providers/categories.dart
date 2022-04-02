import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:note_app_flutter/models/http_exception.dart';
import '../models/category.dart';

class Categories with ChangeNotifier {
  List<Category> _cats = [
    Category(
      id: null,
      name: 'All',
    )
  ];
  List<Category> _dropDownCats;

  final String? authToken;
  final String? userId;

  Categories(this.authToken, this.userId, this._cats, this._dropDownCats);

  List<Category> get cats {
    return [..._cats];
  }

  List<Category> get dropDownCats {
    return [..._dropDownCats];
  }

  Future<void> fetchCategories() async {
    final url = Uri.http(
        'mononotesproapp-env.eba-rmep9tam.us-east-1.elasticbeanstalk.com',
        '/categories');

    var response = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer ' + authToken!,
      },
    );

    var extractedData = json.decode(response.body);
    if (extractedData == null) {
      return;
    }

    _cats = [
      Category(
        id: null,
        name: 'All',
      ),
      ...catsFromJson(extractedData["categories"]),
    ];

    // used in dropdown to show all categories except (All)
    _dropDownCats = catsFromJson(extractedData["categories"]);
    notifyListeners();
  }

  Category fetchCategoryById(String id) {
    return _cats.firstWhere((c) => c.id == id);
  }

  Future<void> addCategory(Category category) async {
    final url = Uri.http(
        'mononotesproapp-env.eba-rmep9tam.us-east-1.elasticbeanstalk.com',
        '/categories');

    var response = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer ' + authToken!,
      },
      body: json.encode({
        'name': category.name,
        'icon': category.icon,
        'color': category.color,
        'creator': userId,
      }),
    );

    final Category newCategory = Category(
      id: json.decode(response.body)['category']['_id'],
      name: json.decode(response.body)['category']['name'],
      icon: json.decode(response.body)['category']['icon'],
      color: json.decode(response.body)['category']['color'],
      creator: json.decode(response.body)['category']['creator'],
      /* createdAt:
          DateTime.parse(json.decode(response.body)['category']['createdAt'])
              .toUtc(),
      updatedAt:
          DateTime.parse(json.decode(response.body)['category']['updatedAt'])
              .toUtc(), */
    );
    _cats.add(newCategory);

    notifyListeners();
  }

  Future<void> updateCategory(String? catId, Category category) async {
    final categoryIndex = _cats.indexWhere((c) => c.id == catId);
    if (categoryIndex >= 0) {
      final url = Uri.http(
          'mononotesproapp-env.eba-rmep9tam.us-east-1.elasticbeanstalk.com',
          '/categories/$catId');

      final response = await http.put(
        url,
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer ' + authToken!,
        },
        body: json.encode({
          '_id': category.id,
          'name': category.name,
          'icon': category.icon,
          'color': category.color,
        }),
      );

      if (response.statusCode >= 400) {
        notifyListeners();
        throw HttpException('Could not update category.');
      }
      _cats[categoryIndex] = category;
      notifyListeners();
    }
  }

  Future<void> deleteCategory(String catId) async {
    final url = Uri.http(
        'mononotesproapp-env.eba-rmep9tam.us-east-1.elasticbeanstalk.com',
        '/categories/$catId');
    final existingCategoryIndex = _cats.indexWhere((c) => c.id == catId);
    Category? existingCategory = _cats[existingCategoryIndex];
    _cats.removeAt(existingCategoryIndex);
    notifyListeners();
    final response = await http.delete(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer ' + authToken!,
      },
    );
    if (response.statusCode >= 400) {
      _cats.insert(existingCategoryIndex, existingCategory);
      notifyListeners();
      throw HttpException('Could not delete category.');
    }
    existingCategory = null;
  }
}
