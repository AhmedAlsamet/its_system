// ignore_for_file: public_member_api_docs, sort_constructors_first, constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:its_system/models/code_model.dart';
import 'package:its_system/models/general_model.dart';
import 'package:its_system/models/institution_model.dart';
import 'package:its_system/models/user_model.dart';

class ComplaintModel {
  int? complaintId;
  TextEditingController? complaintTitle;
  CodeModel? complaintType;
  GeneralModel? date;
  UserModel? user;
  InstitutionModel? institution;
  ComplaintStates? complaintState;
  ComplaintModel({
    this.complaintId,
    this.complaintTitle,
    this.complaintType,
    this.date,
    this.user,
    this.institution,
    this.complaintState,
  });
  ComplaintModel copyWith({
    ComplaintModel? complaint
  }) {
    return ComplaintModel(
      complaintId: complaint!.complaintId ?? complaintId,
      complaintTitle:TextEditingController(text: complaint.complaintTitle != null? complaint.complaintTitle!.text : complaintTitle!.text),
      complaintType: complaint.complaintType ?? complaintType,
      complaintState: complaint.complaintState ?? complaintState,
      date: GeneralModel().copyWith(general: complaint.date),
      user: UserModel().copyWith(user: complaint.user),
      institution: InstitutionModel().copyWith(institution: complaint.institution),
    );
  }


  Map<String, dynamic> toMap(bool forUpdate) {
    Map<String, dynamic> map ={
      'COMP_ID': complaintId,
      'COMP_TITLE': complaintTitle!.text,
      'COMT_ID': complaintType!.codeId,
      'COMP_STATE': complaintState!.name,
      'USR_ID': user!.userId,
      'INST_ID': institution!.institutionId,
    };
    map.addAll(date!.toMapJustDates("COMP", forUpdate));
    return map;
  }

  factory ComplaintModel.fromMap(Map<String, dynamic> map) {
    return ComplaintModel(
      complaintId: map['COMP_ID'] != null ? map['COMP_ID'] as int : null,
      complaintTitle: TextEditingController(text: map['COMP_TITLE']??""),
      complaintType: CodeModel(codeId:  map['COMT_ID'],codeName: GeneralModel.fromMap(map,"COMT")),
      date: GeneralModel.fromMap(map,"COMP"),
      complaintState : ComplaintStates.values.firstWhere((element) => element.name == map["COMP_STATE"],orElse: () => ComplaintStates.EXIST,),
      user: UserModel.fromMap(map),
      institution: InstitutionModel.fromMap(map),
    );
  }

  String toJson(bool forUpdate) => json.encode(toMap(forUpdate));

  factory ComplaintModel.fromJson(String source) => ComplaintModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ComplaintModel(complaintId: $complaintId, complaintTitle: $complaintTitle, complaintType: $complaintType, date: $date, user: $user, institution: $institution)';
  }

  @override
  bool operator ==(covariant ComplaintModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.complaintId == complaintId &&
      other.complaintTitle == complaintTitle &&
      other.complaintType == complaintType &&
      other.date == date &&
      other.user == user &&
      other.institution == institution;
  }

  @override
  int get hashCode {
    return complaintId.hashCode ^
      complaintTitle.hashCode ^
      complaintType.hashCode ^
      date.hashCode ^
      user.hashCode ^
      institution.hashCode;
  }

  ComplaintModel initialize({
    int? complaintId,
    TextEditingController? complaintTitle,
    CodeModel? complaintType,
    GeneralModel? date,
    UserModel? user,
    InstitutionModel? institution,
    ComplaintStates? complaintState,
  }) {
    return ComplaintModel(
      complaintId: complaintId ?? 0,
      complaintTitle: complaintTitle ?? TextEditingController(),
      complaintType: complaintType ?? CodeModel(codeId: 0),
      date: date ?? GeneralModel().initialize(),
      user: user ?? UserModel().initialize(),
      complaintState: complaintState ?? ComplaintStates.EXIST,
      institution: institution ?? InstitutionModel().initialize(),
    );
  }
}

enum ComplaintStates{
  EXIST,
  ARCHIVE
}