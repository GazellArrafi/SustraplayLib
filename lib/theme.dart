import "package:flutter/material.dart";

ThemeData lightMode = new ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Color(0xFFED8128),
    primaryContainer: Color(0xFF57321F),
    secondaryContainer: Color(0xFFD89A77),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    elevation: 2,
    backgroundColor: Color(0xFFED8128),
  ),
  appBarTheme: AppBarTheme(
    centerTitle: true,
    backgroundColor: Color(0xFF57321F),
  ),
);

ThemeData darkMode = new ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Color(0xFF13151E),
    primaryContainer: Color(0xFF272E47), 
    secondaryContainer: Color(0xFFFFFFFF),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    elevation: 2,
    backgroundColor: Color(0xFF13151E),
    extendedTextStyle: TextStyle(
      color: Colors.white,
    )
  ),
  appBarTheme: AppBarTheme(
    centerTitle: true,
    backgroundColor: Color(0xFF272E47),
  )
);