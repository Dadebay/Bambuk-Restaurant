import 'package:flutter/material.dart';

class UserInfo with ChangeNotifier {
  GlobalKey<NavigatorState> yourKey = GlobalKey<NavigatorState>();

  String _name = '';
  String get name => _name;

  String _surname = '';
  String get surname => _surname;

  String _email = '';
  String get email => _email;

  String _phone = '';
  String get phone => _phone;

  String _password = '';
  String get password => _password;

  String _token = '';
  String get token => _token;

  String _costumer_id = '';
  String get costumer_id => _costumer_id;

  void setName(String getName) {
    _name = getName;
    notifyListeners();
  }

  void setSurname(String getSurname) {
    _surname = getSurname;
    notifyListeners();
  }

  void setEmail(String getEmail) {
    _email = getEmail;
    notifyListeners();
  }

  void setPhone(String getPhone) {
    _phone = getPhone;
    notifyListeners();
  }

  void setPassword(String getPassword) {
    _password = getPassword;
    notifyListeners();
  }

  void setToken(String getToken) {
    _token = getToken;
    notifyListeners();
  }

  void setCostumer_id(String getCostumer_id) {
    _costumer_id = getCostumer_id;
    notifyListeners();
  }
}
