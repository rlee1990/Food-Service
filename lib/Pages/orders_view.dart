import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_dev/Models/orders.dart';
import 'package:food_dev/Services/auth_server.dart';
import 'package:food_dev/Widgets/app_drawer.dart';
import 'package:food_dev/Widgets/order_item_widget.dart';
import 'package:provider/provider.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({Key key}) : super(key: key);

  @override
  _OrdersViewState createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {

  var _isLoading = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      setState(() {
       _isLoading = true; 
      });
      final fUser = Provider.of<FirebaseUser>(context, listen: false);
      final isAdmin = Provider.of<Auth>(context, listen: false).isAdmin;
      if(!isAdmin) {
        Provider.of<Orders>(context, listen: false).fecthOrdersById(fUser.uid).then((_) {
        setState(() {
         _isLoading = false; 
        });
      });
      } else {
        Provider.of<Orders>(context, listen: false).fecthOrders().then((_) {
        setState(() {
         _isLoading = false; 
        });
      });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
        centerTitle: true,
      ),
      drawer: CustomAppDrawer(),
      body: SafeArea(
        child: _isLoading ? Center(child: CircularProgressIndicator(),) : ListView.builder(
          itemCount: orderData.orders.length,
          itemBuilder: (ctx, index) => OrderItemWidget(order: orderData.orders[index],), 
        ),
      ),
    );
  }
}