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
          //init: Get.put<WishController>(WishController()),

          builder: (WishListController wishController){

            if(wishController.listWish.value.isNotEmpty){
              return ListView.builder(
                itemCount: wishController.listWish.value.length,
                  itemBuilder: (_, index) => ListTile(
                    onTap: () => Get.toNamed(
                        '/wish',
                        arguments: wishController.listWish.value[index],
                      ),
                    onLongPress: () => wishController.deleteWish(wishController.listWish.value[index]),
                    leading:
                        CachedNetworkImage(
                          imageUrl: wishController.listWish.value[index].listPicURL[0],
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
                    //Container(
                      //height: 30,
                      //width: 30,

                      //decoration: BoxDecoration(
                        //image: DecorationImage(
                          //image:
                          // NetworkImage(
                          //   wishController.listWish.value[index].listPicURL[0],
                          // ),
                          //fit: BoxFit.fill,
                        //),
                      //),
                    //),
                    title: Text(wishController.listWish.value[index].title),
                  ),
              );
            }else {
              return Center(child: Text('список пуст'));
            }
          }
        )
    );
  }
}
