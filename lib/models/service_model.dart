// ignore_for_file: public_member_api_docs, sort_constructors_first, constant_identifier_names
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:its_system/functions.dart';
import 'package:its_system/models/code_model.dart';
import 'package:its_system/models/general_model.dart';
import 'package:its_system/models/institution_model.dart';
import 'package:its_system/models/state_enum.dart';

class ServiceGroupModel {
  int? serviceGroupId;
  GeneralModel? serviceGroupName;
  InstitutionModel? institution; 
  ServiceGroupModel({
    this.serviceGroupId,
    this.serviceGroupName,
    this.institution,
  });

  ServiceGroupModel copyWith({
    ServiceGroupModel? serviceGroup
  }) {
    return ServiceGroupModel(
      serviceGroupId: serviceGroup!.serviceGroupId ?? serviceGroupId,
      serviceGroupName:GeneralModel().copyWith(general: serviceGroup.serviceGroupName!),
      institution: serviceGroup.institution ?? institution!.copyWith(),
    );
  }

  Map<String, dynamic> toMap(bool forUpdate) {
    Map <String, dynamic> map = {
      'INST_ID': institution!.institutionId
    };
    map.addAll(serviceGroupName!.toMap("SRVG", forUpdate));
    return map;
  }

  factory ServiceGroupModel.fromMap(Map<String, dynamic> map) {
    return ServiceGroupModel(
      serviceGroupId: map['SRVG_ID'] != null ? map['SRVG_ID'] as int : null,
      serviceGroupName: GeneralModel.fromMap(map,"SRVG"),
      institution: InstitutionModel.fromMap(map),
    );
  }

  String toJson(bool forUpdate) => json.encode(toMap(forUpdate));

  factory ServiceGroupModel.fromJson(String source) => ServiceGroupModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ServiceGroupModel(serviceGroupId: $serviceGroupId, serviceGroupName: $serviceGroupName, institution: $institution)';

  @override
  bool operator ==(covariant ServiceGroupModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.serviceGroupId == serviceGroupId &&
      other.serviceGroupName == serviceGroupName &&
      other.institution == institution;
  }

  @override
  int get hashCode => serviceGroupId.hashCode ^ serviceGroupName.hashCode ^ institution.hashCode;

  ServiceGroupModel initialize({
    int? serviceGroupId,
    GeneralModel? serviceGroupName,
    InstitutionModel? institution,
  }) {
    return ServiceGroupModel(
      serviceGroupId: serviceGroupId ?? 0,
      serviceGroupName: serviceGroupName ?? GeneralModel().initialize(),
      institution: institution ?? InstitutionModel().initialize(),
    );
  }
}

class ServiceModel {
  int? serviceId;
  GeneralModel? serviceName;
  int? serviceState;
  bool? serviceHasStaticValue;
  ServiceTypes? serviceType;
  GeneralModel? serviceDescription;
  TextEditingController? servicePrice;
  TextEditingController? serviceTime;
  TextEditingController? serviceNumber;
  ServiceGroupModel? serviceGroup;
  InstitutionModel? institution; 
  List<ServicePlaceModel>? servicePlaces;
  List<ServiceGuideModel>? serviceGuides;
  List<ServiceFormModel>? serviceForms;
  ServiceModel({
    this.serviceId,
    this.serviceName,
    this.serviceState,
    this.serviceDescription,
    this.servicePrice,
    this.serviceTime,
    this.serviceGroup,
    this.institution,
    this.servicePlaces,
    this.serviceGuides,
    this.serviceForms,
    this.serviceHasStaticValue,
    this.serviceType,
    this.serviceNumber,
  });

  ServiceModel copyWith({
    ServiceModel? service
  }) {
    return ServiceModel(
      serviceId: service!.serviceId ?? serviceId,
      serviceHasStaticValue: service.serviceHasStaticValue ?? serviceHasStaticValue,
      serviceType: service.serviceType ?? serviceType,
      serviceName: GeneralModel().copyWith(general: service.serviceName!),
      serviceState: service.serviceState ?? serviceState,
      serviceDescription:GeneralModel().copyWith(general: service.serviceDescription!),
      servicePrice:TextEditingController(text: service.servicePrice != null? service.servicePrice!.text : servicePrice!.text),
      serviceTime:TextEditingController(text: service.serviceTime != null? service.serviceTime!.text : serviceTime!.text),
      serviceNumber:TextEditingController(text: service.serviceNumber != null? service.serviceNumber!.text : serviceNumber!.text),
      serviceGroup: ServiceGroupModel().copyWith(serviceGroup: service.serviceGroup),
      institution: InstitutionModel().copyWith(institution: service.institution),
    );
  }

  Map<String, dynamic> toMap(bool forUpdate) {
    Map<String, dynamic> map = {
      'SRV_STATE': serviceState,
      'SRV_TYPE': serviceType!.name,
      'SRV_PRICE': servicePrice!.text,
      'SRV_TIME': serviceTime!.text,
      'SRV_NUMBER': serviceNumber!.text,
      'SRVG_ID': serviceGroup!.serviceGroupId,
      'INST_ID': institution!.institutionId,
      'SRV_HAS_STATIC_PRICE':convertBoolToInt(serviceHasStaticValue)
    };
    map.addAll(serviceName!.toMap("SRV", forUpdate));
    map.addAll(serviceDescription!.toMapAsItIs("SRV_DESCRIPTION","SRV", forUpdate));
    return map;
  }

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      serviceId: map['SRV_ID'] != null ? map['SRV_ID'] as int : null,
      serviceHasStaticValue: getFromBoolOrInt(map['SRV_HAS_STATIC_PRICE']),
      serviceType: ServiceTypes.values.firstWhere((element) => element.name == map['SRV_TYPE'],orElse: () => ServiceTypes.NEW,),
      serviceName: GeneralModel.fromMap(map,"SRV"),
      serviceState: map['SRV_STATE'] != null ? map['SRV_STATE'] as int : null,
      serviceDescription:GeneralModel.fromMapAsItIs(map,"SRV","SRV_DESCRIPTION"),
      servicePrice:TextEditingController(text: (map["SRV_PRICE"] ?? "").toString()),
      serviceTime:TextEditingController(text: (map["SRV_TIME"] ?? "").toString()),
      serviceNumber:TextEditingController(text: (map["SRV_NUMBER"] ?? "").toString()),
      serviceGroup: ServiceGroupModel.fromMap(map),
      institution: InstitutionModel.fromMap(map),
    );
  }

  String toJson(bool forUpdate) => json.encode(toMap(forUpdate));

  factory ServiceModel.fromJson(String source) => ServiceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ServiceModel(serviceId: $serviceId, serviceName: $serviceName, serviceState: $serviceState, serviceDescription: $serviceDescription, servicePrice: $servicePrice, serviceTime: $serviceTime, serviceGroup: $serviceGroup, institution: $institution)';
  }

  @override
  bool operator ==(covariant ServiceModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.serviceId == serviceId &&
      other.serviceName == serviceName &&
      other.serviceState == serviceState &&
      other.serviceDescription == serviceDescription &&
      other.servicePrice == servicePrice &&
      other.serviceTime == serviceTime &&
      other.serviceGroup == serviceGroup &&
      other.institution == institution;
  }

  @override
  int get hashCode {
    return serviceId.hashCode ^
      serviceName.hashCode ^
      serviceState.hashCode ^
      serviceDescription.hashCode ^
      servicePrice.hashCode ^
      serviceTime.hashCode ^
      serviceGroup.hashCode ^
      institution.hashCode;
  }

  ServiceModel initialize({
    int? serviceId,
    GeneralModel? serviceName,
    int? serviceState,
    GeneralModel? serviceDescription,
    TextEditingController? servicePrice,
    TextEditingController? serviceTime,
    TextEditingController? serviceNumber,
    ServiceGroupModel? serviceGroup,
    InstitutionModel? institution,
    States? serviceState2,
    bool? serviceHasStaticValue,
    ServiceTypes? serviceType,
  }) {
    return ServiceModel(
      serviceId: serviceId ?? 0,
      serviceName: serviceName ?? GeneralModel().initialize(),
      serviceState: serviceState ?? 1,
      serviceHasStaticValue: serviceHasStaticValue ?? true,
      serviceType: serviceType ?? ServiceTypes.NEW,
      serviceDescription:serviceDescription ?? GeneralModel().initialize(),
      servicePrice:TextEditingController(text:servicePrice!=null ? servicePrice.text : ""),
      serviceTime:TextEditingController(text:serviceTime!=null ? serviceTime.text : ""),
      serviceNumber:TextEditingController(text:serviceNumber!=null ? serviceNumber.text : ""),
      serviceGroup: serviceGroup ?? ServiceGroupModel().initialize(),
      institution: institution ?? InstitutionModel().initialize(),
    );
  }
}

class ServicePlaceModel {
  int? servicePlaceId;
  InstitutionModel? institution; 
  ServiceModel? service;
  GeneralModel? date;
  ServicePlaceModel({
    this.servicePlaceId,
    this.institution,
    this.service,
    this.date,
  });

  ServicePlaceModel copyWith({
    ServicePlaceModel? servicePlace
  }) {
    return ServicePlaceModel(
      servicePlaceId: servicePlace!.servicePlaceId ?? servicePlaceId,
      institution: InstitutionModel().copyWith(institution:servicePlace.institution ),
      date: GeneralModel().copyWith(general: servicePlace.date),
      service: ServiceModel().copyWith(service: servicePlace.service),
    );
  }

  Map<String, dynamic> toMap(bool forUpdate) {
    Map<String, dynamic> map = {
      // 'SRVP_ID': servicePlaceId,
      'INST_ID': institution!.institutionId,
      'SRV_ID': service!.serviceId,
    };
    map.addAll(date!.toMapJustDates("SRVP", forUpdate));
    return map;
  }

  factory ServicePlaceModel.fromMap(Map<String, dynamic> map) {
    return ServicePlaceModel(
      servicePlaceId: map['SRVP_ID'] != null ? map['SRVP_ID'] as int : null,
      institution: InstitutionModel.fromMap(map),
      service: ServiceModel.fromMap(map),
      date: GeneralModel.fromMap(map,"SRVP"),
    );
  }

  String toJson(bool forUpdate) => json.encode(toMap(forUpdate));

  factory ServicePlaceModel.fromJson(String source) => ServicePlaceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ServicePlace(servicePlaceId: $servicePlaceId, institution: $institution, service: $service, date: $date)';
  }

  @override
  bool operator ==(covariant ServicePlaceModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.servicePlaceId == servicePlaceId &&
      other.institution == institution &&
      other.service == service &&
      other.date == date;
  }

  @override
  int get hashCode {
    return servicePlaceId.hashCode ^
      institution.hashCode ^
      service.hashCode ^
      date.hashCode;
  }

  ServicePlaceModel initialize({
    int? servicePlaceId,
    InstitutionModel? institution,
    ServiceModel? service,
    GeneralModel? date,
  }) {
    return ServicePlaceModel(
      servicePlaceId: servicePlaceId ?? 0,
      institution: institution ?? InstitutionModel().initialize(),
      service: service ?? ServiceModel().initialize(),
      date: date ?? GeneralModel().initialize(),
    );
  }
}

class ServiceGuideModel {
  int? serviceGuideId;
  GeneralModel? serviceGuideName;
  GeneralModel? serviceGuideDescription;
  File? serviceGuideFile;
  String? serviceGuidePath;
  ServiceModel? service;
  int? serviceGuideMainId;
  InstitutionModel? institution;
  ServiceGuideModel({
    this.serviceGuideId,
    this.serviceGuideName,
    this.serviceGuideDescription,
    this.serviceGuideFile,
    this.service,
    this.serviceGuideMainId,
    this.institution,
    this.serviceGuidePath,
  });
  ServiceGuideModel copyWith({
    ServiceGuideModel? serviceGuides
  }) {
    return ServiceGuideModel(
      serviceGuideId: serviceGuides!.serviceGuideId ?? serviceGuideId,
      serviceGuidePath: serviceGuides.serviceGuidePath ?? serviceGuidePath,
      serviceGuideName: GeneralModel().copyWith(general: serviceGuides.serviceGuideName),
      serviceGuideDescription: GeneralModel().copyWith(general: serviceGuides.serviceGuideDescription),
      serviceGuideFile: serviceGuides.serviceGuideFile ?? serviceGuideFile,
      service: ServiceModel().copyWith(service: serviceGuides.service),
      institution: InstitutionModel().copyWith(institution: serviceGuides.institution),
      serviceGuideMainId: serviceGuides.serviceGuideMainId ?? serviceGuideMainId,
    );
  }


  Future<Map<String, dynamic>> toMap(bool forUpdate) async{
    if(serviceGuideFile!.path != serviceGuidePath) {
      serviceGuidePath = await postRequestWithFile("service_guides", int.parse(DateFormat("yyyyMMddHHmmss").format(DateTime.now())) ,serviceGuideFile!,forUpdate ? serviceGuidePath!.split('/').last:null);
    }
    Map<String, dynamic> map = {
      // 'SG_ID': serviceGuideId,
      'SG_FILE_PATH': serviceGuidePath,
      'SRV_ID': service!.serviceId,
      'INST_ID': institution!.institutionId,
      'SG_MAIN_ID': serviceGuideMainId,
    };
    map.addAll(serviceGuideName!.toMap("SG", forUpdate));
    // map.addAll(serviceGuideDescription!.toMapAsItIs("SG_DESCRIPTION","SG", forUpdate));
    return map;
  }

  factory ServiceGuideModel.fromMap(Map<String, dynamic> map) {
    return ServiceGuideModel(
      serviceGuideId: map['SG_ID'] != null ? map['SG_ID'] as int : null,
      serviceGuideMainId: map['SG_MAIN_ID'] != null ? map['SG_MAIN_ID'] as int : null,
      serviceGuideName: GeneralModel.fromMap(map,"SG"),
      serviceGuideDescription: GeneralModel.fromMapAsItIs(map,"SG","SG_DESCRIPTION"),
    serviceGuideFile : File(map["SG_FILE_PATH"] ?? ""),
    serviceGuidePath : map["SG_FILE_PATH"] ?? "",
      service: ServiceModel.fromMap(map),
      institution: InstitutionModel.fromMap(map),
    );
  }

  String toJson(bool forUpdate) => json.encode(toMap(forUpdate));

  factory ServiceGuideModel.fromJson(String source) => ServiceGuideModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ServiceGuidesModel(serviceGuideId: $serviceGuideId, serviceGuideName: $serviceGuideName, serviceGuideFile: $serviceGuideFile, service: $service, serviceGuideMainId: $serviceGuideMainId)';
  }

  @override
  bool operator ==(covariant ServiceGuideModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.serviceGuideId == serviceGuideId &&
      other.serviceGuideName == serviceGuideName &&
      other.serviceGuideFile == serviceGuideFile &&
      other.service == service &&
      other.serviceGuideMainId == serviceGuideMainId;
  }

  @override
  int get hashCode {
    return serviceGuideId.hashCode ^
      serviceGuideName.hashCode ^
      serviceGuideFile.hashCode ^
      service.hashCode ^
      serviceGuideMainId.hashCode;
  }

  ServiceGuideModel initialize({
    int? serviceGuideId,
    GeneralModel? serviceGuideName,
    GeneralModel? serviceGuideDescription,
    File? serviceGuideFile,
    ServiceModel? service,
    InstitutionModel? institution,
    int? serviceGuideMainId,
  }) {
    return ServiceGuideModel(
      serviceGuideId: serviceGuideId ?? 0,
      serviceGuideName: serviceGuideName ?? GeneralModel().initialize(),
      serviceGuideDescription: serviceGuideDescription ?? GeneralModel().initialize(),
      serviceGuideFile: serviceGuideFile ?? File(""),
      serviceGuidePath: serviceGuidePath ?? "",
      service: service ?? ServiceModel().initialize(),
      institution: institution ?? InstitutionModel().initialize(),
      serviceGuideMainId: serviceGuideMainId ?? 0,
    );
  }
}

class ServiceFormModel {
  int? serviceFormId;
  GeneralModel? serviceFormName;
  GeneralModel? serviceFormDescription;
  TextEditingController? serviceFormOrder;
  ServiceModel? service;
  bool? serviceFormIsCancel;
  InstitutionModel? institution;
  List<FormFieldModel>? formFields;
  GlobalKey<FormState>? key;
  ServiceFormModel({
    this.serviceFormId,
    this.serviceFormName,
    this.serviceFormDescription,
    this.serviceFormOrder,
    this.service,
    this.serviceFormIsCancel,
    this.institution,
    this.formFields,
    this.key,
  });

  ServiceFormModel copyWith({
    ServiceFormModel? serviceForm
  }) {
    return ServiceFormModel(
      serviceFormId: serviceForm!.serviceFormId ?? serviceFormId,
      serviceFormName: GeneralModel().copyWith(general: serviceForm.serviceFormName),
      serviceFormDescription:GeneralModel().copyWith(general: serviceForm.serviceFormDescription ),
      serviceFormOrder:TextEditingController(text: serviceForm.serviceFormOrder != null? serviceForm.serviceFormOrder!.text : serviceFormOrder!.text),
      service: ServiceModel().copyWith(service: serviceForm.service),
      institution: InstitutionModel().copyWith(institution: serviceForm.institution),
      serviceFormIsCancel: serviceForm.serviceFormIsCancel ?? serviceFormIsCancel,
      key: GlobalKey(debugLabel:(serviceForm.serviceFormId ?? serviceFormId).toString())
    );
  }

  Map<String, dynamic> toMap(bool forUpdate) {
    Map<String, dynamic> map = {
      // 'SRVF_ID': serviceFormId,
      'SRVF_ORDER': serviceFormOrder!.text,
      'SRV_ID': service!.serviceId,
      'INST_ID': institution!.institutionId,
      'SRVF_IS_CANCEL': convertBoolToInt(serviceFormIsCancel),
    };
    map.addAll(serviceFormName!.toMap("SRVF", forUpdate));
    map.addAll(serviceFormDescription!.toMapAsItIs("SRVF_DESCRIPTION","SRVF", forUpdate));
    return map;
  }

  factory ServiceFormModel.fromMap(Map<String, dynamic> map) {
    return ServiceFormModel(
      serviceFormId: map['SRVF_ID'] != null ? map['SRVF_ID'] as int : null,
      serviceFormName: GeneralModel.fromMap(map,"SRVF"),
      serviceFormDescription: GeneralModel.fromMapAsItIs(map,"SRVF","SRVF_DESCRIPTION"),
      serviceFormOrder:TextEditingController(text: (map["SRVF_ORDER"] ?? "").toString()),
      service: ServiceModel.fromMap(map),
      institution: InstitutionModel.fromMap(map),
      serviceFormIsCancel: getFromBoolOrInt(map['SRVF_IS_CANCEL']),
      key: GlobalKey(debugLabel: (map['SRVF_ID'] ?? 0).toString())
    );
  }

  String toJson(bool forUpdate) => json.encode(toMap(forUpdate));

  factory ServiceFormModel.fromJson(String source) => ServiceFormModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ServiceFormModel(serviceGuideId: $serviceFormId, serviceGuideName: $serviceFormName, service: $service, serviceGuideIsMain: $serviceFormIsCancel)';
  }

  @override
  bool operator ==(covariant ServiceFormModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.serviceFormId == serviceFormId &&
      other.serviceFormName == serviceFormName &&
      other.service == service &&
      other.serviceFormIsCancel == serviceFormIsCancel;
  }

  @override
  int get hashCode {
    return serviceFormId.hashCode ^
      serviceFormName.hashCode ^
      service.hashCode ^
      serviceFormIsCancel.hashCode;
  }


  ServiceFormModel initialize({
    int? serviceFormId,
    GeneralModel? serviceFormName,
    GeneralModel? serviceFormDescription,
    TextEditingController? serviceFormOrder,
    ServiceModel? service,
    InstitutionModel? institution,
    bool? serviceFormIsCancel,
  }) {
    return ServiceFormModel(
      serviceFormId: serviceFormId ?? 0,
      serviceFormName: serviceFormName ?? GeneralModel().initialize(),
      serviceFormDescription:  serviceFormDescription ?? GeneralModel().initialize(),
      serviceFormOrder:TextEditingController(text:serviceFormOrder!=null ? serviceFormOrder.text : ""),
      service: service ?? ServiceModel().initialize(),
      institution: institution ?? InstitutionModel().initialize(),
      serviceFormIsCancel: serviceFormIsCancel ?? false,
      key: GlobalKey( debugLabel: (serviceFormId ?? 0).toString())
    ); 
  }
}

class FormFieldModel {
  int? formFieldId;
  GeneralModel? formFieldName;
  FormFieldTypes? formFieldType;
  ServiceFormModel? serviceForm;
  TextEditingController? formFieldOrder;
  TextEditingController? formFieldValue;
  bool? formFieldIsNull;
  bool? formFieldIsCancel;
  InstitutionModel? institution;
  List<CodeModel>? formFieldDetails;
  FormFieldModel({
    this.formFieldId,
    this.formFieldName,
    this.formFieldType,
    this.serviceForm,
    this.formFieldOrder,
    this.formFieldIsNull,
    this.formFieldIsCancel,
    this.formFieldDetails,
    this.formFieldValue,
    this.institution,
  });

  FormFieldModel copyWith({
    FormFieldModel? formField
  }) {
    return FormFieldModel(
      formFieldId: formField!.formFieldId ?? formFieldId,
      formFieldName: GeneralModel().copyWith(general: formField.formFieldName),
      formFieldType: formField.formFieldType ?? formFieldType,
      serviceForm: ServiceFormModel().copyWith(serviceForm: formField.serviceForm),
      formFieldOrder:TextEditingController(text: formField.formFieldOrder != null? formField.formFieldOrder!.text : formFieldOrder!.text),
      formFieldIsNull: formField.formFieldIsNull ?? formFieldIsNull,
      formFieldIsCancel: formField.formFieldIsCancel ?? formFieldIsCancel,
      formFieldDetails: formField.formFieldDetails ?? formFieldDetails,
      institution: InstitutionModel().copyWith(institution: formField.institution),
    );
  }

  Map<String, dynamic> toMap(bool forUpdate,bool forDetails) {
    Map<String, dynamic> map ={
      'FRMF_ID': formFieldId,
      'FRMF_TYPE': formFieldType!.name,
      if(forDetails)
      'FRMF_VALUE': formFieldValue!.text,
      'SRVF_ID': serviceForm!.serviceFormId,
      'FRMF_ORDER': formFieldOrder!.text,
      'FRMF_IS_NULL': convertBoolToInt(formFieldIsNull) ,
      'FRMF_IS_CANCEL': convertBoolToInt(formFieldIsCancel),
      'INST_ID': institution!.institutionId,
    };
    map.addAll(formFieldName!.toMap("FRMF", forUpdate));
    return map;
  }

  factory FormFieldModel.fromMap(Map<String, dynamic> map) {
    return FormFieldModel(
      formFieldId: map['FRMF_ID'] != null ? map['FRMF_ID'] as int : null,
      formFieldName: GeneralModel.fromMap(map,"FRMF"),
      formFieldType:FormFieldTypes.values.firstWhere((element) => element.name == map["FRMF_TYPE"],orElse: () => FormFieldTypes.INPUT_TEXT),
      serviceForm: ServiceFormModel.fromMap(map),
      formFieldOrder:TextEditingController(text: (map["FRMF_ORDER"] ?? "").toString()),
      formFieldValue:TextEditingController(text: map["FRMF_VALUE"] ?? ""),
      formFieldIsNull: getFromBoolOrInt( map['FRMF_IS_NULL']),
      formFieldIsCancel: getFromBoolOrInt( map['FRMF_IS_CANCEL']),
      institution: InstitutionModel.fromMap(map),
    );
  }

  String toJson(bool forUpdate,bool forDetails) => json.encode(toMap(forUpdate,forDetails));

  factory FormFieldModel.fromJson(String source) => FormFieldModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FormFieldModel(formFieldId: $formFieldId, formFieldName: $formFieldName, formFieldType: $formFieldType, service: $serviceForm, formFieldOrder: $formFieldOrder, formFieldIsNull: $formFieldIsNull, formFieldIsCancel: $formFieldIsCancel)';
  }

  @override
  bool operator ==(covariant FormFieldModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.formFieldId == formFieldId &&
      other.formFieldName == formFieldName &&
      other.formFieldType == formFieldType &&
      other.serviceForm == serviceForm &&
      other.formFieldOrder == formFieldOrder &&
      other.formFieldIsNull == formFieldIsNull &&
      other.formFieldIsCancel == formFieldIsCancel;
  }

  @override
  int get hashCode {
    return formFieldId.hashCode ^
      formFieldName.hashCode ^
      formFieldType.hashCode ^
      serviceForm.hashCode ^
      formFieldOrder.hashCode ^
      formFieldIsNull.hashCode ^
      formFieldIsCancel.hashCode;
  }

  FormFieldModel initialize({
    int? formFieldId,
    GeneralModel? formFieldName,
    FormFieldTypes? formFieldType,
    ServiceFormModel? serviceForm,
    TextEditingController? formFieldOrder,
    bool? formFieldIsNull,
    bool? formFieldIsCancel,
    InstitutionModel? institution,
  }) {
    return FormFieldModel(
      formFieldId: formFieldId ?? 0,
      formFieldName: formFieldName ?? GeneralModel().initialize(),
      formFieldType: formFieldType ?? FormFieldTypes.INPUT_TEXT,
      serviceForm: serviceForm ?? ServiceFormModel().initialize(),
      formFieldOrder:TextEditingController(text:formFieldOrder!=null ? formFieldOrder.text : ""),
      formFieldIsNull: formFieldIsNull ?? true,
      formFieldIsCancel: formFieldIsCancel ?? false,
      institution: institution ?? InstitutionModel().initialize(),
    );
  }
}

enum FormFieldTypes{
  INPUT_NUMBER,
  INPUT_TEXT,
  INPUT_EMAIL,
  RADIO,
  CHECKBOX,
  COMPOBOX,
  FORIGHN_ORDERID,
  PDF_FILE,
  IMAGE_FILE,
  DATE,
  BOOLEAN,
  // FILE,
}

enum ServiceTypes{
  NEW,
  RENEWAL,//تجديد
}
