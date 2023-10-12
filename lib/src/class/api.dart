import 'package:tainopersonnel/src/class/tenant.dart';
import 'package:tainopersonnel/src/class/user.dart';
import 'dart:convert' as conv;
import 'package:http/http.dart' as http;

class API {
  static Future<(User, Tenant)> login(String username, String password) async {
    var user = User(username: username, password: password);
    var tenant = Tenant();
    var jsonData = {
      "username": user.username,
      "password": user.password,
    };

    final response = await http.post(
      Uri.parse(_APIEndpoint._loginEndpoint),
      body: conv.json.encode(jsonData),
    );

    var body = conv.json.decode(response.body);
    throwPotentialError(body);

    var result = body['result'];

    user.firstname = result['user']['firstname'];
    user.lastname = result?['user']['lastname'];
    user.id = result?['user']['id'];
    user.token = result?['token'];
    user.role = result?['user']['role']['name'];
    user.idRole = result?['user']['role']['id'];
    tenant.name = result?['tenant']['name'];
    user.id = result?['tenant']['id'];

    // tenant.logo = await getTenantLogo(user.token);

    return (user, tenant);
  }

  static void throwPotentialError(Map<String, dynamic> json) {
    if (json['error'] != "") {
      var error = _APIError.errors[json['error']];
      if (error == null) {
        throw 'Something went wrong';
      }
      throw error;
    }
  }

  static Future<String> getTenantLogo(String token) async {
    String uri = '${_APIEndpoint._getLogoEndpoint}/$token';

    final response = await http.get(Uri.parse(uri));
    Map<String, dynamic> body = conv.json.decode(response.body);

    if (body['error'] != "") {
      return '';
    }

    return body['result']?["value"];
  }

  static void logout(String token) {
    String uri = '${_APIEndpoint._getLogoutEndpoint}/$token';
    http.get(Uri.parse(uri));
  }
}

class _APIEndpoint {
  static const String _apiEndpoint = 'http://192.168.10.137:8082';
  static const String _loginEndpoint = '$_apiEndpoint/login';
  static const String _getLogoEndpoint = '$_apiEndpoint/logo';
  static const String _getLogoutEndpoint = '$_apiEndpoint/logout';
}

class _APIError {
  static const errors = {
    "api.tp.err.046": "User does not exist or has been deactivated",
  };
}
