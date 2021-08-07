import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wish_list_gx/core.dart';


class HomeView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

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
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(10))
          ),
          child: BottomNavyBar(
            selectedIndex: controller.tabIndex,
            onItemSelected: (index) {
              controller.tabIndex = index;
              controller.changeTabIndex(index, Get.find<UserProfileController>().user.value);
              controller.pageController.jumpToPage(index);
            },
            items: AppTab.values.map((tab) {
              return BottomNavyBarItem(
                icon: tab.appTabIcon(),
                title: Text(tab.localization()),
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
