import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';

class WishView extends StatelessWidget {
  final WishController _wishController = Get.find<WishController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: Column(
        children: [
          // Row(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     Expanded(
          //       child: Container(
          //       height: 100,
          //       width: 100,
          //       child:
          //       ListView.builder(
          //           scrollDirection: Axis.horizontal,
          //           //itemCount: listData.length,
          //           itemBuilder: (context, index) {
          //             return Card(
          //
          //                 child: Container(
          //                     //height: 100,
          //               ),
          //             );
          //           }),
          //     )
          //     )
          //   ],
          // ),
          SizedBox(height: 10),
          //       Row(
          //         children: [
          //           Expanded(child:
          //       ElevatedButton(
          //           onPressed: () {},
          //           child: Icon(Icons.photo_camera)),
          //           )
          // ]
          //       ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _wishController.controllerTitle.value,
                  decoration:
                      InputDecoration(labelText: 'wish_title' .tr),
                ),
              ),
            ],
          ),
          Row(children: [
            Expanded(
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _wishController.controllerDescription.value,
                decoration:
                    InputDecoration(labelText: 'wish_description' .tr),
              ),
            ),
          ]),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _wishController.controllerLink.value,
                  decoration:
                      InputDecoration(labelText: 'wish_link' .tr),
                ),
              ),
            ],
          ),
          Row(children: [
            Expanded(
              child:
                  ElevatedButton(onPressed: (){}, child: Icon(Icons.add)),
            )
          ])
        ],
      ),
    );
  }
}
