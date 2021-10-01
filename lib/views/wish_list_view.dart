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
              return _listViewWish(wishListController);
            }else {
              return Center(child: Text('empty_list'.tr));
            }
          }
    );
  }

  Widget _listViewWish(WishListController wishListController){
    return ListView.builder(
      itemCount: wishListController.listWish.value.length,
      itemBuilder: (_, index) => ListTile(
        onTap: () => Get.toNamed(
          '/wish',
          arguments: wishListController.listWish.value[index],
        ),
        onLongPress: () {
          AppDialog(
              titleText: 'del'.tr,
              confirm: () {
                wishListController
                    .deleteWish(wishListController.listWish.value[index]);
              },
              ).getDialog();
        },

        //wishListController.deleteWish(wishListController.listWish.value[index]),
        leading: wishListController.listWish.value[index].listPicURL.isEmpty ?
        Icon(iconCameraSt, size: 30, color: Get.theme.focusColor,) :
        CachedNetworkImage(
          imageUrl: wishListController.listWish.value[index].listPicURL[0],
          imageBuilder: (context, imageProvider) => Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(5), bottom: Radius.circular(5)),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.fill,
              ),
            ),
          ),
          placeholder: (context, url) => LineIcon.retroCamera(size: 30,),
          errorWidget: (context, url, error) => LineIcon.exclamationCircle(size: 30,),
        ),
        title: Text(
            wishListController.listWish.value[index].title,
            style: TextStyle(fontSize: 18),
        ),
        subtitle: const Text(''),
      ),
    );
  }
}
