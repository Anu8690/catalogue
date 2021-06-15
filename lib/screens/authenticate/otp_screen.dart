import 'package:catalogue/screens/wrapper.dart';
import 'package:catalogue/shared/loading.dart';
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
  bool loading = false;

  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInWithPhoneNumber(String mobile) async {
    setState(() {
      loading = true;
    });
    await _auth.verifyPhoneNumber(
      phoneNumber: mobile,
      timeout: Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
        setState(() {
          loading = false;
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          loading = false;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-resolution timed out...
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading(message: 'Verifying your Mobile Number')
        : Scaffold(
            key: _scaffoldkey,
            appBar: AppBar(
              backgroundColor: Colors.green[600],
              title: Text('Verify OTP'),
            ),
            body: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: PinPut(
                    fieldsCount: 6,
                    textStyle:
                        const TextStyle(fontSize: 25.0, color: Colors.white),
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
                        setState(() {
                          loading = true;
                        });
                        await _auth.signInWithCredential(
                            PhoneAuthProvider.credential(
                                verificationId: _verificationId!,
                                smsCode: otp));
                        setState(() {
                          loading = false;
                        });
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
