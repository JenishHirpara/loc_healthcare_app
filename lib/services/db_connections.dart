import 'dart:convert';
import 'package:healthcare/models/users.dart';
import 'package:http/http.dart' as http;
class DBConnections{
  Future verifyUser(dynamic data) async{
    var url = 'https://health-care-auto.herokuapp.com/api/user/findUser';
    var response = await http.post(url,body: jsonEncode(<String, String>{
      "contact" : data
    }), headers: {
      "Content-Type" : "application/json"
    });
    print(response.body);
    var output = jsonDecode(response.body);
    return output["found"];
  }
  Future registerUser(User user)async{
    var url = 'https://health-care-auto.herokuapp.com/api/user/register';
    var response = await http.post(url, body: jsonEncode(<String, dynamic>{
      "name" : user.name,
      "email" : user.email,
      "age" : user.age,
      "contact" : user.mobileNumber,
      "emergencyContact" : [user.emergencyContact1, user.emergencyContact2, user.emergencyContact3]
    }), headers: {
      "Content-Type" : "application/json"
    });
    print(response.body);
  }
}