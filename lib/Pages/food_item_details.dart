import 'package:flutter/material.dart';
import 'package:food_dev/Models/food_items.dart';
import 'package:provider/provider.dart';

class FoodItemDetails extends StatelessWidget {
  const FoodItemDetails({Key key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as String;
    final foodItems = Provider.of<FoodItems>(context, listen: false);
    final foodItem = foodItems.findById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(foodItem.title),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 300.0,
                child: Image.network(foodItem.imageUrl, fit: BoxFit.cover,),
              ),
              SizedBox(height: 20,),
              Text('\$${foodItem.price}'),
              SizedBox(height: 20,),
              Text(foodItem.description, textAlign: TextAlign.center, softWrap: true,),
              //ToDo Add option to add to cart and remove from cart
            ],
        ),
          ),
        ),
      ),
    );
  }
}