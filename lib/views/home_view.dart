import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

import 'package:wish_list_gx/core.dart';

class HomeView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: const Radius.circular(20),
                bottomRight: const Radius.circular(20))),
      ),
      body: PageView(
        controller: Get.find<HomeController>().pageController,
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
          padding: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: Get.theme.bottomAppBarColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                //color: Colors.grey[600]!.withOpacity(0.5),
                color: Get.theme.shadowColor,
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
            curve: Curves.fastOutSlowIn,
            onItemSelected: (index) {
              controller.tabIndex = index;
              controller.changeTabIndex(
                  index, Get.find<UserProfileController>().user.value
              );
              controller.pageController.jumpToPage(index);
            },
            items: AppTab.values.map((tab) {
              return BottomNavyBarItem(
                icon: tab.appTabIcon(),
                title: Text(tab.localization(), style: TextStyle(fontSize: 12)),
                activeColor: Get.theme.focusColor,
                inactiveColor: Get.theme.accentColor,
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
