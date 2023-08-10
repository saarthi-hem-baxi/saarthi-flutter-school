import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/network.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/urls.dart';

import '../model/worksheet_model/homework_model_new.dart';

class WorksheetController extends GetxController {
  APIClient apiClient = APIClient();
  RxBool loading = false.obs;

  var worksheetPendingModel = HomeworkListModal().obs;
  var worksheetCompletedModel = HomeworkListModal().obs;

  getPendingWorksheet({required BuildContext context, required String page, required String limit}) async {
    loading.value = true;

    debugPrint('URL = ' + APIUrls().baseUrl + 'worksheets/pending/?page=$page&limit=$limit');

    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().baseUrl + 'worksheets/pending/?page=$page&limit=$limit',
      );

      debugPrint("response  => $response");

      if (response.statusCode == 200) {
        // worksheetPendingModel.value = WorksheetModel.fromJson(response.toString());
        worksheetPendingModel.value = HomeworkListModal.fromJson(response.toString());

        loading.value = false;
        return true;
      }
    } on dio.DioError catch (error) {
      debugPrint(error.response?.statusCode.toString());
      if (error.response?.statusCode == 404) {
        Fluttertoast.showToast(msg: 'No Worksheet Found');
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong try again');
      }
      loading.value = false;
      return false;
    }
  }

  getCompletedWorksheet({required BuildContext context, required String page, required String limit}) async {
    loading.value = true;

    debugPrint('URL = ' + APIUrls().baseUrl + 'worksheets/completed/?page=$page&limit=$limit');

    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().baseUrl + 'worksheets/completed/?page=$page&limit=$limit',
      );

      debugPrint("response  => $response");

      if (response.statusCode == 200) {
        // worksheetCompletedModel.value = WorksheetModel.fromJson(response.toString());
        worksheetCompletedModel.value = HomeworkListModal.fromJson(response.toString());
        loading.value = false;
        return true;
      }
    } on dio.DioError catch (error) {
      loading.value = false;
      debugPrint(error.response?.statusCode.toString());
      if (error.response?.statusCode == 404) {
        Fluttertoast.showToast(msg: 'No Worksheet Found');
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong try again');
      }

      return false;
    }
  }
}
