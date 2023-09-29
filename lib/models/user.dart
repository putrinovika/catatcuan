import 'package:flutter/foundation.dart';

class User extends ChangeNotifier {
  int? _id;
  String? _email;
  String? _password;

  int? get id => _id;

  String? get email => this._email;
  set email(String? value) {
    this._email = value;
    notifyListeners();
  }

  String? get password => this._password;
  set password(String? value) {
    this._password = value;
    notifyListeners();
  }

  // konstruktor versi 1
  User(this._email, this._password,
      {required String email, required String password});

  // konstruktor versi 2: konversi dari Map ke Item
  User.fromMap(Map<String, dynamic> map) {
    _id = map['id'];
    _email = map['email'];
    _password = map['password'];
  }

  // konversi dari Item ke Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = _id;
    map['email'] = email;
    map['password'] = password;
    return map;
  }
}
