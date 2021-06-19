import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:catalogue/screens/home/Main/productList.dart';

FirebaseAuth auth = FirebaseAuth.instance;
String uid = auth.currentUser!.uid;

class BillGenerator extends StatefulWidget {
  const BillGenerator({Key? key}) : super(key: key);

  @override
  _BillGeneratorState createState() => _BillGeneratorState();
}

class _BillGeneratorState extends State<BillGenerator> {
  final String bill = "";
  CollectionReference cartCollRef = FirebaseFirestore.instance
      .collection('usercarts')
      .doc(uid)
      .collection('cart');
  Future<List<Map<String, dynamic>>> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await cartCollRef.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
    // print(allData);
    return allData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment Counter',
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('Bill'),
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
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          List<Widget> children;
          Map<String, int>? quantity;
          if (snapshot.hasData) {
            children = [];
            List<Map<String, dynamic>> data =
                snapshot.data as List<Map<String, dynamic>>;
            for (int i = 0; i < data.length; i++) {
              Widget temp = Card(
                child: ListTile(
                  leading: Image.network(data[i]['imageUrl']),
                  title: Text(data[i]['name']),
                  subtitle: Text(
                      '${data[i]['productId']}\nPrice : ${data[i]['price']}'),
                  trailing: SizedBox(
                    width: 50,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        quantity![data[i]['productId']] = value as int;
                      },
                    ),
                  ),
                  isThreeLine: true,
                ),
              );
              children.add(temp);
            }
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              )
            ];
          }
          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children,
              ),
            ),
          );
        },
      ),
    );
  }
}
