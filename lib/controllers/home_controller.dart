import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController{
  final pageController = PageController();
  final animationDuration = Duration(milliseconds: 300);

  var tabIndex = 0;

  void changeTabIndex(int index) {
    tabIndex = index;
    update();
  }

}