import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare/models/users.dart';
import 'package:healthcare/screens/dashboard.dart';
import 'package:healthcare/services/auth_service.dart';
import 'package:healthcare/services/db_connections.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _name;
  String _email;
  String _age;
  String _emergencyContact1;
  String _emergencyContact2;
  String _emergencyContact3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: Text(
            'Register',
          style: GoogleFonts.montserrat(
            fontSize: 30,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Center(
                  child: Text(
                      'Register your details',
                    style: GoogleFonts.montserrat(
                      fontSize: 20
                    ),
                  ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 30,right: 30),
                        child: TextFormField(
                          validator: (String value){
                            if(value.isEmpty)
                              return 'Name is a required field';
                            return null;
                          },
                          onSaved: (String value){
                            _name = value;
                          },
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.normal
                          ),
                          decoration: InputDecoration(
                            labelText: 'Enter Name'
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30,right: 30),
                        child: TextFormField(
                          validator: (String value){
                            if(value.isEmpty)
                              return 'Email is required';
                            if(!RegExp( r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?").hasMatch(value))
                              return 'Incorrect email';
                            return null;
                          },
                          onSaved: (String value){
                            _email = value;
                          },
                          style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.normal
                          ),
                          decoration: InputDecoration(
                              labelText: 'Enter email address'
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30,right: 30),
                        child: TextFormField(
                          validator: (String value){
                            if(value.isEmpty)
                              return 'Age is required';
                            return null;
                          },
                          onSaved: (String value){
                            _age = value;
                          },
                          keyboardType: TextInputType.number,
                          maxLength: 2,
                          style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.normal
                          ),
                          decoration: InputDecoration(
                              labelText: 'Enter age'
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Emergency contacts',
                          style: GoogleFonts.montserrat(
                              fontSize: 20
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30,right: 30),
                        child: TextFormField(
                          validator: (String value){
                            if(value.isEmpty)
                              return 'Emergency contact 1 is required';
                            if(value.length != 10)
                              return 'Mobile number should be of 10 digits';
                            return null;
                          },
                          onSaved: (String value){
                            _emergencyContact1 = value;
                          },
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.normal
                          ),
                          decoration: InputDecoration(
                              prefixText: '+91   ',
                              labelText: 'Emergency contact 1'
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30,right: 30),
                        child: TextFormField(
                          validator: (String value){
                            if(value.isEmpty)
                              return 'Emergency contact 2 is required';
                            if(value.length != 10)
                              return 'Mobile number should be of 10 digits';
                            return null;
                          },
                          onSaved: (String value){
                            _emergencyContact2 = value;
                          },
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.normal
                          ),
                          decoration: InputDecoration(
                              prefixText: '+91   ',
                              labelText: 'Emergency contact 2'
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30,right: 30),
                        child: TextFormField(
                          validator: (String value){
                            if(value.isEmpty)
                              return 'Emergency contact 3 is required';
                            if(value.length != 10)
                              return 'Mobile number should be of 10 digits';
                            return null;
                          },
                          onSaved: (String value){
                            _emergencyContact3 = value;
                          },
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.normal
                          ),
                          decoration: InputDecoration(
                              prefixText: '+91   ',
                              labelText: 'Emergency contact 3'
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: RaisedButton(
                          color: Colors.teal,
                          child: Text(
                              'Submit',
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                              color: Colors.white
                            ),
                          ),
                          onPressed: ()async{
                            if(!_formKey.currentState.validate())
                              return;
                            _formKey.currentState.save();
                            String phoneNo = await AuthService().getCurrentUserPhoneNumber();
                            User user = User(
                              name: _name,
                              email: _email,
                              age: _age,
                              emergencyContact1: _emergencyContact1,
                              emergencyContact2: _emergencyContact2,
                              emergencyContact3: _emergencyContact3,
                              mobileNumber: phoneNo
                            );
                            DBConnections().registerUser(user);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardPage()));
                          },
                        ),
                      )
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
