import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';

enum AppTab { ProfileView, ContactView, MyListView }

enum FormType { login, register }

//const iconPerson = Icons.person;
final iconPerson = LineIcons.byName('user');
//const iconCotacts = Icons.contacts;
final iconCotacts = LineIcons.byName('users');
const iconFavorite = Icons.favorite_border;
const iconEmail = Icons.alternate_email;
final iconKey = LineIcons.byName('key');
//const iconKey = Icons.vpn_key;
//const iconPhone = Icons.phone;
final iconPhone = LineIcons.byName('phone');
final iconDelete = LineIcons.byName('trash');

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
        return Icon(iconPerson, size: 30);
      case AppTab.ContactView:
        return Icon(iconCotacts, size: 30);
      case AppTab.MyListView:
        return Icon(iconFavorite, size: 30);
      default:
        return Icon(iconPerson, size: 30);
    }
  }
}