import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                    leading: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            wishController.listWish.value[index].listPicURL[0],
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
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
