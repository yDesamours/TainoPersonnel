import 'package:tainopersonnel/src/class/report.dart';
import 'package:tainopersonnel/src/class/state.dart';
import 'package:tainopersonnel/src/class/tenant.dart';
import 'package:tainopersonnel/src/class/user.dart';
import 'dart:convert' as conv;
import 'package:http/http.dart' as http;

class API {
  static http.Client client = http.Client();

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
    user.empId = result?['user']['Employee']['id'];

    tenant.name = result?['tenant']['name'];
    tenant.id = result?['tenant']['id'];

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

  static Future<dynamic> sendRequest(Request req, AppState state) async {
    Uri uri = Uri.parse(
        '${req.baseEndpoint}/${state.token}${req.queryParams.toString()}');
    final request = http.Request(req.method.name, uri);
    request.body = conv.json.encode(req.body);

    for (int i = 0; i < 2; i++) {
      var response = await client.send(request);
      Map<String, dynamic> body =
          conv.json.decode(await response.stream.bytesToString());

      String error = body['error'];
      if (error == 'api.tp.err.023') {
        var res = await login(state.username, state.password);
        state.user = res.$1;
      } else if (error != '') {
        throwPotentialError(body);
      } else {
        return body['result'];
      }
    }
  }

  static Future<void> sendDailyReport(AppState state) async {
    Request req = Request(
      method: HttpMethod.post,
      baseEndpoint: _APIEndpoint._sendDailyReport,
      body: state.report.toJSONAPI(),
    );

    state.report.id = await sendRequest(req, state) as int;
  }

  static Future<void> updateDailyReport(AppState state) async {
    Request req = Request(
      method: HttpMethod.put,
      baseEndpoint: _APIEndpoint._sendDailyReport,
      body: state.report.toJSONAPI(),
    );

    await sendRequest(req, state) as int;
  }

  static Future<List<dynamic>> getDailyReports(
    AppState state, [
    String? from,
  ]) async {
    Request req = Request(
      method: HttpMethod.get,
      baseEndpoint: _APIEndpoint._getDailyReports
          .replaceAll('%s', state.empid.toString()),
    );

    if (from != null) {
      req.queryParams = QueryParams({'datefrom': from});
    }

    var reports = await sendRequest(req, state);
    if (reports == null) {
      return [];
    }
    return Future.value(reports);
  }

  static Future<Report> getDailyReport(AppState state, int id) async {
    Request req = Request(
      method: HttpMethod.get,
      baseEndpoint: _APIEndpoint._getDailyReport
          .replaceFirst('%s', state.user!.id.toString()),
    );

    dynamic report = await sendRequest(req, state);
    return Future.value(Report.fromJSON(report));
  }
}

class _APIEndpoint {
  static const String _apiEndpoint = 'http://192.168.10.137:8082';
  //'https://app.sysgestock.com/gestionpersonnelapi';
  static const String _loginEndpoint = '$_apiEndpoint/login';
  static const String _getLogoEndpoint = '$_apiEndpoint/logo';
  static const String _getLogoutEndpoint = '$_apiEndpoint/logout';
  static const String _sendDailyReport = '$_apiEndpoint/dailyreports';
  static const String _getDailyReports =
      '$_apiEndpoint/dailyreports/employees/%s';
  static const String _getDailyReport =
      '$_apiEndpoint/dailyreports/%s/employees/%s';
}

class _APIError {
  static const errors = {
    "api.tp.err.046": "User does not exist or has been deactivated",
  };
}

class Request {
  Request({
    required this.method,
    required this.baseEndpoint,
    this.body,
    this.queryParams,
  });

  final String baseEndpoint;
  final HttpMethod method;
  Map? body;
  QueryParams? queryParams;
}

class QueryParams {
  QueryParams([this.params = const {}]);
  Map<String, String> params;

  void add(String key, String value) {
    params[key] = value;
  }

  @override
  String toString() {
    String queryString = '?';

    if (params.isEmpty) {
      return '';
    }

    for (String key in params.keys) {
      queryString += '&$key=${params[key]}';
    }

    return queryString.replaceFirst('&', '');
  }
}

enum HttpMethod { post, get, put, delete }
