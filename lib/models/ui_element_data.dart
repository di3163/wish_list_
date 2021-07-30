import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum AppTab { ProfileView, ContactView, MyListView }

enum FormType { login, register }

const iconPerson = Icons.person;
const iconCotacts = Icons.contacts;
const iconFavorite = Icons.favorite_border;
const iconEmail = Icons.alternate_email;
const iconKey = Icons.vpn_key;
const iconPhone = Icons.phone;

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
        return Icon(iconPerson);
      case AppTab.ContactView:
        return Icon(iconCotacts);
      case AppTab.MyListView:
        return Icon(iconFavorite);
      default:
        return Icon(iconPerson);
    }
  }
}