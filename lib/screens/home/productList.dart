import 'package:catalogue/Services/productDatabase.dart';
import 'package:catalogue/screens/home/addProduct.dart';
import 'package:catalogue/screens/home/productTiles.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:catalogue/Models/product.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Product>>.value(
      initialData: [],
      value: DatabaseService().products,
      child: Scaffold(
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
          ],
        ),
        body: ProductTiles(),
      ),
    );
  }
}
