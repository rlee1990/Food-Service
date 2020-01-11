import 'package:flutter/material.dart';
import 'package:food_dev/Models/cart.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String productId;
  const CartItem({Key key, this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartItem = Provider.of<Cart>(context).getItem(productId);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: CircleAvatar(
            maxRadius: 25.0,
            backgroundImage: NetworkImage(cartItem.image),
          ),
          title: Text(
              '${cartItem.title}, Total: \$${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}'),
          subtitle: Text('${cartItem.quantity} x'),
          trailing: Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  Provider.of<Cart>(context, listen: false).addItemToCart(productId, cartItem.price, cartItem.title, cartItem.image);
                },
                child: Container(
                  height: 25.0,
                  width: 25.0,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 2.0,
              ),
              InkWell(
                onTap: () {
                  Provider.of<Cart>(context, listen: false).removeItem(productId);
                },
                child: Container(
         
                           height: 25.0,
                  width: 25.0,
                  decoration:
                      BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: Icon(
                    Icons.remove,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
