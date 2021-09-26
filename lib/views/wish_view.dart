import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:wish_list_gx/core.dart';

class WishView extends StatelessWidget {
  WishView({Key? key}) : super(key: key);
  //final WishController _wishController = Get.find<WishController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
        ),

        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: Get.find<WishListController>().user.userStatus == UserStatus.other ?
              _buildOtherWish() :
              _buildUserWish(),
            ),
          ),
        ));
  }

   _buildOtherWish(){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            GetBuilder<WishController>(
              id: 'images',
              builder: (controller) => _buildWishImages(controller),
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                    child: Text(
                      Get.find<WishController>()
                          .currentWish.title,
                    )
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                    child: Text(
                      Get.find<WishController>()
                          .currentWish.description!,
                    )
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                    child: Text(
                      Get.find<WishController>()
                          .currentWish.link!,
                    )
                ),
              ],
            ),
          ]
      ),
    );
  }

  Column _buildUserWish(){
    return
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10),
          GetBuilder<WishController>(
            id: 'images',
            builder: (controller) => _buildWishImages(controller),
          ),
          const SizedBox(
            height: 10,
          ),
          Get.find<WishController>().listImgT.isNotEmpty ?
          Row(children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => Get.find<WishController>().addImage(),
                child: const Icon(iconCameraSt),
              ),
            ),
          ]) :
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (_) => Get.find<WishController>().isChanged = true,
                  controller:
                  Get.find<WishController>().controllerTitle.value,
                  decoration: InputDecoration(labelText: 'wish_title'.tr),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(children: [
            Expanded(
              child: TextField(
                onChanged: (_) => Get.find<WishController>().isChanged = true,
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
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (_) => Get.find<WishController>().isChanged = true,
                  controller:
                  Get.find<WishController>().controllerLink.value,
                  decoration: InputDecoration(labelText: 'wish_link'.tr),
                ),
              ),
            ],
          ),
          !Get.find<WishController>().currentWish.isSaved ?
          Row(children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => Get.find<WishController>().saveWish(),
                child: const Icon(iconAdd),
              ),
            ),
          ]):
            const SizedBox(height: 20)
        ],
      );

  }

  ValueBuilder<int?> _buildWishImages(WishController controller) {
    return ValueBuilder<int?>(
        initialValue: 0,
        builder: (currentImage, updateFn) => Column(
          children: [
            controller.listImgT.isEmpty ?
                IconButton(
                  icon: Icon(iconCameraSt),
                  color:  Get.theme.focusColor,
                  iconSize: 100,
                  onPressed: () => controller.addImage(),
                ) :
            Container(
              height: 150,
              child: PageView(
                physics: const BouncingScrollPhysics(),
                onPageChanged: updateFn,
                children: controller.listImgT.map((patch) {
                  return _imgContainer(patch, controller);
                }).toList(),
              ),
            ),
            controller.listImgT.isNotEmpty
                ? Container(
              height: 30,
              margin: const EdgeInsets.only(top: 12, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: controller.listImgT
                    .map((image) => _buildIndicator(controller
                    .listImgT
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
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      height: 8,
      width: isActive ? 20 : 8,
      decoration: BoxDecoration(
        color: isActive ? Get.theme.focusColor : Get.theme.disabledColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  Widget _imgContainer(String patch, WishController controller) {
    //if (!controller.currentWish.isSaved) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: controller.currentWish.isSaved?
            CachedNetworkImage(
              imageUrl: patch,
              fit: BoxFit.scaleDown,
              placeholder: (context, url) =>
              Icon(iconCameraSt, size: 100, color: Get.theme.focusColor,),
              errorWidget: (context, url, error) =>
                  LineIcon.exclamationCircle(size: 100,),
            ) :
            Image.file(
              File(patch),
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
        Column(
            children: [
          Get.find<WishListController>().user.userStatus != UserStatus.other ?
          GestureDetector(
            onTap: () => controller.deleteImage(patch),
            child: Container(
              height: 40,
              width: 40,
              //color: Colors.blue[600],
              child: Icon(iconDelete, size: 30, color: Get.theme.focusColor,),
              //Icons.delete_forever_outlined,
            ),
          ) :
          Container(),
        ]),
      ],
    );
  }
}
