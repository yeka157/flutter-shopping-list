import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery.dart';

class GroceriesItem extends StatelessWidget {
  const GroceriesItem({super.key, required this.grocery});

  final GroceryItem grocery;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                color: grocery.category.color,
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                grocery.name,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
          Text(grocery.quantity.toString()),
        ],
      ),
    );
  }
}
