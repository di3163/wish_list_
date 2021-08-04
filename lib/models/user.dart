enum UserStatus{authenticated, unauthenticated, other}

class UserWish{

  UserWish(this.userStatus);

  final UserStatus userStatus;

}

class UserApp extends UserWish{
  UserApp(UserStatus userStatus) : super(userStatus);
}

