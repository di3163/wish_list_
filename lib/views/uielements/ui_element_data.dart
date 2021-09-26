import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

enum AppTab { profileView, contactView, myListView }

enum FormType { login, register }

enum ThemeApp {shampoo, graphite}

//const iconPerson = Icons.person;
final iconError = LineIcons.byName('exclamation');
//final iconError = Icons.error_outline;
final iconPerson = LineIcons.byName('user');
//const iconCotacts = Icons.contacts;
final iconCotacts = LineIcons.byName('users');
final iconGifts = LineIcons.byName('gifts');
final iconCog = LineIcons.byName('cog');
final iconGlob = LineIcons.byName('globe');
final iconCamera = LineIcons.retroCamera;
const iconCameraSt = Icons.photo_camera;
const iconBack = Icons.arrow_back;
const iconFavorite = Icons.favorite_border;
const iconEmail = Icons.alternate_email;
final iconKey = LineIcons.byName('key');
//const iconKey = Icons.vpn_key;
//const iconPhone = Icons.phone;
const iconCode =  Icons.app_registration;
const iconAdd = Icons.add;
final iconPhone = LineIcons.byName('phone');
final iconDelete = LineIcons.byName('trash');

extension AppTabNamesLocal on AppTab{
  String localization(){
    switch(this){
      case AppTab.profileView:
        return 'profile' .tr;
      case AppTab.contactView:
        return 'contact' .tr;
      case AppTab.myListView:
        return 'my_list' .tr;
      default:
        return 'profile' .tr;
    }
  }
}

extension AppTabIcon on AppTab{
  Icon appTabIcon(){
    switch(this){
      case AppTab.profileView:
        return Icon(iconPerson, size: 30);
      case AppTab.contactView:
        return Icon(iconCotacts, size: 30);
      case AppTab.myListView:
        return const Icon(iconFavorite, size: 30);
      default:
        return Icon(iconPerson, size: 30);
    }
  }
}