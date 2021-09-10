import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wish_list_gx/core.dart';

abstract class ProfileViewWidget extends StatelessWidget {}

class ProfileWidget extends ProfileViewWidget {
  @override
  Widget build(BuildContext context) {
    UserProfileController _userProfileController =
        Get.find<UserProfileController>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 30),
        ObxValue<Rx<String>>(
            (data) => GestureDetector(
                  onTap: () => _userProfileController.addAvatar(),
                  child: Material(
                    child: data.value.isEmpty
                        ? Icon(iconPerson, size: 90)
                        : CachedNetworkImage(
                            placeholder: (context, url) =>
                                CircularProgressIndicator(
                                    color: Get.theme.accentColor),
                            imageUrl: data.value,
                            errorWidget: (context, url, error) => Icon(
                                iconPerson,
                                size: 90,
                                color: Get.theme.accentColor),
                            width: 90.0,
                            height: 90.0,
                            fit: BoxFit.cover,
                          ),
                    color: Get.theme.buttonColor,
                    borderRadius: BorderRadius.all(Radius.circular(45.0)),
                    clipBehavior: Clip.hardEdge,
                  ),
                ),
            _userProfileController.avatarURL),
        SizedBox(height: 30),
        ElevatedButton(
          onPressed: () => _userProfileController.signOut(), //_signOut,
          child: Text('sign_out'.tr),
        ),
      ],
    );
  }
}

class LoginWidget extends ProfileViewWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        RegisterForm(),
      ],
    );
  }
}
