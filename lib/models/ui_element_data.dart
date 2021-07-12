import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum AppTab { ProfileView, ContactView, MyListView }

enum FormType { login, register }

extension AppTabNamesLocal on AppTab{
  String localization(){
    switch(this){
      case AppTab.ProfileView:
        return 'profile' .tr;
      case AppTab.ContactView:
        return 'contact' .tr;
      case AppTab.MyListView:
        return 'my_list' .tr;
      default:
        return 'profile' .tr;
    }
  }
}

extension AppTabIcon on AppTab{
  Icon appTabIcon(){
    switch(this){
      case AppTab.ProfileView:
        return Icon(Icons.person);
      case AppTab.ContactView:
        return Icon(Icons.contacts);
      case AppTab.MyListView:
        return Icon(Icons.favorite_border);
      default:
        return Icon(Icons.person);
    }
  }
}