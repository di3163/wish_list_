import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';

class WishView extends StatelessWidget {
  const WishView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
          appBar: AppBar(
            shape: const ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: GetX<WishListController>(
                  builder: (WishListController wishListController) {
                return wishListController.currentWishWidget.value;
              }),
            ),
          )),
    );
  }

  Future<bool> _onBackPressed(BuildContext context) async {
    return Get.find<WishController>().isChanged
        ? await showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogBox(
                title: 'save'.tr,
                onClickAction: () async {
                  await Get.find<WishController>().updateWish();
                  return Navigator.of(context).pop(true);
                },
                onCancelAction: () => Navigator.of(context).pop(true),
              );
            },
          )
        : _onNoChanged();
  }

  Future<bool> _onNoChanged() async {
    return Future.delayed(const Duration(microseconds: 10), () {
      return true;
    });
  }
}
