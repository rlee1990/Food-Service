import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:food_dev/Models/user.dart';
import 'package:cloud_functions/cloud_functions.dart';

class Staffs with ChangeNotifier {

  Firestore _firestore = Firestore.instance;
  final HttpsCallable addStaff = CloudFunctions.instance.getHttpsCallable(functionName: 'addStaff');
  final HttpsCallable addUserAccess = CloudFunctions.instance.getHttpsCallable(functionName: 'addAccess');

  List<User> _users = [];

  List<User> get users {
    return [..._users];
  }

  User findById(String id) {
    return _users.firstWhere((item) => item.uid == id);
  }

  Future<void> fetchStaff() {
    return _firestore.collection('staff').getDocuments().then((data) {
      if (data.documents.isEmpty) {
        return;
      }
      final List<User> usersNew =
          data.documents.map((doc) => User.fromSnapshot(doc)).toList();
      _users = usersNew;
      notifyListeners();
    }).catchError((error) {
      print(error);
      throw error;
    });
  }

  Future<void> createUser(String firstName, String lastName, String email, String password) {
    return addStaff.call(<String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
    }).then((_) {
      notifyListeners();
    }).catchError((error) {
      print(error);
      throw error;
    });
  }

  Future<void> addAccess(String email, bool isAdmin, bool isStaff) {
    return addUserAccess.call(<String, dynamic>{
      'email': email,
      'isAdmin': isAdmin,
      'isStaff': isStaff,
    }).then((_) {
      notifyListeners();
    }).catchError((error) {
      print(error);
      throw error;
    });
  }
}