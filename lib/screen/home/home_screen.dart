// import 'dart:math';

// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:saarthi_pedagogy_studentapp/common/footer_menu.dart';
// import 'package:saarthi_pedagogy_studentapp/common/loading_spinner.dart';
// import 'package:saarthi_pedagogy_studentapp/common/no_animation_material_page_route.dart';
// import 'package:saarthi_pedagogy_studentapp/common/weekly_progress_card.dart';
// import 'package:saarthi_pedagogy_studentapp/controllers/dashboard/dashboard_controllers.dart';
// import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
// import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
// import 'package:saarthi_pedagogy_studentapp/screen/ItemCards/book_cards_old.dart';
// import 'package:saarthi_pedagogy_studentapp/screen/ItemCards/pending_cards.dart';
// import 'package:saarthi_pedagogy_studentapp/screen/home/worksheet.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage>
//     with SingleTickerProviderStateMixin {
//   double unClearedConceptCardHeight = 96;

//   final dashBoardController = Get.put(DashboardController());
//   @override
//   void initState() {
//     super.initState();
//     if (dashBoardController.subjectModel.value.data == null) {
//       dashBoardController.getSubjects(context);
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double unClearedConceptCardWidth = (getScreenWidth(context) / 2.5) - 10;

//     return SafeArea(
//       child: Scaffold(
//         body: Container(
//           color: colorScreenBg1Purple,
//           child: Obx(
//             () => dashBoardController.loading.isTrue
//                 ? Center(
//                     child: LoadingSpinner(color: Colors.blue),
//                   )
//                 : Container(
//                     color: Colors.white,
//                     child: Column(
//                       children: [
//                         Container(
//                           margin: const EdgeInsets.all(16),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 children: [
//                                   ClipRRect(
//                                     borderRadius: BorderRadius.circular(15.0),
//                                     child: Image.asset(
//                                         imageAssets + 'sampleprofile.png'),
//                                   ),
//                                   Container(
//                                     margin: const EdgeInsets.only(left: 10),
//                                     child: Text(
//                                       "Hello, Rutvi",
//                                       style: sectionTitleTextStyle,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 children: [
//                                   Container(
//                                     height: 34,
//                                     width: 34,
//                                     alignment: AlignmentDirectional.center,
//                                     child: IconButton(
//                                       onPressed: () => {},
//                                       icon: const Icon(
//                                           Icons.leaderboard_outlined),
//                                       iconSize: 18,
//                                       color: sectionTitleColor,
//                                     ),
//                                     decoration: const BoxDecoration(
//                                         borderRadius: BorderRadius.all(
//                                           Radius.circular(10),
//                                         ),
//                                         color:
//                                             Color.fromRGBO(244, 239, 246, 1)),
//                                   ),
//                                   Container(
//                                     height: 34,
//                                     width: 34,
//                                     margin: const EdgeInsets.only(left: 10),
//                                     alignment: AlignmentDirectional.center,
//                                     child: IconButton(
//                                       onPressed: () => {},
//                                       icon: const Icon(
//                                           Icons.notifications_outlined),
//                                       iconSize: 18,
//                                       color: sectionTitleColor,
//                                     ),
//                                     decoration: const BoxDecoration(
//                                         borderRadius: BorderRadius.all(
//                                           Radius.circular(10),
//                                         ),
//                                         color:
//                                             Color.fromRGBO(244, 239, 246, 1)),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         Expanded(
//                           child: SingleChildScrollView(
//                             scrollDirection: Axis.vertical,
//                             child: Column(
//                               children: [
//                                 Container(
//                                   margin: marginLeftRight16,
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         "Learning Outcomes",
//                                         style: sectionTitleTextStyle,
//                                       ),
//                                       Text(
//                                         "Cleared Concepts",
//                                         style: sectionTitleTextStyle,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Container(
//                                   // height: 254,
//                                   margin: const EdgeInsets.all(16),
//                                   padding: const EdgeInsets.only(
//                                       top: 20, left: 20, right: 20),
//                                   decoration: const BoxDecoration(
//                                     borderRadius: BorderRadius.all(
//                                       Radius.circular(10),
//                                     ),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: colorDropShadowLight,
//                                         offset: Offset(
//                                           1.0,
//                                           1.0,
//                                         ),
//                                         blurRadius: 1.0,
//                                         spreadRadius: 0.0,
//                                       ),
//                                       BoxShadow(
//                                         color: Colors.white,
//                                         offset: Offset(0.0, 0.0),
//                                         blurRadius: 0.0,
//                                         spreadRadius: 0.0,
//                                       ),
//                                     ],
//                                     // color: Colors.amber,
//                                   ),
//                                   child: Column(
//                                     children: [
//                                       SizedBox(
//                                         height: 214,
//                                         child: BarChart(
//                                           BarChartData(
//                                             maxY: 100,
//                                             borderData: FlBorderData(
//                                               border: const Border(
//                                                   top: BorderSide.none,
//                                                   right: BorderSide.none,
//                                                   left: BorderSide.none,
//                                                   bottom: BorderSide.none),
//                                             ),
//                                             titlesData: FlTitlesData(
//                                               leftTitles: SideTitles(
//                                                 interval: 25,
//                                                 showTitles: true,
//                                                 getTextStyles:
//                                                     (context, value) {
//                                                   return const TextStyle(
//                                                       color: colorPink,
//                                                       fontSize: 8,
//                                                       fontFamily:
//                                                           fontFamilyNunito,
//                                                       fontWeight:
//                                                           FontWeight.bold);
//                                                 },
//                                               ),
//                                               bottomTitles: SideTitles(
//                                                 showTitles: true,
//                                                 getTextStyles:
//                                                     (context, value) {
//                                                   return const TextStyle(
//                                                       color: Color.fromRGBO(
//                                                           181, 181, 181, 1),
//                                                       fontSize: 8,
//                                                       fontFamily:
//                                                           fontFamilyNunito,
//                                                       fontWeight:
//                                                           FontWeight.bold);
//                                                 },
//                                                 getTitles: (double value) {
//                                                   switch (value.toInt()) {
//                                                     case 0:
//                                                       return '1A\nEnglish';
//                                                     case 1:
//                                                       return '1A\nMaths';
//                                                     case 2:
//                                                       return '2A\nEnglish';
//                                                     case 3:
//                                                       return '2A\nMaths';
//                                                     case 4:
//                                                       return '3A\nEnglish';
//                                                     case 5:
//                                                       return '3A\nMaths';
//                                                     default:
//                                                       return '';
//                                                   }
//                                                 },
//                                               ),
//                                               topTitles:
//                                                   SideTitles(showTitles: false),
//                                               rightTitles:
//                                                   SideTitles(showTitles: false),
//                                             ),
//                                             barGroups: [
//                                               BarChartGroupData(x: 0, barRods: [
//                                                 BarChartRodData(
//                                                     y: 84,
//                                                     width: 15,
//                                                     colors: [
//                                                       colorGDOrangeDark,
//                                                       colorGDOrangeLight
//                                                     ]),
//                                               ]),
//                                               BarChartGroupData(x: 1, barRods: [
//                                                 BarChartRodData(
//                                                     y: 50,
//                                                     width: 15,
//                                                     colors: [
//                                                       colorGDSkyDark,
//                                                       colorGDSkyLight
//                                                     ]),
//                                               ]),
//                                               BarChartGroupData(x: 2, barRods: [
//                                                 BarChartRodData(
//                                                     y: 50,
//                                                     width: 15,
//                                                     colors: [
//                                                       colorGDOrangeDark,
//                                                       colorGDOrangeLight
//                                                     ]),
//                                               ]),
//                                               BarChartGroupData(x: 3, barRods: [
//                                                 BarChartRodData(
//                                                     y: 42,
//                                                     width: 15,
//                                                     colors: [
//                                                       colorGDSkyDark,
//                                                       colorGDSkyLight
//                                                     ]),
//                                               ]),
//                                               BarChartGroupData(x: 4, barRods: [
//                                                 BarChartRodData(
//                                                     y: 99,
//                                                     width: 15,
//                                                     colors: [
//                                                       colorGDOrangeDark,
//                                                       colorGDOrangeLight
//                                                     ]),
//                                               ]),
//                                               BarChartGroupData(x: 5, barRods: [
//                                                 BarChartRodData(
//                                                     y: 75,
//                                                     width: 15,
//                                                     colors: [
//                                                       colorGDSkyDark,
//                                                       colorGDSkyLight
//                                                     ]),
//                                               ]),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       Container(
//                                         alignment: AlignmentDirectional.topEnd,
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.end,
//                                           children: [
//                                             const Text(
//                                               "View More",
//                                               style: TextStyle(
//                                                   fontSize: 12,
//                                                   fontFamily: fontFamilyNunito,
//                                                   color: colorPink),
//                                             ),
//                                             Transform.rotate(
//                                               angle: 180 * pi / 180,
//                                               child: IconButton(
//                                                 onPressed: () => {
//                                                   Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                       builder: (context) =>
//                                                           const WorkSheetPage(),
//                                                       settings:
//                                                           const RouteSettings(
//                                                         name: roadMapRoute,
//                                                       ),
//                                                     ),
//                                                   )
//                                                   // Navigator.pushNamed(
//                                                   //   context,
//                                                   //   '/' + worksheetRoute,
//                                                   // )
//                                                 },
//                                                 icon: const Icon(
//                                                     Icons.arrow_back_outlined),
//                                                 iconSize: iconSize36 / 2,
//                                                 color: sectionTitleColor,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Container(
//                                   alignment: AlignmentDirectional.topStart,
//                                   margin: marginLeftRight16,
//                                   child: Text(
//                                     "Uncleared Concept (14)",
//                                     style: sectionTitleTextStyle,
//                                   ),
//                                 ),
//                                 SingleChildScrollView(
//                                   padding: const EdgeInsets.only(left: 16),
//                                   scrollDirection: Axis.horizontal,
//                                   child: Row(
//                                     children: [
//                                       Container(
//                                         margin: const EdgeInsets.only(top: 10),
//                                         width: (unClearedConceptCardWidth * 3) +
//                                             30,
//                                         child: Wrap(
//                                           direction: Axis.horizontal,
//                                           children: [
//                                             {
//                                               "title":
//                                                   "Algebraic Expressions and Identities",
//                                               "subject": "Science"
//                                             },
//                                             {
//                                               "title":
//                                                   "Multiplying a Monomial by a Monomial",
//                                               "subject": "Maths"
//                                             },
//                                             {
//                                               "title":
//                                                   "Multiplying a Monomial by a Monomial",
//                                               "subject": "Maths"
//                                             },
//                                             {
//                                               "title":
//                                                   "Multiplying a Monomial by a Monomial",
//                                               "subject": "Maths"
//                                             },
//                                             {
//                                               "title":
//                                                   "Algebraic Expressions and Identities",
//                                               "subject": "Science"
//                                             },
//                                             {
//                                               "title":
//                                                   "Multiplying a Monomial by a Monomial",
//                                               "subject": "Maths"
//                                             },
//                                           ]
//                                               .map(
//                                                 (value) => Card(
//                                                   shape: RoundedRectangleBorder(
//                                                     side: const BorderSide(
//                                                         color: colorDropShadow,
//                                                         width: 1),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             14),
//                                                   ),
//                                                   child: Container(
//                                                     height:
//                                                         unClearedConceptCardHeight,
//                                                     width:
//                                                         unClearedConceptCardWidth,
//                                                     padding:
//                                                         const EdgeInsets.all(5),
//                                                     decoration:
//                                                         const BoxDecoration(
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .all(
//                                                               Radius.circular(
//                                                                   14),
//                                                             ),
//                                                             color:
//                                                                 Colors.white),
//                                                     child: Column(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .start,
//                                                       children: [
//                                                         Text(
//                                                           value["title"]!,
//                                                           style:
//                                                               webPanelDarkText14RegularStyle,
//                                                           maxLines: 2,
//                                                           overflow: TextOverflow
//                                                               .ellipsis,
//                                                         ),
//                                                         Container(
//                                                           margin:
//                                                               const EdgeInsets
//                                                                   .only(top: 5),
//                                                           alignment:
//                                                               AlignmentDirectional
//                                                                   .centerStart,
//                                                           child: Text(
//                                                             value["subject"]!,
//                                                             style:
//                                                                 textTitle8darkText8SemiBoldStyle,
//                                                           ),
//                                                         ),
//                                                         Container(
//                                                           alignment:
//                                                               AlignmentDirectional
//                                                                   .centerEnd,
//                                                           // color: Colors.amber,
//                                                           height: 32,
//                                                           child: Image.asset(
//                                                               imageAssets +
//                                                                   'uranus.png'),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                               )
//                                               .toList(),
//                                         ),
//                                       ),
//                                       Container(
//                                         height: unClearedConceptCardHeight,
//                                         width: unClearedConceptCardWidth,
//                                         alignment: AlignmentDirectional.center,
//                                         margin: const EdgeInsets.only(
//                                             left: 10, right: 10),
//                                         decoration: const BoxDecoration(
//                                           gradient: purpleGradient,
//                                           borderRadius: BorderRadius.all(
//                                             Radius.circular(14),
//                                           ),
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color: colorDropShadowLight,
//                                               offset: Offset(
//                                                 1.0,
//                                                 1.0,
//                                               ),
//                                               blurRadius: 1.0,
//                                               spreadRadius: .0,
//                                             ),
//                                           ],
//                                         ),
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             Text(
//                                               "View More",
//                                               style: textTitle22WhiteBoldStyle,
//                                             ),
//                                             Container(
//                                               width: unClearedConceptCardWidth,
//                                               margin:
//                                                   const EdgeInsets.only(top: 5),
//                                               alignment:
//                                                   AlignmentDirectional.center,
//                                               child: Container(
//                                                 height: iconSize36,
//                                                 width: iconSize36,
//                                                 decoration: const BoxDecoration(
//                                                   // color: colorGDPinkDark,
//                                                   borderRadius:
//                                                       BorderRadius.all(
//                                                     Radius.circular(
//                                                         iconSize36 / 2),
//                                                   ),
//                                                   color: Colors.white,
//                                                 ),
//                                                 child: Transform.rotate(
//                                                   angle: 180 * pi / 180,
//                                                   child: IconButton(
//                                                     onPressed: () => {
//                                                       Navigator.push(
//                                                         context,
//                                                         MaterialPageRoute(
//                                                           builder: (context) =>
//                                                               const WorkSheetPage(),
//                                                           settings:
//                                                               const RouteSettings(
//                                                             name: roadMapRoute,
//                                                           ),
//                                                         ),
//                                                       )
//                                                       // Navigator.pushNamed(
//                                                       //   context,
//                                                       //   '/' + worksheetRoute,
//                                                       // )
//                                                     },
//                                                     icon: const Icon(Icons
//                                                         .arrow_back_outlined),
//                                                     iconSize: 20,
//                                                     color: colorSkyDark,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Stack(
//                                   children: [
//                                     Container(
//                                       alignment: AlignmentDirectional.topEnd,
//                                       child: SvgPicture.asset(
//                                         imageAssets + 'globechild.svg',
//                                         // allowDrawingOutsideViewBox: true,
//                                         height: 200,
//                                         width: 200,
//                                       ),
//                                     ),
//                                     Column(
//                                       children: [
//                                         Container(
//                                           alignment:
//                                               AlignmentDirectional.centerStart,
//                                           margin: const EdgeInsets.only(
//                                               top: 10,
//                                               bottom: 10,
//                                               left: 16,
//                                               right: 16),
//                                           child: Text(
//                                             "Pending (20)",
//                                             style: sectionTitleTextStyle,
//                                           ),
//                                         ),
//                                         Container(
//                                           alignment:
//                                               AlignmentDirectional.centerStart,
//                                           margin: marginLeftRight16,
//                                           child: Row(
//                                             children: const [
//                                               PendingCards(
//                                                   title: 'Precap',
//                                                   count: 06,
//                                                   gradient: skyBlueGradient,
//                                                   icon: 'precap.svg'),
//                                               PendingCards(
//                                                   title: 'CW',
//                                                   count: 10,
//                                                   gradient: greenGradient,
//                                                   icon: 'cw.svg'),
//                                               PendingCards(
//                                                   title: 'HW',
//                                                   count: 04,
//                                                   gradient: purpleGradient,
//                                                   icon: 'hw.svg')
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 Column(
//                                   children: [
//                                     Container(
//                                       alignment:
//                                           AlignmentDirectional.centerStart,
//                                       margin: const EdgeInsets.only(
//                                           top: 10,
//                                           bottom: 10,
//                                           left: 16,
//                                           right: 16),
//                                       child: Text(
//                                         "Books (${dashBoardController.subjectModel.value.data!.length})",
//                                         style: sectionTitleTextStyle,
//                                       ),
//                                     ),
//                                     Container(
//                                       margin: const EdgeInsets.only(
//                                           left: 6, right: 16, bottom: 16),
//                                       child: SingleChildScrollView(
//                                         scrollDirection: Axis.horizontal,
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: dashBoardController
//                                               .subjectModel.value.data!
//                                               .map((item) => GestureDetector(
//                                                     onTap: () => {
//                                                       dashBoardController
//                                                           .getChapters(
//                                                               context, item),
//                                                     },
//                                                     child: BooksOldCards(
//                                                       learn: false,
//                                                       title: item.name ?? "",
//                                                       booksData: const [
//                                                         {
//                                                           "id": 1,
//                                                           "title": "cw",
//                                                           "count": "3",
//                                                         },
//                                                         {
//                                                           "id": 2,
//                                                           "title": "precap",
//                                                           "count": "2",
//                                                         },
//                                                         {
//                                                           "id": 3,
//                                                           "title": "hw",
//                                                           "count": "1",
//                                                         }
//                                                       ],
//                                                     ),
//                                                   ))
//                                               .toList(),
//                                         ),
//                                       ),
//                                     ),
//                                     Container(
//                                       alignment:
//                                           AlignmentDirectional.centerStart,
//                                       margin: const EdgeInsets.only(
//                                           top: 10,
//                                           bottom: 10,
//                                           left: 16,
//                                           right: 16),
//                                       child: Text(
//                                         "Weekly Progress",
//                                         style: sectionTitleTextStyle,
//                                       ),
//                                     ),
//                                     Container(
//                                       margin: const EdgeInsets.only(
//                                         left: 6,
//                                         right: 16,
//                                       ),
//                                       child: Column(
//                                         children: [
//                                           Row(
//                                             children: const [
//                                               WeeklyProgressCard(
//                                                   id: 1,
//                                                   title: 'Videos',
//                                                   subtitle: "4 Viewed",
//                                                   progress: 100),
//                                               WeeklyProgressCard(
//                                                   id: 2,
//                                                   title: 'Exam',
//                                                   subtitle: "4 Viewed",
//                                                   progress: 30),
//                                             ],
//                                           ),
//                                           Row(
//                                             children: const [
//                                               WeeklyProgressCard(
//                                                   id: 3,
//                                                   title: 'Classwork',
//                                                   subtitle: "10 Completed",
//                                                   progress: 80),
//                                               WeeklyProgressCard(
//                                                   id: 4,
//                                                   title: 'Homework',
//                                                   subtitle: "8 Completed",
//                                                   progress: 42),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     Card(
//                                       margin: const EdgeInsets.only(
//                                           left: 16, bottom: 10, right: 16),
//                                       shape: RoundedRectangleBorder(
//                                         side: const BorderSide(
//                                             color: colorDropShadow, width: 1),
//                                         borderRadius: BorderRadius.circular(14),
//                                       ),
//                                       child: Container(
//                                         padding: const EdgeInsets.all(10),

//                                         // height: 64,
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 Row(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.center,
//                                                   children: [
//                                                     Container(
//                                                       margin:
//                                                           const EdgeInsets.only(
//                                                               right: 5),
//                                                       alignment:
//                                                           AlignmentDirectional
//                                                               .center,
//                                                       child: IconButton(
//                                                         padding:
//                                                             EdgeInsets.zero,
//                                                         icon: const Icon(
//                                                           Icons.schedule,
//                                                         ),
//                                                         iconSize: 29,
//                                                         color: colorOrange,
//                                                         onPressed: () {},
//                                                       ),
//                                                     ),
//                                                     Text(
//                                                       "Total Time Spent",
//                                                       style: textTitle18WhiteBoldStyle
//                                                           .merge(const TextStyle(
//                                                               color:
//                                                                   colorText)),
//                                                       maxLines: 1,
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 Text(
//                                                   "1h 14m",
//                                                   style: textTitle22WhiteBoldStyle
//                                                       .merge(const TextStyle(
//                                                           color:
//                                                               sectionTitleColor,
//                                                           fontWeight:
//                                                               FontWeight.w700)),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         FooterMenu(
//                           notifyParent: refresh,
//                           route: homeRoute,
//                         )
//                       ],
//                     ),
//                   ),
//           ),
//         ),
//       ),
//     );
//   }

//   refresh() {
//     setState(() {});
//   }
// }
