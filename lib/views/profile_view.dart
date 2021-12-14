import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wish_list_gx/core.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 43.0),
        child: GetX<UserProfileController>(
            builder: (UserProfileController userProfileController) {
              if(userProfileController.autchData.value is Exception){
                userProfileController.verificationFiled(
                    userProfileController.autchData.value,
                    userProfileController.autchData.value.stackTrace
                );
              }else if(userProfileController.autchData.value.isNotEmpty){
                userProfileController.autoVerification();
              }
              return userProfileController.profileWidget.value;
            }
        )
    );
  }
}


