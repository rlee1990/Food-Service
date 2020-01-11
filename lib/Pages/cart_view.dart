import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_dev/Models/cart.dart' show Cart;
import 'package:food_dev/Models/orders.dart';
import 'package:food_dev/Widgets/cart_item.dart';
import 'package:provider/provider.dart';

class CartView extends StatelessWidget {
  const CartView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Card(
              margin: const EdgeInsets.all(15),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Total',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    Spacer(),
                    Chip(
                      label: Text(
                        '\$${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    OderNowButton(cart: cart)
                  ],
                ),
              ),
            ),
            SizedBox(),
            Expanded(
              child: ListView.builder(
                itemCount: cart.itemCount,
                itemBuilder: (ctx, index) => CartItem(
                  productId: cart.items.keys.toList()[index],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


class OderNowButton extends StatefulWidget {
  const OderNowButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OderNowButtonState createState() => _OderNowButtonState();
}

class _OderNowButtonState extends State<OderNowButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final fUser = Provider.of<FirebaseUser>(context, listen: false);
    return FlatButton(
      child: _isLoading ? CircularProgressIndicator() : Text(
        'Order Now',
        style: TextStyle(color: _isLoading ? Theme.of(context).disabledColor : Theme.of(context).primaryColor),
      ),
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () {
              setState(() {
                _isLoading = true;
              });
              Provider.of<Orders>(context, listen: false)
                  .addOrder(widget.cart.items.values.toList(),
                      widget.cart.totalAmount, fUser.email, fUser.uid)
                  .then((_) {
                setState(() {
                  _isLoading = false;
                });
                widget.cart.clearCart();
              });
            },
    );
  }
}
