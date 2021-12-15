import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:wish_list_gx/core.dart';

abstract class WishWidget extends StatelessWidget{
  const WishWidget({Key? key}) : super(key: key);
}

class ErrWishWidget extends WishWidget{
  const ErrWishWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
      child: Center(
        child: LineIcon.exclamationCircle(size: 30,),
      ),
    );
  }
}

class OtherWishWidget extends WishWidget{

  const OtherWishWidget({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WishController>();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            GetBuilder<WishController>(
              id: 'images',
              builder: (controller) => const _WishImages(),
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                    child: Text(
                      controller.currentWish.title,
                    )
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                    child: Text(
                      controller.currentWish.description!,
                    )
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                  child: Text(
                    controller.currentWish.link!,
                  ),
                ),
                controller.currentWish.link!.isNotEmpty
                    ? IconButton(
                      onPressed: () =>
                        UrlLaunch.launchURL(controller.currentWish.link!),
                      icon: const Icon(iconView),
                      color: Get.theme.hintColor,
                    ) : const SizedBox(width: 1,)
              ],
            ),
          ]
      ),
    );
  }

}

class ControlWidget extends StatefulWidget {
  const ControlWidget({Key? key, required this.controller}) : super(key: key);
  final WishController controller;

  @override
  _ControlWidgetState createState() => _ControlWidgetState();

}

class _ControlWidgetState extends State<ControlWidget> {

  @override
  void deactivate(){
    super.deactivate();
    if (widget.controller.isChanged){
      showDialog(context: context,
        builder: (BuildContext context){
          return DialogBox(
            title: 'save'.tr,
            onClickAction: () async{
              await widget.controller.updateWish();
              Get.back();
            },
            onCancelAction: () => Get.back(),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 10);
  }
}



class UserWishWidget extends WishWidget{

  const UserWishWidget({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WishController>();
    return Padding(
        padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10),
          //ControlWidget(controller: controller),
          GetBuilder<WishController>(
            id: 'images',
            builder: (controller) => const _WishImages(),
          ),
          const SizedBox(
            height: 10,
          ),
          controller.listImgT.isNotEmpty ?
          Row(
              children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => controller.addImage(),
                child: const Icon(iconCameraSt),
              ),
            ),
          ]) :
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (_) => controller.isChanged = true,
                  controller:
                  controller.controllerTitle.value,
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
                onChanged: (_) => controller.isChanged = true,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: controller
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
                // child: GestureDetector(
                //   onLongPress: (){
                //     if (controller.currentWish.link!.isNotEmpty) {
                //       html.window.open(controller.currentWish.link!, '');
                //     }
                //   },
                  child: TextField(
                    onChanged: (_) => controller.isChanged = true,
                    controller:
                    controller.controllerLink.value,
                    decoration: InputDecoration(labelText: 'wish_link'.tr),
                  ),
                ),
              controller.currentWish.link!.isNotEmpty
                    ? IconButton(
                        onPressed: () =>
                          UrlLaunch.launchURL(controller.currentWish.link!),
                        icon: const Icon(iconView),
                        color: Get.theme.hintColor,
                  ) :
                  const SizedBox(width: 1,)
            ],
          ),
          !controller.currentWish.isSaved ?
          Row(children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => controller.saveWish(),
                child: const Icon(iconAdd),
              ),
            ),
          ]):
          const SizedBox(height: 20)
        ],
      ),
    );
  }
}



class _WishImages extends StatelessWidget {
  const _WishImages({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WishController>();
    return ValueBuilder<int?>(
        initialValue: 0,
        builder: (currentImage, updateFn) => Column(
              children: [
                controller.listImgT.isEmpty
                    ? IconButton(
                        icon: const Icon(iconCameraSt),
                        color: Get.theme.focusColor,
                        iconSize: 100,
                        onPressed: () => controller.addImage(),
                      )
                    : Container(
                        height: 150,
                        child: PageView(
                          physics: const BouncingScrollPhysics(),
                          onPageChanged: updateFn,
                          children: controller.listImgT.map((patch) {
                            return _ImgContainer(patch: patch);
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
                              .map((image) => _ImgIndicator(
                                  isActive:
                                      controller.listImgT.indexOf(image) ==
                                          currentImage))
                              .toList(),
                        ),
                      )
                    : const SizedBox(height: 30),
              ],
            ));
  }
}

class _ImgContainer extends StatelessWidget {
  final String patch;


  const _ImgContainer({Key? key, required this.patch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WishController>();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: () => Get.toNamed(
                '/img',
              arguments: patch
            ),
                //Get.find<WishListController>().fullImgShow(patch),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: controller.currentWish.isSaved
                  ? CachedNetworkImage(
                      imageUrl: patch,
                      fit: BoxFit.scaleDown,
                      placeholder: (context, url) => Icon(
                        iconCameraSt,
                        size: 100,
                        color: Get.theme.focusColor,
                      ),
                      errorWidget: (context, url, error) =>
                          LineIcon.exclamationCircle(
                        size: 100,
                      ),
                    )
                  : Image.file(
                      File(patch),
                      fit: BoxFit.scaleDown,
                    ),
            ),
          ),
        ),
        Column(
            children: [
          Get.find<WishListController>().user.userStatus != UserStatus.other
              ? GestureDetector(
                  onTap: () => controller.deleteImage(patch),
                  child: Container(
                    height: 40,
                    width: 40,
                    //color: Colors.blue[600],
                    child: Icon(
                      iconDelete,
                      size: 30,
                      color: Get.theme.focusColor,
                    ),
                    //Icons.delete_forever_outlined,
                  ),
                )
              : Container(),
        ]),
      ],
    );
  }
}

class _ImgIndicator extends StatelessWidget {
  final bool isActive;

  const _ImgIndicator({Key? key, required this.isActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}

