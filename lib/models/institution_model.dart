// ignore_for_file: public_member_api_docs, sort_constructors_first, constant_identifier_names
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:its_system/models/place_model.dart';
import 'package:its_system/models/general_model.dart';
import 'package:its_system/models/state_enum.dart';
 
class InstitutionModel {
  int? institutionId;
  int? institutionMainId;
  GeneralModel? institutionName;
  MunicipalityModel? municipality;
  CityModel? city;
  String? institutionLongitude;
  String? institutionLatitude;
  TextEditingController? institutionAddress;
  TextEditingController? institutionEMail;
  TextEditingController? institutionPhone;
  TextEditingController? institutionPhone2;
  TextEditingController? institutionUniqueKey;
  States? institutionState;
  TextEditingController? institutionDesciption;
  File? institutionLogo;
  InstitutionModel({
    this.institutionId,
    this.institutionName,
    this.municipality,
    this.institutionAddress,
    this.institutionUniqueKey,
    this.institutionState,
    this.institutionDesciption,
    this.city,
    this.institutionEMail,
    this.institutionLatitude,
    this.institutionLongitude,
    this.institutionMainId,
    this.institutionPhone,
    this.institutionPhone2,
    this.institutionLogo,
  });


  InstitutionModel copyWith({
    InstitutionModel? institution
  }) {
    return InstitutionModel(
      institutionId: institution!.institutionId ?? institutionId,
      institutionMainId: institution.institutionMainId ?? institutionMainId,
      institutionLongitude: institution.institutionLongitude ?? institutionLongitude,
      institutionLatitude: institution.institutionLatitude ?? institutionLatitude,
      institutionLogo: institution.institutionLogo ?? institutionLogo,
      institutionName: institution.institutionName ?? institutionName!.copyWith(),
      municipality: institution.municipality ?? municipality!.copyWith(),
      city: institution.city ?? city!.copyWith(),
      institutionAddress:TextEditingController(text:  institution.institutionAddress != null ?institution.institutionAddress!.text  : institutionAddress!.text),
      institutionUniqueKey:TextEditingController(text:institution. institutionUniqueKey != null ?institution.institutionUniqueKey!.text  : institutionUniqueKey!.text),
      institutionDesciption:TextEditingController(text:institution. institutionDesciption != null ?institution.institutionDesciption!.text  : institutionDesciption!.text),
      institutionEMail:TextEditingController(text:institution. institutionEMail != null ?institution.institutionEMail!.text  : institutionEMail!.text),
      institutionPhone:TextEditingController(text:institution. institutionPhone != null ?institution.institutionPhone!.text  : institutionPhone!.text),
      institutionPhone2:TextEditingController(text:institution. institutionPhone2 != null ?institution.institutionPhone2!.text  : institutionPhone2!.text),
      institutionState: institution.institutionState ?? institutionState,
    );
  }

  Map<String, dynamic> toMap(bool forUpdate) {

    Map<String, dynamic> map = {
      // 'INST_ID': institutionId,
      'INST_MAIN_ID': institutionMainId,
      'INST_LONGITUDE': institutionLongitude,
      'INST_LATITUDE': institutionLatitude,
      'MUN_ID': municipality!.municipalityId,
      'CTY_ID': city!.cityId,
      'INST_ADDRESS': institutionAddress!.text,
      'INST_E_MAIL': institutionEMail!.text,
      'INST_PHONE': institutionPhone!.text,
      'INST_PHONE2': institutionPhone2!.text,
      'INST_UNIQUE_KEY': institutionUniqueKey!.text,
      'INST_STATE': institutionState!.name,
      'INST_DESCRIPTION': institutionDesciption!.text,
      'INST_LOGO_PATH': institutionLogo!.path,
    };
    map.addAll(institutionName!.toMap("INST",forUpdate));
    return map;
  }

  factory InstitutionModel.fromMap(Map<String, dynamic> map) {
    return InstitutionModel(
      institutionId: map['INST_ID'] != null ? map['INST_ID'] as int : null,
      institutionMainId: map['INST_MAIN_ID'] != null ? map['INST_MAIN_ID'] as int : null,
      institutionLongitude: map['INST_LONGITUDE'] != null ? map['INST_LONGITUDE'] as String : null,
      institutionLatitude: map['INST_LATITUDE'] != null ? map['INST_LATITUDE'] as String : null,
      institutionName: GeneralModel.fromMap(map,"INST"),
      municipality: MunicipalityModel.fromMap(map),
      city: CityModel.fromMap(map),
      institutionAddress: TextEditingController(text: map['INST_ADDRESS'] ??""),
      institutionUniqueKey: TextEditingController(text: map['INST_UNIQUE_KEY'] ??""),
      institutionDesciption: TextEditingController(text: map['INST_DESCRIPTION'] ??""),
      institutionPhone: TextEditingController(text: map['INST_PHONE'] ??""),
      institutionPhone2: TextEditingController(text: map['INST_PHONE2'] ??""),
      institutionEMail: TextEditingController(text: map['INST_E_MAIL'] ??""),
      institutionLogo: File(map["INST_LOGO_PATH"] ?? ""),
      institutionState: States.values.firstWhere((element) => element.name == map['INST_STATE'],orElse: () => States.ACTIVE,),
    );
  }

  String toJson(bool forUpdate) => json.encode(toMap(forUpdate));

  factory InstitutionModel.fromJson(String source) => InstitutionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CompoundModel(userId: $institutionId, institutionName: $institutionName, municipality: $municipality, institutionAddress: $institutionAddress, institutionUniqueKey: $institutionUniqueKey, institutionState: $institutionState, institutionDesciption: $institutionDesciption)';
  }

  @override
  bool operator ==(covariant InstitutionModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.institutionId == institutionId &&
      other.institutionName == institutionName &&
      other.municipality == municipality &&
      other.institutionAddress!.text == institutionAddress!.text &&
      other.institutionUniqueKey!.text == institutionUniqueKey!.text &&
      other.institutionDesciption!.text == institutionDesciption!.text &&
      other.institutionState == institutionState ;
  }

  @override
  int get hashCode {
    return institutionId.hashCode ^
      institutionName.hashCode ^
      municipality.hashCode ^
      institutionAddress.hashCode ^
      institutionUniqueKey.hashCode ^
      institutionState.hashCode ^
      institutionDesciption.hashCode;
  }

  InstitutionModel initialize({
    int? institutionId,
    GeneralModel? institutionName,
    MunicipalityModel? municipality,
    TextEditingController? institutionAddress,
    TextEditingController? institutionUniqueKey,
    States? institutionState,
    TextEditingController? institutionDesciption,
    File? institutionLogo,
  }) {
    return InstitutionModel(
      institutionId: institutionId ?? 0,
      institutionMainId: institutionMainId ?? 0,
      institutionLatitude: institutionLatitude ?? "0",
      institutionLongitude: institutionLongitude ?? "0",
      institutionLogo: institutionLogo ?? File(""),
      institutionName: institutionName ?? GeneralModel().initialize(),
      municipality: municipality ?? MunicipalityModel().initialize(),
      city: city ?? CityModel().initialize(),
      institutionAddress:TextEditingController(text:   institutionAddress != null ?institutionAddress.text  : ""),
      institutionUniqueKey:TextEditingController(text:  institutionUniqueKey != null ?institutionUniqueKey.text  : ""),
      institutionDesciption:TextEditingController(text: institutionDesciption != null ?institutionDesciption.text  : ""),
      institutionEMail:TextEditingController(text: institutionEMail != null ?institutionEMail!.text  : ""),
      institutionPhone:TextEditingController(text: institutionPhone != null ?institutionPhone!.text  : ""),
      institutionPhone2:TextEditingController(text: institutionPhone2 != null ?institutionPhone2!.text  : ""),
      institutionState: institutionState ?? States.ACTIVE,
    );
  }
}
