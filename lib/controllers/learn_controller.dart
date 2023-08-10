import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/auth_controllers.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/network.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/urls.dart';
import 'package:saarthi_pedagogy_studentapp/model/auth/IntroVideo/intro_videolist.dart';
import 'package:saarthi_pedagogy_studentapp/model/auth/IntroVideo/introvideo.dart';
import 'package:saarthi_pedagogy_studentapp/model/chapters_model/chapters_model.dart';
import 'package:saarthi_pedagogy_studentapp/model/subject_model/datum.dart';
import 'package:saarthi_pedagogy_studentapp/model/subject_model/subject_model.dart';
import 'package:saarthi_pedagogy_studentapp/screen/auth/registration/login_new_screen.dart';

class LearnController extends GetxController {
  APIClient apiClient = APIClient();
  RxBool loading = false.obs;
  RxBool pendingLoading = false.obs;
  var subjectModel = SubjectModel().obs;
  var introVideo = IntroVideo().obs;
  var introVideoList = IntroVideoList().obs;
  var chaptersData = ChaptersModel().obs;
  var pendingCounts = {}.obs;
  RxString studentUserId = ''.obs;
  RxString tourvideoKey = ''.obs;
  RxString tourCode = ''.obs;
  AuthController authController = Get.put(AuthController());

  getSubjects(context) async {
    loading.value = true;
    subjectModel.value = SubjectModel();
    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().baseUrl + 'subject/learn',
      );
      if (response.statusCode == 200) {
        subjectModel.value = SubjectModel.fromJson(response.toString());
      }
      return "";
    } on dio.DioError catch (error) {
      if (error.response?.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Session Expired! Login Again');
        authController.logout();
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginNewScreen()), (route) => false);
      }
      return "";
    } catch (error) {
      Fluttertoast.showToast(msg: 'Something went wrong, Try Again');
    } finally {
      loading.value = false;
    }
  }

  getChapters({required BuildContext context, required Datum subjectData}) async {
    loading.value = true;
    chaptersData.value.data?.clear();
    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().baseUrl + 'subject/${subjectData.id}/chapters/learn',
      );
      if (response.statusCode == 200) {
        chaptersData.value = ChaptersModel.fromJson(response.toString());
        loading.value = false;
      } else {
        loading.value = false;
      }
    } on dio.DioError catch (error) {
      if (error.response?.statusCode == 404) {
        Fluttertoast.showToast(msg: 'No Chapters Found');
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong try again');
      }
    }
  }

  getpendingCounts({
    required String subjectId,
  }) async {
    pendingLoading.value = true;
    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().baseUrl + "subject/$subjectId/pending/counts",
      );
      if (response.statusCode == 200) {
        pendingCounts.value = response.data['data'];
        pendingLoading.value = false;
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Cannot get pending counts');
      pendingLoading.value = false;
    }
  }

  updateProductTourVideoStatus({required String studentUserId, required String tourCode, bool isView = false}) async {
    loading.value = true;

    try {
      dio.Response response = await apiClient.putData(
        url: APIUrls().analyticsUrl + '$studentUserId/product-tour-videos',
        data: {
          "tourCode": tourCode,
          "isView": isView,
        },
      );
      if (response.statusCode == 200) {}
    } catch (error) {
      Fluttertoast.showToast(msg: 'Something went wrong!, Try again');
    } finally {
      loading.value = false;
    }
  }

  getIntroVideos(context, String tourcode) async {
    loading.value = true;
    introVideo.value = IntroVideo();
    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().productTourVideos + 'tourCode=' + tourcode,
      );
      if (response.statusCode == 200) {
        introVideo.value = IntroVideo.fromJson(response.data);
      }
      return "";
    } on dio.DioError catch (error) {
      if (error.response?.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Session Expired! Login Again');
        authController.logout();
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginNewScreen()), (route) => false);
      }
      return "";
    } catch (error) {
      Fluttertoast.showToast(msg: 'Something went wrong, Try Again');
    } finally {
      loading.value = false;
    }
  }

  getIntroVideosList(context) async {
    loading.value = true;
    introVideoList.value = IntroVideoList();
    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().baseUrl + 'product-tour-videos',
      );
      if (response.statusCode == 200) {
        introVideoList.value = IntroVideoList.fromJson(response.data);
      }
      return "";
    } on dio.DioError catch (error) {
      if (error.response?.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Session Expired! Login Again');
        authController.logout();
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginNewScreen()), (route) => false);
      }
      return "";
    } catch (error) {
      Fluttertoast.showToast(msg: 'Something went wrong, Try Again');
    } finally {
      loading.value = false;
    }
  }
}
