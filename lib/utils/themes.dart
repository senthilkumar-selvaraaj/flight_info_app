import 'package:flutter/material.dart';

abstract class AppTheme {
  Color get backgroundColor;
  Color get dateTimeBackgroundColor;
  Color get dateTimeColor;
  Color get loginHeaderColor;
  Color get welcomeMessageColor;
  Color get loginContainerBorderColor;
  Color get placeholderColor;
  Color get textFiledTextColor;
  Color get loginButtonBgColor;
  Color get loginTextColor;
  Color get statusIconBgColor;
  Color get statusIconColor;
  Color get poweredByColor;
  Color get menuCardColor;
  Color get menuIconColor;
  Color get menuTitleColor;
  Color get flightListHeaderColor;
  Color get flightListSectionHeaderColor;
  Color get flightInfoCardBgColor;
  Color get flightInfoCardTextColor;
  Color get flightBRDTextColor;
  Color get flightStatusBgColor;
  Color get flightInfoHintBannerBg;
  // Color get flightInfoCardActiveBorder;
}

class LightTheme extends AppTheme{
  @override
  Color get backgroundColor => AppColors.backgroundColor;

  @override
  Color get loginContainerBorderColor => AppColors.loginContainerBorderColor;
  
  @override
  Color get dateTimeBackgroundColor => AppColors.blueGrey;
  
  @override
  Color get dateTimeColor => AppColors.black;
  
  @override
  Color get statusIconBgColor => AppColors.blueGrey;
  
  @override
  Color get statusIconColor => AppColors.primaryBlue;
  
  @override
  Color get loginHeaderColor => AppColors.black;
  
  @override
  Color get welcomeMessageColor => AppColors.secondaryGrey;
  
  @override
  Color get placeholderColor => AppColors.primaryGrey;
  
  @override
  Color get textFiledTextColor => AppColors.black;
  
  @override
  Color get loginButtonBgColor => AppColors.primaryBlue;
  
  @override
  Color get loginTextColor => AppColors.white;
  
  @override
  Color get menuCardColor => AppColors.white;
  
  @override
  Color get menuIconColor => AppColors.primaryBlue;
  
  @override
  Color get menuTitleColor => AppColors.black;
  
  @override
  Color get flightInfoCardBgColor => AppColors.white;
  
  @override
  Color get poweredByColor => AppColors.primaryGrey;
  
  @override
  Color get flightInfoCardTextColor => AppColors.black;
  
  @override
  Color get flightBRDTextColor => AppColors.primaryBlue;
  
  @override
  Color get flightListSectionHeaderColor => AppColors.primaryGrey;
  
  @override
  Color get flightListHeaderColor => AppColors.black;
  
  @override
  Color get flightInfoHintBannerBg => AppColors.flightInfoBannerBg;
  
  @override
  Color get flightStatusBgColor => AppColors.flightStatusOnTimeBg.withAlpha(127);
}

class DarkTheme extends AppTheme{
  @override
  Color get backgroundColor => AppColors.darkBackgroundColor;

  @override
  Color get loginContainerBorderColor => AppColors.loginContainerDarkBorderColor;
  
  @override
  Color get dateTimeBackgroundColor => AppColors.darkBlueGrey;
  
  @override
  Color get dateTimeColor => AppColors.white;
  
  @override
  Color get statusIconBgColor => AppColors.darkBlueGrey;
  
  @override
  Color get statusIconColor => AppColors.secondaryGrey;
  
  @override
  Color get loginHeaderColor => AppColors.white;
  
  @override
  Color get welcomeMessageColor => AppColors.primaryGrey;
  
  @override
  Color get placeholderColor => AppColors.secondaryGrey;
  
  @override
  Color get textFiledTextColor => AppColors.white;
  
  @override
  Color get loginButtonBgColor => AppColors.secondaryBlue;
  
  @override
  Color get loginTextColor =>  AppColors.white;
  
  @override
  Color get menuCardColor => AppColors.darkBlueGrey;
  
  @override
  Color get menuIconColor => AppColors.white;
  
  @override
  Color get menuTitleColor => AppColors.white;
  
  @override
  Color get flightInfoCardBgColor => AppColors.darkBlueGrey;
  
  @override
  Color get poweredByColor => AppColors.white;
  
  @override
  Color get flightInfoCardTextColor => AppColors.white;
  
  @override
  Color get flightBRDTextColor => AppColors.secondaryBlue;
  
  @override
  Color get flightListSectionHeaderColor => AppColors.secondaryGrey;
  
  @override
  Color get flightListHeaderColor => AppColors.white;
  
  @override
  Color get flightInfoHintBannerBg => AppColors.darkBlueGrey;
  
  @override
  Color get flightStatusBgColor => AppColors.flightStatusOnTime.withAlpha(25);
}



class AppColors{
  static const backgroundColor = Color(0xFFf2f5f8);
  static const darkBackgroundColor = Color(0xFF111d50);
  static const blueGrey = Color(0xFFe8ecf2);
  static const darkBlueGrey = Color(0xFF2d3866);
  static const black = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);
  static const primaryGrey = Color(0xFFa5a5a5);
  static const secondaryGrey = Color(0xFFa7a9b7);
  static const loginContainerBorderColor = Color(0xFFd5d7da);
  static const loginContainerDarkBorderColor = Color(0xFF343f6b);
  static const primaryBlue = Color(0xFF506efa);
  static const secondaryBlue = Color(0xFF6077f7);
  static const statusIconColor = Color(0xFFe8ecf2);
  static const primaryColor = Color(0xFFe8ecf2);
  static const menuIconActiveColor = Color(0xFFe8ecf2);
  static const menuIconColor = Color(0xFFe8ecf2);
  static const flightListColor = Color(0xFFe8ecf2);
  static const flightListHeaderColor = Color(0xFFe8ecf2);
  static const flightInfoCardBgColor = Color(0xFFe8ecf2);
  static const flightInfoCardTextColor = Color(0xFFe8ecf2);
  static const flightStatusOnTimeBg = Color(0xFFdcf9d9);
  static const flightStatusOnTime = Color(0xFF12d700);
  static const flightInfoBannerBg = Color(0xFF0ea600);
  static const flightBRDTextColor = Color(0xFFe8ecf2);
  static const flightInfoCardActiveBorder = Color(0xFFe8ecf2);
}




class ThemeNotifier with ChangeNotifier {
  AppTheme _currentTheme = LightTheme();

  AppTheme get currentTheme => _currentTheme;

  bool get isDark => _currentTheme is  DarkTheme;

  void toggleTheme() {
    _currentTheme = (_currentTheme is LightTheme) ? DarkTheme() : LightTheme();
    notifyListeners();
  }
}