import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/outline_indicator.dart';

import '../../theme/colors.dart';
import '../../theme/style.dart';

class PendingCompletedTab extends StatefulWidget {
  final TabController? tabController;

  const PendingCompletedTab({Key? key, required this.tabController}) : super(key: key);

  @override
  _PendingCompletedTabState createState() => _PendingCompletedTabState();
}

class _PendingCompletedTabState extends State<PendingCompletedTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.h,
      child: TabBar(
        isScrollable: true,
        controller: widget.tabController,
        labelStyle: textTitle14BoldStyle.merge(const TextStyle(fontWeight: FontWeight.w600)),
        labelColor: colorPurple,
        unselectedLabelStyle: textTitle14BoldStyle.merge(const TextStyle(fontWeight: FontWeight.w600)),
        unselectedLabelColor: colorText163Gray,
        indicator: const OutlineIndicator(color: colorPurple, strokeWidth: 4, radius: Radius.circular(10)),
        indicatorSize: TabBarIndicatorSize.label,
        // indicatorWeight: 10,
        tabs: const [
          Tab(
            text: 'Pending',
          ),
          Tab(
            text: 'Completed',
          ),
        ],
      ),
    );
  }
}
