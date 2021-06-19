import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;
String uid = auth.currentUser!.uid;

class Product {
  final String name;
  final String price;
  final String imageUrl;
  String productId;
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
    productId = prodId;
    UploadTask countTask = FirebaseStorage.instance
        .ref('assets/images/count.txt')
        .putString(prodId);
    await countTask;
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

  Future addToCart() async {
    CollectionReference cartCollectionRef = FirebaseFirestore.instance
        .collection('usercarts')
        .doc(uid)
        .collection('cart');

    // hash the document key below //
    return cartCollectionRef
        .doc(productId)
        .set({
          'name': name,
          'imageUrl': imageUrl,
          'price': price,
          'productId': productId,
        })
        .then((value) => print("user added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
