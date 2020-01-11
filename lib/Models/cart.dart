import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return  _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  CartItem getItem(String productId) {
    return _items[productId];
  }

  void addItemToCart(String productId, double price, String title, String image) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              price: existingCartItem.price,
              image: existingCartItem.image,
              quantity: existingCartItem.quantity + 1));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              image: image,
              quantity: 1));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              price: existingCartItem.price,
              image: existingCartItem.image,
              quantity: existingCartItem.quantity - 1));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              price: existingCartItem.price,
              image: existingCartItem.image,
              quantity: existingCartItem.quantity - 1));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }
}

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String image;

  CartItem(
      {@required this.id,
      @required this.price,
      @required this.quantity,
      @required this.image,
      @required this.title});
  
  factory CartItem.fromSnapshot(DocumentSnapshot snapshot) {
    return CartItem(
      id: snapshot.documentID,
      title: snapshot.data['title'],
      quantity: snapshot.data['quantity'],
      price: snapshot.data['price'],
      image: snapshot.data['image'],
    );
  }

  CartItem.fromMap(Map<dynamic, dynamic> data)
  : id = data['id'],
    title = data['title'],
      quantity = data['quantity'],
      price = data['price'],
      image = data['image'];

  toJason() {
    return {
      'title': title,
      'quantity': quantity,
      'price': price,
      'image': image,
    };
  }

  toJason2() {
    return {
      'title': title,
      'quantity': quantity,
      'price': price,
      'image': image,
      'id': id
    };
  }
}
