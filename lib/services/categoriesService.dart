import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/constant/api_routes.dart';
import '../models/http_exception.dart';
import '../models/category.dart';
import '../notifiers/categories_notifier.dart';

class CategoriesService {
  static Future<void> fetchCategories(
      CategoriesNotifier categoriesNotifier) async {
    final url = Uri.http(ApiRoutes.base_url, '/categories');

    var response = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer ' + categoriesNotifier.authToken!,
      },
    );

    var extractedData = json.decode(response.body);
    if (extractedData == null) {
      return;
    }

    categoriesNotifier.cats = [
      Category(
        id: null,
        name: 'All',
      ),
      ...catsFromJson(extractedData["categories"]),
    ];

    categoriesNotifier.dropDownCats = catsFromJson(extractedData["categories"]);
  }

  static Category fetchCategoryById(
      String id, CategoriesNotifier categoriesNotifier) {
    return categoriesNotifier.cats.firstWhere((element) => element.id == id);
  }

  static Future<void> addCategory(
      Category category, CategoriesNotifier categoriesNotifier) async {
    final url = Uri.http(ApiRoutes.base_url, '/categories');

    var response = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer ' + categoriesNotifier.authToken!,
      },
      body: json.encode({
        'name': category.name,
        'icon': category.icon,
        'color': category.color,
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
    categoriesNotifier.addCategoryToList(newCategory);
  }

  static Future<void> updateCategory(String? catId, Category category,
      CategoriesNotifier categoriesNotifier) async {
    final categoryIndex =
        categoriesNotifier.cats.indexWhere((c) => c.id == catId);
    if (categoryIndex >= 0) {
      final url = Uri.http(ApiRoutes.base_url, '/categories/$catId');

      final response = await http.put(
        url,
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer ' + categoriesNotifier.authToken!,
        },
        body: json.encode({
          'name': category.name,
          'icon': category.icon,
          'color': category.color,
        }),
      );

      if (response.statusCode >= 400) {
        throw HttpException('Could not update category.');
      }
      categoriesNotifier.updateCategoryInList(category);
    }
  }

  static Future<void> deleteCategory(
      String catId, CategoriesNotifier categoriesNotifier) async {
    final url = Uri.http(ApiRoutes.base_url, '/categories/$catId');
    categoriesNotifier.deleteCategoryFromList(catId, true);
    final response = await http.delete(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer ' + categoriesNotifier.authToken!,
      },
    );
    if (response.statusCode >= 400) {
      categoriesNotifier.deleteCategoryFromList(catId, false);
      throw HttpException('Could not delete category.');
    }
  }
}
