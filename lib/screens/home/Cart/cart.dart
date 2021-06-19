import 'package:catalogue/Services/productDatabase.dart';
import 'package:catalogue/screens/home/Cart/cartList.dart';
import 'package:flutter/material.dart';
import 'package:catalogue/screens/home/Main/productList.dart';
import 'package:provider/provider.dart';
import 'package:catalogue/Models/product.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Product>>.value(
      initialData: [],
      value: DatabaseService().cartProducts,
          child: Scaffold(
          appBar: AppBar(
            title: Text('Cart'),
            backgroundColor: Colors.green[600],
            actions: <Widget>[
              IconButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => ProductList()),
                        (route) => false);
                  },
                  icon: Icon(Icons.cancel_outlined)),
            ],
          ),
          body: CartList(),
        ),
    );
  }
}
