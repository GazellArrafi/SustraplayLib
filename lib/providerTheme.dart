import "package:flutter/material.dart";
import "package:sustraplay_abp/theme.dart";

class ProviderTheme extends ChangeNotifier{
  ThemeData _themeData = lightMode;

  ThemeData get setTheme => _themeData;

  set setTheme(ThemeData themeData){
    _themeData = themeData;
    notifyListeners();
  }  

  void light(){
    setTheme = lightMode;
  }

  void dark(){
    setTheme = darkMode;
  }
}