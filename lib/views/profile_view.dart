import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wish_list_gx/core.dart';

class ProfileView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 43.0),
      child: GetBuilder<UserProfileController>(
        builder: (controller) {
          return controller.user.value.userStatus == UserStatus.authenticated ?
          _profile(controller) :  _login(controller);
        }
      )
    );
  }

  Column _profile(UserProfileController controller) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 30),

        ObxValue<Rx<String>>(
            (data) => GestureDetector(
              onTap: () => controller.addAvatar(),
              child: Material(
                child: data.value.isEmpty ?
                Icon(iconPerson, size: 90) :
                CachedNetworkImage(
                  placeholder: (context, url) => CircularProgressIndicator(color: Get.theme.accentColor),
                  imageUrl: data.value,
                  errorWidget: (context, url, error) => Icon(iconPerson, size: 90, color: Get.theme.accentColor),
                  width: 90.0,
                  height: 90.0,
                  fit: BoxFit.cover,
                ),
                color: Get.theme.buttonColor,
                borderRadius:
                BorderRadius.all(Radius.circular(45.0)),
                clipBehavior: Clip.hardEdge,
              ),
            ),
            controller.avatarURL),
          
        SizedBox(height: 30),
        ElevatedButton(
          onPressed: () => controller.signOut(), //_signOut,
          child: Text('sign_out'.tr),
        ),
      ],

    );
  }


  Widget _login(UserProfileController controller) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 20,),
          // Align(
          //   alignment: Alignment.centerLeft,
          //   child: Text(
          //     controller.formType.value == FormType.login ?
          //         'log_in' .tr : 'sign_up' .tr,
          //     textAlign: TextAlign.start,
          //   ),
          // ),
          controller.formType.value == FormType.login ?
          LoginForm(userProfileController: Get.find<UserProfileController>()) :
          RegisterForm(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                controller.formType.value == FormType.login
                    ? 'no_account'.tr
                    : 'already_registered'.tr,
              ),
              TextButton(
                key: Key('buttonRegister'),
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: controller.formType.value == FormType.login ? 'sign_up'.tr : 'log_in'.tr,
                    )
                  ],
                       style: TextStyle(color: Get.theme.disabledColor)
                    ),
                ),
                onPressed: () => controller.switchForm(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}