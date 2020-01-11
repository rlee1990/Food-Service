import 'package:flutter/material.dart';
import 'package:food_dev/Models/cart.dart';
import 'package:food_dev/Models/food_item.dart';
import 'package:provider/provider.dart';

class FoodMenuItem extends StatelessWidget {
  const FoodMenuItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final item = Provider.of<FoodItem>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed('/foodItem', arguments: item.id);
          },
          child: Image.network(
            item.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: Consumer<FoodItem>(
            builder: (ctx, foodItem, _) => IconButton(
              icon: Icon(
                  foodItem.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                item.changeFavoriteStatus();
              },
            ),
          ),
          title: Text(
            item.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.add_shopping_cart),
            onPressed: () {
              cart.addItemToCart(
                  item.id, item.price, item.title, item.imageUrl);
                  Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('${item.title} added to cart'),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  textColor: Colors.red,
                  label: 'UNDO',
                  onPressed: () {
                    cart.removeSingleItem(item.id);
                  },
                ),
              ));
            },
          ),
        ),
      ),
    );
  }
}
