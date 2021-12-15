import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wish_list_gx/core.dart';

class BottomSheetSetting extends StatelessWidget {
  const BottomSheetSetting({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final _homeController = Get.find<HomeController>();
    return Container(
      decoration: BoxDecoration(
        color: Get.theme.disabledColor.withOpacity(0.3),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
      ),
      height: 400,
      child: Column(children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('black_crows'.tr, style: Get.theme.primaryTextTheme.button),
            const SizedBox(width: 30),
            Obx(
              () => Switch(
                value: _homeController.isThemeBlackCrows.value,
                onChanged: (bool newValue) {
                  _homeController.onSwitchThemeMode();
                  _homeController.isThemeBlackCrows.value = newValue;
                },
                inactiveThumbColor: Colors.grey[200],
                inactiveTrackColor: Colors.grey[600],
                activeColor: Colors.grey[200],
                activeTrackColor: Colors.grey[600],
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => _homeController.onSwitchLocale(),
              child: Text('change_locale'.tr,
                  style: Get.theme.primaryTextTheme.button),
            ),
            const SizedBox(width: 30),
            IconButton(
                onPressed: () => _homeController.onSwitchLocale(),
                icon: Icon(
                  iconGlob,
                  size: 30,
                  color: Get.theme.focusColor,
                )),
            const SizedBox(width: 20),
          ],
        ),
        _homeController.user.userStatus == UserStatus.authenticated
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () =>
                        Get.find<UserProfileController>().addAvatar(),
                    child: Text('change_avatar'.tr,
                        style: Get.theme.primaryTextTheme.button),
                  ),
                  const SizedBox(width: 30),
                  IconButton(
                      onPressed: () =>
                          Get.find<UserProfileController>().addAvatar(),
                      icon: Icon(
                        iconCamera,
                        size: 30,
                        color: Get.theme.focusColor,
                      )),
                  const SizedBox(width: 20),
                ],
              )
            : const SizedBox(width: 20),
      ]),
    );
  }
}
