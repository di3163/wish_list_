import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_list_gx/controllers/home_controller.dart';
import 'package:wish_list_gx/core.dart';

class BottomSheetSetting extends StatelessWidget {
  BottomSheetSetting({Key? key}) : super(key: key);
  final _homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Get.theme.disabledColor.withOpacity(0.3),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
      ),
      height: 400,
      child: Column(
        children: [
          const SizedBox(height: 20),
        Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('light_shampoo' .tr, style: Get.theme.primaryTextTheme.button),
              const SizedBox(width: 30),
              Obx(() =>
                  Switch(
                  value: _homeController.isThemeLightShampoo.value,
                  onChanged: (bool newValue) {
                    _homeController.onSwitchThemeMode();
                    _homeController.isThemeLightShampoo.value = newValue;
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
              Text('black_crows' .tr, style: Get.theme.primaryTextTheme.button),
              const SizedBox(width: 30),
              Obx(() =>
                  Switch(
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
                  child: Text('change_locale'.tr, style: Get.theme.primaryTextTheme.button),
              ),
              const SizedBox(width: 30),
              IconButton(
                  onPressed: () => _homeController.onSwitchLocale(),
                  icon: Icon(iconGlob, size: 30, color: Get.theme.focusColor,)),
              const SizedBox(width: 20),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Get.find<UserProfileController>().addAvatar(),
                child: Text('change_avatar'.tr, style: Get.theme.primaryTextTheme.button),
              ),
              const SizedBox(width: 30),
              IconButton(
                  onPressed: () => Get.find<UserProfileController>().addAvatar(),
                  icon: Icon(iconCamera, size: 30, color: Get.theme.focusColor,)),
              const SizedBox(width: 20),
            ],
          ),
        // Row(
        //   children:[
        // Obx(() => DropdownButton<ThemeApp>(
        //   value: ThemeApp.Shampoo,
        //   icon: const Icon(Icons.arrow_downward),
        //   iconSize: 24,
        //   elevation: 16,
        //   style: const TextStyle(color: Colors.deepPurple),
        //   underline: Container(
        //     height: 2,
        //     color: Colors.deepPurpleAccent,
        //   ),
        //   onChanged: (ThemeApp? newValue) {
        //     _homeController.themeApp.value = newValue!;
        //   },
        //   items: ThemeApp.values.map((ThemeApp value) {
        //     return DropdownMenuItem<ThemeApp>(
        //       value: value,
        //       child: Text(value.toString()),
        //     );
        //   }).toList(),
        // ))])
        ]
      ),
    );
  }

  // Widget _dropDownBut() {
  //   return Obx(() => DropdownButton<ThemeApp>(
  //         value: ThemeApp.Shampoo,
  //         icon: const Icon(Icons.arrow_downward),
  //         iconSize: 24,
  //         elevation: 16,
  //         style: const TextStyle(color: Colors.deepPurple),
  //         underline: Container(
  //           height: 2,
  //           color: Colors.deepPurpleAccent,
  //         ),
  //         onChanged: (ThemeApp? newValue) {
  //           _homeController.themeApp.value = newValue!;
  //         },
  //         items: ThemeApp.values.map((ThemeApp value) {
  //           return DropdownMenuItem<ThemeApp>(
  //             value: value,
  //             child: Text(value.toString()),
  //           );
  //         }).toList(),
  //       ));
  // }
}


