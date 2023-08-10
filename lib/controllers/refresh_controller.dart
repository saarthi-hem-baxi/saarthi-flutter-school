import 'package:get/state_manager.dart';

class RefreshController extends GetxController {
  RxBool refreshHomeWork = false.obs;
  RxBool refreshRoadmap = false.obs;

  void refreshHomeworkkData() {
    refreshHomeWork.value = !refreshHomeWork.value;
  }

  void refreshRoadmapData() {
    refreshRoadmap.value = !refreshRoadmap.value;
  }
}
