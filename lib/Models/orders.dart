import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:food_dev/Models/cart.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Firestore _firestore = Firestore.instance;

  Future<void> addOrder(List<CartItem> cartItems, double total, String email, String uid) {
    return _firestore.collection('orders').add({
      'amount': total,
      'orderTime': FieldValue.serverTimestamp(),
      'userEmail': email,
      'uid': uid,
      'items': cartItems
            .map((item) => {'title': item.title, 'price': item.price, 'id': item.id, 'quantity': item.quantity, 'image': item.image,}
                )
            .toList(),
    }).then((data) {
      data.snapshots().forEach((DocumentSnapshot snapshot) {
        OrderItem order = OrderItem.fromSnapshot(snapshot);
        _orders.insert(
        0, order);
    notifyListeners();
      });
    }).catchError((error) {
      print(error);
      throw error;
    });
  }

  Future<void> fecthOrders() {
    return _firestore.collection('orders').orderBy('orderTime', descending: true).getDocuments().then((data) {
      if (data.documents.isEmpty) {
        return;
      }
      final List<OrderItem> fbOrders = data.documents.map((doc) => OrderItem.fromSnapshot(doc)).toList();
      _orders = fbOrders;
      notifyListeners();
    }).catchError((error) {
      print(error);
      throw error;
    });
  }

  Future<void> fecthOrdersById(String uid) {
    return _firestore.collection('orders').where('uid', isEqualTo: uid).getDocuments().then((data) {
      if (data.documents.isEmpty) {
        return;
      }
      final List<OrderItem> fbOrders = data.documents.map((doc) => OrderItem.fromSnapshot(doc)).toList();
      _orders = fbOrders.reversed.toList();
      notifyListeners();
    }).catchError((error) {
      print(error);
      throw error;
    });
  }
}

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> items;
  final Timestamp orderTime;
  final String userEmail;
  final String uid;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.items,
      @required this.userEmail,
      @required this.uid,
      @required this.orderTime});

  factory OrderItem.fromSnapshot(DocumentSnapshot snapshot) {
    return OrderItem(
      userEmail: snapshot.data['userEmail'],
      id: snapshot.documentID,
      amount: snapshot.data['amount'],
      uid: snapshot.data['uid'],
      items: snapshot.data['items'].map<CartItem>((item) {
        return CartItem.fromMap(item);
      }).toList(),
      orderTime: snapshot.data['orderTime'],
    );
  }

  toJason() {
    return {
      'amount': amount,
      'orderTime': orderTime,
      'items': items,
      'userEmail': userEmail,
      'uid': uid,
    };
  }
}
