import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  MyUser? _user;
  final AuthMethods _authMethods = AuthMethods();

  MyUser get getUser => _user!;

  Future<void> refreshUser () async{
    MyUser user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}