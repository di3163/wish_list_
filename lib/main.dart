import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wish_list_gx/core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String themeApp = preferences.getString('theme') ?? 'lightshampoo';

  await Firebase.initializeApp();
  runApp(MyApp(themeApp));
}

class MyApp extends StatelessWidget {
  MyApp(this.themeApp);
  final String themeApp;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: Messages(),
        locale: Get.deviceLocale,
        fallbackLocale: Locale('en', 'UK'),
      initialBinding: MainBinding(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,

      theme: themeApp == 'lightshampoo'?
        themeLightShampoo : themeBlackCrows,
      //themeMode: ThemeMode.light,
    );
  }


}
