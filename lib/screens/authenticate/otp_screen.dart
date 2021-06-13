import 'package:catalogue/screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OtpScreen extends StatefulWidget {
  final String mobile;
  OtpScreen(this.mobile);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String? _verificationId;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInWithPhoneNumber(String mobile) async {
    _auth.verifyPhoneNumber(
      phoneNumber: mobile,
      timeout: Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        setState(() {
          _verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-resolution timed out...
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text('Verify OTP'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: PinPut(
              fieldsCount: 6,
              textStyle: const TextStyle(fontSize: 25.0, color: Colors.white),
              eachFieldWidth: 40.0,
              eachFieldHeight: 55.0,
              focusNode: _pinPutFocusNode,
              controller: _pinPutController,
              submittedFieldDecoration: pinPutDecoration,
              selectedFieldDecoration: pinPutDecoration,
              followingFieldDecoration: pinPutDecoration,
              pinAnimationType: PinAnimationType.fade,
              onSubmit: (otp) async {
                try {
                  await _auth.signInWithCredential(PhoneAuthProvider.credential(
                      verificationId: _verificationId!, smsCode: otp));
                } catch (e) {
                  print(e);
                  print('Some Error');
                }
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Wrapper()),
                    (route) => false);
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    signInWithPhoneNumber(widget.mobile);
  }
}
