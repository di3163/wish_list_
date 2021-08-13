import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:line_icons/line_icon.dart';
import 'package:wish_list_gx/core.dart';

class WishList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: GetX<WishListController>(
          builder: (WishListController wishListController){
            if(wishListController.listWish.value.isNotEmpty){
              return _listViewWish(wishListController);
            }else {
              return Center(child: Text('empty_list'.tr));
            }
          }
        )
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
        onLongPress: () => wishListController.deleteWish(wishListController.listWish.value[index]),
        leading: wishListController.listWish.value[index].listPicURL.isEmpty ?
        LineIcon.retroCamera(size: 30,) :
        CachedNetworkImage(
          imageUrl: wishListController.listWish.value[index].listPicURL[0],
          imageBuilder: (context, imageProvider) => Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.fill,
              ),
            ),
          ),
          placeholder: (context, url) => LineIcon.retroCamera(size: 30,),
          errorWidget: (context, url, error) => LineIcon.exclamationCircle(size: 30,),
        ),
        title: Text(wishListController.listWish.value[index].title),
      ),
    );
  }
}
