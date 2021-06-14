import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:catalogue/screens/authenticate/otp_screen.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class Register extends StatefulWidget {
  final Function? toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _phoneController = TextEditingController();
  String? mobile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.all(32),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Log In",
              style: TextStyle(
                  color: Colors.lightBlue,
                  fontSize: 36,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 16,
            ),
            TextFormField(
              keyboardType:  TextInputType.number,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  hintText: "Phone Number"),
              controller: _phoneController,
              onChanged: (val) => setState(() => mobile = '+91$val'),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              width: double.infinity,
              child: TextButton(
                child: Text("Login"),
                onPressed: () async {
                  if (mobile != null) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            OtpScreen(mobile!)));
                  } else {
                    print("No mobile number given");
                  }
                },
              ),
            )
          ],
        ),
      ),
    ));
  }
}
