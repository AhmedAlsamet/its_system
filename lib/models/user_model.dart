// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: constant_identifier_names

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:its_system/functions.dart';
import 'package:its_system/models/institution_model.dart';
import 'package:its_system/models/general_model.dart';
import 'package:its_system/models/place_model.dart';
import 'package:its_system/models/state_enum.dart';

class UserModel {
  int? userId;
  TextEditingController? userAge;
  TextEditingController? userNumber;
  GeneralModel? userName;
  TextEditingController? userPassword;
  TextEditingController? userUniqueKey;
  TextEditingController? userEMail;
  TextEditingController? userPhoneNumber;
  TextEditingController? userAddress1;
  TextEditingController? userAddress2;
  TextEditingController? userNote;
  UserTypes? userType;
  File? userImage;
  File? userIDCardImage;
  String? userIDCardPath;
  String? userImagePath;
  States? userState;
  DateTime? userLastConnected;
  DateTime? userRegisterDate;
  InstitutionModel? institution;
  CityModel? city;
  bool? userGender;
  UserModel({
    this.userId,
    this.userAge,
    this.userNumber,
    this.userName,
    this.userPassword,
    this.userEMail,
    this.userUniqueKey,
    this.userPhoneNumber,
    this.userType,
    this.userImage,
    this.userIDCardImage,
    this.userIDCardPath,
    this.userImagePath,
    this.userState,
    this.institution,
    this.userLastConnected,
    this.userRegisterDate,
    this.userGender,
    this.userAddress1,
    this.userAddress2,
    this.userNote,
    this.city,
  });

  UserModel.fromMap(Map<String, dynamic> map,[String prefix = ""]) {
    userId = (map['${prefix}USR_ID']??0);
    userAge = TextEditingController(text:(map['${prefix}USR_AGE']??"").toString());
    userGender = getFromBoolOrInt(map['${prefix}USR_GENDER']??"");
    userNumber = TextEditingController(text:(map['${prefix}USR_NUMBER']??"0").toString());
    userName = GeneralModel.fromMap(map, "${prefix}USR");
    institution = InstitutionModel.fromMap(map);
    city = CityModel.fromMap(map);
    userPassword = TextEditingController(text: map["${prefix}USR_PASSWORD"] ?? "");
    userEMail = TextEditingController(text: map["${prefix}USR_E_MAIL"] ?? "");
    userUniqueKey = TextEditingController(text: map["${prefix}USR_UNIQUE_KEY"] ?? "");
    userPhoneNumber = TextEditingController(text: map["${prefix}USR_PHONE"] ?? "");
    userAddress1 = TextEditingController(text: map["${prefix}USR_ADDRESS1"] ?? "");
    userAddress2 = TextEditingController(text: map["${prefix}USR_ADDRESS2"] ?? "");
    userNote = TextEditingController(text: map["${prefix}USR_NOTE"] ?? "");
    userImage = File(map["${prefix}USR_IMG_PATH"] ?? "");
    userIDCardImage = File(map["${prefix}USR_ID_PATH"] ?? "");
    userImagePath = map["${prefix}USR_IMG_PATH"] ?? "";
    userIDCardPath = map["${prefix}USR_ID_PATH"] ?? "";
    userState = States.values.firstWhere((element) => element.name == map["${prefix}USR_STATE"],orElse: () => States.ACTIVE,);
    userType = UserTypes.values.firstWhere((element) => element.name == map["${prefix}USR_TYPE"],orElse: () => UserTypes.ADMIN,);
    userRegisterDate = DateTime.parse(map['${prefix}USR_REGISTER_DATE']??DateTime.now().toString());
    userLastConnected = DateTime.parse(map['${prefix}USR_LAST_CONNECTED']??DateTime.now().toString());
  }
  UserModel.fromMapWithOnlyIdAndName(Map<String, dynamic> map) {
    userId = (map['USR_ID']??0);
    userNumber = TextEditingController(text:map['USR_ID']??"0");
    userName = GeneralModel.fromMap(map, "USR");
  }

  Future<Map<String, dynamic>> toMap(bool forUpdate) async{
    print(city!.toMap(false));
    if(userImage!.path != userImagePath) {
      userImagePath = await postRequestWithFile("user_photos", int.parse(city!.cityId!.toString()+userNumber!.text) ,userImage!);
    }
    if(userIDCardImage!.path != userIDCardPath) {
      userIDCardPath = await postRequestWithFile("user_ids", int.parse(city!.cityId!.toString()+userNumber!.text) ,userIDCardImage!);
    }
    Map<String, dynamic> map = <String, dynamic>{};
    map['USR_AGE'] = userAge!.text == "" ? "0" : userAge!.text;
    map['USR_GENDER'] = convertBoolToInt(userGender);
    map['USR_NUMBER'] = userNumber!.text;
    map["USR_PASSWORD"]   = userPassword!.text;
    map["USR_UNIQUE_KEY"] = userUniqueKey!.text;
    map["USR_PHONE"] = userPhoneNumber!.text;
    map["USR_ADDRESS1"] = userAddress1!.text;
    map["USR_ADDRESS2"] = userAddress2!.text;
    map["USR_NOTE"] = userNote!.text;
    map["USR_E_MAIL"] = userEMail!.text;
    map["INST_ID"] = institution!.institutionId;
    map["CTY_ID"] = city!.cityId;
    map["USR_IMG_PATH"] = userImagePath;
    map["USR_ID_PATH"] = userIDCardPath;
    map["USR_LAST_CONNECTED"] = userLastConnected.toString();
    map["USR_REGISTER_DATE"] = userRegisterDate.toString();
    map["USR_TYPE"] = userType!.name;
    map["USR_STATE"] = userState!.name;

    map.addAll(userName!.toMap("USR",forUpdate));
    return map;
  }
  Map<String, dynamic> toMapForSave() {
    Map<String, dynamic> map = <String, dynamic>{};
    map['USR_ID'] = userId;
    map['USR_AGE'] = userAge!.text == "" ? "0" : userAge!.text;
    map['USR_GENDER'] = convertBoolToInt(userGender);
    map['USR_NUMBER'] = userNumber!.text;
    map["USR_PASSWORD"]   = userPassword!.text;
    map["USR_UNIQUE_KEY"] = userUniqueKey!.text;
    map["USR_PHONE"] = userPhoneNumber!.text;
    map["USR_E_MAIL"] = userEMail!.text;
    map["INST_ID"] = userType==UserTypes.SUPER_ADMIN ? 0 : institution!.institutionId;
    map["CTY_ID"] = city!.cityId;
    map["USR_IMG_PATH"] = userImagePath;
    map["USR_ID_PATH"] = userIDCardPath;
    map["USR_ADDRESS1"] = userAddress1!.text;
    map["USR_ADDRESS2"] = userAddress2!.text;
    map["USR_LAST_CONNECTED"] = userLastConnected.toString();
    map["USR_REGISTER_DATE"] = userRegisterDate.toString();
    map["USR_TYPE"] = userType!.name;
    map["USR_STATE"] = userState!.name;

    map.addAll(userName!.toMap("USR",false));
    return map;
  }

  // Map<String, dynamic> toMapWithOutPassord(bool forUpdate) {
  //   Map<String, dynamic> map = <String, dynamic>{};
  //   map['USR_NUMBER'] = userNumber!.text;
  //   map["USR_TYPE"] = userType;
  //   map["USR_TYPE"] = getUserType(userType!);
  //   map["USR_STATE"] = getState(userState!);
  //   map.addAll(userName!.toMap("USR_NAME",forUpdate));
  //   return map;
  // }


  // getUserType(UserTypes type){
  //   switch (type) {
  //     case UserTypes.CITIZEN:
  //       return "CITIZEN";
  //     case UserTypes.FAMILY:
  //       return "FAMILY";
  //     case UserTypes.SECURITY:
  //       return "SECURITY";
  //     case UserTypes.SUPER_ADMIN:
  //       return "SUPER_ADMIN";
  //     case UserTypes.ADMIN:
  //       return "ADMIN";
  //     default:
  //       return "CITIZEN";
  //   }
  // }
  // getUserTypeAsString(UserTypes type){
  //   switch (type) {
  //     case UserTypes.CITIZEN:
  //       return "مقيم";
  //     case UserTypes.FAMILY:
  //       return "فرد عائلة";
  //     case UserTypes.SECURITY:
  //       return "فرد أمن";
  //     case UserTypes.SUPER_ADMIN:
  //       return "أدمن رئيسي";
  //     case UserTypes.ADMIN:
  //       return "أدمن";
  //     default:
  //       return "CITIZEN";
  //   }
  // }
  // setUserType(String type){
  //   switch (type) {
  //     case "CITIZEN":
  //       return UserTypes.CITIZEN;
  //     case "FAMILY":
  //       return UserTypes.FAMILY;
  //     case "SECURITY":
  //       return UserTypes.SECURITY;
  //     case "SUPER_ADMIN":
  //       return UserTypes.SUPER_ADMIN;
  //     case "ADMIN":
  //       return UserTypes.ADMIN;
  //     default:
  //       return UserTypes.CITIZEN;
  //   }
  // }

  //   getUserStateAsString(States state){
  //   switch (state) {
  //     case States.ACTIVE:
  //       return "ACTIVE".tr();
  //     case States.INACTIVE:
  //       return "INACTIVE".tr();
  //     case States.BLOCKED:
  //       return "محظور";
  //     // case States.DELETED:
  //     //   return "محذوف";
  //     default:
  //       return "ACTIVE".tr();
  //   }
  // }

  UserModel copyWith({
    UserModel? user
  }) {
    return UserModel(
      userId:(user!.userId ?? userId),
      userNumber:TextEditingController(text: user.userNumber != null? user.userNumber!.text:userNumber!.text),
      userAge:TextEditingController(text: user.userAge != null? user.userAge!.text:userAge!.text),
      userName:GeneralModel().copyWith(general: user.userName!),
      institution:user.institution ?? InstitutionModel().copyWith(institution: institution!),
      city:user.city ?? CityModel().copyWith(city: city!),
      userPassword:TextEditingController(text: user.userPassword != null? user.userPassword!.text : userPassword!.text),
      userEMail:TextEditingController(text:user. userEMail != null? user.userEMail!.text : userEMail!.text),
      userPhoneNumber:TextEditingController(text: user.userPhoneNumber != null? user.userPhoneNumber!.text : userPhoneNumber!.text),
      userAddress1:TextEditingController(text: user.userAddress1 != null? user.userAddress1!.text : userAddress1!.text),
      userAddress2:TextEditingController(text: user.userAddress2 != null? user.userAddress2!.text : userAddress2!.text),
      userUniqueKey:TextEditingController(text:user. userUniqueKey != null? user.userUniqueKey!.text : userUniqueKey!.text),
      userNote:TextEditingController(text:user. userNote != null? user.userNote!.text : userNote!.text),
      userType:user.userType ?? userType,
      userLastConnected:user.userLastConnected ?? userLastConnected,
      userRegisterDate:user.userRegisterDate ?? userRegisterDate,
      userImage:user.userImage ?? userImage,
      userImagePath:user.userImagePath ?? userImagePath,
      userIDCardImage:user.userIDCardImage ?? userIDCardImage,
      userIDCardPath:user.userIDCardPath ?? userIDCardPath,
      userState:user.userState ?? userState,
      userGender:user.userGender ?? userGender,
    );
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.userId == userId &&
      other.userNumber!.text == userNumber!.text &&
      other.userName!.arabicTitle!.text == userName!.arabicTitle!.text &&
      other.userName!.englishTitle!.text == userName!.englishTitle!.text &&
      other.userPassword == userPassword &&
      other.userLastConnected == userLastConnected &&
      other.userRegisterDate == userRegisterDate &&
      other.userType == userType &&
      other.userImage == userImage &&
      other.userState == userState;
  }

  @override
  int get hashCode {
    return userNumber.hashCode ^
      userName.hashCode ^
      userPassword.hashCode ^
      userType.hashCode ^
      userImage.hashCode ^
      userState.hashCode;
  }

    UserModel initialize({
        int? userId,
        TextEditingController? userNumber,
        TextEditingController? userAge,
        GeneralModel? userName,
        TextEditingController? userPassword,
        TextEditingController? userUniqueKey,
        TextEditingController? userEMail,
        TextEditingController? userPhoneNumber,
        TextEditingController? userAddress1,
        TextEditingController? userAddress2,
        TextEditingController? userNote,
        UserTypes? userType,
        File? userImage,
        String? userImagePath,
        File? userIDCardImage,
        String? userIDCardPath,
        States? userState,
        DateTime? userLastConnected,
        DateTime? userRegisterDate,
        InstitutionModel? institution,
        CityModel? city,
        int? userLedId,
        TextEditingController? userLedNumber,
        TextEditingController? userLedName,
        bool? userGender,
        }) {
    return UserModel(
      userId: userId??0,
      institution: institution??InstitutionModel().initialize(),
      city: city??CityModel().initialize(),
      userImage:userImage ?? File(""),
      userImagePath:userImagePath ?? "",
      userIDCardImage:userIDCardImage ?? File(""),
      userIDCardPath:userIDCardPath ?? "",
      userType:userType ?? UserTypes.CITIZEN,
      userNumber:TextEditingController(text:userNumber!=null ? userNumber.text : ""),
      userAge:TextEditingController(text:userAge!=null ? userAge.text : ""),
      userUniqueKey: TextEditingController(text: (userUniqueKey !=null ?userUniqueKey.text : "")),
      userName: userName??GeneralModel().initialize(),
      userLastConnected:userLastConnected ?? DateTime.now(),
      userRegisterDate:userRegisterDate ?? DateTime.now(),
      userState:userState ?? States.ACTIVE,
      userGender:userGender ?? true,
      userPassword: TextEditingController(text: (userPassword !=null ?userPassword.text : "")),
      userPhoneNumber:TextEditingController(text: (userPhoneNumber!=null ?userPhoneNumber.text : "")),
      userEMail:TextEditingController(text: (userEMail !=null ?userEMail.text : "")),
      userAddress1:TextEditingController(text: (userAddress1 !=null ?userAddress1.text : "")),
      userAddress2:TextEditingController(text: (userAddress2 !=null ?userAddress2.text : "")),
      userNote:TextEditingController(text: (userNote !=null ?userNote.text : "")),
    );
  }

}

enum UserTypes {
  SUPER_ADMIN,
  CITIZEN,
  GUEST,
  ADMIN,
}
