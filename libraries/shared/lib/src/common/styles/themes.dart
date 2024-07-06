import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Themes {
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
    useMaterial3: true,
    fontFamily: 'IBMPlexSans',
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: Colors.white,
        statusBarColor: Colors.white,
      ),
    ),
    // backgroundColor: ColorPalettes.lightBG,
    // primaryColor: ColorPalettes.lightPrimary,
    // accentColor:  ColorPalettes.lightAccent,
    // cursorColor: ColorPalettes.lightAccent,
    // dividerColor: ColorPalettes.darkBG,
    // scaffoldBackgroundColor: ColorPalettes.lightBG,
    // appBarTheme: AppBarTheme(
    //   textTheme: TextTheme(
    //     headline6: TextStyle(
    //       color: ColorPalettes.darkBG,
    //       fontSize: 18.0,
    //       fontWeight: FontWeight.bold,
    //     ),
    //   ),
    // ),
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.orange,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    fontFamily: 'IBMPlexSans',
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: Colors.black,
        statusBarColor: Colors.black,
      ),
    ),

    // brightness: Brightness.dark,
    // backgroundColor: ColorPalettes.darkBG,
    // primaryColor: ColorPalettes.darkPrimary,
    // accentColor: ColorPalettes.darkAccent,
    // dividerColor: ColorPalettes.lightPrimary,
    // scaffoldBackgroundColor: ColorPalettes.darkBG,
    // cursorColor: ColorPalettes.darkAccent,
    // appBarTheme: AppBarTheme(
    // color: ColorPalettes.darkPrimary,
    // textTheme: TextTheme(
    //   headline6: TextStyle(
    //     color: ColorPalettes.lightBG,
    //     fontSize: 18.0,
    //     fontWeight: FontWeight.w700,
    //   ),
    // ),
    // ),
  );
}
