import 'dart:io';
import 'package:get/get.dart' hide Trans;
import 'package:flutter/material.dart';
import 'package:its_system/models/state_enum.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/helper/db/general_helper.dart';
import 'package:its_system/helper/device_information.dart';
import 'package:its_system/models/qr_style_model.dart';
import 'package:its_system/models/user_model.dart';
import 'package:its_system/pages/home/home_screen.dart';
import 'package:its_system/pages/home/home_screen_for_mobile.dart';
import 'package:its_system/statics_values.dart';
import 'package:its_system/theme.dart';
import 'package:its_system/pages/entry/entry_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/services.dart';

bool isLogin = true;
bool isAdmin = true;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences pref = await SharedPreferences.getInstance();
  await GetStorage.init();
  GetStorage().writeIfNull('darkMode', false);
  GetStorage().writeIfNull('paper_size', 57);

  // String key2 = GetStorage().read("key2") ?? "";
  StaticValue.systemType = GetStorage().read("TYEP") ?? 1;
  if(StaticValue.systemType == 1){  
        StaticValue.serverName = GetStorage().read("server_name")??(await rootBundle.loadString("assets/serv")).toString().trim();
        StaticValue.userName = GetStorage().read("user_name")??"administrator";
        StaticValue.password = GetStorage().read("password")??"mero@mriam#medo";
        StaticValue.deviceName = await DeviceInformationHelper.getDeviceNameForWindows();
      }
  // for change connecting string by user
  
  Map<String, dynamic>? u = GetStorage().read("user");
  Map<String, dynamic>? s = GetStorage().read("qr_style");
  // for save last notifications revived
  if(u != null){
    StaticValue.userData = UserModel.fromMap(u);
  }
  else{
    StaticValue.userData = UserModel().initialize();
  }
  if(s != null){
    StaticValue.qrStyle = QRStyleModel.fromMap(s);
  }
  else{
    StaticValue.qrStyle = QRStyleModel().initialize();
  }
    // if(productKey1 == "" &&productKey2 == ""&&key1 == "" &&key2 == ""){
    if(StaticValue.userData!.userId == 0){
      isLogin = true;
    }else{
      // StaticValue.productKey2 = productKey2; 
        await GeneralHelper().update(withMassage: false, tableName: 'users', primaryKey: 'USR_ID', primaryKeyValue: StaticValue.userData!.userId, items: {"USR_LAST_CONNECTED":DateTime.now()});
        if(StaticValue.userData!.userState == States.INACTIVE){
            final e = await GeneralHelper().getByIdAsMap(" SELECT * FROM users as u "
              // " INNER JOIN institutions as c ON c.INST_ID = u.INST_ID "
              // " INNER JOIN municipalities as ci ON c.MUN_ID = ci.MUN_ID "
              // " INNER JOIN cities as co ON co.CTY_ID = ci.CTY_ID "
              " WHERE USR_ID = ${StaticValue.userData!.userId}");
            UserModel u = UserModel.fromMap(e);
            StaticValue.userData = u;
            if(GetStorage().read("user")!= null){
              await GetStorage().write("user",StaticValue.userData!.toMapForSave());
            }
        }
      isLogin = false;
        if(StaticValue.userData!.userType == UserTypes.CITIZEN || StaticValue.userData!.userType == UserTypes.GUEST){
          isAdmin = false;
        }
        else{
          isAdmin = true;
        }
    }

  await translator.init(
    localeType: LocalizationDefaultType.device,
    language: pref.getString("lang")??"ar",
    languagesList: <String>[ 'en','ar'],
    assetsDirectory: 'assets/langs/',
  );
  
  if(Platform.isWindows){
    StaticValue.deviceIp = await DeviceInformationHelper.getDeviceIpForWindows();
  }

  runApp(LocalizedApp(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Get.lazyPut(()=>GeneralController());
    // Get.lazyPut(()=>ReportController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "QR-Code Syetem",
      localizationsDelegates: translator.delegates,
      locale: translator.activeLocale,
      supportedLocales: translator.locals(),
      themeMode:
          GetStorage().read("darkMode") ? ThemeMode.dark : ThemeMode.light,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      home: isLogin ? const EntryPage() : isAdmin ? const HomeScreen() : const HomeScreenForMoble()
    );
  }
}
