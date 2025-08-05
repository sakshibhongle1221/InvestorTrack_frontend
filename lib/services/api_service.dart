import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'http://localhost:3000';

  Future<Map<String,dynamic>> registerUser(String name,String email,String password) async {
    try{
      final response = await http.post(
        Uri.parse('$_baseUrl/signup'),
        headers: <String,String>{
          'Content-Type':'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String,String>{
          'name': name,
          'email':email,
          'password':password,
        }),
      );

      if(response.statusCode == 201){
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed To Register User.Status Code : ${response.statusCode}');
      }
    }
    catch(e){
      throw Exception('Failed To Connect To The Server. Error: $e');
    }
  }

  Future<String> loginUser(String email,String password) async{
    try{
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers:<String,String>{
          'Content-Type':'application/json;charset=UTF-8',
        },
        body: jsonEncode(<String,String>{
          'email':email,
          'password':password,
        }),
      );
      final data = jsonDecode(response.body);
      if(response.statusCode == 200){
        return data['token'];
      } else {
        throw Exception(data['message']??'Failed To Login');
      }
    }
    catch(e){
      throw Exception('Failed To Connect To Server. Error:$e');
    }
  } 
}
