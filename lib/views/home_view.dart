import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wish_list_gx/core.dart';





class HomeView extends StatelessWidget {
  final UserController _userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    //HomeController homeController = Get.put(HomeController());
    //HomeController homeController = Get.find();

    return Scaffold(
      body: PageView(
        //controller: homeController.pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          //Get.find<UserController>().userStatus == UserStatus.authenticated ?
          _selectView(),
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
            onItemSelected: (index) => controller.changeTabIndex(index),
            items: AppTab.values.map((tab) {
              return BottomNavyBarItem(
                icon: tab.appTabIcon(),
                title: Text(tab.localization()),
              );
            }).toList(),

          ),
        ),
      ),
    );
  }

  Widget _selectView() {
    if (_userController.userStatus.value == UserStatus.unauthenticated){
      return ProfileView();
    }

    return ProfileView();
  //   if (uiAppState.addWish){
  //     return WishView();
  //   }
  //   if (uiAppState.activeTab == AppTab.ContactView) {
  //     return ContactView();
  //   } else if(uiAppState.activeTab == AppTab.MyListView) {
  //     return MyListView();
  //   }else{
  //     return ProfileView();
  //   }
  }
}
