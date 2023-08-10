import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saarthi_pedagogy_studentapp/globals.dart' as global;
import 'package:saarthi_pedagogy_studentapp/model/communication/socket_msg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../controllers/auth_controllers.dart';
import '../../../controllers/communication_controller.dart';
import '../../../helpers/const.dart';
import '../../../helpers/utils.dart';
import '../../../model/auth/users.dart';
import '../../../model/communication/get_message_list.dart';
import '../../../theme/colors.dart';
import '../../../theme/style.dart';
import '../../../widgets/common/loading_spinner.dart';
import '../../../widgets/communication/dynamic_grid.dart';
import '../../../widgets/communication/text_chat_widget.dart';

class ClassCommunicationPage extends StatefulWidget {
  final String title;
  const ClassCommunicationPage({Key? key, required this.title}) : super(key: key);

  @override
  State<ClassCommunicationPage> createState() => _ClassCommunicationPageState();
}

// enum MediaTypes { audio, video, doc, pdf, image }

double progress = 0;

class _ClassCommunicationPageState extends State<ClassCommunicationPage> {
  // ignore: unused_field
  String _tempDir = '';

  final ScrollController listScrollController = ScrollController();

  List<File>? files = [];
  int currentPage = 1;

  bool _direction = false;

  final communicationController = Get.put(CommunicationController());
  List<MessageData> messages = [];
  List<MessageData> unreadmessages = [];

  dynamic socketData;

  final List<String> selectedAllFiles = [];

  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  int messageCounter = 0;

  User _currentUser = User();

  final AuthController _authController = Get.put(AuthController());

  @override
  void dispose() {
    super.dispose();
    messageCounter = 0;
    communicationController.unReadCount.value = 0;
    global.inCommunicationPage = false;
  }

  _getLocalStorage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var userData = pref.getString(loginUserDataKey) ?? "";
    _currentUser = User.fromJson(json.decode(userData));
    setState(() {});
    connectAndListen(_currentUser);
  }

  void connectAndListen(User currentUser) async {
    try {
      global.socket?.on('group-message', (data) {
        socketData = data;
        messageCounter++;

        SocketMsgData socketMsgData = SocketMsgData.fromJson(data);

        String fname = "";
        String lname = "";
        String name = '';
        if (data['name'] != null) {
          name = data['name'].toString();
        } else {
          List splitName = data['name'].toString().split(" ");
          fname = splitName[0] ?? "";
          lname = splitName[1] ?? "";
        }
        unreadmessages.add(
          MessageData(
            media: socketMsgData.media ?? [],
            message: socketMsgData.message,
            schoolUser: SchoolUser(
              firstName: fname,
              lastName: lname,
              name: name,
            ),
            date: data['date'] ?? DateTime.now().toLocal().toIso8601String(),
          ),
        );

        if (mounted) {
          setState(() {});
        }
      });
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    global.inCommunicationPage = true;
    _getLocalStorage();
    getTemporaryDirectory().then((d) => _tempDir = d.path);
    Future.delayed(const Duration(seconds: 0), () {
      listScrollController.jumpTo(listScrollController.position.maxScrollExtent);
    });

    communicationController
        .getMessageList(
      pageNumber: currentPage,
    )
        .then((v) {
      if (mounted) {
        setState(() {
          messages = [...messages, ...communicationController.messageListData.value.data ?? []];
        });
      }
    });

    Future.delayed(Duration.zero, () {
      _authController.renewUser();
    });
  }

  _refreshData() async {
    currentPage += 1;
    // print("max Page ${maxPage(communicationController.messageListData.value.total ?? 0, apiLimit)}");
    // print("current Page $currentPage");

    if (currentPage <= maxPage(communicationController.messageListData.value.total ?? 0, apiLimit)) {
      _refreshController.requestRefresh();
      communicationController.getMessageList(pageNumber: currentPage).then((v) {
        if (v) {
          setState(() {
            if (mounted) {
              messages = [...messages, ...communicationController.messageListData.value.data ?? []];

              // _refreshController.refreshCompleted();
              _refreshController.loadComplete();
            }
          });
        }
      });
    } else {
      // _refreshController.refreshCompleted();
      _refreshController.loadComplete();
    }
  }

  refreshProgress() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorExtraLightGreybg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  progress = 0;
                });
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 7.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.w),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.05),
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: sectionTitleColor,
                ),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: Text(
                widget.title,
                style: sectionTitleTextStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        elevation: 1,
        backgroundColor: colorScreenBg1Purple,
      ),
      body: SafeArea(
        bottom: false,
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (listScrollController.position.userScrollDirection == ScrollDirection.reverse) {
              setState(() {
                _direction = true;
              });
            } else if (listScrollController.offset <= listScrollController.position.minScrollExtent && !listScrollController.position.outOfRange) {
              setState(() {
                _direction = false;
              });
            }
            return true;
          },
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(imageAssets + 'communication_bg.png'),
              ),
            ),
            child: Stack(
              children: <Widget>[
                Obx(
                  () {
                    {
                      if (communicationController.messageListLoading.isTrue && communicationController.isFirstLoad.isTrue) {
                        return const Center(
                          child: LoadingSpinner(),
                        );
                      } else {
                        return messages.isEmpty && communicationController.messageListLoading.isFalse
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SvgPicture.asset(
                                    imageAssets + 'ic_no_msg.svg',
                                    width: getScreenWidth(context) * 0.5,
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Text(
                                    'No announcement yet !',
                                    textAlign: TextAlign.center,
                                    style: sectionTitleTextStyle.merge(TextStyle(fontSize: 22.sp)),
                                  )
                                ],
                              )
                            : SmartRefresher(
                                reverse: true,
                                enablePullDown: false,
                                enablePullUp: true,
                                controller: _refreshController,
                                footer: CustomFooter(
                                    builder: (context, mode) {
                                      Widget body;
                                      if (mode == LoadStatus.idle) {
                                        body = const SizedBox();
                                      } else if (mode == LoadStatus.loading) {
                                        body = const Center(
                                          child: LoadingSpinner(),
                                        );
                                      } else if (mode == LoadStatus.failed) {
                                        body = const SizedBox();
                                      } else if (mode == LoadStatus.canLoading) {
                                        body = const SizedBox();
                                      } else {
                                        body = const Text("No more Data....");
                                      }
                                      return SizedBox(
                                        child: Center(child: body),
                                      );
                                    },
                                    height: 10.h),
                                // onRefresh: _refreshData,
                                onLoading: _refreshData,
                                child: ListView.builder(
                                  itemCount: messages.length,
                                  shrinkWrap: true,
                                  controller: listScrollController,
                                  padding: EdgeInsets.only(top: 10.h, bottom: 70.h),
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    List<MessageData> messageData = messages;
                                    // List<MessageData> messageData = messages.reversed.toList();

                                    if (((messageData)[index].media ?? []).isNotEmpty && ((messageData)[index].message ?? '').isNotEmpty) {
                                      return getDynamicGrids(messageData, index);
                                    } else if (((messageData)[index].media ?? []).isEmpty && ((messageData)[index].message ?? '').isNotEmpty) {
                                      return TextMessageWidget(
                                        messageData: messageData,
                                        index: index,
                                      );
                                    } else if (((messageData)[index].media ?? []).isNotEmpty && ((messageData)[index].message ?? '').isEmpty) {
                                      return getDynamicGrids(messageData, index);
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                              );
                      }
                    }
                  },
                ),
                progress > 0
                    ? Container(
                        height: getScrenHeight(context),
                        color: Colors.transparent,
                        child: Center(
                          child: Container(
                            height: 150.h,
                            margin: EdgeInsets.only(left: 30.w, right: 30.w),
                            decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
                            child: AlertDialog(
                              title: Text(progress.toStringAsFixed(0) + "% Opening... Wait For a while",
                                  style: sectionTitleTextStyle.merge(TextStyle(fontSize: 16.sp))),
                            ),
                          ),
                        ),
                      )
                    : Container(),
                Visibility(
                  visible: _direction || messageCounter > 0,
                  child: Positioned(
                    bottom: 70.0,
                    right: 0.0,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          messageCounter = 0;
                        });
                        addSocketMessage(socketData);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: messageCounter > 0
                            ? Container(
                                height: 46.h,
                                width: 72.w,
                                decoration: BoxDecoration(
                                  color: colorSkyLight,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      messageCounter.toString(),
                                      style: textTitle22WhiteBoldStyle.merge(TextStyle(fontSize: 24.sp, color: sectionTitleDarkBgColor)),
                                    ),
                                    SvgPicture.asset(imageAssets + 'communication_new_msg.svg', width: 20.w, height: 20.h),
                                  ],
                                ),
                              )
                            : ClipOval(
                                child: Container(
                                  height: 46.h,
                                  width: 46.w,
                                  decoration: const BoxDecoration(shape: BoxShape.circle, color: colorSkyLight),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(imageAssets + 'communication_new_msg.svg', width: 20.w, height: 20.h),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getDynamicGrids(List<MessageData> messageData, int index) {
    // this condition for grid item docs or image or video etc 1,2 or 3 and more then 3

    // for 1 item
    // container width
    //width: ((getScreenWidth(context) * 0.75) / 3) * 1,
    //gridview      crossAxisCount: 1,
    // item count is dynmic
    // for 2 item
    // container width
    //width: ((getScreenWidth(context) * 0.75) / 3) * 2,
    //gridview      crossAxisCount: 2,
    // item count is dynmic
    // for 3 item or more
    // container width
    //width: ((getScreenWidth(context) * 0.75) / 3) * 3,
    //gridview      crossAxisCount: 3,
    // item count is dynmic
    if (messageData[index].media?.length == 1) {
      return DynamicGridItem(
        context: context,
        messageData: messageData,
        index: index,
        gridCount: () {
          String? name = messageData[index].schoolUser?.name;

          if (name != null) {
            int nameLength = name.length;

            if ((messageData[index].message ?? '').length > 30 || nameLength > 14) {
              return 3;
            } else if ((messageData[index].message ?? '').length > 15 || nameLength > 8) {
              return 2;
            } else {
              return 1;
            }
          } else {
            String? fname = messageData[index].schoolUser?.firstName ?? '';
            String? lname = messageData[index].schoolUser?.lastName ?? '';
            int nameLength = fname.length;
            int nameLength1 = lname.length;

            if ((messageData[index].message ?? '').length > 30 || (nameLength + nameLength1) > 14) {
              return 3;
            } else if ((messageData[index].message ?? '').length > 15 || (nameLength + nameLength1) > 8) {
              return 2;
            } else {
              return 1;
            }
          }
        }(),
        updateDownloadUI: updateDownloadUI,
      );
    } else if (messageData[index].media?.length == 2) {
      return DynamicGridItem(
        context: context,
        messageData: messageData,
        index: index,
        gridCount: 2,
        updateDownloadUI: updateDownloadUI,
      );
    } else {
      return DynamicGridItem(
        context: context,
        messageData: messageData,
        index: index,
        gridCount: 3,
        updateDownloadUI: updateDownloadUI,
      );
    }
  }

  updateDownloadUI(double prg) {
    if (prg >= 100) {
      setState(() {
        progress = 0;
      });
    } else {
      setState(() {
        progress = prg;
      });
    }
  }

  // This is what you're looking for!
  // ignore: unused_element
  void _scrollDown() {
    listScrollController.animateTo(
      listScrollController.position.minScrollExtent,
      duration: const Duration(microseconds: 1),
      curve: Curves.easeOut,
    );
    setState(() {
      _direction = false;
    });
  }

  Future<String?> generateThumbnail(String videoPath) async {
    final uint8list = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      imageFormat: ImageFormat.JPEG,
    );
    return uint8list;
  }

  Future<String?> getThumb(String videoPath) async {
    final Directory _dir = await getTemporaryDirectory();
    final bytes = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: _dir.path,
      imageFormat: ImageFormat.PNG,
    );

    return bytes;
  }

  void addSocketMessage(data) {
    _scrollDown();

    messages = [
      //add socket messages to current messages array
      ...unreadmessages.reversed.toList(),
      ...messages
    ];
    unreadmessages.clear();
    global.socket?.emit('read-message', {
      _currentUser.id,
    });
    setState(() {});
  }
}
