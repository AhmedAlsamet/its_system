import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get_storage/get_storage.dart';
import 'package:its_system/core/utils/snakbar_dialog.dart';
import 'package:its_system/helper/db/general_helper.dart';
import 'package:its_system/models/place_model.dart';
import 'package:its_system/models/qr_style_model.dart';
import 'package:its_system/pages/home/home_screen.dart';
import 'package:its_system/models/state_enum.dart';
import 'package:its_system/models/user_model.dart';
import 'package:its_system/pages/home/home_screen_for_mobile.dart';
import 'package:its_system/pages/no_internet_screen.dart';
import 'package:its_system/statics_values.dart';
import 'package:localize_and_translate/localize_and_translate.dart';


class EntryController extends GetxController {
  late GlobalKey<FormState> loginFormKey;
  late GlobalKey<FormState> signupFormKey;
  late GlobalKey<FormState> signAsVisitorFormKey;
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailNode = FocusNode();
  FocusNode nameNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  PageController pageController = PageController(initialPage: 1);
  late Rx<UserModel> user;
  RxList<Rx<CityModel>> cities = <Rx<CityModel>>[].obs;
  RxInt selectedCity = 0.obs;

  RxBool rememberMe = false.obs;
  RxBool showPassword2 = true.obs;
  RxBool showPassword1 = true.obs;


  GeneralHelper db = GeneralHelper();
  RxBool loginIn = true.obs;
  RxBool isLight = true.obs;
  RxString activeLanguageCode = "".obs;
  @override
  void onInit() async {
    super.onInit();
    loginFormKey = GlobalKey<FormState>();
    signupFormKey = GlobalKey<FormState>();
    signAsVisitorFormKey = GlobalKey<FormState>();
    GetStorage.init();
    isLight.value = GetStorage().read("darkMode");
    activeLanguageCode.value = translator.activeLanguageCode;
    user = UserModel().initialize().obs;
    await fetchAll();
  }


  fetchAll()async{
    await db.getAllAsMap("SELECT * FROM cities WHERE CTY_IS_DELETE = 0").then((value) {
      for (var i = 0; i < value!.length; i++) {
        cities.add(CityModel.fromMap(value[i]).obs);
      }
      selectedCity.value = cities.first.value.cityId!;
    }).timeout(Duration(seconds: 10)).onError((error, stackTrace) => Get.offAll(()=>NoInternetScreen()));
  }

  // onClickEnter()async{
  //     final e = await db.getById<UserModel>(" SELECT * FROM users WHERE USR_E_MAIL = ${emailController.text};");
  //     if (e != null) {
  //       passwordNode.requestFocus();
  //       nameController.text =  e.userName!.arabicTitle.text;
  //     } else {
  //       snakbarDialog(
  //           title: "errorTitle".tr(),
  //           content: "errorEmailAddress".tr(),
  //           durationSecound: 5,
  //           icon: const Icon(Icons.cancel_rounded,
  //               color: Colors.white, size: 30));
  //     }
  // }

  onLogin() async {
  if(loginFormKey.currentState!.validate()){
      final e = await db.getByIdAsMap(" SELECT * FROM users as u "
      // " INNER JOIN institutions as c ON c.INST_ID = u.INST_ID "
      // " INNER JOIN municipalities as ci ON c.MUN_ID = ci.MUN_ID "
      // " INNER JOIN cities as co ON co.CTY_ID = ci.CTY_ID "
      " WHERE (USR_PHONE = '${emailController.text}' OR USR_E_MAIL = '${emailController.text}') AND USR_PASSWORD = '${passwordController.text}'");
    if(e == null){
        snakbarDialog(
          title: "errorTitle".tr(),
          content: "errorDBConnection".tr(),
          durationSecound: 5,
          icon:
              const Icon(Icons.cancel_rounded, color: Colors.white, size: 30));
        return;
    }
    if(e is String && e == "NO ITEM"){
        snakbarDialog(
            title: "errorTitle".tr(),
            content:
                "errorEmailAddressOrPassword".tr(),
            durationSecound: 5,
            icon: const Icon(Icons.cancel_rounded,
                color: Colors.white, size: 30));
        return;
    }
    UserModel u = UserModel.fromMap(e);
    if (u.userState != States.BLOCKED && u.userState != States.DELETED) {
        StaticValue.userData = u;
        print(StaticValue.userData!.city!.toMap(false));
        print(u.city!.toMap(false));
        
        await db.update(tableName: 'users', primaryKey: 'USR_ID', primaryKeyValue: u.userId, items: {"USR_LAST_CONNECTED":DateTime.now()});
        if(rememberMe.value){
            dynamic s = await db.getByIdAsMap(
              "SELECT * FROM qr_styles ${StaticValue.userData!.userType == UserTypes.SUPER_ADMIN ? "" : " WHERE INST_ID = ${StaticValue.userData!.institution!.institutionId}"}");
            GetStorage().write("its_user", e);
          if (s != null && s is! String) {
            StaticValue.qrStyle = QRStyleModel.fromMap(s);
            GetStorage().write("qr_style", s);
          }
        }
        if(u.userType == UserTypes.CITIZEN){
          Get.off(const HomeScreenForMoble());
        }
        else{
          Get.off(const HomeScreen());
        }
        return;
      }
      snakbarDialog(
        title: "errorTitle".tr(),
        content:
            "errorEmailAddressOrPassword".tr(),
        durationSecound: 5,
        icon: const Icon(Icons.cancel_rounded,
            color: Colors.white, size: 30));
    }
  }
  onSignUp() async {
  if(signupFormKey.currentState!.validate()){
    if(selectedCity.value == 0){
        snakbarDialog(
          title: "errorTitle".tr(),
          content:
              "youMustChooseCity".tr(),
          durationSecound: 5,
          icon: const Icon(Icons.cancel_rounded,
              color: Colors.white, size: 30));
        return;
    }
    if(user.value.userPassword!.text != passwordController.text){
        snakbarDialog(
          title: "errorTitle".tr(),
          content:
              "InSimilerPasswords".tr(),
          durationSecound: 5,
          icon: const Icon(Icons.cancel_rounded,
              color: Colors.white, size: 30));
        return;
    }
    user.value.city!.cityId = selectedCity.value;
    user.value.institution!.institutionId = 0;
    if(signupFormKey.currentState!.validate()){
      final e = await db.getByIdAsMap(" SELECT * FROM users WHERE (USR_PHONE = '${user.value.userPhoneNumber!.text}')");
    if(e == null){
        snakbarDialog(
          title: "errorTitle".tr(),
          content: "errorDBConnection".tr(),
          durationSecound: 5,
          icon:
              const Icon(Icons.cancel_rounded, color: Colors.white, size: 30));
        return;
    }
    if(e is String && e == "NO ITEM"){
      final lastUserNumber = await db.getByIdAsMap("SELECT IfNull(MAX(USR_NUMBER),0) as USR_NUMBER  FROM users WHERE (INST_ID = ${user.value.institution!.institutionId})");
      user.value.userNumber!.text = (lastUserNumber["USR_NUMBER"]+1).toString();
      user.value.userUniqueKey!.text = "${selectedCity.value}0${user.value.userNumber!.text}";
      user.value.userState = States.INACTIVE;
      user.value.userId = await db.createNew("users", await user.value.toMap(false));
      if(user.value.userId! > 0){
        StaticValue.userData = user.value;
        Get.off(const HomeScreenForMoble());
        return;
      }
    }
        await snakbarDialog(
          title: "repittedValue".tr(),
          content: "dublicatePhoneNumber".tr(),
          durationSecound: 5,
          icon:
              const Icon(Icons.cancel_rounded, color: Colors.white, size: 30));
    }
  }
}
  onSignAsGuest() async {
    if(signAsVisitorFormKey.currentState!.validate()){
      final lastUserNumber = await db.getByIdAsMap(" SELECT IFNULL(MAX(USR_NUMBER),0) as USR_NUMBER  FROM users WHERE USR_TYPE = 'CITIZEN' AND (INST_ID = ${user.value.institution!.institutionId})");
      user.value.userNumber!.text = (lastUserNumber["USR_NUMBER"]+1).toString();
      user.value.userName!.arabicTitle!.text = emailController.text;
      user.value.userUniqueKey!.text = "999${user.value.userNumber!.text}";
      user.value.userPhoneNumber!.text = "999${user.value.userNumber!.text}";
      user.value.userState = States.INACTIVE;
      user.value.userType = UserTypes.GUEST;
      user.value.userId = await db.createNew("users", await user.value.toMap(false));
      GetStorage().write("its_user", user.value.toMapForSave());
      if(user.value.userId! > 0){
        StaticValue.userData = user.value;
        Get.off(const HomeScreenForMoble());
        return;
      }
    }
  }
}
