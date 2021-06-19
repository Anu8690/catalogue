import 'package:catalogue/Services/productDatabase.dart';
import 'package:catalogue/screens/home/addProduct.dart';
import 'package:catalogue/screens/home/cart.dart';
import 'package:catalogue/screens/home/productTiles.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:catalogue/Models/product.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _selectedDestination = 0;
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Product>>.value(
      initialData: [],
      value: DatabaseService().products,
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 40, 0, 5),
                child: Text(
                  'Settings',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
              ),
              ListTile(
                leading: Icon(Icons.add),
                title: Text('Add Product'),
                selected: _selectedDestination == 0,
                onTap: () {
                  selectDestination(0);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ProductUpload()));
                },
              ),
              ListTile(
                leading: Icon(Icons.search),
                title: Text('Search Product'),
                selected: _selectedDestination == 1,
                onTap: () => selectDestination(1),
              ),
              ListTile(
                leading: Icon(Icons.label),
                title: Text('Generate Bill'),
                selected: _selectedDestination == 2,
                onTap: () => selectDestination(2),
              ),
              Divider(
                height: 1,
                thickness: 1,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Account settings',
                ),
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Log Out'),
                selected: _selectedDestination == 3,
                onTap: () {
                  selectDestination(3);
                  _auth.signOut();
                },
              ),
            ],
          ),
        ),
        backgroundColor: Colors.green[50],
        appBar: AppBar(
          title: Text('Catalogue'),
          backgroundColor: Colors.green[600],
          actions: <Widget>[
            IconButton(onPressed: (){
              Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Cart()));
            }, icon: Icon(Icons.shopping_cart))
          ],
        ),
        body: ProductTiles(),
      ),
    );
  }

  void selectDestination(int index) {
    setState(() {
      _selectedDestination = index;
    });
  }
}
