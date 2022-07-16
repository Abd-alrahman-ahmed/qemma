import 'package:flutter/material.dart';

class AppTheme {
  static const Color _lightPrimary = Color.fromARGB(255, 48, 118, 114);
  static const Color _lightAppBar = Color.fromARGB(255, 20, 77, 83);
  static const Color _lightBackground = Color.fromARGB(255, 255, 255, 255);
  static const Color _lightBtnPrimary = Color.fromARGB(237, 48, 118, 115);
  static const Color _lightBtnPrimaryActive = Color.fromARGB(255, 48, 118, 114);
  static const Color _lightBtnPrimaryHover = Color.fromARGB(255, 48, 118, 114);
  static const Color _lightBtnPrimaryDisable =
      Color.fromARGB(170, 48, 118, 115);

  static final ThemeData lightTheme = ThemeData(
    primaryColor: _lightPrimary,
    primaryColorLight: _lightPrimary,
    appBarTheme: const AppBarTheme(
      color: _lightAppBar,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    backgroundColor: _lightBackground,
    scaffoldBackgroundColor: _lightBackground,
    iconTheme: const IconThemeData(color: Colors.white),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: _lightBtnPrimary,
        textStyle: const TextStyle(color: Colors.white, fontSize: 16.0),
        minimumSize: const Size(300, 40),
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: _lightBtnPrimary, //text on button
      hoverColor: _lightBtnPrimaryHover,
      disabledColor: _lightBtnPrimaryDisable,
      focusColor: _lightBtnPrimaryActive,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      textTheme: ButtonTextTheme.primary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      iconColor: _lightBtnPrimary,
      labelStyle: const TextStyle(color: Colors.black, fontSize: 16.0),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: Colors.black,
      unselectedLabelColor: Colors.white,
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: _lightPrimary,
            width: 4.0,
          ),
        ),
      ),
    ),
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      button: TextStyle(
        color: Colors.black,
        fontSize: 16.0,
      ),
    ),
  );
}
