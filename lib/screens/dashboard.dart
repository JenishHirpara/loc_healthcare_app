import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare/screens/account_screeen.dart';
import 'package:healthcare/screens/qr_page.dart';
import 'package:healthcare/screens/home_screen.dart';
import 'package:healthcare/services/auth_service.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  void onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }
  String mobileNumber = '';
  @override
  void initState(){
    getMobileNumber();
    super.initState();
  }
  Future<void> getMobileNumber() async{
    String mobNum = await AuthService().getCurrentUserPhoneNumber();
    setState(() {
      mobileNumber = mobNum;
    });
  }
  @override
  Widget build(BuildContext context) {

    List<Widget> _widgetOptions = [
      HomeScreen(mobileNo: mobileNumber,),
      QRPage(mobileNumber: mobileNumber,),
      AccountScreen(mobileNumber: mobileNumber,)
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'HeathCare App',
          style: GoogleFonts.montserrat(
            fontSize: 30
          ),
        ),
        backgroundColor: Colors.teal,
        actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
              ),
              onPressed: (){
                AuthService().signOut();
              },
          )
        ],
        centerTitle: true,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(

        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            title: Text('Home')
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.launch
              ),
            title: Text('QR code')
          ),
          BottomNavigationBarItem(
              icon: Icon(
                  Icons.account_box,
              ),
            title: Text('Account')
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        onTap: onItemTapped,

      ),
    );
  }
}
//child: RaisedButton(
//child: Text('Sign Out'),
//onPressed: (){
//AuthService().signOut();
//},
//),