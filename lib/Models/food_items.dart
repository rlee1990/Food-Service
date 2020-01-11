import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_dev/Models/food_item.dart';
import 'package:uuid/uuid.dart';

class FoodItems with ChangeNotifier {
  Firestore _firestore = Firestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  final uuid = new Uuid();

  List<FoodItem> _items = [];

  // bool _showOnlyFavorites = false;

  List<FoodItem> get items {
    // if (_showOnlyFavorites) {
    //   return _items.where((item) => item.isFavorite).toList();
    // }
    return [..._items];
  }

  List<FoodItem> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  List<FoodItem> get chickenItems {
    return _items.where((item) => item.category == 'Chicken').toList();
  }

  List<FoodItem> get saladsItems {
    return _items.where((item) => item.category == 'Salads').toList();
  }

  List<FoodItem> get sandwichItems {
    return _items.where((item) => item.category == 'Sandwiches').toList();
  }

  List<FoodItem> get drinksItems {
    return _items.where((item) => item.category == 'Drinks').toList();
  }

  List<FoodItem> get sidesItems {
    return _items.where((item) => item.category == 'Sides').toList();
  }

  FoodItem findById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }

  Future<void> fetchFoodItems() {
    return _firestore.collection('foodItems').getDocuments().then((data) {
      if (data.documents.isEmpty) {
        return;
      }
      final List<FoodItem> foodItems =
          data.documents.map((doc) => FoodItem.fromSnapshot(doc)).toList();
      _items = foodItems;
      notifyListeners();
    }).catchError((error) {
      print(error);
      throw error;
    });
  }

  // void showOnlyFavorites() {
  //   _showOnlyFavorites = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showOnlyFavorites = false;
  //   notifyListeners();
  // }

  Future<void> addFoodItem(FoodItem foodItem, File image) {
    String imgUUID = uuid.v4();
    String imageName = '$imgUUID.jpeg';

    if (image != null) {
      StorageReference foodRef =
        _storage.ref().child('Photos').child('MenuFood').child(imageName);
    StorageUploadTask uploadTask = foodRef.putFile(image);

    return uploadTask.onComplete.then((snapshot) {
      snapshot.ref.getDownloadURL().then((url) {
        FoodItem newItem = FoodItem(
            category: foodItem.category,
            imageUrl: url.toString(),
            id: foodItem.id,
            title: foodItem.title,
            price: foodItem.price,
            description: foodItem.description,
            isFavorite: foodItem.isFavorite);
        _firestore
            .collection('foodItems')
            .add(newItem.toJason())
            .then((product) {
          product.snapshots().forEach((DocumentSnapshot snapshot) {
            FoodItem item = FoodItem.fromSnapshot(snapshot);
            _items.add(item);
            notifyListeners();
          });
        }).catchError((error) {
          print(error);
          throw error;
        });
      });
    });
    } else if (image == null) {
      _firestore
            .collection('foodItems')
            .add(foodItem.toJason())
            .then((product) {
          product.snapshots().forEach((DocumentSnapshot snapshot) {
            FoodItem item = FoodItem.fromSnapshot(snapshot);
            _items.add(item);
            notifyListeners();
          });
        }).catchError((error) {
          print(error);
          throw error;
        });
    } else {
      return Future.value();
    }
  }

  Future<void> updateItem(String id, FoodItem item, File image) {
    String imgUUID = uuid.v4();
    String imageName = '$imgUUID.jpeg';
    final index = _items.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      if (image != null) {
        StorageReference foodRef =
            _storage.ref().child('Photos').child('MenuFood').child(imageName);
        StorageUploadTask uploadTask = foodRef.putFile(image);
        return uploadTask.onComplete.then((snapshot) {
          snapshot.ref.getDownloadURL().then((url) {
            FoodItem newItem = FoodItem(
                category: item.category,
                imageUrl: url.toString(),
                id: item.id,
                title: item.title,
                price: item.price,
                description: item.description,
                isFavorite: item.isFavorite);
            _firestore
                .collection('foodItems')
                .document(id)
                .setData(newItem.toJason(), merge: true)
                .then((product) {
              _items[index] = newItem;
              notifyListeners();
            }).catchError((error) {
              print(error);
              throw error;
            });
          }).catchError((error) {
            print(error);
            throw error;
          });
        }).catchError((error) {
          print(error);
          throw error;
        });
      } else {
        return _firestore
            .collection('foodItems')
            .document(id)
            .setData(item.toJason(), merge: true)
            .then((product) {
          _items[index] = item;
          notifyListeners();
        }).catchError((error) {
          print(error);
          throw error;
        });
      }
    } else {
      return Future.value();
    }
  }

  void deleteItem(String id) {
    final existingItemIndex = _items.indexWhere((prod) => prod.id == id);
    var existingItem = _items[existingItemIndex];
    _items.removeAt(existingItemIndex);
    _firestore.collection('foodItems').document(id).delete().then((response) {
      existingItem = null;
      notifyListeners();
    }).catchError((_) {
      _items.insert(existingItemIndex, existingItem);
      notifyListeners();
    });
  }
}
