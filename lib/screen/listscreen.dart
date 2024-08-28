import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/model/groceryitem.dart';
import 'package:shopping_list/screen/add_items.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  List<GroceryItem> groceryList = [];
  var _isLoading = true;
  String? _errorMessage;
  @override
  void initState() {
    super.initState();
    _loadItem();
  }

  void _loadItem() async {
    try {
      final url = Uri.https('flutter-pro-7bab3-default-rtdb.firebaseio.com',
          'shopping-list.json');

      final response = await http.get(url);
      if (response.statusCode >= 400) {
        setState(() {
          _errorMessage = 'Failed to Fetch the Details. Please Try Again';
        });
      }
      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });

        return;
      }
      final Map<String, dynamic> datalist = json.decode(response.body);
      final List<GroceryItem> _loadList = [];
      for (final item in datalist.entries) {
        final category = categories.entries.firstWhere(
            (catel) => catel.value.category == item.value['category']);
        _loadList.add(GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category.value));
      }
      setState(() {
        groceryList = _loadList;
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Something went Wrong. Please Try Again';
      });
    }
  }

  void _addItems() async {
    final newItem = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const AddItems()));

    if (newItem == null) {
      return;
    }

    setState(() {
      groceryList.add(newItem);
      _isLoading = false;
    });
  }

  void _removeItems(GroceryItem item) async {
    final index = groceryList.indexOf(item);
    setState(() {
      groceryList.remove(item);
    });

    final url = Uri.https('flutter-pro-7bab3-default-rtdb.firebaseio.com',
        'shopping-list/${item.id}.json');

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      setState(() {
        groceryList.insert(index, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget userscreen =
        const Center(child: Text("OOPS NO ITEM PRESENT IN LIST....!"));

    if (_isLoading) {
      userscreen = const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (groceryList.isNotEmpty) {
      userscreen = ListView.builder(
        itemCount: groceryList.length,
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction) {
            _removeItems(groceryList[index]);
          },
          key: ValueKey(groceryList[index].id),
          child: ListTile(
            title: Text(
              groceryList[index].name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            leading: Container(
              width: 20,
              height: 20,
              color: groceryList[index].category.col,
            ),
            trailing: Text(
              groceryList[index].quantity.toString(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
      );
    }
    if (_errorMessage != null) {
      userscreen = Center(child: Text(_errorMessage!));
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your Groceries"),
          actions: [
            IconButton(onPressed: _addItems, icon: const Icon(Icons.add))
          ],
        ),
        body: userscreen);
  }
}
