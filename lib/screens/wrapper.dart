import 'package:flutter/material.dart';
import 'package:catalogue/screens/home/home.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:catalogue/screens/authenticate/authenticate.dart';
// import 'package:catalogue/Models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Wrapper extends StatelessWidget {
  // final Future<FirebaseApp> __fbApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context); // check

    if(user == null){
      return Authenticate();
    }else{
      return ProductUpload();
    }
    // if (user == null) {
    //   return FutureBuilder(
    //     future: __fbApp,
    //     builder: (context, snapshot) {
    //       if (snapshot.hasError) {
    //         print('you have an error! ${snapshot.error.toString()}');
    //         return Text('Something went wrong!');
    //       } else if (snapshot.hasData) {
    //         return Authenticate();
    //       } else {
    //         return Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       }
    //     },
    //   );
    // } else {
    //   return FutureBuilder(
    //     future: __fbApp,
    //     builder: (context, snapshot) {
    //       if (snapshot.hasError) {
    //         print('you have an error! ${snapshot.error.toString()}');
    //         return Text('Something went wrong!');
    //       } else if (snapshot.hasData) {
    //         return ProductUpload();
    //       } else {
    //         return Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       }
    //     },
    //   );
    // }
  }
}
