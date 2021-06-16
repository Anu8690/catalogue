import 'package:catalogue/Services/productDatabase.dart';
import 'package:catalogue/screens/home/addProduct.dart';
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

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Product>>.value(
      initialData: [],
      value: DatabaseService().products,
      child: Scaffold(
        
        drawer: Drawer(
            child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Settings'),
            ),
          ],
        )),
        backgroundColor: Colors.green[50],
        appBar: AppBar(
          title: Text('Catalogue'),
          backgroundColor: Colors.green[600],
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  print("button pressed");
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ProductUpload()));
                },
                icon: Icon(Icons.add)),
            IconButton(
                onPressed: () {
                  _auth.signOut();
                },
                icon: Icon(Icons.logout))
          ],
        ),
        body: ProductTiles(),
      ),
    );
  }
}
