import 'package:flutter/material.dart';
import 'package:healthcare/screens/dashboard.dart';
import 'package:healthcare/services/auth_service.dart';
void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HealthCare app',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
//      home: AuthService().handleAuth(),
    home: AuthService().handleAuth(),
    );
  }
}