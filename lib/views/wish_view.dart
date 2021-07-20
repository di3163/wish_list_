import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';

class WishView extends GetView<WishController> {
  //final WishController _wishController = Get.find<WishController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildWishImages(),
              SizedBox(height: 10,),
              Row(
                  children: [
                    Expanded(child:
                      ElevatedButton(
                        onPressed: () => controller.addImage(),
                        child: Icon(Icons.photo_camera),
                      ),
                    ),
                  ]
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.controllerTitle.value,
                      decoration: InputDecoration(labelText: 'wish_title'.tr),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Row(children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: controller.controllerDescription.value,
                    decoration:
                        InputDecoration(labelText: 'wish_description'.tr),
                  ),
                ),
                ]
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.controllerLink.value,
                      decoration: InputDecoration(labelText: 'wish_link'.tr),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    // return Container(
    //   margin: EdgeInsets.all(5.0),
    //   child: Column(
    //     children: [
    //       // Row(
    //       //   mainAxisSize: MainAxisSize.min,
    //       //   children: [
    //       //     Expanded(
    //       //       child: Container(
    //       //       height: 100,
    //       //       width: 100,
    //       //       child:
    //       //       ListView.builder(
    //       //           scrollDirection: Axis.horizontal,
    //       //           //itemCount: listData.length,
    //       //           itemBuilder: (context, index) {
    //       //             return Card(
    //       //
    //       //                 child: Container(
    //       //                     //height: 100,
    //       //               ),
    //       //             );
    //       //           }),
    //       //     )
    //       //     )
    //       //   ],
    //       // ),
    //       SizedBox(height: 10),
    //       //       Row(
    //       //         children: [
    //       //           Expanded(child:
    //       //       ElevatedButton(
    //       //           onPressed: () {},
    //       //           child: Icon(Icons.photo_camera)),
    //       //           )
    //       // ]
    //       //       ),
    //       Row(
    //         children: [
    //           Expanded(
    //             child: TextField(
    //               controller: _wishController.controllerTitle.value,
    //               decoration:
    //                   InputDecoration(labelText: 'wish_title' .tr),
    //             ),
    //           ),
    //         ],
    //       ),
    //       Row(children: [
    //         Expanded(
    //           child: TextField(
    //             keyboardType: TextInputType.multiline,
    //             maxLines: null,
    //             controller: _wishController.controllerDescription.value,
    //             decoration:
    //                 InputDecoration(labelText: 'wish_description' .tr),
    //           ),
    //         ),
    //       ]),
    //       Row(
    //         children: [
    //           Expanded(
    //             child: TextField(
    //               controller: _wishController.controllerLink.value,
    //               decoration:
    //                   InputDecoration(labelText: 'wish_link' .tr),
    //             ),
    //           ),
    //         ],
    //       ),
    //       Row(children: [
    //         Expanded(
    //           child:
    //               ElevatedButton(onPressed: (){}, child: Icon(Icons.add)),
    //         )
    //       ])
    //     ],
    //   ),
    // );
  }

  ValueBuilder<int?> _buildWishImages(){

    return ValueBuilder<int?>(
        initialValue: 0,
        builder: (currentImage, updateFn) =>
            Column(
              children: [
                Obx(() =>
                Container(
                  height: 150,
                  child: PageView(
                    physics: BouncingScrollPhysics(),
                    onPageChanged: updateFn,
                    children: controller.currentWish.listPicURL.map((patch){
                      return _imgContainer(patch);
                    }).toList(),
                  ),
                )),
                controller.currentWish.listPicURL.length > 1 ? Container(
                  height: 30,
                  margin: EdgeInsets.only(top: 12, bottom: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                    controller.currentWish.listPicURL.map((image) =>
                        _buildIndicator(
                            controller.currentWish.
                            listPicURL.indexOf(image) == currentImage)
                    ).toList(),
                  ),
                ): Container(),
                ],
            )
    );
  }

  Widget _buildIndicator(bool isActive){
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

  Container _imgContainer(String patch){
    if(controller.currentWish.title.isEmpty){
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Image.file(
          File(patch),
          fit: BoxFit.scaleDown,
        ),
      );
    }else{
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Image.network(
          patch,
          fit: BoxFit.scaleDown,
        ),
      );
    }
  }
}


