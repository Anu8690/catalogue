import 'package:flutter/material.dart';
import 'package:catalogue/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:catalogue/screens/authenticate/authenticate.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    if(user == null){
      return Authenticate();
    }else{
      return ProductUpload();
    }
  }
}
