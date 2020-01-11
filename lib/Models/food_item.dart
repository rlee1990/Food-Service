import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FoodItem with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  bool isFavorite;

  FoodItem({
      @required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.category,
      @required this.imageUrl,
      this.isFavorite = false
      });

  factory FoodItem.fromSnapshot(DocumentSnapshot snapshot) {
    return FoodItem(
      id: snapshot.documentID,
      title: snapshot.data['title'],
      description: snapshot.data['description'],
      price: snapshot.data['price'],
      category: snapshot.data['category'],
      imageUrl: snapshot.data['imageUrl'],
      isFavorite: snapshot.data['isFavorite']
    );
  }

  Future<void> changeFavoriteStatus() {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    return Firestore.instance.collection('foodItems').document(id).setData({'isFavorite': isFavorite}, merge: true).catchError((error) {
      isFavorite = oldStatus;
      notifyListeners();
      print(error);
      throw error;
    });
  }

  toJason() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
    };
  }
}
