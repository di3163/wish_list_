import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';

void main(){
  Get.put<FirebaseRepository>(FirebaseRepository());
  Get.put<UserProfileController>(UserProfileController());
  testWidgets('login view tests', (WidgetTester tester) async{
      await tester.pumpWidget(
        MaterialApp(
          home: LoginForm(userProfileController: Get.find<UserProfileController>()),
        ),
      );
      expect(find.byKey(Key('fieldEmail')), findsOneWidget);
      expect(find.byKey(Key('fieldPass')), findsOneWidget);
      expect(find.byKey(Key('buttonLoginSend')), findsOneWidget);
    });
}