import 'package:flutter/material.dart';
import 'package:food_dev/Models/user.dart';

class ManagedStaffItem extends StatelessWidget {
  final User user;
  const ManagedStaffItem({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${user.firstName} ${user.lastName}'),
      subtitle: Text(user.email),
      leading: CircleAvatar(
        maxRadius: 25,
        backgroundColor: Colors.greenAccent,
      ),
      trailing: Container(
        width: 100.0,
        child: Row(
          children: <Widget>[
            IconButton(icon: Icon(Icons.edit), onPressed: () {
              
            },),
            IconButton(icon: Icon(Icons.delete), onPressed: () {
              
            },)
          ],
        ),
      ),
    );
  }
}