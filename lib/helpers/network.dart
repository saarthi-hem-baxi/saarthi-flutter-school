import 'package:dio/dio.dart' as dio;
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'header.dart';

class APIClient {
  dio.Dio dioClient = dio.Dio();
  var token = '';

  getLocalToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString(userTokenKey);
    if (tokenString != null) {
      token = tokenString;
    }
  }

  _getHeaders({Map options = const {}}) async {
    final headers = await HeaderHandler().getHeaders();

    Map<String, String> allHeaders = {
      ...options,
      ...headers,
      "authorization": "Bearer $token",
    };
    return allHeaders;
  }

  Future getData({
    required String url,
  }) async {
    await getLocalToken();
    try {
      var response = await dioClient.get(
        url,
        options: dio.Options(
          headers: await _getHeaders(),
        ),
      );
      HeaderHandler().handleHeaders(response);
      return response;
    } on dio.DioError catch (error) {
      HeaderHandler().handleHeaders(error.response!);
      rethrow;
    } catch (error) {
      rethrow;
    }
  }

  Future postData({
    required String url,
    required dynamic data,
  }) async {
    await getLocalToken();
    try {
      dio.Response response = await dioClient.post(
        url,
        data: data,
        options: dio.Options(
          headers: await _getHeaders(),
          responseType: dio.ResponseType.json,
        ),
      );
      HeaderHandler().handleHeaders(response);
      return response;
    } on dio.DioError catch (error) {
      if (error.response != null) {
        HeaderHandler().handleHeaders(error.response!);
        rethrow;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future putData({
    required String url,
    required dynamic data,
  }) async {
    await getLocalToken();
    try {
      var response = await dioClient.put(
        url,
        data: data,
        options: dio.Options(
          headers: await _getHeaders(),
          responseType: dio.ResponseType.json,
        ),
      );
      HeaderHandler().handleHeaders(response);
      return response;
    } on dio.DioError catch (error) {
      HeaderHandler().handleHeaders(error.response!);
      rethrow;
    } catch (error) {
      rethrow;
    }
  }

  Future deleteData({
    required String url,
  }) async {
    await getLocalToken();
    try {
      var response = dioClient.delete(
        url,
        options: dio.Options(
          headers: await _getHeaders(),
          responseType: dio.ResponseType.json,
        ),
      );
      HeaderHandler().handleHeaders(response);
      return response;
    } on dio.DioError catch (error) {
      HeaderHandler().handleHeaders(error.response!);
      rethrow;
    } catch (error) {
      rethrow;
    }
  }
}
