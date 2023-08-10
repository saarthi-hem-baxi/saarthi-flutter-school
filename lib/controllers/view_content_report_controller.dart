import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:saarthi_pedagogy_studentapp/model/view_content_report/filter_subject_model.dart';
import 'package:saarthi_pedagogy_studentapp/model/view_content_report/view_content_report_detail_model.dart';
import 'package:saarthi_pedagogy_studentapp/model/view_content_report/view_content_report_model.dart';
import '../helpers/network.dart';
import '../helpers/urls.dart';

class ViewContentReportController extends GetxController {
  APIClient apiClient = APIClient();
  RxBool loading = false.obs;
  var viewContentReportModel = ViewContentReportModel().obs;
  var filterSubjectModel = FilterSubjectModel().obs;
  var viewContentReportDetailModel = ViewContentReportDetailModel().obs;

  Future getSubjects() async {
    String url = APIUrls().publisherUrl + 'content-report/student-subjects';
    try {
      dio.Response response = await apiClient.getData(url: url);
      if (response.statusCode == 200) {
        filterSubjectModel.value = FilterSubjectModel.fromJson(response.data);
      }
    } on dio.DioError catch (error) {
      if (error.response?.statusCode == 404) {
        Fluttertoast.showToast(msg: 'No Data Found');
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong try again');
      }
    }
  }

  getContentReportList(int sort, String resolutionStatus, String type, String subjectIDs, String currentPage, String search) async {
    loading.value = true;
    viewContentReportModel.value = ViewContentReportModel();
    String url = APIUrls().publisherUrl +
        'content-report/student-reports?page=$currentPage&limit=15&sort=$sort&currentStatus=$resolutionStatus&type=$type&subject=$subjectIDs&search=$search';
    try {
      dio.Response response = await apiClient.getData(url: url);
      if (response.statusCode == 200) {
        loading.value = false;
        viewContentReportModel.value = ViewContentReportModel.fromJson(response.data);
        return true;
      }
    } on dio.DioError catch (error) {
      if (error.response?.statusCode == 404) {
        Fluttertoast.showToast(msg: 'No Data Found');
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong try again');
      }
      loading.value = false;
      return false;
    }
  }

  Future getContentReportDetail(String id) async {
    // Content Type:
    // content - forTeacher,forStudent,description(Use webview), example(Use webview),word (Use webview)(for meaning),
    // media - video,image,pdf,document,audio,simulation,link,word(media)
    // question-question
    viewContentReportDetailModel.value = ViewContentReportDetailModel();
    loading.value = true;
    String url = APIUrls().publisherUrl + 'content-report/student-report/$id';
    try {
      dio.Response response = await apiClient.getData(url: url);
      if (response.statusCode == 200) {
        viewContentReportDetailModel.value = ViewContentReportDetailModel.fromJson(response.data);
        loading.value = false;
      }
    } on dio.DioError catch (error) {
      if (error.response?.statusCode == 404) {
        Fluttertoast.showToast(msg: 'No Data Found');
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong try again');
      }
      loading.value = false;
    }
  }
}
