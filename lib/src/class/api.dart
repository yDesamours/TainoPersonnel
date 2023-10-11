import 'package:tainopersonnel/src/class/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class API {
  static Future<User> login(String username, String password) async {
    var user = User(username: username, password: password);
    var jsonData = {
      "username": user.username,
      "password": user.password,
    };

    final response = await http.post(
      Uri.parse(_APIEndpoint._loginEndpoint),
      body: json.encode(jsonData),
    );

    var body = json.decode(response.body);
    if (body['error'] != "") {
      var error = _APIError.errors[body['error']];
      if (error == null) {
        throw 'Something went wrong';
      }
      throw error;
    }

    var result = body['result'];

    user.firstname = result['user']['firstname'];
    user.lastname = result?['user']['lastname'];
    user.id = result?['user']['id'];
    user.role = result?['user']['role']['name'];
    user.roleId = result?['user']['role']['id'];
    user.tenant = result?['tenant']['name'];
    user.tenantId = result?['tenant']['id'];

    return user;
  }
}

class _APIEndpoint {
  static const String _apiEndpoint = 'http://192.168.10.137:8082';
  static const String _loginEndpoint = '$_apiEndpoint/login';
}

class _APIError {
  static const errors = {
    "api.tp.err.046": "User does not exist or has been deactivated",
  };
}
