import 'dart:io';

import 'package:wish_list_gx/core.dart';

typedef RequestBody = Map<String, dynamic>;
//typedef DocumentReference FunctionDocReference(String docName);

class AllUsersListFailure implements Exception {
  final String? msg;
  const AllUsersListFailure([this.msg]);
}

abstract class FetchAllRegistredUsers{
  Future<RequestBody> fetchAllRegistredUsers();
}

abstract class SignUpWithSMSCode{
  Future<void> signUpWithSMSCode({
    required String smsCode});
}

abstract class VerifyPhoneNumber{
  Future verifyPhoneNumber({
    required String phoneNumber,
    required String email});
}

abstract class UpdateUserProfile{
  Future<void> updateUserProfile(String photoURL);
}

abstract class ImageOperations{
  Future<String> saveImage(File image);
  Future deleteImage(String imgUrl);
}

abstract class FetchUserAvatarURL{
  Future<String> fetchUserAvatarURL(String id);
}

abstract class UpdateUserWish{
  Future updateUserWish(Wish wish);
}

abstract class AddUserWish{
  Future addUserWish(Wish wish);
}

abstract class FetchUserWishStream {
  Stream<List<Wish>> fetchUserWishStream(String id);
}

abstract class DeleteWish {
  deleteWish(Wish wish);
}