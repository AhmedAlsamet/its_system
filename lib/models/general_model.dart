// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class GeneralModel {
  TextEditingController? arabicTitle;
  TextEditingController? englishTitle;
  DateTime? createDate;
  DateTime? updateDate;
  String? arabicHint;
  String? englishHint;


  String get getTitle {
    if(translator.activeLanguageCode == "ar"){
      if(arabicTitle!.text!= ""){
        return arabicTitle!.text;
      }
      return anyFieldHasValue();
    }
    if(translator.activeLanguageCode == "en"){
      if(englishTitle!.text!= ""){
        return englishTitle!.text;
      }
      return anyFieldHasValue();
    }
    return anyFieldHasValue();
  }

  String anyFieldHasValue(){
    if(arabicTitle!.text!= ""){
      return arabicTitle!.text;
    }
    if(englishTitle!.text!= ""){
      return englishTitle!.text;
    }
    return "NULL";
  }
   
  TextEditingController anyFieldHasValueAsFaild(){
    if(arabicTitle!.text!= ""){
      return arabicTitle!;
    }
    if(englishTitle!.text!= ""){
      return englishTitle!;
    }
    return TextEditingController();
  }
  TextEditingController get getTitleAsFaild{
    if(translator.activeLanguageCode == "ar"){
      if(arabicTitle!.text!= ""){
        return arabicTitle!;
      }
      return anyFieldHasValueAsFaild();
    }
    if(translator.activeLanguageCode == "en"){
      if(englishTitle!.text!= ""){
        return englishTitle!;
      }
      return anyFieldHasValueAsFaild();
    }
    return anyFieldHasValueAsFaild();
  }

  GeneralModel({
    this.arabicTitle,
    this.englishTitle,
    this.createDate,
    this.updateDate,
    this.arabicHint,
    this.englishHint,
  });
  

  Map<String, dynamic> toMap(String columnName,bool forUpdate) {
    Map<String, dynamic> map = {
      "${columnName}_NAME": arabicTitle!.text,
      '${columnName}_NAME_EN': englishTitle!.text,
    };
    if(forUpdate){
      map['${columnName}_UPDATED_DATE'] = DateTime.now();
    }
    return map;
  }
  Map<String, dynamic> toMapAsItIs(String columnName,String columnPrefix,bool forUpdate) {
    Map<String, dynamic> map = {
      columnName: arabicTitle!.text,
      '${columnName}_EN': englishTitle!.text,
    };
    if(forUpdate){
      map['${columnPrefix}_UPDATED_DATE'] = DateTime.now();
    }
    return map;
  }
  Map<String, dynamic> toMapJustDates(String columnName,bool forUpdate) {
    Map<String, dynamic> map = {};
    if(forUpdate){
      map['${columnName}_UPDATED_DATE'] = DateTime.now();
    }
    return map;
  }

  factory GeneralModel.fromMap(Map<String, dynamic> map,String columnPrefix) {
    return GeneralModel(
      arabicTitle: TextEditingController(text:map["${columnPrefix}_NAME"]??""),
      englishTitle: TextEditingController(text:map['${columnPrefix}_NAME_EN']??""),
      createDate: DateTime.parse(map['${columnPrefix}_CREATED_DATE']??DateTime.now().toString()),
      updateDate: DateTime.parse(map['${columnPrefix}_UPDATED_DATE']??DateTime.now().toString()),
    );
  }

  factory GeneralModel.fromMapAsItIs(Map<String, dynamic> map,String columnPrefix,String columnName) {
    return GeneralModel(
      arabicTitle: TextEditingController(text:map[columnName]??""),
      englishTitle: TextEditingController(text:map['${columnName}_EN']??""),
      createDate: DateTime.parse(map['${columnPrefix}_CREATED_DATE']??DateTime.now().toString()),
      updateDate: DateTime.parse(map['${columnPrefix}_UPDATED_DATE']??DateTime.now().toString()),
    );
  }

  String toJson(String columnName,bool forUpdate) => json.encode(toMap(columnName,forUpdate));

  factory GeneralModel.fromJson(String source,String columnName) => GeneralModel.fromMap(json.decode(source) as Map<String, dynamic>,columnName);

  GeneralModel copyWith({
    GeneralModel? general,
  }) {
    return GeneralModel(
      arabicTitle: TextEditingController(text: (general!.arabicTitle !=null ?general.arabicTitle!.text : arabicTitle!.text)),
      englishTitle:TextEditingController(text: (general.englishTitle !=null ?general.englishTitle!.text : englishTitle!.text)),
      arabicHint: general.arabicHint ?? arabicHint,
      englishHint:general. englishHint ??  englishHint,
    );
  }

  GeneralModel initialize({
    TextEditingController? arabicTitle,
    TextEditingController? englishTitle,
    TextEditingController? kurdishTitle,
    String? arabicHint,
    String? englishHint,
  }) {
    return GeneralModel(
      arabicTitle: TextEditingController(text: (arabicTitle !=null ?arabicTitle.text : "")),
      englishTitle:TextEditingController(text: (englishTitle !=null ?englishTitle.text : "")),
      arabicHint: arabicHint ?? "",
      englishHint: englishHint ?? "",
    );
  }

  
}

