import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wish_list_gx/core.dart';


class HomeView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
      ),
      body: PageView(
        controller: Get.find<HomeController>().pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (index){
          Get.find<HomeController>().tabIndex = index;
        },
        children: [
          ProfileView(),
          ContactXView(),
          WishList(),
        ],
      ),
      bottomNavigationBar:
      GetBuilder<HomeController>(
        builder: (controller) => Container(
          padding: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: Get.theme.bottomAppBarColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                //color: Colors.grey[600]!.withOpacity(0.5),
                color: Colors.grey[600]!,
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: BottomNavyBar(
            selectedIndex: controller.tabIndex,
            showElevation: false,
            backgroundColor: Get.theme.bottomAppBarColor,
            onItemSelected: (index) {
              controller.tabIndex = index;
              controller.changeTabIndex(index, Get.find<UserProfileController>().user.value);
              controller.pageController.jumpToPage(index);
            },
            items: AppTab.values.map((tab) {
              return BottomNavyBarItem(
                icon: tab.appTabIcon(),
                title: Text(tab.localization(), style: TextStyle(fontSize: 12)),
                activeColor: Get.theme.focusColor,
                inactiveColor: Get.theme.accentColor,
                //activeColor: controller.naviBarItemColor,
              );
            }).toList(),
          ),
        ),
      ),
      floatingActionButton: Obx(() =>
         Visibility(
          child: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => Get.toNamed('/wish', arguments: Wish.empty()),
          ),
          visible: Get.find<HomeController>().visibleFAB.value,
        ),
      ),
    );
  }
}
