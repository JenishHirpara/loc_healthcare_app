import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare/screens/book_appointment_page.dart';
import 'package:healthcare/screens/diary_page.dart';
import 'package:http/http.dart' as http;
class HomeScreen extends StatefulWidget {
  final String mobileNo;
  HomeScreen({this.mobileNo});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    const double _topSectionTopPadding = 50.0;
    const double _topSectionBottomPadding = 20.0;
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: _topSectionTopPadding,
              left: 20.0,
              right: 10.0,
              bottom: _topSectionBottomPadding,
            ),
            child: FlatButton(
              child: Text(
                'Want to book an appointment? Tap here!',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.normal
                ),
              ),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => AppointmentsPage()));
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: _topSectionTopPadding,
              left: 20.0,
              right: 10.0,
              bottom: _topSectionBottomPadding,
            ),
            child: FlatButton(
              child: Text(
                'Fill the diary by tapping here',
                style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.normal
                ),
              ),
              onPressed: () async{
                var res = await http.get('https://health-care-auto.herokuapp.com/api/diary/'+widget.mobileNo,headers: {"Content-Type": "application/json"});
                print(res.body);
                Navigator.push(context, MaterialPageRoute(builder: (context) => DiaryPage()));
              },
            ),

          )
        ],
      ),
    );
  }
}
