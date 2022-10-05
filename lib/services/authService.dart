import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constant/api_routes.dart';
import '../models/http_exception.dart';
import '../notifiers/auth_notifier.dart';

class AuthService {
  static Timer? _authTimer;

  static Future<void> signup(
      String email, String password, AuthNotifier authNotifier) async {
    Map<String, String> data = {
      'email': email,
      'password': password,
    };
    print(data);
    final url = Uri.http(ApiRoutes.base_url, '/users/signup');
    try {
      final response = await http.post(url,
          headers: {"Content-type": "application/json"},
          body: json.encode(data));
      print(json.decode(response.body));
      final responseData = json.decode(response.body);

      if (responseData['success'] == false) {
        throw HttpException(responseData['message']);
      }
      login(email, password, authNotifier);
    } catch (error) {
      throw error;
    }
  }

  static Future<void> login(
      String email, String password, AuthNotifier authNotifier) async {
    Map<String, String> data = {
      'email': email,
      'password': password,
    };
    // print(data);
    final url = Uri.http(ApiRoutes.base_url, '/users/login');
    try {
      final response = await http.post(url,
          headers: {"Content-type": "application/json"},
          body: json.encode(data));
      print(json.decode(response.body));
      final responseData = json.decode(response.body);
      if (responseData['success'] == false) {
        throw HttpException(responseData['message']);
      }
      authNotifier.token = responseData['token'];
      authNotifier.userId = responseData['userId'];
      authNotifier.expiryDate = DateTime.now().add(
        Duration(
          minutes: responseData['expiresIn'],
        ),
      );
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': authNotifier.token,
        'userId': authNotifier.userId,
        'expiryDate': authNotifier.expiryDate?.toIso8601String()
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  static Future<bool> tryAutoLogin(AuthNotifier authNotifier) async {
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
    authNotifier.token = extractedUserData['token'];
    authNotifier.userId = extractedUserData['userId'];
    authNotifier.expiryDate = expiryDate;
    _autoLogout(authNotifier);
    return true;
  }

  static logout(AuthNotifier authNotifier) async {
    authNotifier.token = null;
    authNotifier.expiryDate = null;
    authNotifier.userId = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static _autoLogout(AuthNotifier authNotifier) {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry =
        authNotifier.expiryDate?.difference(DateTime.now()).inMinutes;
    _authTimer =
        Timer(Duration(minutes: timeToExpiry!), (() => logout(authNotifier)));
  }
}
