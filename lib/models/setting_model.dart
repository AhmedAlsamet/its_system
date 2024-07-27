// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:flutter/material.dart';

class SettingModel {
  int? settingId;
  TextEditingController? settingValue;
  String? settingCode;
  String? settingType;
  int? institutionId;
  SettingModel({
    this.settingId,
    this.settingValue,
    this.settingCode,
    this.settingType,
    this.institutionId,
  });


  SettingModel copyWith({
    int? settingId,
    TextEditingController? settingValue,
    String? settingCode,
    String? settingType,
    int? institutionId,
  }) {
    return SettingModel(
      settingId: settingId ?? this.settingId,
      settingValue: settingValue ?? this.settingValue,
      settingCode: settingCode ?? this.settingCode,
      settingType: settingType ?? this.settingType,
      institutionId: institutionId ?? this.institutionId,
    );
  }

    SettingModel.fromMap(Map<String,dynamic> map){
    settingId =  map['SET_ID'];
    settingCode =  map['SET_CODE'];
    settingValue =  TextEditingController(text: map['SET_VALUE'] ?? "");
    settingType =  map['SET_TYPE'];
    institutionId =  map['INST_ID'];
  }
  

    Map<String,dynamic> toMap(){
    Map<String,dynamic> map = <String, dynamic>{};
    map['SET_ID'] = settingId;
    map['SET_CODE'] = settingCode;
    map['SET_VALUE'] = settingValue!.text;
    map['SET_TYPE'] = settingType;
    map['INST_ID'] = institutionId;
    return map;
  }

  String toJson() => json.encode(toMap());

  factory SettingModel.fromJson(String source) => SettingModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SettingModel(settingId: $settingId, settingValue: $settingValue, settingCode: $settingCode, settingType: $settingType)';
  }

  @override
  bool operator ==(covariant SettingModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.settingId == settingId &&
      other.settingValue!.text == settingValue!.text &&
      other.settingCode == settingCode &&
      other.settingType == settingType;
  }

  @override
  int get hashCode {
    return settingId.hashCode ^
      settingValue.hashCode ^
      settingCode.hashCode ^
      settingType.hashCode;
  }
}
