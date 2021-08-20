import 'package:firebase_auth/firebase_auth.dart';

enum UserStatus{authenticated, unauthenticated, other}

abstract class UserApp{
  final String id;
  final UserStatus userStatus;

  UserApp({required this.id, required this.userStatus});
}

class UserEmpty extends UserApp{
  UserEmpty() : super(id: '', userStatus:  UserStatus.unauthenticated);
}

class UserFirebase extends UserApp {
  UserFirebase({required String id, required UserStatus userStatus, required this.photoURL})
      : super(id: id, userStatus: userStatus);

  final String photoURL;

  factory UserFirebase.fromJson(Map<String, dynamic> json){
    return UserFirebase(
        id: json['id'],
        userStatus: json['userStatus'],
        photoURL: json['photoURL']
    );
  }

  factory UserFirebase.fromFirebaseUser(User? user){
    return UserFirebase(
        id: user != null ? user.uid : '',
        userStatus: user != null ? UserStatus.authenticated : UserStatus.unauthenticated,
        photoURL: user != null ? user.photoURL ?? '' : ''
    );
  }
}

class UserOther extends UserApp{
  UserOther({
    required String id,
    required UserStatus userStatus,
    required this.name,
    required this.email,
    required this.phone}) : super(id: id, userStatus: userStatus);

  String name;
  String email;
  String phone;

  factory UserOther.fromJson(Map<String, dynamic> json){
    return UserOther(
        id: json['id'],
        userStatus: json['userStatus'],
        name: json['name'],
        email: json['email'],
        phone:  json['phone']
    );
  }
}