import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catalogue/Models/product.dart';

class CartList extends StatefulWidget {
  const CartList({Key? key}) : super(key: key);

  @override
  _CartListState createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  @override
  Widget build(BuildContext context) {
    final _cartList = Provider.of<List<Product>>(context);
    return ListView.builder(
      itemCount: _cartList.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: Image.network(_cartList[index].imageUrl),
            title: Text(_cartList[index].name),
            subtitle: Text(
                '${_cartList[index].productId}\nPrice : ${_cartList[index].price}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Delete item from database cart
              },
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}
