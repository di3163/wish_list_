import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';

abstract class AppUserWidget {
  Widget appBarLeading();
  Widget appBarTitle();
}

class OtherUserWidget extends AppUserWidget{
  String otherUserName;

  OtherUserWidget(this.otherUserName);

  @override
  Widget appBarLeading() {
    return Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(iconBack),
            onPressed: () => Get.find<HomeController>().pageController.jumpToPage(1),
          );
        }
    );
  }

  @override
  Widget appBarTitle() {
    return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Icon(iconPerson, size: 35),
      const SizedBox(width: 15,),
      Text(otherUserName, style: Get.theme.primaryTextTheme.headline6, ),
    ],
  );
  }
}

class UserWidget extends AppUserWidget{
  @override
  Widget appBarLeading() {
   return Container();
  }

  @override
  Widget appBarTitle() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(iconGifts, size: 40,),
        const SizedBox(width: 15,),
        Text('app_bar_title' .tr, style: Get.theme.primaryTextTheme.headline6, ),
      ],
    );
  }
}