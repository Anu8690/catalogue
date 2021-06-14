
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String name;
  final String price;
  final String imageUrl;
  Product({required this.name,required this.price,required this.imageUrl});

  Future uploadProduct() async {
    CollectionReference products =
        FirebaseFirestore.instance.collection('products');
    return products
        .add({
          'name': name,
          'imageUrl': imageUrl,
          'price':price,
        })
        .then((value) => print("user added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
