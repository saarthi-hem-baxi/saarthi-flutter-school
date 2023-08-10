import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/network.dart';
import 'package:saarthi_pedagogy_studentapp/model/auth/citylist.dart';
import 'package:saarthi_pedagogy_studentapp/model/auth/help_page.dart';
import 'package:saarthi_pedagogy_studentapp/model/auth/renew.dart';
import 'package:saarthi_pedagogy_studentapp/model/auth/reset_token.dart';
import 'package:saarthi_pedagogy_studentapp/model/auth/schoollist.dart';
import 'package:saarthi_pedagogy_studentapp/model/auth/teaching.dart';
import 'package:saarthi_pedagogy_studentapp/model/auth/total_time_spent.dart';
import 'package:saarthi_pedagogy_studentapp/model/auth/update_session.dart';
import 'package:saarthi_pedagogy_studentapp/screen/auth/registration/forgotpassword_screen_3.dart';
import 'package:saarthi_pedagogy_studentapp/screen/auth/registration/login_new_screen.dart';
import 'package:saarthi_pedagogy_studentapp/screen/auth/registration/registration_with_link.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/app_operation.dart';
import '../helpers/socket_helper.dart';
import '../helpers/urls.dart';
import '../model/auth/users.dart';
import '../screen/auth/license_expire_popup.dart';

class AuthController extends GetxController {
  APIClient apiClient = APIClient();
  RxBool loading = false.obs;
  RxBool schoolLoading = false.obs;
  RxBool teachingLoading = false.obs;
  RxBool duplicationLoading = false.obs;
  RxBool registerLoading = false.obs;
  RxBool loadingForgotPassword = false.obs;
  RxBool usersLoading = false.obs;
  Rx<User> currentUser = User().obs;
  RxList<User> allUsers = [User()].obs;
  RxBool renewLoading = false.obs;
  RxString sessionToken = "".obs;
  Rx<TotalTimeSpent> totalTimeSpent = TotalTimeSpent().obs;
  var userModal = UsersModal().obs;
  var schoolData = {}.obs;
  var teachingData = [TeachingModal()].obs;
  var teachingClassSectionData = [TeachingModal()].obs;
  var loginType = LoginType.phone;
  Rx<String> tempUserId = "".obs;
  RxBool cityandSchoolloading = false.obs;

  Rx<SchoolListModel> schoolListModel = SchoolListModel().obs;
  RxBool isOpenSubscriptionPopup = false.obs;
  RxBool helpPageLoading = false.obs;
  RxBool isClassSelected = false.obs;
  Rx<HelpPageContactModal> helpPageContactData = HelpPageContactModal().obs;
  RxString schoolId = "".obs;

  RxList<CityListModel> cityListdata = <CityListModel>[].obs;
  RxList<SchoolListModel> schoolListData = <SchoolListModel>[].obs;
  RxString appMaintanceNotes = "".obs;

  Future<bool> loginWithEmail({
    required String? email,
    required String? password,
  }) async {
    loading.value = true;
    try {
      dio.Response response = await apiClient.postData(
        url: APIUrls().authUrl + 'email-login',
        data: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        loading.value = false;
        tempUserId.value = '';
        userPostProcess(response: response);
        return true;
      } else {
        return false;
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Incorrect Credentials');
      loading.value = false;
      return false;
    }
  }

  //Regiter With OTP(Dynamic Link)
  Future<bool> loginWithEmailDynamicLink({
    required String? email,
    required String? password,
    required String? schoolId,
  }) async {
    loading.value = true;
    try {
      dio.Response response = await apiClient.postData(
        url: '${APIUrls().registraionUrl}school/$schoolId/student/with-email',
        data: jsonEncode({"email": email, "password": password}),
      );
      if (response.statusCode == 200) {
        tempUserId.value = '';
        userPostProcess(response: response);
        return true;
      } else {
        return false;
      }
    } on dio.DioError catch (e) {
      if (e.response?.statusCode == 409) {
        Fluttertoast.showToast(msg: "Student already registered");
      } else if (e.response?.statusCode == 404) {
        Fluttertoast.showToast(msg: "User not found");
      }
      return false;
    } catch (error) {
      Fluttertoast.showToast(msg: 'Incorrect Credentials');
      return false;
    } finally {
      loading.value = false;
    }
  }

  //Regiter With OTP(Dynamic Link)
  Future<bool> registerWithContact({
    required String? contact,
    required String? schoolId,
  }) async {
    loading.value = true;
    try {
      dio.Response response = await apiClient.postData(
        url: '${APIUrls().registraionUrl}school/$schoolId/student/send-otp',
        data: jsonEncode({"contact": contact}),
      );
      if (response.statusCode == 200) {
        tempUserId.value = '';
        if (response.data['data']['studentId'] != null) {
          tempUserId.value = response.data['data']['studentId'];
        }
        Fluttertoast.showToast(msg: "Otp sent to your mobile number");
        return true;
      } else {
        return false;
      }
    } on dio.DioError catch (e) {
      if (e.response?.statusCode == 409) {
        Fluttertoast.showToast(msg: "Student already registered");
      } else if (e.response?.statusCode == 404) {
        Fluttertoast.showToast(msg: "User not found");
      }
      return false;
    } catch (error) {
      Fluttertoast.showToast(msg: 'OTP Cannot be sent');
      return false;
    } finally {
      loading.value = false;
    }
  }

  //Send OTP
  loginWithContact({
    required String? contact,
  }) async {
    loading.value = true;
    try {
      dio.Response response = await apiClient.postData(
        url: APIUrls().authUrl + 'send-otp',
        data: jsonEncode({"contact": contact}),
      );
      if (response.statusCode == 200) {
        tempUserId.value = '';
        if (response.data['data']['studentId'] != null) {
          tempUserId.value = response.data['data']['studentId'];
        }
        Fluttertoast.showToast(msg: "Otp sent to your mobile number");
        return true;
      } else {
        return false;
      }
    } on dio.DioError catch (e) {
      if (e.response?.statusCode == 404) {
        Fluttertoast.showToast(msg: "User not found");
      }
      return false;
    } catch (error) {
      Fluttertoast.showToast(msg: 'OTP Cannot be sent');
      return false;
    } finally {
      loading.value = false;
    }
  }

  // Verify OTP for mobile login
  Future<bool> verifyLoginOTP({
    required String? contact,
    required String? otp,
  }) async {
    loading.value = true;
    try {
      dio.Response response = await apiClient.postData(
        url: APIUrls().authUrl + 'verify-login-otp',
        data: jsonEncode({"contact": contact, "otp": otp}),
      );
      if (response.statusCode == 200) {
        userPostProcess(response: response);
        return true;
      } else {
        return false;
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'OTP Cannot be verified');
      return false;
    } finally {
      loading.value = false;
    }
  }

  //Contact Resend OTP
  Future<bool> contactResendOTP({
    required String? contact,
  }) async {
    loading.value = true;
    try {
      dio.Response response = await apiClient.postData(
        url: APIUrls().authUrl + 'resend-otp',
        data: jsonEncode({"contact": contact}),
      );
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Otp sent to your mobile number");
        return true;
      } else {
        return false;
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Something went wrong');
      return false;
    } finally {
      loading.value = false;
    }
  }

  Future renewUser() async {
    renewLoading.value = true;
    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().authUrl + 'renew',
      );
      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        RenewUserModal renewUserModal = RenewUserModal.fromJson(response.data['data']);

        currentUser.value = renewUserModal.user ?? User();
        allUsers.value = renewUserModal.users ?? [User()];

        prefs.setString(loginUserDataKey, jsonEncode(renewUserModal.user));
        prefs.setString(users, jsonEncode(renewUserModal.users));
      }
    } catch (error) {
      debugPrint("Something went wrong");
    } finally {
      renewLoading.value = false;
    }
  }

  userPostProcess({required dio.Response response}) async {
    if (response.data['data'] != null) {
      if (response.data['data']['studentId'] != null) {
        tempUserId.value = response.data['data']['studentId'];
      } else {
        userModal.value = UsersModal.fromJson(response.data['data']);
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString(userTokenKey, response.data['data']['token']);
        sessionToken.value = response.data['data']['token'] ?? "";
        if (userModal.value.users?.length == 1) {
          currentUser.value = userModal.value.users?[0] ?? User();

          // await pref.setString(loginUserDataKey, jsonEncode(userModal.value.users?[0] ?? []));
          //Register FCMToken
          registerFCMToken();
        }
        // await pref.setString(users, jsonEncode(userModal.value.users));
        // pref.setBool(loginKey, true);
      }
    }
  }

  Future updateSession({required String studentUserId, bool isNeedToRegisterFCM = true}) async {
    loading.value = true;

    try {
      dio.Response response = await apiClient.putData(
        url: APIUrls().authUrl + 'update-session',
        data: {"studentUserId": studentUserId},
      );

      UpdateSessionModal updateSessionModal = UpdateSessionModal.fromJson(response.data['data']);
      SharedPreferences pref = await SharedPreferences.getInstance();

      pref.setString(loginUserDataKey, jsonEncode(updateSessionModal.user));
      pref.setString(userTokenKey, updateSessionModal.token ?? "");
      currentUser.value = updateSessionModal.user ?? User();

      //Register FCMToken
      if (isNeedToRegisterFCM) {
        registerFCMToken();
      }
      if (response.statusCode == 200) {}
    } catch (error) {
      Fluttertoast.showToast(msg: 'Something went wrong!, Try again');
    } finally {
      loading.value = false;
    }
  }

  Future getSessionUserData() async {
    usersLoading.value = true;
    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().authUrl + 'session-data',
      );
      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        RenewUserModal renewUserModal = RenewUserModal.fromJson(response.data['data']);

        currentUser.value = renewUserModal.user ?? User();
        allUsers.value = renewUserModal.users ?? [User()];

        prefs.setString(loginUserDataKey, jsonEncode(renewUserModal.user));
        prefs.setString(users, jsonEncode(renewUserModal.users));
      }
    } catch (error) {
      debugPrint("Cannot get users");
    } finally {
      usersLoading.value = false;
    }
  }

  // Forgot Password Method
  sendOTP({required BuildContext context, required String email}) async {
    loadingForgotPassword.value = true;
    try {
      dio.Response response = await apiClient.postData(
        url: APIUrls().authUrl + 'forgot-password/send-otp',
        data: jsonEncode({"email": email}),
      );

      if (response.statusCode == 200) {
        return true;
      }
    } on dio.DioError catch (e) {
      if (e.response?.statusCode == 404) {
        Fluttertoast.showToast(msg: "Email Not Found.");
      }
      return false;
    } catch (error) {
      Fluttertoast.showToast(msg: 'Email Not Found.');
    } finally {
      loadingForgotPassword.value = false;
    }
  }

  //Verify OTP
  verifyOTP({
    required BuildContext context,
    required String email,
    required String otp,
    required bool isFromDynamicLink,
    required String schoolId,
  }) async {
    loadingForgotPassword.value = true;
    try {
      dio.Response response = await apiClient.postData(
        url: APIUrls().authUrl + 'forgot-password/verify-otp',
        data: jsonEncode({"email": email, "otp": otp}),
      );
      if (response.statusCode == 200) {
        loadingForgotPassword.value = false;
        ResetToken resetToken = ResetToken.fromJson(response.data);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ForgotpasswordScreen3(
              email: email,
              resetToken: resetToken.data.resetToken,
              fromDynamicLink: isFromDynamicLink,
              schoolId: schoolId,
            ),
          ),
        );
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Incorrect OTP');
      loadingForgotPassword.value = false;
      return false;
    }
  }

  resetPassword({
    required BuildContext context,
    required String email,
    required String password,
    required String resetToken,
    required bool isFromDynamicLink,
  }) async {
    loadingForgotPassword.value = true;

    try {
      var response = await apiClient.postData(
        url: APIUrls().authUrl + 'forgot-password/reset-password',
        data: jsonEncode({"email": email, "password": password, "resetToken": resetToken}),
      );

      if (response.statusCode == 200) {
        loadingForgotPassword.value = false;
        if (isFromDynamicLink) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegistrationWithLinkScreen(isFromPasswordReset: true, schoolId: schoolId.value),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginNewScreen(isFromPasswordReset: true),
            ),
          );
        }
      }
    } catch (error) {
      if (error is dio.DioError) {
        if (error.response!.statusCode == 404) {
          Fluttertoast.showToast(msg: 'User Not Found');
        } else if (error.response!.statusCode == 401) {
          Fluttertoast.showToast(msg: 'Not Authorized');
        }
      } else {}
      loadingForgotPassword.value = false;
    }
  }

  logout() async {
    loading.value = true;
    disconnectAnalyticsSocket();
    try {
      var response = await apiClient.postData(
        url: APIUrls().authUrl + 'logout',
        data: {"fcmToken": await getFCMToken()},
      );

      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.remove(loginUserDataKey);
      pref.remove(userTokenKey);
      pref.setBool(loginKey, false);
      pref.setBool(isTourOnScreenEnabledkey, false);
      pref.setBool(isTourOnLearnScreenkey, false);
      pref.setBool(isTourOnSubjectScreenkey, false);
      pref.setBool(isTourOnChapterScreenkey, false);
      pref.setBool(isTourOnRoadMapLearnScreenkey, false);
      pref.setBool(isTourOnRoadMapHomeworkScreenkey, false);
      if (response.statusCode == 200) {
        loading.value = false;
      }
    } catch (error) {
      if (error is dio.DioError) {
        if (error.response?.statusCode == 404) {
          Fluttertoast.showToast(msg: 'User not found');
        } else if (error.response!.statusCode == 401) {
          Fluttertoast.showToast(msg: 'Not Authorized');
        }
      }
      loading.value = false;
    }
  }

  registerFCMToken() async {
    getFCMToken().then((fcmToken) async {
      await apiClient.postData(url: APIUrls().authUrl + 'register-token', data: {"fcmToken": fcmToken});
    }).catchError((error) {
      debugPrint("Cannot register FCMToken");
    });
  }

  Future<String?> getFCMToken() async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      debugPrint("Cannot get FCMToken");
      return '';
    }
  }

  Future getSchoolDetail({required String schoolId, bool isFromRegistrationLink = false}) async {
    schoolLoading.value = true;
    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().registraionUrl + 'school/$schoolId',
      );
      if (response.statusCode == 200) {
        schoolData.value = response.data['data'];
        schoolLoading.value = false;
      }
    } on dio.DioError catch (e) {
      if (e.response?.statusCode == 404) {
        // schoolDeactivateDialog(message: e.response?.data['error'] ?? 'School deactivated.');
        LicenceExpiredPopUp.showPopUp(
          isFromRegistrationLink: isFromRegistrationLink,
          schoolId: schoolId,
        );
      }
      return false;
    } catch (error) {
      Fluttertoast.showToast(msg: 'Cannot get school details ');
      return false;
    } finally {
      schoolLoading.value = false;
    }
  }

  getTeachingData({required String schoolId}) async {
    teachingLoading.value = true;
    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().registraionUrl + 'school/$schoolId/classes-with-sections',
      );
      if (response.statusCode == 200) {
        teachingData.value = teachingModalFromJson(response.data['data']);
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Cannot get teaching details');
    } finally {
      teachingLoading.value = false;
    }
  }

  getTeachingDataClassSection({required String schoolId}) async {
    teachingLoading.value = true;
    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().registraionUrl + 'school/$schoolId/classes-sections-subjects',
      );
      if (response.statusCode == 200) {
        teachingClassSectionData.value = teachingModalFromJson(response.data['data']);
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Cannot get teaching details');
    } finally {
      teachingLoading.value = false;
    }
  }

  Future<bool> checkStudentDuplication({required String schoolId, required Map data}) async {
    duplicationLoading.value = true;
    try {
      await apiClient.postData(url: APIUrls().registraionUrl + 'school/$schoolId/student/existing', data: data);
      return true;
    } on dio.DioError catch (e) {
      if (e.response?.statusCode == 409) {
        Fluttertoast.showToast(msg: "Student already registered");
      }
      return false;
    } catch (error) {
      Fluttertoast.showToast(msg: 'Cannot proceed. Try again.');
      return false;
    } finally {
      duplicationLoading.value = false;
    }
  }

  Future<bool> studentRegistration({required Map data}) async {
    registerLoading.value = true;
    try {
      dio.Response response = await apiClient.postData(url: APIUrls().registraionUrl + 'school/${data['schoolId']}/student', data: data);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on dio.DioError catch (e) {
      if (e.response?.statusCode == 409) {
        Fluttertoast.showToast(msg: "Student already registered");
      }
      return false;
    } catch (error) {
      Fluttertoast.showToast(msg: 'Cannot register account');
      return false;
    } finally {
      registerLoading.value = false;
    }
  }

  Future<bool> studentRegistrationNew({required Map data, required String schoolId}) async {
    registerLoading.value = true;
    try {
      dio.Response response = await apiClient.postData(url: APIUrls().registraionUrl + 'school/$schoolId/student', data: data);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on dio.DioError catch (e) {
      if (e.response?.statusCode == 404) {
        Fluttertoast.showToast(msg: e.response?.statusMessage ?? 'User not found');
      } else if (e.response?.statusCode == 409) {
        Fluttertoast.showToast(msg: 'Student already registered');
      }
      return false;
    } catch (error) {
      Fluttertoast.showToast(msg: 'Cannot register account');
      return false;
    } finally {
      registerLoading.value = false;
    }
  }

  Future<bool> studentAddSchool({required Map data, required String schoolId, bool? isFromLoginAddSchool}) async {
    teachingLoading.value = true;
    try {
      if (isFromLoginAddSchool == true) {
        if ((userModal.value.users ?? []).isNotEmpty) {
          await updateSession(studentUserId: (userModal.value.users ?? []).first.id ?? "");
        }
      } // while we add student from login sheet we need to update session first for temp.

      dio.Response response = await apiClient.postData(url: '${APIUrls().lmsSchoolUrl}$schoolId/student/add-school', data: data);
      if (response.statusCode == 200) {
        if (isFromLoginAddSchool == true) {
          Future.delayed(const Duration(milliseconds: 300), () {
            updateSession(studentUserId: response.data?['data']?['_id'] ?? "");
          }); // here we are add some deley for backend process for preapre session data
        }
        return true;
      }
      if (response.statusCode == 409) {
        Fluttertoast.showToast(msg: 'Student already registered');
        return false;
      }
      return false;
    } on dio.DioError catch (e) {
      if (e.response?.statusCode == 409) {
        Fluttertoast.showToast(msg: "Student already registered");
      }
      return false;
    } catch (error) {
      Fluttertoast.showToast(msg: 'Cannot register student');
      rethrow;
    } finally {
      teachingLoading.value = false;
    }
  }

  Future getAppInReviewStatus() async {
    bool isNeedToCall = await checkNeedToCallReviewApi();
    try {
      if (isNeedToCall) {
        dio.Response response = await apiClient.getData(url: APIUrls().baseUrl + 'app-review');
        if (response.statusCode == 200) {
          if (response.data['data'] != null) {
            if (response.data['data']['review'] == true) {
              await dotenv.load(fileName: '.env.review');
              setModeAndAppVersionToPref("review");
              return true;
            } else {
              setModeAndAppVersionToPref("production");
              return true;
            }
          }
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong!");
      return false;
    }
  }

  Future totalTime() async {
    try {
      dio.Response response = await apiClient.getData(url: APIUrls().dashboardUrl + 'total-time-spent');
      if (response.statusCode == 200) {
        if (response.data['data'] != null) {
          totalTimeSpent.value = TotalTimeSpent.fromJson(response.data);
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong!");
      return false;
    }
  }

  checkNeedToCallReviewApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? mode = prefs.getString(appMode);
    String? version = prefs.getString(appVersion);
    String? currentVersion = await getAppCurrentVersion();

    if (mode == null || mode == "" || version == "" || version == null) {
      return true;
    } else if (mode == "review" || currentVersion != version) {
      return true;
    } else {
      return false;
    }
  }

  Future getCities({required String cityName}) async {
    cityandSchoolloading.value = true;
    try {
      dio.Response response = await apiClient.getData(url: "${APIUrls().registraionUrl}cities?search=$cityName");
      if (response.statusCode == 200) {
        cityListdata.clear();
        cityListdata.value = cityListModelFromJson(response.data['data']);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong!");
      return false;
    } finally {
      cityandSchoolloading.value = false;
    }
  }

  Future getSchools({required String stateId, required String cityName, required String schoolName}) async {
    cityandSchoolloading.value = true;
    try {
      dio.Response response = await apiClient.getData(url: "${APIUrls().registraionUrl}/states/$stateId/cities/$cityName/schools?search=$schoolName");
      if (response.statusCode == 200) {
        schoolListData.clear();
        schoolListData.value = schoolListModelFromJson(response.data['data']);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong!");
      return false;
    } finally {
      cityandSchoolloading.value = false;
    }
  }

  setModeAndAppVersionToPref(String mode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currentVersion = await getAppCurrentVersion();
    prefs.setString(appMode, mode);
    prefs.setString(appVersion, currentVersion);
  }

  getHelpPageContactDetails() async {
    helpPageLoading.value = true;
    try {
      dio.Response response = await apiClient.getData(
        url: '${APIUrls().authUrl}support-person-details',
      );
      if (response.statusCode == 200) {
        helpPageContactData.value = HelpPageContactModal.fromJson(response.data['data']);
        helpPageLoading.value = false;
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Cannot get help page data');
      helpPageLoading.value = false;
    }
  }

  getSupportExecutiveDetails({
    required String schoolId,
  }) async {
    helpPageLoading.value = true;
    try {
      dio.Response response = await apiClient.getData(
        url: '${APIUrls().authUrl}support-person/detail?schoolId=$schoolId',
      );
      if (response.statusCode == 200) {
        helpPageContactData.value = HelpPageContactModal.fromJson(response.data['data']);
        helpPageLoading.value = false;
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Cannot get help page data');
      helpPageLoading.value = false;
    }
  }

  void getAppMaintanceNotes() async {
    try {
      dio.Response response = await apiClient.getData(
        url: '${APIUrls().authUrl}maintenance/detail',
      );
      if (response.statusCode == 200) {
        appMaintanceNotes.value = response.data?['data']?['notes'] ?? "";
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Cannot get data');
    }
  }
}
