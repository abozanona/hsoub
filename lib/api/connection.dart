import 'dart:convert';
import 'package:hsoub/classes/endpoints.dart';
import 'package:http/http.dart' as http;

class Connection {
  static Map<String, String> _getHeaders() {
    return {
      'authorization': '',
      'Content-Type': 'application/json; charset=UTF-8',
    };
  }

  static Future<dynamic> get(String url) async {
    try {
      var res = await http
          .get(
            Uri.parse(url),
            headers: _getHeaders(),
          )
          .timeout(Endpoints.timeout);
      var decodeRes = jsonDecode(res.body);
      if (decodeRes['result'] == null) {
        return null;
      } else {
        return decodeRes['result'];
      }
    } catch (ex) {
      return null;
    }
  }

  static Future<dynamic> post(String url, Map<dynamic, dynamic> body, {bool cacheRequest = false}) async {
    try {
      var res = await http
          .post(
            Uri.parse(url),
            headers: _getHeaders(),
            body: json.encode(body),
          )
          .timeout(Endpoints.timeout);
      var decodeRes = jsonDecode(res.body);
      if (decodeRes['result'] == null) {
        return null;
      }
      return decodeRes['result'];
    } catch (ex) {
      return null;
    }
  }

  static Future<dynamic> put(String url, Map<dynamic, dynamic> body) async {
    try {
      var res = await http
          .put(
            Uri.parse(url),
            headers: _getHeaders(),
            body: json.encode(body),
          )
          .timeout(Endpoints.timeout);
      var decodeRes = jsonDecode(res.body);
      if (decodeRes['result'] == null) {
        return null;
      }
      return decodeRes['result'];
    } catch (ex) {
      return null;
    }
  }
}
