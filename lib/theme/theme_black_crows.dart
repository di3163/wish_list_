import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData _themeDark = ThemeData.dark();

ThemeData themeBlackCrows = _themeDark.copyWith(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: Colors.grey[700],
    primaryColorLight: Colors.grey[500],
    primaryColorDark: Colors.grey[800],
    scaffoldBackgroundColor: Colors.grey[700],
    backgroundColor: Colors.grey[700],
    focusColor: Colors.white,
    splashColor: Colors.grey[200],
    hintColor: Colors.grey[200],
    accentColor: Colors.grey[200],
    bottomAppBarColor: Colors.grey[800],
    buttonColor: Colors.grey[800],
    disabledColor: Colors.grey[400],
    shadowColor:  Colors.grey[400],
    // primaryTextTheme:  _textLight(_themeLight.textTheme),
    // textTheme: _textLight(_themeLight.textTheme),
    textTheme: _textTheme,
    primaryTextTheme: _textTheme,

    appBarTheme: AppBarTheme(
      color: Colors.grey[800],
      iconTheme: IconThemeData(color: Colors.grey[200]),
      textTheme: _textAppBar(_themeDark.textTheme),
      actionsIconTheme: IconThemeData(color: Colors.grey[200]),
      titleTextStyle: TextStyle(color: Colors.grey[200]),
      toolbarTextStyle: TextStyle(color: Colors.grey[200]),
      shadowColor: Colors.grey[400]
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor:  Colors.grey[500],
    ),

    buttonTheme: ButtonThemeData(
      buttonColor:  Colors.grey[800],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          // backgroundColor: MaterialStateProperty.resolveWith<Color>(
          //         (_) => Colors.teal[300]!),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[800]!),
          shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
            return RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));
          }),
        )
    ),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(color: Colors.grey[600]!)),
          //backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[600]!),
        )
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.grey[800],
    )
);



TextTheme _textAppBar(TextTheme base) {
  return base.copyWith(
    headline4: base.headline4!.copyWith(
        color: Colors.grey[200]
    ),
  );
}

// TextTheme _textLight(TextTheme base) {
//   return base.copyWith(
//     // headline4: base.headline6!.copyWith(
//     //     color: Colors.white
//     // ),
//     headline4: GoogleFonts.rajdhani().copyWith(
//     //headline4: base.headline6!.copyWith(
//         color: Colors.black
//     ),
//     bodyText2: GoogleFonts.rajdhani().copyWith(
//         color: Colors.black
//     ),
//   );
// }
final TextTheme _textTheme = TextTheme(
  headline1: GoogleFonts.roboto(
      fontSize: 97, fontWeight: FontWeight.w300, letterSpacing: -1.5),
  headline2: GoogleFonts.roboto(
      fontSize: 61, fontWeight: FontWeight.w300, letterSpacing: -0.5),
  headline3: GoogleFonts.roboto(fontSize: 48, fontWeight: FontWeight.w400),
  headline4: GoogleFonts.roboto(
      fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  headline5: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.w400),
  headline6: GoogleFonts.roboto(
      fontSize: 20, fontWeight: FontWeight.w400, letterSpacing: 0.15),
  subtitle1: GoogleFonts.roboto(
      fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),   //16
  subtitle2: GoogleFonts.roboto(
      fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),   //14
  bodyText1: GoogleFonts.roboto(
      fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
  bodyText2: GoogleFonts.roboto(
      fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  button: GoogleFonts.roboto(
      fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
  caption: GoogleFonts.roboto(
      fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
  overline: GoogleFonts.roboto(
      fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),

);