import 'package:flutter/material.dart';

class AuthNotifier with ChangeNotifier {
  String? _token;
  String? _userId;
  DateTime? _expiryDate;

  bool get isAuth {
    return _token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  DateTime? get expiryDate {
    return _expiryDate;
  }

  set token(String? token) {
    _token = token;
    notifyListeners();
  }

  set userId(String? userId) {
    _userId = userId;
    notifyListeners();
  }

  set expiryDate(DateTime? expiryDate) {
    _expiryDate = expiryDate;
    notifyListeners();
  }
}
