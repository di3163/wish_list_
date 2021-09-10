import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wish_list_gx/core.dart';

class ProfileView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 43.0),
        child:
        GetX<UserProfileController>(
            builder: (UserProfileController userProfileController) {
              return userProfileController.profileWidget.value;
            }
        )
    );
  }
}


