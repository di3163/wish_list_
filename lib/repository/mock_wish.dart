import 'package:wish_list_gx/core.dart';

class MockWish {
  List<Wish> getWishList() {
    return <Wish>[
      Wish(
          title: 'mazda rx 8',
          description: 'Mazda Rx8',
          listPicURL: [
            "assets/images/mazdarx.png",
            "assets/images/mazdarx_1.jpg",
            "assets/images/mazdarx_3.jpg"
        ]
      )
    ];
  }
}