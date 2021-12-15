import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:wish_list_gx/core.dart';

class ImgView extends StatelessWidget {
  final String patch;

  const ImgView({Key? key, required this.patch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        //child: Padding(
        //padding: const EdgeInsets.all(10.0),
        children: [
          Expanded(
            child: InteractiveViewer(
              child: Get.find<WishController>().currentWish.isSaved
                  ? CachedNetworkImage(
                      imageUrl: patch,
                      fit: BoxFit.fitWidth,
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
                      fit: BoxFit.fitWidth,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
