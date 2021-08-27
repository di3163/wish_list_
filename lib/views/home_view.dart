
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

import 'package:wish_list_gx/core.dart';

class HomeView extends StatelessWidget {
  final _homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        //actions: [
         // ObxValue<Rx<String>>(
         //       (data) =>
                //     Container(
                //   width: 55,
                //   //height: 20,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(15),
                //   ),
                //   child: ClipOval(
                //     child: CachedNetworkImage(
                //           placeholder: (context, url) => Icon(iconPerson, size: 20, color: Get.theme.accentColor,),
                //           imageUrl: data.value,
                //           errorWidget: (context, url, error) => Icon(iconPerson, size: 20, color: Get.theme.accentColor,),
                //         fit: BoxFit.fill,
                //     ),
                //   ),
                // ),

        //    Get.find<HomeController>().avatarURL
        //),
        //],
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: const Radius.circular(20),
                bottomRight: const Radius.circular(20))),
      ),
      body: PageView(
        controller: _homeController.pageController,
        onPageChanged: (index){
          _homeController.tabIndex = index;
          if (_homeController.user.userStatus == UserStatus.other){
            _homeController.user = Get.find<UserProfileController>().user.value;
          }else{
            _homeController.onChangeTabIndex(index);
            _homeController.update();
          }
          //Get.find<HomeController>().pageController.jumpToPage(index);
          // Get.find<HomeController>().changeTabIndex(
          //     index, Get.find<UserProfileController>().user.value
          // );
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
              controller.user = Get.find<UserProfileController>().user.value;
              //controller.onChangeTabIndex(index);
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
          visible: _homeController.visibleFAB.value,
        ),
      ),
    );
  }
}
