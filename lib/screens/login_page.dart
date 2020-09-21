import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();
  String phoneNumber, verificationId, smsCode;
  bool isMessageSent = false, isVerifyPressed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'HeathCare App',
          style:
              GoogleFonts.montserrat(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Stack(
        children: <Widget>[
          Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 25, right: 25),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        focusColor: Colors.black,
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                        labelText: 'Enter your phone number',
                        filled: true,
                        fillColor: Colors.grey[200],
                        prefix: Text('+91  '),
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Colors.teal,
                        )),
                    onChanged: (val) {
                      this.phoneNumber = val;
                    },
                  ),
                ),
                isMessageSent
                    ? Padding(
                        padding: EdgeInsets.only(left: 25, right: 25),
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          maxLength: 6,
                          decoration: InputDecoration(
                            hintText: 'Enter OTP',
                          ),
                          onChanged: (val) {
                            this.smsCode = val;
                          },
                        ),
                      )
                    : Container(),
                Padding(
                  padding: EdgeInsets.only(left: 25, right: 25),
                  child: RaisedButton(
                    child: Center(
                      child: Text(
                        isMessageSent ? 'Login' : 'Verify',
                        style: GoogleFonts.montserrat(fontSize: 20),
                      ),
                    ),
                    onPressed: () {
                      isMessageSent
                          ? AuthService().signInWithOTP(smsCode, verificationId)
                          : verifyPhone('+91' + phoneNumber);
                    },
                  ),
                )
              ],
            ),
          ),
          isVerifyPressed?Center(child: CircularProgressIndicator()):Container()
        ],
      ),
    );
  }

  Future<void> verifyPhone(phoneNo) async {
    setState(() {
      isVerifyPressed = true;
    });
    final PhoneVerificationCompleted verified = (AuthCredential authResult) async {
      AuthService().signIn(authResult);
    };
    final PhoneVerificationFailed verificationFailed =
        (AuthException authResult) {
      print(authResult.toString());
    };
    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      setState(() {
        isVerifyPressed = false;
      });
      this.verificationId = verId;
    };
    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
      setState(() {
        this.isMessageSent = true;
      });
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 30),
        verificationCompleted: verified,
        verificationFailed: verificationFailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }
}
