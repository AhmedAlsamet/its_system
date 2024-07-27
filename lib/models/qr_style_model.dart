// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:its_system/functions.dart';
import 'package:its_system/models/institution_model.dart';

class QRStyleModel {

  int? qrStyleId;
  InstitutionModel? institution;
  Color? qrColor;
  bool? qrStyleIsRounded;
  bool? qrIsDefault;
  File? qrImageFile;
  String? qrImagePath;
  QRStyle? qrStyle;
  PrettyQrDecorationImagePosition? qrImagePosition;
  QRStyleModel({
    this.qrStyleId,
    this.institution,
    this.qrColor,
    this.qrStyleIsRounded,
    this.qrIsDefault,
    this.qrImageFile,
    this.qrImagePath,
    this.qrStyle,
    this.qrImagePosition,
  });

  QRStyleModel copyWith({
    QRStyleModel? qrStyle,
  }) {
    return QRStyleModel(
      qrStyleId: qrStyle!.qrStyleId ?? qrStyleId,
      institution: qrStyle.institution ?? institution!.copyWith(),
      qrColor: qrStyle.qrColor ?? qrColor,
      qrStyleIsRounded:qrStyle. qrStyleIsRounded ?? qrStyleIsRounded,
      qrIsDefault: qrStyle.qrIsDefault ?? qrIsDefault,
      qrImagePath: qrStyle.qrImagePath != "" ? qrStyle.qrImagePath :qrImagePath,
      qrImageFile: qrStyle.qrImageFile!.path != "" ? qrStyle.qrImageFile :qrImageFile,
      qrStyle: qrStyle.qrStyle ?? this.qrStyle,
      qrImagePosition:qrStyle. qrImagePosition ?? qrImagePosition,
    );
  }
  QRStyleModel initialize({
    int? qrStyleId,
    InstitutionModel? institution,
    Color? qrColor,
    bool? qrStyleIsRounded,
    bool? qrIsDefault,
    String? qrImagePath,
    File? qrImageFile,
    QRStyle? qrStyle,
    PrettyQrDecorationImagePosition? qrImagePosition,
  }) {
    return QRStyleModel(
      qrStyleId: qrStyleId ?? 0,
      institution: institution ?? InstitutionModel().initialize(),
      qrColor: qrColor ?? Colors.black,
      qrStyleIsRounded: qrStyleIsRounded ?? true,
      qrIsDefault: qrIsDefault ?? false,
      qrImageFile: File(qrImageFile != null ? qrImageFile.path:""),
      qrImagePath: qrImagePath ?? "",
      qrStyle: qrStyle ?? QRStyle.Smooth,
      qrImagePosition: qrImagePosition ?? PrettyQrDecorationImagePosition.embedded,
    );
  }


  Future<Map<String, dynamic>> toMap() async{
    if(qrImageFile!.path != "" && (await qrImageFile!.exists())) {
      qrImagePath = await postRequestWithFile("qr_photos", institution!.institutionId! ,qrImageFile!);
    }
    return <String, dynamic>{
      // 'QRS_ID': qrStyleId,
      'INST_ID': institution!.institutionId,
      'QRS_COLOR': qrColor!.value,
      'QRS_IS_ROUNDED': qrStyleIsRounded! ? "1" : "0",
      'QRS_IS_DEFAULT': qrIsDefault!  ? "1" : "0",
      'QRS_IMAGE_PATH': qrImagePath,
      'QRS_STYLE': qrStyle!.name,
      'QRS_IMAGE_POSITION': qrImagePosition!.name,
    };
  }

  factory QRStyleModel.fromMap(Map<String, dynamic> map) {
    return QRStyleModel(
      qrStyleId: map['QRS_ID'] != null ? map['QRS_ID'] as int : null,
      institution: map['INST_ID'] != null ? InstitutionModel.fromMap(map) : null,
      qrColor: map['QRS_COLOR'] != null ? Color(int.parse(map['QRS_COLOR'].toString())) : null,
      qrStyleIsRounded: map['QRS_IS_ROUNDED'] != null ? map['QRS_IS_ROUNDED'] as bool : null,
      qrIsDefault: map['QRS_IS_DEFAULT'] != null ? map['QRS_IS_DEFAULT'] as bool : null,
      // qrImagePath: File(map['QRS_IMAGE_PATH']??""),
      qrImagePath: map['QRS_IMAGE_PATH']??"",
      qrStyle: QRStyle.values.firstWhere((element) => element.name == map['QRS_STYLE'],orElse: () => QRStyle.Smooth,),
      qrImagePosition: PrettyQrDecorationImagePosition.values.firstWhere((element) => element.name == map['QRS_STYLE'],orElse: () => PrettyQrDecorationImagePosition.embedded,),
    );
  }

  String toJson() => json.encode(toMap());

  factory QRStyleModel.fromJson(String source) => QRStyleModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'QRStyleModel(qrStyleId: $qrStyleId, institution: $institution, qrColor: $qrColor, qrStyleIsRounded: $qrStyleIsRounded, qrIsDefault: $qrIsDefault, qrImagePath: $qrImagePath, qrStyle: $qrStyle, qrImagePosition: $qrImagePosition)';
  }

  @override
  bool operator ==(covariant QRStyleModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.qrStyleId == qrStyleId &&
      other.institution == institution &&
      other.qrColor == qrColor &&
      other.qrStyleIsRounded == qrStyleIsRounded &&
      other.qrIsDefault == qrIsDefault &&
      other.qrImagePath == qrImagePath &&
      other.qrStyle == qrStyle &&
      other.qrImagePosition == qrImagePosition;
  }

  @override
  int get hashCode {
    return qrStyleId.hashCode ^
      institution.hashCode ^
      qrColor.hashCode ^
      qrStyleIsRounded.hashCode ^
      qrIsDefault.hashCode ^
      qrImagePath.hashCode ^
      qrStyle.hashCode ^
      qrImagePosition.hashCode;
  }
}



enum QRStyle{
  Smooth,
  Rounded_rectangle
}
