import 'package:firebase_auth/firebase_auth.dart';


enum UserStatus{authenticated, unauthenticated, other}

abstract class UserApp{
  final String id;
  final UserStatus userStatus;
  final String photoURL;

  const UserApp({required this.id, required this.userStatus, required this.photoURL});
}

class UserEmpty extends UserApp{
  // UserEmpty() : super(id: '', userStatus:  UserStatus.unauthenticated, photoURL: '');
  UserEmpty({required String id, required UserStatus userStatus, required String photoURL})
      : super(id: id, userStatus: userStatus, photoURL: photoURL);

  factory UserEmpty.empty(){
    return UserEmpty(
        id: '',
        userStatus:  UserStatus.unauthenticated,
        photoURL: ''
    );
  }

}

class UserFirebase extends UserApp {
  UserFirebase({required String id, required UserStatus userStatus, required String photoURL})
      : super(id: id, userStatus: userStatus, photoURL: photoURL);

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
    required photoURL,
    required this.name,
    required this.email,
    required this.phone}) : super(id: id, userStatus: userStatus, photoURL: photoURL);

  String name;
  String email;
  String phone;

  factory UserOther.fromJson(Map<String, dynamic> json){
    return UserOther(
        id: json['id'],
        userStatus: json['userStatus'],
        name: json['name'],
        email: json['email'],
        phone:  json['phone'],
        photoURL: json['photoURL']
    );
  }
}