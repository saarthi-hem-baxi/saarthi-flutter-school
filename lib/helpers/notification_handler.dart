// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/homework_controller.dart';
import 'package:saarthi_pedagogy_studentapp/screen/home/bottom_footer_navigation.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/auth_controllers.dart';
import '../controllers/communication_controller.dart';
import '../model/auth/users.dart';
import '../model/chapters_model/datum.dart' as chapter_modal;
import '../model/subject_model/datum.dart' as subject_modal;
import '../screen/home/communication/class_communication.dart';
import '../screen/homework/homework_submission.dart';
import '../screen/homework/online_test_topic_concept.dart';
import '../screen/menu/view_content_report_detail.dart';
import '../screen/precap_concept_key_learning_screen.dart';
import '../screen/system_generated_test/autohw_concept_keylearning_list.dart';
import '../screen/system_generated_test/autohw_topic_keylearning_list.dart';
import 'const.dart';
import 'socket_helper.dart';

class NotificationHandler {
  static const PRECAP_AVAILABLE = "PRECAP_AVAILABLE";
  static const UPLOAD_CW_AVAILABLE = "UPLOAD_CW_AVAILABLE";
  static const UPLOAD_CW_ANSWER_AVAILABLE = "UPLOAD_CW_ANSWER_AVAILABLE";
  static const UPLOAD_CW_MARKS_AVAILABLE = "UPLOAD_CW_MARKS_AVAILABLE";
  static const EXISTING_CW_AVAILABLE = "EXISTING_CW_AVAILABLE";
  static const EXISTING_CW_ANSWER_AVAILABLE = "EXISTING_CW_ANSWER_AVAILABLE";
  static const EXISTING_CW_MARKS_AVAILABLE = "EXISTING_CW_MARKS_AVAILABLE";
  static const GENERATE_CW_AVAILABLE = "GENERATE_CW_AVAILABLE";
  static const GENERATE_CW_ANSWER_AVAILABLE = "GENERATE_CW_ANSWER_AVAILABLE";
  static const GENERATE_CW_MARKS_AVAILABLE = "GENERATE_CW_MARKS_AVAILABLE";
  static const ONLINE_TEST_CW_AVAILABLE = "ONLINE_TEST_CW_AVAILABLE";
  static const UPLOAD_HW_AVAILABLE = "UPLOAD_HW_AVAILABLE";
  static const UPLOAD_HW_ANSWER_AVAILABLE = "UPLOAD_HW_ANSWER_AVAILABLE";
  static const UPLOAD_HW_MARKS_AVAILABLE = "UPLOAD_HW_MARKS_AVAILABLE";
  static const GENERATE_HW_AVAILABLE = "GENERATE_HW_AVAILABLE";
  static const GENERATE_HW_ANSWER_AVAILABLE = "GENERATE_HW_ANSWER_AVAILABLE";
  static const GENERATE_HW_MARKS_AVAILABLE = "GENERATE_HW_MARKS_AVAILABLE";
  static const ONLINE_TEST_HW_AVAILABLE = "ONLINE_TEST_HW_AVAILABLE";
  static const AUTO_HW_AVAILABLE = "AUTO_HW_AVAILABLE";
  static const COMMUNICATION_NEW_MESSAGE = "COMMUNICATION_NEW_MESSAGE";
  static const CONTENT_REPORT = "CONTENT_REPORT";

  Future isCheckNotificationUpdateSession({required String studentId}) async {
    AuthController authController = Get.put(AuthController());
    final communicationController = Get.put(CommunicationController());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = prefs.getString(loginUserDataKey);
    authController.currentUser.value = User.fromJson(jsonDecode(userData ?? ""));

    if (authController.currentUser.value.id == studentId) {
      return true;
    } else {
      return authController
          .updateSession(
        studentUserId: studentId,
        isNeedToRegisterFCM: false,
      )
          .then((value) {
        communicationController.socketLeaveRoom(sectionId: authController.currentUser.value.section!.id ?? "");
        communicationController.socketJoinRoom();
        connectToAnalyticsSocketServer();
      });
    }
  }

  handlePushNotification(Map<String, dynamic> message) {
    String subjectId = message['subject'] ?? "";
    String chapterId = message['chapter'] ?? "";
    String studentId = message['student'] ?? "";

    final communicationController = Get.put(CommunicationController());
    final _homeworkController = Get.put(HomeworkController());

    switch (message['type']) {
      case NotificationHandler.PRECAP_AVAILABLE:
        isCheckNotificationUpdateSession(studentId: studentId).then((value) {
          Get.offAll(const BottomFooterNavigation());
          Get.to(
            PrecapConceptkeyLearningPage(
              subjectData: subject_modal.Datum(id: subjectId),
              chaptersData: chapter_modal.ChaptersDatum(id: chapterId),
              isFromTests: false,
              isFromNotification: true,
            ),
            preventDuplicates: false,
          );
        });
        break;
      case NotificationHandler.UPLOAD_HW_AVAILABLE:
      case NotificationHandler.UPLOAD_HW_ANSWER_AVAILABLE:
      case NotificationHandler.UPLOAD_HW_MARKS_AVAILABLE:
      case NotificationHandler.GENERATE_HW_AVAILABLE:
      case NotificationHandler.GENERATE_HW_ANSWER_AVAILABLE:
      case NotificationHandler.GENERATE_HW_MARKS_AVAILABLE:
        isCheckNotificationUpdateSession(studentId: studentId).then((value) {
          Get.offAll(const BottomFooterNavigation());
          Get.to(
            HomeWorkSubmissionPage(
              homeworkId: message['studentHomework'],
              subjectId: subjectId,
              chapterId: chapterId,
            ),
            preventDuplicates: false,
          );
        });
        break;
      case NotificationHandler.ONLINE_TEST_HW_AVAILABLE:
        isCheckNotificationUpdateSession(studentId: studentId).then((value) {
          Get.offAll(const BottomFooterNavigation());
          _homeworkController.isFromTests = true;
          Get.to(
            HWOnlineTestTopicsPage(
              title: message['homeworkName'],
              homeworkId: message['studentHomework'],
              subjectId: subjectId,
              chapterId: chapterId,
            ),
            preventDuplicates: false,
          );
        });
        break;
      case NotificationHandler.AUTO_HW_AVAILABLE:
        isCheckNotificationUpdateSession(studentId: studentId).then((value) {
          Get.offAll(const BottomFooterNavigation());
          _homeworkController.isFromNotification = true;
          if (message['autoHomeworkType'] == "topic" && message['conceptsCount'] == "0") {
            Get.to(
              AutoHWTopickeyLearningPage(
                homeworkId: message['studentAutoHomework'],
                subjectId: subjectId,
                chapterId: chapterId,
              ),
              preventDuplicates: false,
            );
          } else {
            Get.to(
              AutoHWConceptkeyLearningPage(
                homeworkId: message['studentAutoHomework'],
                subjectId: subjectId,
                chapterId: chapterId,
              ),
              preventDuplicates: false,
            );
          }
        });
        break;
      case NotificationHandler.COMMUNICATION_NEW_MESSAGE:
        isCheckNotificationUpdateSession(studentId: studentId).then((value) {
          Get.offAll(const BottomFooterNavigation());
          communicationController.socketJoinRoom();
          Get.to(
            const ClassCommunicationPage(title: 'Communication'),
            preventDuplicates: false,
          );
        });
        break;
      case NotificationHandler.CONTENT_REPORT:
        isCheckNotificationUpdateSession(studentId: studentId).then((value) {
          Get.offAll(const BottomFooterNavigation());
          Get.to(
            ViewContentReportDetail(id: message['contentReport'] ?? ""),
            preventDuplicates: false,
          );
        });
        break;
    }
  }
}
