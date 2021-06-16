import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:catalogue/Models/product.dart';

class DatabaseService {
  CollectionReference productCollectionRef =
      FirebaseFirestore.instance.collection('products');

  List<Product> _productListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      return Product(
        imageUrl: data['imageUrl']??'',
        price: data['price']??'Contact Manufacturer',
        name: data['name']??'',
        productId: data['productId'],
      );
    }).toList();
  }

  Stream<List<Product>> get products {
    return productCollectionRef.snapshots().map(_productListFromSnapshot);
  }
}
