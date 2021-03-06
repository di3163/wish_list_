
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

import 'package:wish_list_gx/core.dart';


class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);
  final HomeController _homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ObxValue<Rx<AppUserWidget>>(
              (data) => data.value.appBarLeading(),
          Get.find<HomeController>().userWidget,
        ),
        title: ObxValue<Rx<AppUserWidget>>(
              (data) => data.value.appBarTitle(),
          Get.find<HomeController>().userWidget,
        ),
        actions: [
          Obx(() =>
              Visibility(

                child: IconButton(
                  icon: Icon(iconCog),
                  onPressed: () => Get.bottomSheet(BottomSheetSetting()),
                ),
                visible: Get.find<HomeController>().isVisibleSettingCog.value,
              ),
          ),
        ],

        shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)
            )
        ),
        elevation: 10,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: Get.isDarkMode?
            const DecorationImage(
              image: AssetImage('assets/images/wall_dark.png'), fit: BoxFit.cover,
            ):
            const DecorationImage(
              image: AssetImage('assets/images/wall_light.png'), fit: BoxFit.cover,
            ),
        ),
        child: PageView(
          controller: _homeController.pageController,
          physics: const BouncingScrollPhysics(),
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
      ),
      bottomNavigationBar: _BottomNavyBarWidget(),
      floatingActionButton: Obx(() =>
         Visibility(
          child: FloatingActionButton(
            child: Icon(
                iconAdd,
                color: Get.theme.focusColor,
              ),
            onPressed: () => Get.toNamed('/wish', arguments: Wish.empty()),
          ),
          visible: _homeController.isVisibleFAB.value,
        ),
      ),
    );
  }
}

class _BottomNavyBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
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
              offset: const Offset(0, 3),
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
              title: Text(tab.localization(), style: const TextStyle(fontSize: 12)),
              activeColor: Get.theme.focusColor,
              inactiveColor: Get.theme.splashColor,
            );
          }).toList(),
        ),
      ),
    );
  }
}

