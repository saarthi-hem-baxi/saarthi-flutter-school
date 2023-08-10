import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saarthi_pedagogy_studentapp/controllers/view_content_report_controller.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/screen/menu/view_content_report_detail.dart';
import 'package:saarthi_pedagogy_studentapp/theme/colors.dart';
import 'package:saarthi_pedagogy_studentapp/theme/style.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controllers.dart';
import '../../model/view_content_report/view_content_report_model.dart';
import '../../widgets/common/loading_spinner.dart';

class ViewContentReport extends StatefulWidget {
  const ViewContentReport({Key? key}) : super(key: key);

  @override
  State<ViewContentReport> createState() => _ViewContentReportState();
}

class _ViewContentReportState extends State<ViewContentReport> {
  int sort = -1;
  final viewContentReportController = Get.put(ViewContentReportController());
  List<ResolutionStatusModel> resolutionStatusList = [];
  List<bool> tempResolutionStatusList = [];
  List<ContentTypeModel> contentTypeList = [];
  List<bool> tempContentTypeList = [];
  String resolutionStatus = '';
  String contentType = '';
  List<String> subjectIdList = [];
  int filterCount = 0;
  String subjectIDs = '';
  int currentPage = 1;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  List<Reports>? reportList = [];
  bool shouldExecute = false;
  final TextEditingController _textEditingController = TextEditingController(text: "");
  String searchTxt = '';
  bool isFilterApply = false;
  bool isClearAll = false;
  List<SubjectFilterData>? subjectDataList = [];
  List<bool> tempSubjectIDList = [];
  Timer? _debounce;

  final AuthController _authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      reloadData();
    });
    filterSubjectData();

    Future.delayed(Duration.zero, () {
      _authController.renewUser();
    });
  }

  reloadData() async {
    currentPage = 1;
    reportList = [];
    loadMore();
  }

  loadMore() async {
    bool issuccess =
        await viewContentReportController.getContentReportList(sort, resolutionStatus, contentType, subjectIDs, currentPage.toString(), searchTxt);
    if (issuccess) {
      if ((viewContentReportController.viewContentReportModel.value.data?.reports ?? []).isNotEmpty) {
        currentPage += 1;
        reportList?.addAll(viewContentReportController.viewContentReportModel.value.data!.reports!);
        shouldExecute = true;
        if (mounted) setState(() {});
        _refreshController.loadComplete();
      } else {
        shouldExecute = true;
        if (mounted) setState(() {});
        _refreshController.loadComplete();
      }
    }
  }

  filterSubjectData() async {
    viewContentReportController.getSubjects();
    ResolutionStatusModel resolutionStatusModel;
    resolutionStatusModel = ResolutionStatusModel('All', 'all', false);
    resolutionStatusList.add(resolutionStatusModel);
    tempResolutionStatusList.add(false);
    resolutionStatusModel = ResolutionStatusModel('Reported', 'reported', false);
    resolutionStatusList.add(resolutionStatusModel);
    tempResolutionStatusList.add(false);
    resolutionStatusModel = ResolutionStatusModel('In Progress', 'in-progress', false);
    resolutionStatusList.add(resolutionStatusModel);
    tempResolutionStatusList.add(false);
    resolutionStatusModel = ResolutionStatusModel('Resolved', 'resolved', false);
    resolutionStatusList.add(resolutionStatusModel);
    tempResolutionStatusList.add(false);

    ContentTypeModel contentTypeModel;
    contentTypeModel = ContentTypeModel('All', false);
    contentTypeList.add(contentTypeModel);
    tempContentTypeList.add(false);
    contentTypeModel = ContentTypeModel('Content', false);
    contentTypeList.add(contentTypeModel);
    tempContentTypeList.add(false);
    contentTypeModel = ContentTypeModel('Media', false);
    contentTypeList.add(contentTypeModel);
    tempContentTypeList.add(false);
    contentTypeModel = ContentTypeModel('Question', false);
    contentTypeList.add(contentTypeModel);
    tempContentTypeList.add(false);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          GestureDetector(
            onTap: () {
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
          Text(
            'Reported Content',
            style: sectionTitleTextStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      elevation: 0,
      backgroundColor: colorExtraLightGreybg,
    );

    final searchBox = Container(
      height: 40.h,
      margin: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: TextField(
        controller: _textEditingController,
        onChanged: (txt) {
          if (txt.isEmpty) {
            isClearAll = false;
          } else {
            isClearAll = true;
          }
          setState(() {});
          if (txt.length > 3) {
            searchTxt = txt.replaceFirst(RegExp('[#]'), "");
            if (_debounce?.isActive ?? false) _debounce!.cancel();
            _debounce = Timer(const Duration(seconds: 1), () {
              if (viewContentReportController.loading.isFalse) {
                isFilterApply = true;
                reloadData();
              }
            });
          }

          if (txt.isEmpty) {
            searchTxt = '';
            Future.delayed(const Duration(seconds: 1), () {
              if (viewContentReportController.loading.isFalse) {
                isFilterApply = false;
                reloadData();
              }
            });
          }
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          hintText: 'Search all issues...',
          hintStyle: textTitle16WhiteRegularStyle.merge(TextStyle(color: colorGrey600, fontSize: 14.sp, fontWeight: FontWeight.w600)),
          prefixIcon: const Icon(Icons.search, color: colorBlueDark),
          suffixIcon: isClearAll
              ? IconButton(
                  onPressed: () {
                    if (_textEditingController.text.isNotEmpty) {
                      _textEditingController.clear();
                      searchTxt = '';
                      Future.delayed(Duration.zero, () {
                        if (isFilterApply && filterCount == 0) {
                          isFilterApply = false;
                        }
                        reloadData();
                      });
                    }
                  },
                  icon: const Icon(Icons.clear, color: colorBlueDark),
                )
              : const SizedBox(),
        ),
      ),
    );

    Widget filterWidget = Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: getScreenWidth(context) * 0.46,
            child: Center(
              child: InkWell(
                onTap: () {
                  showSortModelDialog();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      '${imageAssets}menu/view_content_report/sort.svg',
                      height: 15.h,
                      width: 15.w,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text('Sort', style: textTitle18WhiteBoldStyle.merge(const TextStyle(color: colorWebPanelDarkText))),
                  ],
                ),
              ),
            ),
          ),
          const VerticalDivider(
            width: 1.0,
            thickness: 1,
            color: Color.fromRGBO(204, 204, 204, 1),
          ),
          SizedBox(
            width: getScreenWidth(context) * 0.52,
            child: Center(
              child: InkWell(
                onTap: () {
                  showFilterModelDialog();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      '${imageAssets}menu/view_content_report/filter.svg',
                      height: 15.h,
                      width: 15.w,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      'Filter',
                      style: textTitle18WhiteBoldStyle.merge(
                        const TextStyle(
                          color: colorWebPanelDarkText,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: 18.h,
                      height: 18.w,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorGrey600,
                      ),
                      child: Center(
                        child: Text(
                          filterCount.toString(),
                          style: textTitle16WhiteBoldStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: colorExtraLightGreybg,
      appBar: appBar,
      body: SafeArea(
        child: Obx(
          () => (reportList ?? []).isEmpty && viewContentReportController.loading.isTrue || !shouldExecute
              ? SizedBox(
                  height: 100.h,
                  child: const Center(
                    child: LoadingSpinner(color: Colors.blue),
                  ),
                )
              : (reportList ?? []).isEmpty && viewContentReportController.loading.isFalse
                  ? isFilterApply
                      ? Stack(
                          children: [
                            Column(
                              children: [
                                searchBox,
                                Expanded(
                                  child: NoDataCard(
                                    isFilterApply: isFilterApply,
                                  ),
                                )
                              ],
                            ),
                            Positioned(
                              bottom: 0,
                              width: MediaQuery.of(context).size.width,
                              child: filterWidget,
                            )
                          ],
                        )
                      : NoDataCard(isFilterApply: isFilterApply)
                  : Stack(
                      children: [
                        Column(
                          children: [
                            searchBox,
                            Expanded(
                              child: SmartRefresher(
                                enablePullDown: false,
                                enablePullUp: true,
                                header: const WaterDropHeader(),
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
                                      body = const Text("Load Failed!Click retry!");
                                    } else if (mode == LoadStatus.canLoading) {
                                      body = const Text("release to load more");
                                    } else {
                                      body = const SizedBox();
                                    }
                                    return SizedBox(
                                      height: 55.0,
                                      child: Center(child: body),
                                    );
                                  },
                                ),
                                controller: _refreshController,
                                onLoading: loadMore,
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: Column(
                                      children: [
                                        ...(reportList ?? []).map(
                                          (reports) {
                                            return ReportListItem(reports: reports);
                                          },
                                        ).toList(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 0,
                          width: MediaQuery.of(context).size.width,
                          child: filterWidget,
                        )
                      ],
                    ),
        ),
      ),
    );
  }

  showSortModelDialog() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(14.w), topRight: Radius.circular(14.w)),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        constraints: BoxConstraints(minHeight: 30.h),
                        width: MediaQuery.of(context).size.width,
                        color: const Color(0xffF9F6F8),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                          child: Text(
                            "Sort by",
                            style: textTitle18WhiteBoldStyle.merge(
                              TextStyle(
                                color: sectionTitleColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 20.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        color: sort == -1 ? colorBackground : Colors.white,
                        width: MediaQuery.of(context).size.width,
                        child: InkWell(
                          onTap: () {
                            sort = -1;
                            Navigator.pop(context);
                            reloadData();
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                            child: Text(
                              "Latest to Oldest",
                              style: textTitle18WhiteBoldStyle.merge(
                                TextStyle(
                                  color: sort == -1 ? colorGrey800 : colorGrey600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        color: sort == 1 ? colorBackground : Colors.white,
                        width: MediaQuery.of(context).size.width,
                        child: InkWell(
                          onTap: () {
                            sort = 1;
                            Navigator.pop(context);
                            reloadData();
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                            child: Text(
                              "Oldest to Latest",
                              style: textTitle18WhiteBoldStyle.merge(
                                TextStyle(color: sort == 1 ? colorGrey800 : colorGrey600),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  showFilterModelDialog() {
    if (subjectDataList!.isEmpty) {
      SubjectFilterData subjectFilterData;
      subjectFilterData = SubjectFilterData('', 'All', ['all'], '', false);
      subjectDataList?.add(subjectFilterData);
      tempSubjectIDList.add(false);
      (viewContentReportController.filterSubjectModel.value.subjectData ?? []).map((subjectData) {
        subjectFilterData = SubjectFilterData(subjectData.id, subjectData.name, subjectData.subjects, subjectData.subjectId, false);
        subjectDataList?.add(subjectFilterData);
        tempSubjectIDList.add(false);
      }).toList();
    }
    tempResolutionStatusList.mapIndexed(
      (index, item) {
        resolutionStatusList[index].cheked = item;
      },
    ).toList();
    tempContentTypeList.mapIndexed(
      (index, item) {
        contentTypeList[index].cheked = item;
      },
    ).toList();
    tempSubjectIDList.mapIndexed(
      (index, item) {
        subjectDataList?[index].cheked = item;
      },
    ).toList();

    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(14.w), topRight: Radius.circular(14.w)),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (context) {
          return SafeArea(
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(10.w),
                      color: const Color.fromRGBO(249, 246, 248, 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Filter",
                            style: textTitle16WhiteRegularStyle.merge(
                              TextStyle(
                                color: sectionTitleColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 20.sp,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  for (var element in resolutionStatusList) {
                                    element.cheked = false;
                                  }
                                  for (var element in contentTypeList) {
                                    element.cheked = false;
                                  }
                                  for (var element in subjectDataList!) {
                                    element.cheked = false;
                                  }
                                  resolutionStatus = '';
                                  contentType = '';
                                  subjectIdList.clear();
                                  subjectIDs = '';
                                  filterCount = 0;
                                  setState(() {});
                                },
                                child: Text(
                                  "Clear All",
                                  style: textTitle16WhiteRegularStyle
                                      .merge(TextStyle(color: const Color.fromRGBO(68, 68, 68, 1), fontWeight: FontWeight.w600, fontSize: 16.sp)),
                                ),
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  resolutionStatus = '';
                                  resolutionStatusList.mapIndexed((index, resolutionStatusData) {
                                    tempResolutionStatusList[index] = resolutionStatusData.cheked;
                                    if (resolutionStatusData.cheked) {
                                      if (resolutionStatus == '') {
                                        resolutionStatus = resolutionStatusData.status.toString();
                                      } else {
                                        resolutionStatus = '$resolutionStatus,${resolutionStatusData.status}';
                                      }
                                    }
                                  }).toList();

                                  contentType = '';
                                  contentTypeList.mapIndexed((index, contentTypeData) {
                                    tempContentTypeList[index] = contentTypeData.cheked;
                                    if (contentTypeData.cheked) {
                                      if (contentType == '') {
                                        contentType = contentTypeData.title.toLowerCase();
                                      } else {
                                        contentType = '$contentType,${contentTypeData.title.toLowerCase()}';
                                      }
                                    }
                                  }).toList();
                                  subjectIDs = '';
                                  List<String> selectedSubjectId = [];
                                  subjectDataList?.mapIndexed((index, subjectFilterData) {
                                    tempSubjectIDList[index] = subjectFilterData.cheked;
                                    if (subjectFilterData.cheked) {
                                      if ((subjectFilterData.id ?? '').isEmpty) {
                                        selectedSubjectId.add('all');
                                        subjectIDs = selectedSubjectId.join(',');
                                      } else {
                                        selectedSubjectId.add(subjectFilterData.id ?? '');
                                        subjectIDs = selectedSubjectId.join(',');
                                      }
                                      // subjectFilterData.subjects?.map((id) {
                                      //   if (subjectIDs.isEmpty) {
                                      //     subjectIDs = id;
                                      //   } else {
                                      //     subjectIDs = '$subjectIDs,$id';
                                      //   }
                                      // }).toList();
                                    }
                                  }).toList();

                                  filterCount = 0;
                                  if (resolutionStatus.isNotEmpty) {
                                    filterCount = filterCount + 1;
                                  }
                                  if (contentType.isNotEmpty) {
                                    filterCount = filterCount + 1;
                                  }
                                  if (subjectIDs.isNotEmpty) {
                                    filterCount = filterCount + 1;
                                  }

                                  Future.delayed(Duration.zero, () {
                                    isFilterApply = true;
                                    reloadData();
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.w),
                                  decoration: const BoxDecoration(
                                    color: colorBlueDark,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        'Apply',
                                        style: textTitle12BoldStyle.merge(
                                          const TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(
                        'Resolution Status',
                        style: textTitle16WhiteRegularStyle.merge(
                          TextStyle(
                            color: colorWebPanelDarkText,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.sp,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 10.h),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: resolutionStatusList.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Theme(
                                data: ThemeData(unselectedWidgetColor: colorBlueDark),
                                child: Checkbox(
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  value: resolutionStatusList[index].cheked,
                                  activeColor: colorBlueDark,
                                  onChanged: (v) {
                                    if (index == 0) {
                                      resolutionStatusList.map((e) {
                                        if (e.cheked) {
                                          e.cheked = false;
                                        }
                                      }).toList();
                                    } else {
                                      resolutionStatusList[0].cheked = false;
                                    }
                                    setState(() {
                                      resolutionStatusList[index].cheked = v!;
                                    });
                                  },
                                ),
                              ),
                              Text(resolutionStatusList[index].title,
                                  style:
                                      textTitle16WhiteRegularStyle.merge(const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.w400))),
                            ],
                          );
                        },
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 300.0,
                          mainAxisExtent: 30.0,
                          childAspectRatio: 4.0,
                        ),
                      ),
                    ),
                    const Divider(
                      color: colorFormFieldBorder,
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(
                        'Type',
                        style: textTitle16WhiteRegularStyle.merge(
                          TextStyle(
                            color: colorWebPanelDarkText,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.sp,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 10.h),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: contentTypeList.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Theme(
                                data: ThemeData(unselectedWidgetColor: colorBlueDark),
                                child: Checkbox(
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  value: contentTypeList[index].cheked,
                                  activeColor: colorBlueDark,
                                  onChanged: (v) {
                                    if (index == 0) {
                                      contentTypeList.map((e) {
                                        if (e.cheked) {
                                          e.cheked = false;
                                        }
                                      }).toList();
                                    } else {
                                      contentTypeList[0].cheked = false;
                                    }
                                    setState(() {
                                      contentTypeList[index].cheked = v!;
                                    });
                                  },
                                ),
                              ),
                              Text(contentTypeList[index].title,
                                  style:
                                      textTitle16WhiteRegularStyle.merge(const TextStyle(color: colorWebPanelDarkText, fontWeight: FontWeight.w400))),
                            ],
                          );
                        },
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 300.0,
                          mainAxisExtent: 30.0,
                          childAspectRatio: 4.0,
                        ),
                      ),
                    ),
                    const Divider(
                      color: colorFormFieldBorder,
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(
                        'Subjects',
                        style: textTitle16WhiteRegularStyle.merge(
                          TextStyle(
                            color: colorWebPanelDarkText,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.sp,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 3.h),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: (subjectDataList?.length ?? 0),
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Theme(
                                data: ThemeData(unselectedWidgetColor: colorBlueDark),
                                child: Checkbox(
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  value: subjectDataList?[index].cheked,
                                  activeColor: colorBlueDark,
                                  onChanged: (v) {
                                    if (index == 0) {
                                      subjectDataList?.map((e) {
                                        if (e.cheked) {
                                          e.cheked = false;
                                        }
                                      }).toList();
                                    } else {
                                      subjectDataList?[0].cheked = false;
                                    }
                                    setState(() {
                                      subjectDataList?[index].cheked = v!;
                                    });
                                  },
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  capitalize((subjectDataList?[index].name ?? "")),
                                  style: textTitle16WhiteRegularStyle.merge(
                                    const TextStyle(
                                      color: colorWebPanelDarkText,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    )
                  ],
                );
              },
            ),
          );
        });
  }
}

class NoDataCard extends StatelessWidget {
  const NoDataCard({Key? key, required this.isFilterApply}) : super(key: key);
  final bool isFilterApply;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: isFilterApply ? const EdgeInsets.fromLTRB(15, 10, 15, 60) : const EdgeInsets.fromLTRB(15, 10, 15, 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20.h,
              ),
              Text('Duh Oh !', style: textTitle20WhiteBoldStyle.merge(const TextStyle(color: colorWebPanelDarkText))),
              SizedBox(
                height: 20.h,
              ),
              Container(
                  width: getScreenWidth(context),
                  height: getScrenHeight(context) / 2.5,
                  margin: const EdgeInsets.only(left: 20, right: 20, bottom: 50),
                  child: SvgPicture.asset(
                    '${imageAssets}no_data.svg',
                    allowDrawingOutsideViewBox: true,
                    colorBlendMode: BlendMode.luminosity,
                    // fit: BoxFit.f,
                  )),
            ],
          ),
          Positioned(
              bottom: 20,
              child: Column(
                children: [
                  Container(
                    alignment: AlignmentDirectional.center,
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                      'Nothing Here !',
                      textAlign: TextAlign.center,
                      style: textTitle20WhiteBoldStyle.merge(const TextStyle(color: Color(0xff314196), fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Container(
                    alignment: AlignmentDirectional.center,
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                      'You haven’t reported any issue yet.',
                      textAlign: TextAlign.center,
                      style: textTitle14BoldStyle.merge(TextStyle(color: colorWebPanelDarkText, fontSize: 18.sp, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}

class ReportListItem extends StatelessWidget {
  const ReportListItem({Key? key, required this.reports}) : super(key: key);
  final Reports reports;

  Widget getSubjectIconWidget(String? iconUrl) {
    String ext = (iconUrl ?? "").split(".").last;

    if (iconUrl == null) {
      return SvgPicture.asset(
        '${imageAssets}menu/view_content_report/subject_icon.svg',
        height: 80.w,
        width: 80.w,
        fit: BoxFit.cover,
      );
    }

    if (ext == 'svg') {
      return ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: SvgPicture.network(
          iconUrl,
          width: 80.w,
          height: 80.w,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: CachedNetworkImage(
          imageUrl: iconUrl,
          width: 80.w,
          height: 80.w,
          fit: BoxFit.cover,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewContentReportDetail(
              id: (reports.id ?? ''),
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              getSubjectIconWidget(reports.subject?.subjectIconData?.subjectIcon),
              SizedBox(
                width: 10.w,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                (reports.subject?.name ?? ""),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: textTitle18WhiteBoldStyle.merge(
                                  const TextStyle(
                                    color: colorGrey800,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                '#${(reports.reportId ?? "")}',
                                style: textError16WhiteBoldStyle.merge(
                                  const TextStyle(
                                    color: colorGrey600,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SvgPicture.asset(
                          '${imageAssets}menu/view_content_report/back.svg',
                          height: 23.h,
                          width: 13.w,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(capitalize((reports.content?.type ?? "")),
                        style: textTitle12RegularStyle.merge(const TextStyle(color: colorGrey600, fontWeight: FontWeight.w400))),
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IntrinsicWidth(child: ReportContentWidget(status: reports.currentStatus.toString())),
                        Text((reports.createdAt != null ? DateFormat("dd/MM/yy").format(reports.createdAt!) : ""),
                            style: textTitle12RegularStyle.merge(const TextStyle(color: colorGrey600, fontWeight: FontWeight.w400))),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}

class ReportContentWidget extends StatelessWidget {
  const ReportContentWidget({
    Key? key,
    required this.status,
  }) : super(key: key);
  final String status;

  ReportContentData getReportContentData(String status) {
    // reported => unassigned
    // in-progress => assigned, in-progress, assign-to-verify, assigned-to-verify, to-notify, escalated
    // resolved => notified

    ReportContentData reportContentData;
    switch (status) {
      case 'notified':
        reportContentData = ReportContentData('RESOLVED', const Color.fromRGBO(243, 251, 239, 1), const Color.fromRGBO(160, 223, 129, 1),
            const Color.fromRGBO(80, 152, 42, 1), '${imageAssets}menu/view_content_report/resolved_icon.svg');
        break;

      case 'unassigned':
        reportContentData = ReportContentData('REPORTED', const Color.fromRGBO(242, 244, 247, 1), const Color.fromRGBO(208, 213, 221, 1),
            const Color.fromRGBO(102, 112, 133, 1), '${imageAssets}menu/view_content_report/reported_icon.svg');

        break;

      case 'assigned':
        reportContentData = ReportContentData('IN PROGRESS', const Color.fromRGBO(255, 241, 224, 1), const Color.fromRGBO(255, 206, 148, 1),
            const Color.fromRGBO(229, 122, 0, 1), '${imageAssets}menu/view_content_report/inprogress_icon.svg');

        break;

      case 'in-progress':
        reportContentData = ReportContentData('IN PROGRESS', const Color.fromRGBO(255, 241, 224, 1), const Color.fromRGBO(255, 206, 148, 1),
            const Color.fromRGBO(229, 122, 0, 1), '${imageAssets}menu/view_content_report/inprogress_icon.svg');

        break;

      case 'assign-to-verify':
        reportContentData = ReportContentData('IN PROGRESS', const Color.fromRGBO(255, 241, 224, 1), const Color.fromRGBO(255, 206, 148, 1),
            const Color.fromRGBO(229, 122, 0, 1), '${imageAssets}menu/view_content_report/inprogress_icon.svg');

        break;

      case 'assigned-to-verify':
        reportContentData = ReportContentData('IN PROGRESS', const Color.fromRGBO(255, 241, 224, 1), const Color.fromRGBO(255, 206, 148, 1),
            const Color.fromRGBO(229, 122, 0, 1), '${imageAssets}menu/view_content_report/inprogress_icon.svg');

        break;

      case 'to-notify':
        reportContentData = ReportContentData('IN PROGRESS', const Color.fromRGBO(255, 241, 224, 1), const Color.fromRGBO(255, 206, 148, 1),
            const Color.fromRGBO(229, 122, 0, 1), '${imageAssets}menu/view_content_report/inprogress_icon.svg');

        break;

      case 'escalated':
        reportContentData = ReportContentData('IN PROGRESS', const Color.fromRGBO(255, 241, 224, 1), const Color.fromRGBO(255, 206, 148, 1),
            const Color.fromRGBO(229, 122, 0, 1), '${imageAssets}menu/view_content_report/inprogress_icon.svg');

        break;

      default:
        reportContentData = ReportContentData('REPORTED', const Color.fromRGBO(243, 251, 239, 1), const Color.fromRGBO(160, 223, 129, 1),
            const Color.fromRGBO(80, 152, 42, 1), '${imageAssets}menu/view_content_report/resolved_icon.svg');
    }
    return reportContentData;
  }

  @override
  Widget build(BuildContext context) {
    ReportContentData reportContentData = getReportContentData(status);

    return Container(
      padding: EdgeInsets.only(
        left: 4.w,
        right: 4.w,
        top: 2.h,
        bottom: 2.h,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: reportContentData.lineColor),
        borderRadius: BorderRadius.all(
          Radius.circular(4.w),
        ),
        color: reportContentData.bgColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(
              right: 4.w,
              bottom: (0.9).h,
            ),
            child: SvgPicture.asset(
              reportContentData.iconPath,
              width: 10.h,
              height: 10.h,
            ),
          ),
          Text(
            reportContentData.title.toUpperCase(),
            style: textTitle12BoldStyle.merge(TextStyle(
              color: reportContentData.textColor,
              fontWeight: FontWeight.w700,
              fontSize: 11.sp,
            )),
          )
        ],
      ),
    );
  }
}

class ReportContentData {
  final String title;
  final Color bgColor;
  final Color lineColor;
  final Color textColor;
  final String iconPath;

  ReportContentData(this.title, this.bgColor, this.lineColor, this.textColor, this.iconPath);
}

class ContentReportModel {
  final List<Data>? data;

  ContentReportModel({
    this.data,
  });

  ContentReportModel.fromJson(Map<String, dynamic> json)
      : data = (json['data'] as List?)?.map((dynamic e) => Data.fromJson(e as Map<String, dynamic>)).toList();

  Map<String, dynamic> toJson() => {'data': data?.map((e) => e.toJson()).toList()};
}

class Data {
  final String? name;
  final String? status;

  Data({
    this.name,
    this.status,
  });

  Data.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String?,
        status = json['status'] as String?;

  Map<String, dynamic> toJson() => {'name': name, 'status': status};
}

class ResolutionStatusModel {
  final String title;
  final String status;
  bool cheked;

  ResolutionStatusModel(this.title, this.status, this.cheked);
}

class ContentTypeModel {
  final String title;
  bool cheked;

  ContentTypeModel(this.title, this.cheked);
}

class SubjectFilterData {
  final String? subjectId;
  final String? name;
  final List<String>? subjects;
  final String? id;
  bool cheked;

  SubjectFilterData(
    this.subjectId,
    this.name,
    this.subjects,
    this.id,
    this.cheked,
  );
}
