import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Product {
  final String name;
  final String price;
  final String imageUrl;
  final String productId;
  late int count;
  Product(
      {required this.name,
      required this.price,
      required this.imageUrl,
      required this.productId});

  Future uploadProduct() async {
    String prodId;
    Reference countRef =
        FirebaseStorage.instance.ref('assets/images/count.txt');
    Uint8List? downloadedData = await countRef.getData();
    prodId = utf8.decode(downloadedData!);
    count = int.parse(prodId.substring(3));
    count += 1;
    prodId = 'AB-$count';
    UploadTask countTask = FirebaseStorage.instance
        .ref('assets/images/count.txt')
        .putString(productId);
    CollectionReference products =
        FirebaseFirestore.instance.collection('products');
    return products
        .add({
          'name': name,
          'imageUrl': imageUrl,
          'price': price,
          'productId': prodId,
        })
        .then((value) => print("user added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
