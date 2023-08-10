import 'package:dio/dio.dart' as dio;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/network.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/urls.dart';

class LuckyDrawController extends GetxController {
  APIClient apiClient = APIClient();

  RxBool loading = false.obs;
  RxBool notcodeloading = false.obs;

  Future<bool> unlockLuckyDraw({required String luckydrawcode}) async {
    loading.value = true;
    var newstring = luckydrawcode.replaceAll("-", "");
    var body = {"drawCode": newstring};
    try {
      dio.Response response = await apiClient.putData(
        url: APIUrls().unlockluckydrawurl,
        data: body,
      );
      if (response.statusCode == 200) {
        loading.value = false;
        return true;
      } else {
        return false;
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Somthing went wrong');
      loading.value = false;
      return false;
    }
  }

  Future<bool> dontHaveCode() async {
    notcodeloading.value = true;
    try {
      dio.Response response = await apiClient.putData(url: APIUrls().baseUrl + "lucky-draw/dont-have-a-code", data: "");
      if (response.statusCode == 200) {
        notcodeloading.value = false;

        return true;
      } else {
        return false;
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Something went wrong');
      notcodeloading.value = false;
      return false;
    }
  }
}
