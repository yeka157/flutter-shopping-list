import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery.dart';
import 'package:shopping_list/widgets/groceries_item.dart';

class GroceriesList extends StatelessWidget {
  const GroceriesList({super.key, required this.groceries, required this.removeItem});

  final List<GroceryItem> groceries;
  final void Function(GroceryItem grocery) removeItem;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(groceries[index]),
        onDismissed: (direction) {
          removeItem(groceries[index]);
        },
        child: GroceriesItem(
          grocery: groceries[index],
        ),
      ),
      itemCount: groceries.length,
    );
  }
}
