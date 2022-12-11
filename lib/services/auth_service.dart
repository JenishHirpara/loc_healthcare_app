import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/screens/dashboard.dart';
import 'package:healthcare/screens/login_page.dart';
import 'package:healthcare/screens/register_page.dart';
import 'package:healthcare/services/db_connections.dart';

class AuthService {
  getCurrentUserPhoneNumber() async {
    FirebaseUser currentUser;
    currentUser = await FirebaseAuth.instance.currentUser();
    return currentUser.phoneNumber;
  }

  //Handling Auth
  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return FutureBuilder(
            future: DBConnections().verifyUser(snapshot.data.phoneNumber),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == true)
                return DashboardPage();
              else {
                return RegisterPage();
              }
            },
          );
        } else {
          return LoginPage();
        }
      },
    );
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }

  signIn(AuthCredential authCredential) {
    FirebaseAuth.instance.signInWithCredential(authCredential);
  }

  signInWithOTP(smsCode, verId) {
    AuthCredential authCredential = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    signIn(authCredential);
  }
}
