import 'package:flutter/material.dart';
import 'package:food_dev/Models/food_items.dart';
import 'package:food_dev/Widgets/food_item.dart';
import 'package:provider/provider.dart';

class FoodItemsGrid extends StatelessWidget {
  final bool showChicken;
  final bool showDrinks;
  final bool showSalads;
  final bool showSides;
  final bool showSandwiches;
  const FoodItemsGrid({
    Key key,
    this.showChicken,
    this.showDrinks,
    this.showSalads,
    this.showSides,
    this.showSandwiches,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemsData = Provider.of<FoodItems>(context);
    final loadedItems = showChicken
        ? itemsData.chickenItems
        : showDrinks
            ? itemsData.drinksItems
            : showSalads
                ? itemsData.saladsItems
                : showSides
                    ? itemsData.sidesItems
                    : showSandwiches
                        ? itemsData.sandwichItems
                        : itemsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: loadedItems.length,
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: loadedItems[index],
        child: FoodMenuItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}
