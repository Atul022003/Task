import 'dart:developer';

import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:task/constants.dart';

import '../utilities/sharedpreferencehelper.dart'; // For json decoding

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  SharedPreferenceHelper sharedPref = SharedPreferenceHelper();

  Future<bool> isLoggedIn() async {
    await sharedPref.init();
    final token = sharedPref.getToken();
    return token !=null && token.isNotEmpty;
  }

  void setToken(String? token) async {
    await sharedPref.init();
    sharedPref.setToken(token);
  }

  Future<bool>login(String email, String password)async{
  _isLoading = true;
notifyListeners();
  final response = await http.post(Uri.parse(Constants.loginUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email" : email,
        "password" : password,
      })
  );

  _isLoading = false;
  notifyListeners();

  if(response.statusCode == 200){
    final Map<String, dynamic> jsonData = jsonDecode(response.body);
    final String token = jsonData['token'];
    setToken(token);
    return true;
  } else {
    return false;
  }

}
}