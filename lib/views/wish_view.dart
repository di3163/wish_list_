
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';

class WishView extends StatelessWidget {
  const WishView({Key? key}) : super(key: key);

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
              child: GetX<WishListController>(
                builder: (WishListController wishListController){
                  return wishListController.currentWishWidget.value;
                }
              )
            ),
          ),
        ));
  }
}
