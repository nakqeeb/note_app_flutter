import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:note_app_flutter/models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';
/* import 'package:shared_preferences/shared_preferences.dart';
import '../models/http_exception.dart'; */

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  String? _username;
  Timer? _authTimer;

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

  String? get username {
    return _username;
  }

  Future<void> signup(String name, String email, String password) async {
    Map<String, String> data = {
      'name': name,
      'email': email,
      'password': password,
    };
    print(data);
    final url = Uri.http('nodejs-note-app.herokuapp.com', '/users/signup');
    try {
      final response = await http.post(url,
          headers: {"Content-type": "application/json"},
          body: json.encode(data));
      print(json.decode(response.body));
      final responseData = json.decode(response.body);

      if (responseData['success'] == false) {
        notifyListeners();
        throw HttpException(responseData['message']);
      }
      login(email, password);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    Map<String, String> data = {
      'email': email,
      'password': password,
    };
    // print(data);
    final url = Uri.http('nodejs-note-app.herokuapp.com', '/users/login');
    try {
      final response = await http.post(url,
          headers: {"Content-type": "application/json"},
          body: json.encode(data));
      print(json.decode(response.body));
      final responseData = json.decode(response.body);
      if (responseData['success'] == false) {
        throw HttpException(responseData['message']);
      }
      _token = responseData['token'];
      _userId = responseData['userId'];
      _username = responseData['username'];
      _expiryDate = DateTime.now().add(
        Duration(
          minutes: responseData['expiresIn'],
        ),
      );
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate?.toIso8601String()
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    print(extractedUserData);
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  void logout() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    _username = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate?.difference(DateTime.now()).inMinutes;
    _authTimer = Timer(Duration(minutes: timeToExpiry!), logout);
  }
}
