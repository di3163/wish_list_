
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:wish_list_gx/core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences preferences = await SharedPreferences.getInstance();

  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(MyApp(preferences.getString('theme') ?? 'lightshampoo'));
}

class MyApp extends StatelessWidget {
  const MyApp(this.themeApp, {Key? key}) : super(key: key);
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
        fallbackLocale: const Locale('en', 'UK'),
      initialBinding: MainBinding(),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,

      theme: themeApp == 'lightshampoo'?
        themeLightShampoo : themeBlackCrows,
    );
  }

}
