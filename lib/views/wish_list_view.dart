import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:line_icons/line_icon.dart';
import 'package:wish_list_gx/core.dart';

class WishList extends StatelessWidget {
  const WishList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<WishListController>(
          builder: (WishListController wishListController){
            if(wishListController.listWish.value.isNotEmpty){
              return const _ListViewWish();
            }else {
              return Center(child: Text('empty_list'.tr));
            }
          }
    );
  }
}

class _ListViewWish extends StatelessWidget {
  const _ListViewWish({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GetX<WishListController>(
        builder: (WishListController wishListController) {
          return ListView.builder(
            key: PageStorageKey(key),
            itemCount: wishListController.listWish.value.length,
            itemBuilder: (_, index) =>
                ListTile(
                  onTap: () =>
                      Get.toNamed(
                        '/wish',
                        arguments: wishListController.listWish.value[index],
                      ),
                  onLongPress: () {
                    DialogBox(
                      title: 'del'.tr,
                      onClickAction: () {
                        wishListController
                            .deleteWish(
                            wishListController.listWish.value[index]);
                        Get.back();
                      },
                      onCancelAction: () => Get.back(),
                    );
                    // Get.defaultDialog(
                    //   title: 'del'.tr,
                    //   backgroundColor: Get.theme.backgroundColor,
                    //   buttonColor: Get.theme.bottomAppBarColor,
                    //   onConfirm: () {
                    //     wishListController
                    //         .deleteWish(
                    //         wishListController.listWish.value[index]);
                    //     Get.back();
                    //   },
                    //   onCancel: () => Get.back(),
                    //   middleText: '',
                    // );

                    // AppDialog(
                    //     titleText: 'del'.tr,
                    //     confirm: () {
                    //       wishListController
                    //           .deleteWish(wishListController.listWish.value[index]);
                    //     },
                    //     ).getDialog();
                  },

                  //wishListController.deleteWish(wishListController.listWish.value[index]),
                  leading: wishListController.listWish.value[index].listPicURL
                      .isEmpty ?
                  Icon(iconCameraSt, size: 30, color: Get.theme.focusColor,) :
                  CachedNetworkImage(
                    imageUrl: wishListController.listWish.value[index]
                        .listPicURL[0],
                    imageBuilder: (context, imageProvider) =>
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(5),
                                bottom: Radius.circular(5)),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                    placeholder: (context, url) =>
                        LineIcon.retroCamera(size: 30,),
                    errorWidget: (context, url, error) =>
                        LineIcon.exclamationCircle(size: 30,),
                  ),
                  title: Text(
                    wishListController.listWish.value[index].title,
                    style: const TextStyle(fontSize: 18),
                  ),
                  subtitle: const Text(''),
                  trailing: IconButton(
                    onPressed: () {
                      showDialog(context: context,
                          builder: (BuildContext context){
                              return DialogBox(
                                title: 'del'.tr,
                                onClickAction: () {
                                  wishListController
                                    .deleteWish(
                                  wishListController.listWish.value[index]);
                                  Get.back();
                                },
                                onCancelAction: () => Get.back(),
                              );
                            },
                          );


                      // AppDialog(
                      //     titleText: 'del'.tr,
                      //     confirm: () { wishListController
                      //              .deleteWish(
                      //             wishListController.listWish.value[index]);
                      //       },
                      //     ).getDialog();

                      // Get.defaultDialog(
                      //   title: 'del'.tr,
                      //   backgroundColor: Get.theme.backgroundColor,
                      //   buttonColor: Get.theme.bottomAppBarColor,
                      //   onConfirm: () {
                      //     wishListController
                      //         .deleteWish(
                      //         wishListController.listWish.value[index]);
                      //     Get.back();
                      //   },
                      //   onCancel: () => Get.back(),
                      //   middleText: '',
                      // );
                    },
                    icon: Icon(
                      iconDelete,
                      color: Get.theme.focusColor,
                    ),
                  ),
                ),
          );

        }
    );
  }
}

