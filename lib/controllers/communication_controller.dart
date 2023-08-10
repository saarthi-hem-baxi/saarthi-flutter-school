import 'package:dio/dio.dart' as dio;
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/auth_controllers.dart';
import 'package:saarthi_pedagogy_studentapp/globals.dart' as global;
import 'package:saarthi_pedagogy_studentapp/model/auth/users.dart';

import '../helpers/const.dart';
import '../helpers/network.dart';
import '../helpers/urls.dart';
import '../model/communication/get_message_list.dart';

class CommunicationController extends GetxController {
  APIClient apiClient = APIClient();
  RxBool sectionListLoading = false.obs;
  RxBool messageListLoading = false.obs;
  RxBool isFirstLoad = true.obs;
  RxBool isHasNewMessage = false.obs;
  RxInt unReadCount = 0.obs;

  var messageListData = MessageListModel().obs;
  AuthController authController = Get.put(AuthController());

  Future<bool> getMessageList({
    required int pageNumber,
  }) async {
    messageListLoading.value = true;
    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().communicationUrl + "student/messages?page=$pageNumber&limit=$apiLimit",
      );
      if (response.statusCode == 200) {
        messageListData.value = MessageListModel.fromJson(response.data);
        return true;
      }
      return false;
    } catch (error) {
      Fluttertoast.showToast(msg: 'Cannot get message');
      return false;
    } finally {
      messageListLoading.value = false;
      isFirstLoad.value = false;
    }
  }

  checkNewMessage() async {
    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().communicationUrl + "student/messages/new",
      );
      if (response.statusCode == 200) {
        isHasNewMessage.value = response.data['data']['newMessage'];
      }
    } catch (error) {
      return false;
    }
  }

  getUnreadMessageCount() async {
    try {
      dio.Response response = await apiClient.getData(
        url: APIUrls().communicationUrl + "student/messages/unread/count",
      );
      if (response.statusCode == 200) {
        unReadCount.value = response.data['data']['unreadMessageCount'];
      } else {
        unReadCount.value = response.data['data']['unreadMessageCount'];
      }
    } catch (error) {
      return false;
    }
  }

  void socketJoinRoom() async {
    try {
      // User user = await getCurrentUser();
      User user = authController.currentUser.value;
      global.socket!.emit('join-room', {user.section?.id});
      debugPrint("user join to room sucessfully");
    } catch (e) {
      debugPrint("Cannot join room $e");
    }
  }

  void socketLeaveRoom({required String? sectionId}) async {
    try {
      if (global.socket?.connected ?? false) {
        global.socket?.emit('leave-room', {sectionId});
      }
    } catch (e) {
      debugPrint("Cannot leave room $e");
    }
  }
}
