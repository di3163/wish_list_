import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';



class RegisterForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GetX<UserProfileController>(
        builder: (UserProfileController userProfileController){
          return userProfileController.appFormWidget.value.render();
        },
      ),
    );
  }
}





