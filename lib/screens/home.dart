import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery.dart';
// import 'package:shopping_list/widgets/groceries_item.dart';
import 'package:shopping_list/widgets/groceries_list.dart';
import 'package:shopping_list/widgets/new_item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<GroceryItem> _groceryItems = [];

  bool _isLoading = true;
  String? _error;
  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
        'flutter-prep-f9042-default-rtdb.firebaseio.com', 'shopping-list.json');
    try {
      final response = await http.get(url);
      if (response.statusCode >= 400) {
        setState(() {
          _error = 'Failed to fetch data. Please try again later.';
        });
      }
      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      final Map<String, dynamic> listData = json.decode(response.body);
      final List<GroceryItem> loadedItems = [];
      for (final item in listData.entries) {
        final category = categories.entries
            .firstWhere(
                (element) => element.value.name == item.value['category'])
            .value;
        loadedItems.add(
          GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category,
          ),
        );
      }

      setState(() {
        _groceryItems = loadedItems;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Something went wrong! Please try again.';
      });
      
    }
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (context) => const NewItem(),
      ),
    );

    if (newItem == null) return;

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void removeItem(GroceryItem grocery) {
    final url = Uri.https('flutter-prep-f9042-default-rtdb.firebaseio.com',
        'shopping-list/${grocery.id}.json');
    http.delete(url);
    setState(() {
      _groceryItems.remove(grocery);
    });
    // final groceryIndex = _groceryItems.indexOf(grocery);
    // ScaffoldMessenger.of(context).clearSnackBars();
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     duration: const Duration(seconds: 3),
    //     content: const Text('Grocery Deleted'),
    //     action: SnackBarAction(
    //       label: 'Undo',
    //       onPressed: () {
    //         setState(() {
    //           _groceryItems.insert(groceryIndex, grocery);
    //         });
    //       },
    //     ),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No Groceries found. Add some groceries!'),
    );

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_groceryItems.isNotEmpty) {
      content = GroceriesList(
        groceries: _groceryItems,
        removeItem: removeItem,
      );
    }

    if (_error != null) {
      content = Center(
        child: Text(_error!),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groceries'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: content,
    );
  }
}
