import 'package:catalogue/screens/home/productList.dart';
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
  String? _name;
  String? _price;
  File? _image;
  String? _imageUrl;
  final picker = ImagePicker();

  Future getImage() async {
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
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: Text('Catalogue'),
        backgroundColor: Colors.green[600],
        actions: <Widget>[
          IconButton(
              onPressed: () {
                print("button pressed");
                // switch bac to list
                /////////////////////////////////
              },
              icon: Icon(Icons.add)),
        ],
      ),
      body: Container(
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
              child: Column(
                children: <Widget>[
                  Text("Add Product"),
                  SizedBox(height: 20.0),
                  TextFormField(
                    // decoration: textInputDecoration,
                    validator: (val) =>
                        val == null ? 'Please enter a name' : null,
                    onChanged: (val) => setState(() => _name = val),
                  ),
                  TextFormField(
                    // decoration: textInputDecoration,
                    validator: (val) =>
                        val == null ? 'Please enter a name' : null,
                    onChanged: (val) => setState(() => _price = val),
                  ),
                  TextButton(
                      onPressed: () {
                        getImage();
                      },
                      child: Text('Add Image')),
                  TextButton(
                      onPressed: () async {
                        if (_image == null || _name == null) {
                          print("fields empty");
                        } else {
                          await uploadImagetoFirebase(context);
                          Product product = new Product(
                              name: _name!,
                              price: _price!,
                              imageUrl: _imageUrl!);
                          await product.uploadProduct();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductList()),
                              (route) => false);
                        }
                      },
                      child: Text('Upload'))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageUpload extends StatefulWidget {
  const ImageUpload({Key? key}) : super(key: key);

  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
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
      UploadTask task =
          FirebaseStorage.instance.ref('/uploads/$fileName').putFile(_image!);
      task.snapshotEvents.listen((TaskSnapshot snapshot) {
        print('Snapshot state: ${snapshot.state}'); // paused, running, complete
        print('Progress: ${snapshot.totalBytes / snapshot.bytesTransferred}');
      }, onError: (Object e) {
        print(e); // FirebaseException
      });

// Optional
      task.then((TaskSnapshot snapshot) {
        print('Upload complete!');
      }).catchError((Object e) {
        print(e); // FirebaseException
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: Text('Catalogue'),
        backgroundColor: Colors.green[600],
        actions: <Widget>[
          IconButton(
              onPressed: () {
                print("button pressed");
                getImage();
              },
              icon: Icon(Icons.add)),
        ],
      ),
      body: Container(
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
                child: _image != null
                    ? Image.file(
                        _image!,
                      )
                    : Text("No Image")),
            TextButton(
                onPressed: () async {
                  await uploadImagetoFirebase(context);
                },
                child: Text("Upload"))
          ],
        ),
      ),
    );
  }
}
