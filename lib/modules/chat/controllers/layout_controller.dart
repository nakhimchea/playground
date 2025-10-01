import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LayoutController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  RxString aiModel = 'ChatGPT-4.1'.obs;

  RxBool isSidebarOpen = true.obs;
  RxBool useMobileLayout = false.obs;
  bool isMobile(double width) => width < 600;

  void toggleSidebar() {
    isSidebarOpen.value = !isSidebarOpen.value;
  }
}
