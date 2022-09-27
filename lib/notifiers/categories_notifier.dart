import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoriesNotifier with ChangeNotifier {
  List<Category> _cats = [
    Category(
      id: null,
      name: 'All',
    )
  ];
  // used in dropdown to show all categories except (All)
  List<Category> _dropDownCats;

  final String? _authToken;

  CategoriesNotifier(this._authToken, this._cats, this._dropDownCats);

  String? get authToken {
    return _authToken;
  }

  List<Category> get cats {
    return [..._cats];
  }

  List<Category> get dropDownCats {
    return [..._dropDownCats];
  }

  set cats(List<Category> cats) {
    _cats = cats;
    notifyListeners();
  }

  set dropDownCats(List<Category> dropDownCats) {
    _dropDownCats = dropDownCats;
    notifyListeners();
  }

  addCategoryToList(Category category) {
    _cats.add(category);
    notifyListeners();
  }

  updateCategoryInList(Category category) {
    final categoryIndex = _cats.indexWhere((c) => c.id == category.id);
    _cats[categoryIndex] = category;
    notifyListeners();
  }

  deleteCategoryFromList(String catId, bool isDeleted) {
    final existingCategoryIndex = _cats.indexWhere((c) => c.id == catId);
    Category? existingCategory = _cats[existingCategoryIndex];
    if (isDeleted) {
      _cats.removeAt(existingCategoryIndex);
      notifyListeners();
    } else {
      _cats.insert(existingCategoryIndex, existingCategory);
      notifyListeners();
    }
  }
}
