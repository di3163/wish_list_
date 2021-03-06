
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:wish_list_gx/core.dart';
import 'package:mockito/annotations.dart';
import 'profile_view_test.mocks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MockFirebaseRepository extends Mock implements FirebaseRepository{}


@GenerateMocks([MockFirebaseRepository])

class _Wrapper extends StatelessWidget {
  final Widget child;
  _Wrapper(this.child);
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height
    )
    );
    return child;
  }
}

Widget testableWidget({required Widget child}) {
  return MediaQuery(
    data: MediaQueryData(),
    child: GetMaterialApp(
      home: Scaffold(body: _Wrapper(child)),
    ),
  );
}

void main(){
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  //Get.put<FirebaseRepository>(MockMockFirebaseRepository());

  // testWidgets('login view tests', (WidgetTester tester) async{
  //     await tester.pumpWidget(
  //       testableWidget(
  //         child: LoginForm(userProfileController: UserProfileController(MockMockFirebaseRepository())),
  //       ),
  //     );
  //     expect(find.byKey(Key('fieldEmail')), findsOneWidget);
  //     expect(find.byKey(Key('fieldPass')), findsOneWidget);
  //     expect(find.byKey(Key('buttonLoginSend')), findsOneWidget);
  //   });
}