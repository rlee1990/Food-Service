import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_dev/Models/cart.dart';
import 'package:food_dev/Models/food_items.dart';
import 'package:food_dev/Models/orders.dart';
import 'package:food_dev/Models/staffs.dart';
import 'package:food_dev/Pages/cart_view.dart';
import 'package:food_dev/Pages/edit_add_staff_view.dart';
import 'package:food_dev/Pages/edit_item_view.dart';
import 'package:food_dev/Pages/food_item_details.dart';
import 'package:food_dev/Pages/food_menu_overview.dart';
import 'package:food_dev/Pages/login_view.dart';
import 'package:food_dev/Pages/manage_items_view.dart';
import 'package:food_dev/Pages/manage_staff.dart';
import 'package:food_dev/Pages/orders_view.dart';
import 'package:food_dev/Pages/signup_view.dart';
import 'package:food_dev/Services/auth_server.dart';
import 'package:food_dev/utils/fooddel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  runZoned(() async {
    runApp(Root());
  });
  Firestore.instance
      .settings(sslEnabled: true);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  FoodDel.prefs = await SharedPreferences.getInstance();
}

class Root extends StatelessWidget {
  const Root({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
          value: FirebaseAuth.instance.onAuthStateChanged,
        ),
        ChangeNotifierProvider.value(
          value: Auth(),
        )
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    Provider.of<Auth>(context, listen: false).checkIsAdmin();
    final user = Provider.of<FirebaseUser>(context);
    return user != null ? MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: FoodItems(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        ),
        ChangeNotifierProvider.value(
          value: Staffs(),
        ),
      ],
      child: MaterialApp(
      title: 'Food Del',
      theme: ThemeData(
        primaryColor: Color(0xffff2020),
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
      routes: {
        '/foodItem': (ctx) => FoodItemDetails(),
        '/cart': (ctx) => CartView(),
        '/orders': (ctx) => OrdersView(),
        '/manageItems': (ctx) => ManageItemsView(),
        '/editItem': (ctx) => EditItemsView(),
        '/signup': (ctx) => SignUp(),
        '/manageStaff': (ctx) => ManageStaffView(),
        '/editStaff': (ctx) => EditStaffView(),
      },
    ),
    ) : MaterialApp(
    title: 'Food Del',
    theme: ThemeData(
      primaryColor: Color(0xffff2020),
    ),
    debugShowCheckedModeBanner: false,
    home: Home(),
    routes: {
      '/foodItem': (ctx) => FoodItemDetails(),
      '/cart': (ctx) => CartView(),
      '/orders': (ctx) => OrdersView(),
      '/manageItems': (ctx) => ManageItemsView(),
      '/editItem': (ctx) => EditItemsView(),
      '/signup': (ctx) => SignUp(),
      '/manageStaff': (ctx) => ManageStaffView(),
      '/editStaff': (ctx) => EditStaffView(),
    },
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseUser>(
        builder: (ctx, fUser, _) {
          return fUser != null ? FoodMenuOverview() : Login();
        },
      );
  }
}
