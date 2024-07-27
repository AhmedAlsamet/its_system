
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/constants.dart';

class AppTheme{
  bool isAndroid = Platform.isAndroid;
    TextTheme lightTextTheme() {
    return  TextTheme(
      headlineLarge: TextStyle(color:Colors.black,fontSize: isAndroid? 32 :35,fontFamily: translator.activeLanguageCode == 'ar' ? 'tajawal' :'tajawal' ),
      headlineMedium: TextStyle(color:Colors.black, fontSize: isAndroid? 28 :30,fontFamily:translator.activeLanguageCode == 'ar' ? 'tajawal' :'tajawal' ,),
      headlineSmall: TextStyle(color:Colors.black, fontSize: isAndroid? 26 :28,fontFamily:translator.activeLanguageCode == 'ar' ? 'tajawal' :'tajawal' ,),
      bodyLarge: TextStyle(color:Colors.black, fontSize:isAndroid? 24 : 26,fontFamily:translator.activeLanguageCode == 'ar' ? 'tajawal' :'tajawal' ,),
      bodyMedium: TextStyle(color:Colors.black, fontSize: isAndroid? 22 : 24,fontFamily:translator.activeLanguageCode == 'ar' ? 'tajawal' :'tajawal' ,),
      bodySmall: TextStyle(color:Colors.black, fontSize: isAndroid? 20 : 22,fontFamily:translator.activeLanguageCode == 'ar' ? 'tajawal' :'tajawal' ,),
      displayLarge: TextStyle(color:Colors.black, fontSize: isAndroid? 18 : 20,fontFamily:translator.activeLanguageCode == 'ar' ? 'tajawal' :'tajawal' ,),
      displayMedium: TextStyle(color:Colors.black, fontSize: isAndroid? 16 : 18,fontFamily:translator.activeLanguageCode == 'ar' ? 'tajawal' :'tajawal' ,),
      displaySmall: TextStyle(color:Colors.black, fontSize: isAndroid? 14 : 16,fontFamily:translator.activeLanguageCode == 'ar' ? 'tajawal' :'tajawal' ,),
      labelLarge: TextStyle(color:Colors.black, fontSize: isAndroid? 12 : 14,fontFamily:translator.activeLanguageCode == 'ar' ? 'tajawal' :'tajawal' ,),
      labelMedium: TextStyle(color:Colors.black, fontSize: isAndroid? 10 : 12,fontFamily:translator.activeLanguageCode == 'ar' ? 'tajawal' :'tajawal' ,),
      labelSmall: TextStyle(color:Colors.black, fontSize: isAndroid? 8 : 10,fontFamily:translator.activeLanguageCode == 'ar' ? 'tajawal' :'tajawal' ,),
    );
  }
     TextTheme darkTextTheme() {
    return  TextTheme(
      headlineLarge: TextStyle(color:Colors.white,fontSize:  isAndroid? 32 :35,fontFamily: translator.activeLanguageCode == 'ar' ? 'tajawal' :'tajawal' ),
      headlineMedium: TextStyle(color:Colors.white, fontSize: isAndroid? 28 :30,fontFamily:translator.activeLanguageCode == 'ar' ? 'tajawal' :'tajawal' ,),
      headlineSmall: TextStyle(color:Colors.white, fontSize: isAndroid? 26 :28,fontFamily:translator.activeLanguageCode == 'ar' ? 'tajawal' :'tajawal' ,),
      bodyLarge: TextStyle(color:Colors.white, fontSize: isAndroid? 24 :26,fontFamily:translator.activeLanguageCode == 'ar' ? 'tajawal' :'tajawal' ,),
      bodyMedium: TextStyle(color:Colors.white, fontSize:isAndroid? 22 : 24,fontFamily:translator.activeLanguageCode == 'ar' ? 'tajawal' :'tajawal' ,),
      bodySmall: TextStyle(color:Colors.white, fontSize: isAndroid? 20 : 22,fontFamily:translator.activeLanguageCode == 'ar' ? 'tajawal' :'tajawal' ,),
      displayLarge: TextStyle(color:Colors.white, fontSize: isAndroid? 18 : 20,fontFamily:translator.activeLanguageCode == 'ar' ? 'tajawal' :'tajawal' ,),
      displayMedium: TextStyle(color:Colors.white, fontSize: isAndroid? 16 : 18,fontFamily:translator.activeLanguageCode == 'ar' ? 'tajawal' :'tajawal' ,),
      displaySmall: TextStyle(color:Colors.white, fontSize: isAndroid? 14 : 16,fontFamily:translator.activeLanguageCode == 'ar' ? 'tajawal' :'tajawal' ,),
      labelLarge: TextStyle(color:Colors.white, fontSize: isAndroid? 12 : 14,fontFamily:translator.activeLanguageCode == 'ar' ? 'tajawal' :'tajawal' ,),
      labelMedium: TextStyle(color:Colors.white, fontSize: isAndroid? 10 : 12,fontFamily:translator.activeLanguageCode == 'ar' ? 'tajawal' :'tajawal' ,),
      labelSmall: TextStyle(color:Colors.white, fontSize: isAndroid? 8 : 10,fontFamily:translator.activeLanguageCode == 'ar' ? 'tajawal' :'tajawal' ,),
    );
  }
  static ThemeData lightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor:headColor , primary: headColor,),
      iconTheme: const IconThemeData(color: Colors.black),
      indicatorColor: headColor,
      primaryColorLight: const Color.fromRGBO(255, 255, 255, 1),
      // colorScheme: ColorScheme.dark(background: Colors.white),
        scaffoldBackgroundColor: bgColor,
        secondaryHeaderColor: headColor,
        // for app bar 
        chipTheme:  ChipThemeData(backgroundColor: Colors.black.withOpacity(0.3)),
        // for main appbar items shadow

        radioTheme: RadioThemeData(
            fillColor: MaterialStateProperty.all(headColor)
        ),
        // textTheme: AppTheme.lightTextTheme(),
        // GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
        //     .apply(bodyColor: Colors.white),
        canvasColor: bgColor,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          unselectedItemColor: Color(0xff252A34),
          selectedItemColor: headColor,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ),
        cardColor: Colors.white,
        textTheme: AppTheme().lightTextTheme(),
        primaryColor: headColor,
        appBarTheme: AppBarTheme(
          shadowColor: Colors.black,
          color:headColor,titleTextStyle:  AppTheme().lightTextTheme().displayLarge!.copyWith(color: Colors.white) ),
        shadowColor: secondaryColor.withOpacity(0.2),
        progressIndicatorTheme: const ProgressIndicatorThemeData(color: headColor),
        expansionTileTheme:  ExpansionTileThemeData(
            collapsedIconColor: Colors.black,
            textColor: Colors.black,
            iconColor: headColor,
            shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(20))
        ),
        dividerColor: Colors.black,
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
          )
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            overlayColor: MaterialStateColor.resolveWith((states) => headColor.withOpacity(0.05))
          )
        )
        // for TABLE Border
      );
  }

  ///Dark theme
  static ThemeData darkTheme() {
    return ThemeData.dark().copyWith(
      iconTheme: const IconThemeData(color: Colors.white),
      primaryColorLight: Colors.grey.shade800,
      secondaryHeaderColor: darkColor,
        // for app bar 

      chipTheme: const ChipThemeData(backgroundColor:  Colors.white),
        // for main appbar items shadow

      indicatorColor: primaryColor,
      // colorScheme: ColorScheme.dark(background:Colors.grey.shade800, ),
        scaffoldBackgroundColor: Colors.grey.shade800,
        radioTheme: RadioThemeData(
            fillColor: MaterialStateProperty.all(primaryColor),
        ),
        // textTheme: AppTheme.lightTextTheme(),
        // GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
        //     .apply(bodyColor: Colors.white),
        canvasColor: darkColor,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          unselectedItemColor: Colors.white,
          selectedItemColor: primaryColor,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ),
        textTheme: AppTheme().darkTextTheme(),
        // primaryColor: primaryColor,
        cardColor: Colors.grey.shade700,
        appBarTheme: AppBarTheme(color: Colors.grey.shade800,titleTextStyle:  AppTheme().lightTextTheme().displayLarge!.copyWith(color: Colors.white) ),
        shadowColor: darkSecondaryColor.withOpacity(0.2),
        progressIndicatorTheme: const ProgressIndicatorThemeData(color: primaryColor),
        expansionTileTheme: ExpansionTileThemeData(
            collapsedIconColor: Colors.white,
            textColor: Colors.white,
            iconColor: primaryColor,
            shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(20))
        ),
        buttonTheme: ButtonThemeData(
          hoverColor: Colors.red
        ),
        dividerColor: Colors.white,
        // for TABLE Border

        // dialogTheme: DialogTheme(
        //   titleTextStyle: AppTheme.lightTextTheme().displayLarge,
        //   backgroundColor: Colors.white
        // ),
        // dialogBackgroundColor: Colors.white
      );
  }
}