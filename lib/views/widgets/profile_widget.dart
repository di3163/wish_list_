import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wish_list_gx/core.dart';

abstract class ProfileViewWidget extends StatelessWidget {
  const ProfileViewWidget({Key? key}) : super(key: key);
}


class ProfileWidget extends ProfileViewWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProfileController _userProfileController =
        Get.find<UserProfileController>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 30),
        ObxValue<Rx<String>>(
            (data) => GestureDetector(
                  onTap: () => _userProfileController.addAvatar(),
                  child: ClipOval(
                    child: data.value.isEmpty
                        ? Icon(iconPerson, size: 110, color: Get.theme.splashColor,)
                        : CachedNetworkImage(
                            placeholder: (context, url) =>
                                CircularProgressIndicator(
                                    color: Get.theme.splashColor),
                            imageUrl: data.value,
                            errorWidget: (context, url, error) => Icon(
                                iconPerson,
                                size: 110,
                                color: Get.theme.splashColor),
                            width: 110.0,
                            height: 110.0,
                            //color: Get.theme.bottomAppBarColor,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
            _userProfileController.avatarURL),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () => _userProfileController.signOut(), //_signOut,
          child: Text('sign_out'.tr),
        ),
      ],
    );
  }
}

class LoginWidget extends ProfileViewWidget {
  const LoginWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        GetX<UserProfileController>(
          builder: (UserProfileController userProfileController){
            return userProfileController.appFormWidget.value.render();
          }
        )
        //RegisterForm(),
      ],
    );
  }
}
