import 'dart:core';
import 'dart:core' as prefix0;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class Auth with ChangeNotifier {

  bool _isAdmin = false;

  bool get isAdmin {
    return _isAdmin;
  }

  Future<void> checkIsAdmin() {
    return FirebaseAuth.instance.currentUser().then((user) {
      if (user != null) {
        user.getIdToken(refresh: true).then((result) {
        _isAdmin = result.claims['admin'] ?? false;
        prefix0.print(result.claims);
        print('Got Admin');
        notifyListeners();
      });
      }
    });
  }
}