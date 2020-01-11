import 'package:flutter/material.dart';
import 'package:food_dev/Models/food_items.dart';
import 'package:food_dev/Widgets/app_drawer.dart';
import 'package:food_dev/Widgets/managed_food_item.dart';
import 'package:provider/provider.dart';

class ManageItemsView extends StatelessWidget {
  const ManageItemsView({Key key}) : super(key: key);

  Future<void> _refreshItems(BuildContext context) {
    return Provider.of<FoodItems>(context, listen: false).fetchFoodItems();
  }

  @override
  Widget build(BuildContext context) {
    final items = Provider.of<FoodItems>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Items'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add), onPressed: () {
            Navigator.of(context).pushNamed('/editItem');
          },),
        ],
      ),
      drawer: CustomAppDrawer(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _refreshItems(context),
                  child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListView.builder(
              itemCount: items.items.length,
              itemBuilder: (_, index) => Column(
                children: <Widget>[
                  ManagedFoodItem(item: items.items[index],),
                  Divider()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}