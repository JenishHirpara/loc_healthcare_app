import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare/models/prescription.dart';
import 'package:healthcare/models/reports.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class AccountScreen extends StatefulWidget {
  final String mobileNumber;

  AccountScreen({this.mobileNumber});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String fileName;
  int numOfReports, numOfPrescriptions;
  bool isLoading;
  List<Report> reports = List<Report>();
  List<Prescription> prescriptions = List<Prescription>();
  Future<void> getPrescriptions() async {
    String url = 'https://health-care-auto.herokuapp.com/api/user/'+widget.mobileNumber;
    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    var output = jsonDecode(response.body);
    numOfReports = output['noOfReports'];
    numOfPrescriptions = output['noOfPrescriptions'];
    print(numOfReports);
    print(numOfPrescriptions);
    if(numOfReports == 0){
      setState(() {
        isLoading = false;
      });
      return;
    }
    for(int i = 0; i < numOfReports; i++){
      reports.add(Report(
        title: output['userReports'][i]['title'],
        url: output['userReports'][i]['file']
      ));
    }
    for(int i = 0; i < numOfPrescriptions; i++){
      prescriptions.add(Prescription(
          title: output['userPrescriptions'][i]['title'],
          url: output['userPrescriptions'][i]['details']
      ));
    }
    setState(() {
      isLoading = false;
    });
  }

  Future _uploadFile() async {
    var file = await FilePicker.getFile(
        allowedExtensions: ['pdf', 'docx'], type: FileType.custom);
    final StorageReference firebaseStorageReference = FirebaseStorage.instance
        .ref()
        .child('8850356911' + DateTime.now().toString());
    final StorageUploadTask task = firebaseStorageReference.putFile(file);
    return await (await task.onComplete).ref.getDownloadURL();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getPrescriptions();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return isLoading ? CircularProgressIndicator() : SingleChildScrollView(
      child: Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 50,
              left: 20.0,
              right: 10.0,
              bottom: 20,
            ),
            child: Container(
              child: Column(
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      'Want to upload reports? Tap here!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(fontSize: 20),
                    ),
                    onPressed: () async {
                      if (!_formKey.currentState.validate()) return;
                      _formKey.currentState.save();
                      String fileUrl = await _uploadFile();
                      print(fileUrl);
                      String url =
                          'https://health-care-auto.herokuapp.com/api/user/userReports';
                      var response = await http.post(url,
                          body: jsonEncode({
                            'contact': widget.mobileNumber,
                            'title': fileName,
                            'file': fileUrl
                          }),
                          headers: {"Content-Type": "application/json"});
                      print(response.body);
                    },
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: TextFormField(
                        validator: (String value) {
                          if (value.isEmpty)
                            return 'File name is a required field';
                          return null;
                        },
                        onSaved: (String value) {
                          fileName = value;
                        },
                        style: GoogleFonts.montserrat(
                            fontSize: 12, fontWeight: FontWeight.normal),
                        decoration:
                            InputDecoration(labelText: 'Enter File name'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Your reports : ',
                    style: GoogleFonts.montserrat(fontSize: 25),
                  ),
                  if (numOfReports == 0) Container(
                    child: Text(
                      'No reports added',
                      style: GoogleFonts.montserrat(
                        fontSize: 20
                      ),
                    ),
                  ) else ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, i) {
                      if(numOfReports == 0){
                        return Container();
                      }
                      return Container(
                        child: Column(
                          children: <Widget>[
                            Text(
                              '${i+1} '+reports[i].title,
                              style: GoogleFonts.montserrat(
                                fontSize: 15
                              ),
                            ),
                            FlatButton(
                              child: Text(
                                'View',
                                style: GoogleFonts.montserrat(
                                  fontSize: 12
                                ),
                              ),
                              onPressed: () async{
                                print(reports[i].url);
                                await launch(reports[i].url);
                              },
                            )
                          ],
                        ),
                      );
                    },
                    itemCount: numOfReports,
                  ),
                  Text(
                    'Your Prescriptions : ',
                    style: GoogleFonts.montserrat(fontSize: 25),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, i) {
                      if(numOfPrescriptions == 0){
                        return Container();
                      }
                      return Container(
                        child: Column(
                          children: <Widget>[
                            Text(
                              '${i+1} '+prescriptions[i].title,
                              style: GoogleFonts.montserrat(
                                  fontSize: 15
                              ),
                            ),
                            FlatButton(
                              child: Text(
                                'View',
                                style: GoogleFonts.montserrat(
                                    fontSize: 12
                                ),
                              ),
                              onPressed: () async{
                                print(prescriptions[i].url);
                                await launch(prescriptions[i].url);
                              },
                            )
                          ],
                        ),
                      );
                    },
                    itemCount: numOfPrescriptions,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
        ),
    );
  }
}
