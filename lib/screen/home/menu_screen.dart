// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/auth_controllers.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/learn_controller.dart';
import 'package:saarthi_pedagogy_studentapp/globals.dart' as global;
import 'package:saarthi_pedagogy_studentapp/helpers/app_operation.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/model/auth/users.dart';
import 'package:saarthi_pedagogy_studentapp/screen/auth/registration/login_new_screen.dart';
import 'package:saarthi_pedagogy_studentapp/screen/auth/registration/registration_screen_2.dart';
import 'package:saarthi_pedagogy_studentapp/screen/home/communication/class_communication.dart';
import 'package:saarthi_pedagogy_studentapp/screen/home/profile_screen.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/loading_spinner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/communication_controller.dart';
import '../../helpers/socket_helper.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';
import '../menu/view_content_report.dart';
import '../productvideotour/productvideolist_screen.dart';

class MenuScreenPage extends StatefulWidget {
  const MenuScreenPage({Key? key}) : super(key: key);

  @override
  State<MenuScreenPage> createState() => _MenuScreenPageState();
}

class _MenuScreenPageState extends State<MenuScreenPage> {
  final authController = Get.put(AuthController());
  final dashBoardController = Get.put(LearnController());
  String appVersion = '';

  List<User> _allUser = [User()];
  bool _isLoading = true;
  bool _isRefresh = false;

  int messageCounter = 0;

  final communicationController = Get.put(CommunicationController());

  final AuthController _authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    loadData();
    listenSocketMsg();
    Future.delayed(Duration.zero, () {
      _authController.renewUser();
    });
  }

  loadData() async {
    appVersion = await getAppCurrentVersion();
    communicationController.getUnreadMessageCount().then((v) {
      setState(() {
        messageCounter = communicationController.unReadCount.value;
      });
    });
    authController.getSessionUserData().then((v) {
      _allUser = authController.allUsers;
    });
    _getLocalStorage();

    setState(() {});
  }

  _getLocalStorage() async {
    setState(() {
      _allUser = authController.allUsers;
    });

    _isLoading = false;
    _isRefresh = false;
    setState(() {});
    communicationController.getUnreadMessageCount().then((v) {
      if (mounted) {
        setState(() {
          messageCounter = communicationController.unReadCount.value;
        });
      }
    });
  }

  void listenSocketMsg() async {
    try {
      global.socket?.on('group-message', (data) {
        messageCounter++;
        if (mounted) {
          setState(() {});
        }
      });
      // ignore: empty_catches
    } catch (e) {}
  }

  _openLink(String url) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) throw 'Could not launch $url';
  }

  _onUserSelect({required User prevUser, required User user}) {
    _isRefresh = true;
    authController.currentUser.value = user;
    disconnectAnalyticsSocket();
    Navigator.pop(context);
    _getLocalStorage();
    authController
        .updateSession(
      studentUserId: user.id ?? "",
      isNeedToRegisterFCM: false,
    )
        .then((v) {
      communicationController.socketLeaveRoom(sectionId: prevUser.section!.id ?? "");
      communicationController.socketJoinRoom();
      messageCounter = 0;
      communicationController.getUnreadMessageCount().then((v) {
        if (mounted) {
          setState(() {
            messageCounter = communicationController.unReadCount.value;
          });
        }
      });
      dashBoardController.studentUserId.value = authController.currentUser.value.id.toString();
      _callTotalTimeSpent(authController, context);
      connectToAnalyticsSocketServer();
    });
  }

  _callTotalTimeSpent(AuthController authController, BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    authController.totalTime().then((value) async {
      pref.setBool(isTourOnLearnScreenkey, authController.totalTimeSpent.value.data?.screenData?.lEARN ?? false);
      pref.setBool(isTourOnSubjectScreenkey, authController.totalTimeSpent.value.data?.screenData?.sUBJECT ?? false);
      pref.setBool(isTourOnChapterScreenkey, authController.totalTimeSpent.value.data?.screenData?.cHAPTERLIST ?? false);
      pref.setBool(isTourOnRoadMapLearnScreenkey, authController.totalTimeSpent.value.data?.screenData?.rOADMAPLEARN ?? false);
      pref.setBool(isTourOnRoadMapHomeworkScreenkey, authController.totalTimeSpent.value.data?.screenData?.rOADMAPHOMEWORK ?? false);
      // print('MinutReached===Menu==${authController.totalTimeSpent.value.data?.minutesReached}');
      if (authController.totalTimeSpent.value.data?.minutesReached == true) {
        pref.setBool(isTourOnScreenEnabledkey, true);
      } else {
        pref.setBool(isTourOnScreenEnabledkey, false);
      }
    });
  }

  _onProfilePage() {
    if (_allUser.length > 1) {
      Navigator.pop(context);
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreenPage(
          currentUser: authController.currentUser.value,
        ),
      ),
    );
  }

  _showUserList() {
    setState(() {
      _isRefresh = true;
    });
    authController.getSessionUserData().then((value) {
      _isRefresh = false;
      _allUser = authController.allUsers;
      List<User> users = authController.allUsers.where((element) => element.id != authController.currentUser.value.id).toList();

      setState(() {});
      showModalBottomSheet(
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.only(topLeft: Radius.circular(14.w), topRight: Radius.circular(14.w)),
          // ),
          context: context,
          builder: (context) {
            return SafeArea(
              child: Obx(() => authController.usersLoading.isTrue
                  ? const Center(child: LoadingSpinner())
                  : SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              "Select User Profile",
                              style: textTitle14BoldStyle.merge(
                                TextStyle(
                                  color: colorDarkText,
                                  fontFamily: fontFamilyMedium,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            //Display Current User
                            SchoolListTile(
                              user: authController.currentUser.value,
                              onTap: () {
                                Navigator.pop(context);
                              },
                              onProfileTap: _onProfilePage,
                              currentUserId: authController.currentUser.value.id ?? "",
                              isLastItem: false,
                            ),
                            const Divider(),
                            ...users.mapIndexed((int index, item) {
                              return SchoolListTile(
                                user: users[index],
                                onTap: () {
                                  _onUserSelect(prevUser: authController.currentUser.value, user: users[index]);
                                },
                                currentUserId: authController.currentUser.value.id ?? "",
                                isLastItem: index == users.length - 1,
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    )),
            );
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Menu",
          style: sectionTitleTextStyle,
        ),
        elevation: 0,
        centerTitle: false,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegistrationScreen2(fromAddSchool: true, userInputData: const {}),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 11.h, horizontal: 16.w),
              padding: EdgeInsets.all(5.w),
              alignment: AlignmentDirectional.center,
              decoration: BoxDecoration(
                gradient: blueDarkGradient2,
                borderRadius: BorderRadius.all(
                  Radius.circular(6.w),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 2.w,
                  ),
                  const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(
                    width: 7.w,
                  ),
                  Text(
                    "School",
                    style: textTitle12BoldStyle.merge(
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          color: const Color(0xffF5F5F5),
          child: Stack(
            children: [
              Positioned(
                top: 0.0,
                left: -110,
                child: SvgPicture.asset(
                  imageAssets + 'menu/ic_menu_ball.svg',
                ),
              ),
              Positioned(
                bottom: 0.0,
                right: -(MediaQuery.of(context).size.width / 1.9),
                top: MediaQuery.of(context).size.height / 3.5,
                child: SvgPicture.asset(
                  imageAssets + 'menu/ic_menu_ball1.svg',
                ),
              ),
              Positioned(
                bottom: 10.0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: SvgPicture.asset(
                    imageAssets + 'menu/girl_happy.svg',
                  ),
                ),
              ),
              SizedBox(
                height: getScrenHeight(context),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 4.h,
                  ),
                  child: Column(
                    children: [
                      Obx(() {
                        User user = authController.currentUser.value;
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _allUser.length == 1 ? _onProfilePage : _showUserList,
                          child: Container(
                            decoration: boxDecoration10,
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                            margin: EdgeInsets.symmetric(vertical: 5.h),
                            child: _isRefresh
                                ? const Center(
                                    child: LoadingSpinner(),
                                  )
                                : Row(
                                    children: [
                                      Container(
                                        width: 60.w,
                                        height: 60.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: colorDropShadow,
                                              offset: Offset(0.0, 2.0),
                                              blurRadius: 5,
                                              spreadRadius: 0,
                                            ),
                                            BoxShadow(
                                              color: Colors.white,
                                              offset: Offset(0.0, 0.0),
                                              blurRadius: 0.0,
                                              spreadRadius: 0.0,
                                            ),
                                          ],
                                        ),
                                        child: !_isLoading
                                            ? (user.thumb != null && user.thumb!.isNotEmpty)
                                                ? CircleAvatar(backgroundImage: NetworkImage(user.thumb ?? ""))
                                                : Icon(
                                                    Icons.account_circle_rounded,
                                                    size: 50.w,
                                                    color: colorText163Gray,
                                                  )
                                            : Padding(
                                                padding: EdgeInsets.all(10.w),
                                                child: const LoadingSpinner(),
                                              ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _isLoading
                                                  ? ""
                                                  : user.name == null
                                                      ? ('${user.firstName} ${user.lastName}')
                                                      : ('${user.name}'),
                                              style: textTitle14BoldStyle.merge(TextStyle(color: colorPink, fontSize: 20.sp)),
                                            ),
                                            Text(
                                              _isLoading ? '' : user.school?.name ?? "",
                                              style: textTitle14BoldStyle.merge(const TextStyle(color: Colors.black, fontWeight: FontWeight.normal)),
                                            ),
                                            Text(
                                              _isLoading ? '' : 'Class ${user.userClass?.name} ${user.section?.name}',
                                              style: textTitle14BoldStyle.merge(const TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        );
                      }),
                      // MenuItemCard(
                      //   title: "Report Card",
                      //   bgColor: colorRedLight,
                      //   iconPath: imageAssets + "menu/report_icon.svg",
                      //   isFullWidth: true,
                      //   onTap: () {},
                      // ),
                      // SizedBox(
                      //   height: 10.h,
                      // ),
                      // Container(
                      //   padding:
                      //       EdgeInsets.symmetric(horizontal: 7.w, vertical: 10.h),
                      //   decoration: const BoxDecoration(
                      //     color: Colors.transparent,
                      //     borderRadius: BorderRadius.all(Radius.circular(10)),
                      //     boxShadow: [
                      //       BoxShadow(
                      //         color: Color.fromRGBO(123, 160, 44, 0.12),
                      //         offset: Offset(
                      //           5.0,
                      //           5.0,
                      //         ),
                      //         blurRadius: 10.0,
                      //         spreadRadius: 2.0,
                      //       ),
                      //       BoxShadow(
                      //         color: Colors.white,
                      //         offset: Offset(0.0, 0.0),
                      //       ),
                      //     ],
                      //   ),
                      //   child: Row(
                      //     children: [
                      //       const MenuItemIcon(
                      //         iconpath: imageAssets + "menu/sound_icon.svg",
                      //         bgColor: colorPurpleLight,
                      //       ),
                      //       SizedBox(
                      //         width: 10.w,
                      //       ),
                      //       Expanded(
                      //         child: Text(
                      //           "Sound Notification",
                      //           style: textTitle16WhiteBoldStyle.merge(
                      //               const TextStyle(color: colorWebPanelDarkText)),
                      //         ),
                      //       ),
                      //       SizedBox(
                      //         width: 10.w,
                      //       ),
                      //       CupertinoSwitch(
                      //         value: _soundNotification,
                      //         onChanged: _onSoundNotificationChange,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 10.h,
                      // ),
                      SizedBox(
                        height: 5.h,
                      ),
                      MenuItemCard(
                        title: "Communication",
                        bgColor: colorPurpleLight,
                        iconPath: imageAssets + "menu/communication_icon.svg",
                        isFullWidth: true,
                        isCount: true,
                        isCommunication: true,
                        messageCounter: messageCounter,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ClassCommunicationPage(title: 'Communication'),
                            ),
                          ).then((value) {
                            communicationController.getUnreadMessageCount().then((v) {
                              setState(() {
                                messageCounter = communicationController.unReadCount.value;
                              });
                            });
                          });
                        },
                      ),

                      SizedBox(
                        height: 10.h,
                      ),
                      MenuItemCard(
                        title: "Product Tour Video",
                        bgColor: colorPurpleLight,
                        iconPath: imageAssets + "ic_introvideo.svg",
                        isFullWidth: true,
                        isCount: true,
                        messageCounter: messageCounter,
                        onTap: () {
                          setState(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProductvideoListScreen(),
                              ),
                            );
                          });

                          //     .then((value) {
                          //   communicationController.getUnreadMessageCount().then((v) {
                          //     setState(() {
                          //       messageCounter =
                          //           communicationController.unReadCount.value;
                          //     });
                          //   });
                          // });
                        },
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      MenuItemCard(
                        title: "View Reported Content",
                        bgColor: colorPinkLight,
                        iconPath: imageAssets + "menu/view_content_report_icon.svg",
                        isFullWidth: true,
                        isCount: false,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ViewContentReport(),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: MenuItemCard(
                              title: "Privacy\nPolicy",
                              bgColor: colorOrangeLight,
                              iconPath: imageAssets + "menu/description_orange.svg",
                              isFullWidth: false,
                              onTap: () {
                                _openLink("https://saarthipedagogy.com/privacy-policy/");
                              },
                            ),
                          ),
                          SizedBox(
                            width: 12.w,
                          ),
                          Expanded(
                            child: MenuItemCard(
                              title: "Terms &\nConditions",
                              bgColor: colorRedLight,
                              iconPath: imageAssets + "menu/description_purple.svg",
                              isFullWidth: false,
                              onTap: () {
                                _openLink("https://saarthipedagogy.com/terms-conditions/");
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: MenuItemCard(
                              title: "Version \n $appVersion",
                              bgColor: colorTealLight,
                              iconPath: imageAssets + "menu/version.svg",
                              isFullWidth: false,
                              onTap: () {},
                            ),
                          ),
                          SizedBox(
                            width: 12.w,
                          ),
                          Expanded(
                            child: MenuItemCard(
                              title: "Log out",
                              bgColor: colorSkyLight,
                              iconPath: imageAssets + "menu/logout.svg",
                              isFullWidth: false,
                              onTap: () {
                                doLogout();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  doLogout() async {
    authController.logout();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginNewScreen(),
      ),
    );
    // Navigator.of(context)
    //     .pushNamedAndRemoveUntil('/' + loginRoute, (route) => false);
  }
}

class MenuItemCard extends StatefulWidget {
  MenuItemCard(
      {Key? key,
      required this.title,
      required this.iconPath,
      required this.bgColor,
      required this.isFullWidth,
      required this.onTap,
      this.isCount,
      this.isCommunication = false,
      this.messageCounter = 0})
      : super(key: key);

  final String title;
  final String iconPath;
  final Color bgColor;
  final bool isFullWidth;
  final VoidCallback onTap;
  final bool? isCount;
  bool isCommunication;
  final int messageCounter;

  @override
  State<MenuItemCard> createState() => _MenuItemCardState();
}

class _MenuItemCardState extends State<MenuItemCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: const BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(123, 160, 44, 0.12),
              offset: Offset(
                5.0,
                5.0,
              ),
              blurRadius: 10.0,
              spreadRadius: 2.0,
            ),
            BoxShadow(
              color: Colors.white,
              offset: Offset(0.0, 0.0),
            ),
          ],
        ),
        child: Row(
          children: [
            MenuItemIcon(
              iconpath: widget.iconPath,
              bgColor: widget.bgColor,
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: textTitle16WhiteBoldStyle.merge(const TextStyle(color: colorWebPanelDarkText)),
                  ),
                  widget.isCommunication
                      ? widget.isCount ?? false
                          ? widget.messageCounter > 0
                              ? Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(1),
                                  margin: EdgeInsets.only(right: 8.w),
                                  decoration: const BoxDecoration(
                                    color: colorRed,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 28,
                                    minHeight: 28,
                                  ),
                                  child: Text(
                                    widget.messageCounter.toString(),
                                    style: textBody14Style.merge(const TextStyle(color: Colors.white)),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : Container()
                          : Container()
                      : Container()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItemIcon extends StatelessWidget {
  const MenuItemIcon({Key? key, required this.iconpath, required this.bgColor}) : super(key: key);

  final String iconpath;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.h,
      height: 40.h,
      margin: EdgeInsets.only(left: 10.w),
      padding: EdgeInsets.all(10.h),
      alignment: AlignmentDirectional.center,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        color: bgColor,
      ),
      child: SvgPicture.asset(
        iconpath,
        fit: BoxFit.fill,
      ),
    );
  }
}

class SchoolListTile extends StatelessWidget {
  const SchoolListTile({
    Key? key,
    required this.currentUserId,
    required this.user,
    required this.onTap,
    this.onProfileTap,
    required this.isLastItem,
  }) : super(key: key);

  final User user;
  final String currentUserId;
  final VoidCallback onTap;
  final VoidCallback? onProfileTap;
  final bool isLastItem;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: currentUserId == user.id ? colorBlue500 : Colors.white,
                width: currentUserId == user.id ? 2 : 0,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            margin: EdgeInsets.symmetric(vertical: 5.h),
            child: Row(
              children: [
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
                  child: (user.thumb != null && user.thumb!.isNotEmpty)
                      ? CircleAvatar(backgroundImage: NetworkImage(user.thumb ?? ""))
                      : Icon(
                          Icons.account_circle_rounded,
                          size: 50.w,
                          color: colorText163Gray,
                        ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // user.firstName ?? "",
                        user.name == null ? ('${user.firstName} ${user.lastName}') : ('${user.name}'),
                        style: textTitle14BoldStyle.merge(
                          TextStyle(
                            color: currentUserId == user.id ? colorBlue600 : colorDarkText,
                            fontFamily: fontFamilyMedium,
                            fontWeight: FontWeight.w500,
                            fontSize: 20.sp,
                          ),
                        ),
                      ),
                      Text(
                        user.school?.name ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTitle14BoldStyle
                            .merge(TextStyle(color: colorDarkText, fontFamily: fontFamilyPoppins, fontWeight: FontWeight.w400, fontSize: 14.sp)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Class ${user.userClass?.name} ${user.section?.name}',
                            style: textTitle14BoldStyle
                                .merge(TextStyle(color: colorDarkText, fontFamily: fontFamilyPoppins, fontWeight: FontWeight.w600, fontSize: 14.sp)),
                          ),
                          currentUserId == user.id
                              ? GestureDetector(
                                  onTap: onProfileTap ?? () {},
                                  child: Container(
                                    alignment: AlignmentDirectional.bottomEnd,
                                    child: Container(
                                      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(6)), color: colorBlue600),
                                      margin: const EdgeInsets.only(top: 2.5),
                                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Center(
                                            child: Text(
                                              "View Profile",
                                              style: textFormSmallerTitleStyle.merge(
                                                TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: fontFamilySemiBold,
                                                  fontSize: 12.sp,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          const Icon(
                                            Icons.arrow_forward,
                                            color: Colors.white,
                                            size: 14,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          currentUserId == user.id || isLastItem
              ? const SizedBox()
              : const Divider(
                  color: colorGrey300,
                  height: 1,
                )
        ],
      ),
    );
  }
}
