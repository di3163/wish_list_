import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:wish_list_gx/core.dart';

class WishView extends StatelessWidget {
  //final WishController _wishController = Get.find<WishController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GetBuilder<WishController>(
                  id: 'images',
                  builder: (controller) => _buildWishImages(controller),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.find<WishController>().addImage(),
                      child: Icon(Icons.photo_camera),
                    ),
                  ),
                ]),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller:
                            Get.find<WishController>().controllerTitle.value,
                        decoration: InputDecoration(labelText: 'wish_title'.tr),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: Get.find<WishController>()
                          .controllerDescription
                          .value,
                      decoration:
                          InputDecoration(labelText: 'wish_description'.tr),
                    ),
                  ),
                ]),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller:
                            Get.find<WishController>().controllerLink.value,
                        decoration: InputDecoration(labelText: 'wish_link'.tr),
                      ),
                    ),
                  ],
                ),
                Row(children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.find<WishController>().saveWish(),
                      child: Icon(Icons.add),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ));
  }

  ValueBuilder<int?> _buildWishImages(WishController controller) {
    return ValueBuilder<int?>(
        initialValue: 0,
        builder: (currentImage, updateFn) => Column(
              children: [
                Container(
                  height: 150,
                  child: PageView(
                    physics: BouncingScrollPhysics(),
                    onPageChanged: updateFn,
                    children: controller.listImg.map((patch) {
                      return _imgContainer(patch, controller);
                    }).toList(),
                  ),
                ),
                controller.listImg.length > 1
                    ? Container(
                        height: 30,
                        margin: EdgeInsets.only(top: 12, bottom: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: controller.listImg
                              .map((image) => _buildIndicator(controller
                                      .listImg
                                      .indexOf(image) ==
                                  currentImage))
                              .toList(),
                        ),
                      )
                    : Container(),
              ],
            ));
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 6),
      height: 8,
      width: isActive ? 20 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.grey[400],
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  Container _imgContainer(String patch, WishController controller) {
    if (controller.currentWish.title.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Image.file(
          File(patch),
          fit: BoxFit.scaleDown,
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: CachedNetworkImage(
          imageUrl: patch,
          fit: BoxFit.scaleDown,
          placeholder: (context, url) => LineIcon.retroCamera(size: 100,),
          errorWidget: (context, url, error) => LineIcon.exclamationCircle(size: 100,),
        ),
        // Image.network(
        //   patch,
        //   fit: BoxFit.scaleDown,
        // ),
      );
    }
  }
}
