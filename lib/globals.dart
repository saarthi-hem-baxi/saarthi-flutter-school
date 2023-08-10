library globals;

import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart';

Socket? socket;
Socket? analyticsSocket;
Timer? analyticsTimer;
bool inCommunicationPage = false;
bool? isTourOnScreenEnabled;
bool? isTourOnLearnscreen;
bool? isTourOnSubjectScreen;
bool? isTourOnChapterScreen;
bool? isTourOnRoadMapLearnScreen;
bool? isTourOnRoadMapHomeworkScreen;
bool? isVideoComplete;
bool? videoControl;
bool? isTourVideo = false;
bool showBackIcon=false;
