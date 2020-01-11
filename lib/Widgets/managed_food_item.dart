import 'package:flutter/material.dart';
import 'package:food_dev/Models/food_item.dart';
import 'package:food_dev/Models/food_items.dart';
import 'package:provider/provider.dart';

class ManagedFoodItem extends StatelessWidget {
  final FoodItem item;
  const ManagedFoodItem({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.title),
      leading: CircleAvatar(
        maxRadius: 25,
        backgroundImage: NetworkImage(item.imageUrl),
      ),
      trailing: Container(
        width: 100.0,
        child: Row(
          children: <Widget>[
            IconButton(icon: Icon(Icons.edit), onPressed: () {
              Navigator.of(context).pushNamed('/editItem', arguments: item.id);
            },),
            IconButton(icon: Icon(Icons.delete), onPressed: () {
              Provider.of<FoodItems>(context, listen: false).deleteItem(item.id);
            },)
          ],
        ),
      ),
    );
  }
}