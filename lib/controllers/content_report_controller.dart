import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import '../helpers/network.dart';
import '../helpers/urls.dart';

class ContentReportController extends GetxController {
  APIClient apiClient = APIClient();
  RxBool lpReportLoading = false.obs;
  RxBool qbReportLoading = false.obs;

  Future sendLPContentReport({required dio.FormData formData, required bool isLessonPlanReport}) async {
    lpReportLoading.value = true;
    try {
      String apiUrl = isLessonPlanReport ? "student-lessonplan-report" : "student-question-report";

      dio.Response response = await apiClient.postData(
        url: APIUrls().publisherUrl + 'content-report/$apiUrl',
        data: formData,
      );

      if (response.statusCode == 200) {
        lpReportLoading.value = false;

        Fluttertoast.showToast(
          msg: isLessonPlanReport ? "Your Lesson Plan's report sent successfully" : "Your Question's report sent successfully",
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Cannot sent report!, Try again.');
    }
  }
}
