import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/network.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/urls.dart';
import 'package:saarthi_pedagogy_studentapp/model/tests_model/tests_model.dart';

class TestsController extends GetxController {
  APIClient apiClient = APIClient();
  RxBool loading = false.obs;

  var testsPendingModel = TestsModel().obs;
  var testsCompletedModel = TestsModel().obs;

  getPendingGeneralTests({required BuildContext context, required String page, required String limit}) async {
    loading.value = true;

    debugPrint('URL = ' + APIUrls().baseUrl + 'tests/pending/?page=$page&limit=$limit');

    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().baseUrl + 'tests/pending/?page=$page&limit=$limit',
      );

      debugPrint("response  => $response");

      if (response.statusCode == 200) {
        testsPendingModel.value = TestsModel.fromJson(response.toString());

        loading.value = false;
        return true;
      }
    } on dio.DioError catch (error) {
      debugPrint(error.response?.statusCode.toString());
      if (error.response?.statusCode == 404) {
        Fluttertoast.showToast(msg: 'No Tests Found');
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong try again');
      }
      loading.value = false;
      return false;
    }
  }

  getCompletedGeneralTests({required BuildContext context, required String page, required String limit}) async {
    loading.value = true;

    debugPrint('URL = ' + APIUrls().baseUrl + 'tests/completed/?page=$page&limit=$limit');

    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().baseUrl + 'tests/completed/?page=$page&limit=$limit',
      );

      debugPrint("response  => $response");

      if (response.statusCode == 200) {
        testsCompletedModel.value = TestsModel.fromJson(response.toString());
        loading.value = false;
        return true;
      }
    } on dio.DioError catch (error) {
      debugPrint(error.response?.statusCode.toString());
      if (error.response?.statusCode == 404) {
        Fluttertoast.showToast(msg: 'No Tests Found');
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong try again');
      }
      loading.value = false;
      return false;
    }
  }
}
