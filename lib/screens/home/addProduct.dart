import 'package:catalogue/screens/home/productList.dart';
import 'package:catalogue/shared/loading.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:catalogue/Models/product.dart';

class ProductUpload extends StatefulWidget {
  const ProductUpload({Key? key}) : super(key: key);

  @override
  _ProductUploadState createState() => _ProductUploadState();
}

class _ProductUploadState extends State<ProductUpload> {
  bool loading = false;
  String? _name;
  String? _price;
  File? _image;
  String? _imageUrl;
  String imgErr = '';
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  Future getImage() async {
    setState(() {
      imgErr = '';
    });
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future? uploadImagetoFirebase(BuildContext context) async {
    if (_image == null) {
      print("No image selected");
    } else {
      String fileName = basename(_image!.path);
      UploadTask task = FirebaseStorage.instance
          .ref('assets/images/$fileName')
          .putFile(_image!);

      task.snapshotEvents.listen((TaskSnapshot snapshot) {
        print('Snapshot state: ${snapshot.state}'); // paused, running, complete
        print('Progress: ${snapshot.totalBytes / snapshot.bytesTransferred}');
      }, onError: (Object e) {
        setState(() {
          loading = false;
        });
        print(e); // FirebaseException
      });

// Optional
      task.then((TaskSnapshot snapshot) {
        print('Upload complete!');
      }).catchError((Object e) {
        print(e); // FirebaseException
      });
      String? imageUrl = await (await task).ref.getDownloadURL();
      setState(() {
        _imageUrl = imageUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading(message: 'Uploading Product...')
        : Scaffold(
            backgroundColor: Colors.green[50],
            appBar: AppBar(
              title: Text('Add Product'),
              backgroundColor: Colors.green[600],
              actions: <Widget>[
                IconButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductList()),
                          (route) => false);
                    },
                    icon: Icon(Icons.cancel_outlined)),
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(15),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                        border: Border.all(color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(2, 2),
                            spreadRadius: 2,
                            blurRadius: 1,
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Text("Add Product"),
                            SizedBox(height: 20.0),
                            TextFormField(
                              // decoration: textInputDecoration,
                              validator: (val) =>
                                  val == '' ? 'Please enter a name' : null,
                              onChanged: (val) => setState(() => _name = val),
                            ),
                            TextFormField(
                              // decoration: textInputDecoration,
                              validator: (val) =>
                                  val == '' ? 'Please enter Price' : null,
                              onChanged: (val) => setState(() => _price = val),
                            ),
                            Container(
                                margin: EdgeInsets.all(15),
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  border: Border.all(color: Colors.white),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(2, 2),
                                      spreadRadius: 2,
                                      blurRadius: 1,
                                    ),
                                  ],
                                ),
                                child: _image != null
                                    ? Image.file(
                                        _image!,
                                      )
                                    : Text("No Image")),
                            Text(imgErr,
                                style: TextStyle(color: Colors.red[300])),
                            TextButton(
                                onPressed: () {
                                  getImage();
                                },
                                child: Text('Add Image')),
                            TextButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate() &&
                                      _image != null) {
                                    setState(() {
                                      loading = true;
                                    });
                                    await uploadImagetoFirebase(context);
                                    Product product = new Product(
                                        name: _name!,
                                        price: _price!,
                                        imageUrl: _imageUrl!,
                                        productId: '',);
                                    await product.uploadProduct();
                                    setState(() {
                                      loading = false;
                                    });
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProductList()),
                                        (route) => false);
                                  } else if (_image == null) {
                                    setState(() {
                                      imgErr = 'No Image Selected';
                                    });
                                  }
                                },
                                child: Text('Upload'))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
