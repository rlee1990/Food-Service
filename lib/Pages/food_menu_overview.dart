import 'package:flutter/material.dart';
import 'package:food_dev/Models/cart.dart';
import 'package:food_dev/Models/food_items.dart';
import 'package:food_dev/Widgets/app_drawer.dart';
import 'package:food_dev/Widgets/badge.dart';
import 'package:food_dev/Widgets/food_items_grid.dart';
import 'package:provider/provider.dart';

enum FilterOptions { Salads, Sandwiches, Chicken, Drinks, Sides, All }

class FoodMenuOverview extends StatefulWidget {
  const FoodMenuOverview({Key key}) : super(key: key);

  @override
  _FoodMenuOverviewState createState() => _FoodMenuOverviewState();
}

class _FoodMenuOverviewState extends State<FoodMenuOverview> {
  bool _showFavoritesOnly = false;
  bool showChicken = false;
  bool showDrinks = false;
  bool showSalads = false;
  bool showSides = false;
  bool showSandwiches = false;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<FoodItems>(context).fetchFoodItems().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('R&R Catering'),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.filter_list),
            onSelected: (FilterOptions value) {
              setState(() {
                if (value == FilterOptions.Chicken) {
                  showChicken = true;
                  showDrinks = false;
                  showSalads = false;
                  showSides = false;
                  showSandwiches = false;
                } else if (value == FilterOptions.Drinks) {
                  showChicken = false;
                  showDrinks = true;
                  showSalads = false;
                  showSides = false;
                  showSandwiches = false;
                } else if (value == FilterOptions.Salads) {
                  showChicken = false;
                  showDrinks = false;
                  showSalads = true;
                  showSides = false;
                  showSandwiches = false;
                } else if (value == FilterOptions.Sandwiches) {
                  showChicken = false;
                  showDrinks = false;
                  showSalads = false;
                  showSides = false;
                  showSandwiches = true;
                } else if (value == FilterOptions.Sides) {
                  showChicken = false;
                  showDrinks = false;
                  showSalads = false;
                  showSides = true;
                  showSandwiches = false;
                } else {
                  showChicken = false;
                  showDrinks = false;
                  showSalads = false;
                  showSides = false;
                  showSandwiches = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Chicken'),
                value: FilterOptions.Chicken,
              ),
              PopupMenuItem(
                child: Text('Salads'),
                value: FilterOptions.Salads,
              ),
              PopupMenuItem(
                child: Text('Sides'),
                value: FilterOptions.Sides,
              ),
              PopupMenuItem(
                child: Text('Sandwiches'),
                value: FilterOptions.Sandwiches,
              ),
              PopupMenuItem(
                child: Text('Drinks'),
                value: FilterOptions.Drinks,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed('/cart');
              },
            ),
          ),
        ],
      ),
      drawer: CustomAppDrawer(),
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : FoodItemsGrid(showChicken: showChicken, showDrinks: showDrinks, showSalads: showSalads, showSandwiches: showSandwiches, showSides: showSides,),
      ),
    );
  }
}
