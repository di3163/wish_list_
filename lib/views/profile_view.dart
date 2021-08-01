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
          return controller.userStatus.value == UserStatus.authenticated ?
          _profile() :  _login(controller);
        }
      )
    );
  }

  Column _profile() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 30),
        Text('user'),
        SizedBox(height: 30),
        ElevatedButton(
          onPressed: () => Get.find<UserProfileController>().signOut(), //_signOut,
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
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              controller.formType.value == FormType.login ?
                  'log_in' .tr : 'sign_up' .tr,
              textAlign: TextAlign.start,
            ),
          ),
          controller.formType.value == FormType.login ?
          LoginForm(userProfileController: Get.find<UserProfileController>()) :
          RegisterForm(userProfileController: Get.find<UserProfileController>()),
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
                  ],style: TextStyle(color: Colors.grey)),
                ),
                onPressed: () => controller.switchForm(),
              ),
            ],
          ),
          //_formType == FormType.login ? LoginForm() : RegisterForm(),

        ],
      ),
    );
  }
}