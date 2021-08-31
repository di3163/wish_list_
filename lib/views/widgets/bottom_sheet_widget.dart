import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_list_gx/controllers/home_controller.dart';

class BottomSheetSetting extends StatelessWidget {
  bool isSwitch = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Get.theme.disabledColor.withOpacity(0.3),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
      ),
      height: 250,
      child: Column(
        children: [
          SizedBox(height: 20),
        Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('data'),
              SizedBox(width: 30),
              Obx(() =>
                  Switch(
                  value: Get.find<HomeController>().isThemeLightShampoo.value,
                  onChanged: (bool newValue) {
                    Get.find<HomeController>().isThemeLightShampoo.value = newValue;
                  },
              ),
              ),
              SizedBox(width: 20),

            ],
          )
        ],
      ),
    );
  }
}
