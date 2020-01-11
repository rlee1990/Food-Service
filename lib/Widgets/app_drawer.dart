import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_dev/Services/auth_server.dart';
import 'package:provider/provider.dart';

class CustomAppDrawer extends StatelessWidget {
  const CustomAppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isAdmin = Provider.of<Auth>(context, listen: false).isAdmin;
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(title: Text('R&R'), automaticallyImplyLeading: false,),
          Divider(),
          ListTile(
            leading:  Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            leading:  Icon(Icons.receipt),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/orders');
            },
          ),
           Divider(),
          // if (fUser.uid == '3SNctJfJjdQhOVishCroSOKS0pk2')
          if(isAdmin)
          ListTile(
            leading:  Icon(Icons.edit),
            title: Text('Manage Items'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/manageItems');
            },
          ),
          // if (fUser.uid == '3SNctJfJjdQhOVishCroSOKS0pk2')
          if (isAdmin)
          ListTile(
            leading:  Icon(Icons.group),
            title: Text('Manage Staff'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/manageStaff');
            },
          ),
          ListTile(
            title: Text('Logout'),
            leading: Icon(Icons.power_settings_new),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
              FirebaseAuth.instance.signOut();
            },
          )
        ],
      ),
    );
  }
}