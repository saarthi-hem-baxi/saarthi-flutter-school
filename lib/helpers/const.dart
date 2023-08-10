import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const imageAssets = 'lib/assets/images/';
const noImagePlaceholder = imageAssets + 'no-image.png';

const termsConditionRoute = "termscondition";
const worksheetRoute = "worksheet";
const homeRoute = "home";
const loginRoute = "loginpassword";
const forgotPasswordRoute = "forgotpassword";
const resetOTPRoute = "resetotp";
const createPasswordRoute = "createPassword";
const createPasswordSuccessRoute = "createPasswordSuccess";
const profileRoute = "profileRoute";
const learnRoute = "learn";
const testRoute = "test";
const menuRoute = "menu";
const chaptersRoute = "chapter";
const roadMapRoute = "roadMap";
const examRoute = "exam";
const precapConceptkeyLearningRoute = "precapconcept";
const resultRoute = "resultRoute";
const lessonPlanRoute = "lessonPlanRoute";
const lessonPlanWordViewRoute = "lessonPlanWordViewRoute";
const lessonPlanMediaDetailRoute = "lessonPlanMediaDetailRoute";
const precapAnswerRoute = "precapAnswerRoute";
const homeWorkRoute = "homeWorkRoute";
const submissionRoute = "submissionRoute";

const loginKey = "login";

const loginUserDataKey = "loginUserData";
const users = "users";
const userTokenKey = "token";
const usrIdKey = "_id";
const userEmailKey = "_email";
const appMode = "appMode";
const appVersion = "appVersion";
const isTourOnScreenEnabledkey = "isTourOnScreenEnabled";
const isTourOnLearnScreenkey = "isTourOnLearnScreen";
const isTourOnSubjectScreenkey = "isTourOnSubjectScreen";
const isTourOnChapterScreenkey = "isTourOnChapterScreen";
const isTourOnRoadMapLearnScreenkey = "isTourOnRoadMapLearnScreen";
const isTourOnRoadMapHomeworkScreenkey = "isTourOnRoadMapHomeworkScreen";

const int apiLimit = 15;
const int totalTimeSpent = 0;

const headerMargin = EdgeInsets.only(top: 20, left: 20);
const loginScreenBackgroundColor = Color.fromRGBO(250, 247, 235, 1);

const double iconSize32 = 32;
const double iconSize36 = 36;
const fieldBetweenMargin10 = 10;
const marginLeftRight16 = EdgeInsets.only(left: 16, right: 16);

enum ByHomeworkTypes { topic, concept, chapter }

enum HomeworkFileUploadTypes { image, pdf }

enum CWTestResposponseAction { next, completed, failed, noQuestion }

enum HWTestResposponseAction { next, completed, failed, noQuestion }

enum SelfExamResposponseAction { next, completed, failed, noQuestion }

enum LoginType {
  email,
  phone,
}

enum TestType { hw, cw, precap, onlinetest, systemgenerated }

String getDateTime(String date) {
  //
  // "date": "2022-04-27T04:18:35.464Z",
  DateTime tempDate = DateFormat("yyyy-MM-ddThh:mm:ss.Z").parse(date);

  // 12 Hour format:
  String date1 = DateFormat('dd MMM hh:mm').format(tempDate);
  String date2 = DateFormat('a').format(tempDate).toLowerCase();
  return date1 + ' ' + date2;
}
