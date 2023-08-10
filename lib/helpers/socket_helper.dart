import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/communication_controller.dart';
import 'package:saarthi_pedagogy_studentapp/globals.dart' as global;
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../model/auth/users.dart';

Future connectToCommunicationSocketServer() async {
  try {
    global.socket = io(
      APIUrls().communicationSocketUrl,
      OptionBuilder().setPath(APIUrls().communicationSocketPath).setTransports(['websocket']).disableAutoConnect().build(),
    );
    global.socket!.connect();
    debugPrint("Connected to Communication Socket Server");
  } catch (e) {
    debugPrint("Cannot connect to socket server $e");
  }
}

Future connectToAnalyticsSocketServer() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String tokenString = prefs.getString(userTokenKey) ?? "";

  /// this code is temp. commented
  /// please do not remove this code

  try {
    // Configure socket transports must be sepecified
    global.analyticsSocket?.close();
    global.analyticsSocket?.destroy();
    global.analyticsSocket = io(
      APIUrls().analyticsSocketUrl,
      OptionBuilder()
          .setQuery({
            "token": tokenString,
            "type": 'student',
          })
          .setAuth({
            "token": tokenString,
            "type": 'student',
          })
          .setPath(APIUrls().analyticsSocketPath)
          .setTransports(['websocket']) // for Flutter or Dart VM
          .enableForceNewConnection()
          .build(),
    );
    await sendStudentActiveStatus();
    debugPrint("Connected to Analytics Socket Server");
  } catch (e) {
    debugPrint("Cannot connect to socket server $e");
  }
}

Future sendStudentActiveStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userString = prefs.getString(loginUserDataKey) ?? "";
  String tokenString = prefs.getString(userTokenKey) ?? "";
  User user = User.fromJson(jsonDecode(userString));
  global.analyticsTimer?.cancel();

  sendAnalyticsData(eventName: "student-active-connection", data: {
    "student": user.id ?? "",
    "session": tokenString,
    "metadata": {
      "school": user.school?.id ?? "",
      "class": user.userClass?.id ?? "",
      "section": user.section?.id ?? "",
    }
  }); // for sending when first time

  global.analyticsTimer = Timer.periodic(Duration(seconds: int.parse(APIUrls().analyticsTimeout)), (timer) {
    sendAnalyticsData(eventName: "student-active-connection", data: {
      "student": user.id ?? "",
      "session": tokenString,
      "metadata": {
        "school": user.school?.id ?? "",
        "class": user.userClass?.id ?? "",
        "section": user.section?.id ?? "",
      }
    });
  });
}

void sendAnalyticsData({required String eventName, Map<String, dynamic>? data}) {
  if (global.analyticsSocket != null) {
    global.analyticsSocket!.emit(eventName, data);
  }
}

//call all socket server here for the app
void initSocketConnectionForApp() async {
  final communicationController = Get.put(CommunicationController());
  connectToCommunicationSocketServer().then((value) {
    communicationController.socketJoinRoom();
  });
  connectToAnalyticsSocketServer();
}

void disconnectAnalyticsSocket() {
  global.analyticsSocket?.disconnect();
  global.analyticsSocket?.close();
  global.analyticsTimer?.cancel();
}

// global.socket?.on('error', (_) => debugPrint('error'));
//       global.socket?.on('disconnect', (_) => debugPrint('disconnect'));
//       global.socket?.on('fromServer', (_) => debugPrint(_));
