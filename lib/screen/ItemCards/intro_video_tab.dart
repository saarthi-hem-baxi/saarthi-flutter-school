import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/outline_indicator.dart';

import '../../theme/colors.dart';
import '../../theme/style.dart';

class IntroVideoTab extends StatefulWidget {
  final TabController? tabController;

  const IntroVideoTab({Key? key, required this.tabController})
      : super(key: key);

  @override
  _IntroVideoTabState createState() => _IntroVideoTabState();
}

class _IntroVideoTabState extends State<IntroVideoTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: 70.h,
      child: TabBar(
        isScrollable: true,
        controller: widget.tabController,
        labelStyle: textTitle14BoldStyle
            .merge(const TextStyle(fontWeight: FontWeight.w600)),
        labelColor: Colors.white,
        unselectedLabelStyle: textTitle14BoldStyle
            .merge(const TextStyle(fontWeight: FontWeight.w600)),
        unselectedLabelColor: colorWebPanelDarkText,
        indicatorPadding:   EdgeInsets.only(top: MediaQuery.of(context).orientation == Orientation.landscape? 20 :0),
        indicator: const OutlineIndicator(
            color: colorSky, strokeWidth: 4, radius: Radius.circular(10)),
        indicatorSize: TabBarIndicatorSize.label,
        // indicatorWeight: 10,
        tabs: const [
          Tab(
            text: 'English',
          ),
          Tab(
            text: 'Hindi',
          ),
        ],
      ),
    );


  }
}
