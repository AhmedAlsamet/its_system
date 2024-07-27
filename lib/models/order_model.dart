// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:its_system/models/general_model.dart';
import 'package:its_system/models/institution_model.dart';
import 'package:its_system/models/service_model.dart';
import 'package:its_system/models/user_model.dart';

class OrderModel {
  int? orderId;
  int? orderNumber;
  int? paymentNumber;
  DateTime? orderRegisteredAt;
  UserModel? userCreated;
  TextEditingController? orderNote;
  OrderState? orderState;
  InstitutionModel? institution;
  ServiceModel? service;
  ServicePlaceModel? servicePlace;
  List<FormFieldModel>? orderDetails;

  OrderModel({
    this.orderId,
    this.orderState,
    this.orderRegisteredAt,
    this.userCreated,
    this.orderNote,
    this.institution,
    this.orderNumber,
    this.paymentNumber,
    this.service,
    this.servicePlace,
    this.orderDetails,
  });

  OrderModel copyWith({
    OrderModel? order,
  }) {
    return OrderModel(
      orderId:order!.orderId ?? orderId,
      orderNumber: order.orderNumber ?? orderNumber,
      paymentNumber: order.paymentNumber??paymentNumber,
      service: ServiceModel().copyWith(service: order.service),
      servicePlace: ServicePlaceModel().copyWith(servicePlace: order.servicePlace),
      orderState:order.orderState ?? orderState,
      institution: InstitutionModel().copyWith(institution: order.institution),
      orderRegisteredAt:order.orderRegisteredAt ?? orderRegisteredAt,
      userCreated:order.userCreated ?? UserModel().copyWith(user:userCreated!),
      orderNote: TextEditingController(text:order.orderNote != null ? order.orderNote!.text : orderNote!.text ) ,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ORD_ID': orderId,
      "ORD_NUMBER":orderNumber,
      'USR_ID': userCreated!.userId,
      'ORD_REGISTER_AT': orderRegisteredAt!.toString(),
      'ORD_NOTE': orderNote!.text,
      "SRV_ID":service!.serviceId,
      'ORD_STATE':orderState!.name,
      "SRVP_ID":servicePlace!.servicePlaceId,
      'INST_ID': institution!.institutionId,
      "PAYMENT_NUMBER":paymentNumber
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map,) {
    return OrderModel(
      orderId: map['ORD_ID'] != null ? map['ORD_ID'] as int : null,
      orderNumber: map['ORD_NUMBER'] != null ? map['ORD_NUMBER'] as int : null,
      paymentNumber: map['PAYMENT_NUMBER'] != null ? map['PAYMENT_NUMBER'] as int : null,
      userCreated: UserModel.fromMap(map),
      orderRegisteredAt: map['ORD_REGISTER_AT'] != null ? DateTime.parse(map['ORD_REGISTER_AT']) : null,
      orderNote:  TextEditingController(text:map['ORD_NOTE']??""),
      service: ServiceModel.fromMap(map),
      orderState: OrderState.values.firstWhere((element) => element.name == map['ORD_STATE'],orElse: () => OrderState.NEW,),
      servicePlace: ServicePlaceModel.fromMap(map),
      institution: InstitutionModel.fromMap(map),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source,String scanUserPrefix,String createdUserPrefix) => OrderModel.fromMap(json.decode(source) as Map<String, dynamic>);

  OrderModel initialize({
    int? orderId,
    int? orderNumber,
    int? paymentNumber,
    DateTime? orderRegisteredAt,
    UserModel? userCreated,
    TextEditingController? orderNote,
    OrderState? orderState,
    InstitutionModel? institution,
    ServiceModel? service,
    ServicePlaceModel? servicePlace,
    List<FormFieldModel>? orderDetails,
  }) {
    return OrderModel(
      orderId: orderId ?? 0,
      orderNumber: orderNumber ?? 0,
      paymentNumber: paymentNumber ?? 0,
      orderRegisteredAt: orderRegisteredAt ?? DateTime.now(),
      userCreated: userCreated ?? UserModel().initialize(),
      orderNote: orderNote ?? TextEditingController(),
      orderState: orderState ?? OrderState.NEW,
      institution: institution ?? InstitutionModel().initialize(),
      service: service ?? ServiceModel().initialize(),
      servicePlace: servicePlace ?? ServicePlaceModel().initialize(),
      orderDetails: orderDetails ?? [],
    );
  }
}

class OrderResultModel {
  int? orderResultId;
  GeneralModel? orderResultValue;
  OrderResultTypes? orderResultType;
  OrderModel? order;
  OrderResultModel({
    this.orderResultId,
    this.orderResultValue,
    this.orderResultType,
    this.order,
  });

  OrderResultModel copyWith({
    OrderResultModel? orderResult,
  }) {
    return OrderResultModel(
      orderResultId: orderResult!.orderResultId ?? orderResultId,
      orderResultValue: GeneralModel().copyWith(general: orderResult.orderResultValue),
      orderResultType: orderResult.orderResultType ?? orderResultType,
      order:  OrderModel().copyWith(order: orderResult.order),
    );
  }

  Map<String, dynamic> toMap(bool forUpdate) {
    Map<String, dynamic> map ={
      'ORDR_ID': orderResultId,
      'ORDR_TYPE': orderResultType!.name,
      'ORD_ID': order!.orderId,
    };
    map.addAll(orderResultValue!.toMapAsItIs("ORDR_VALUE","ORDR", forUpdate));
    return map;
  }

  factory OrderResultModel.fromMap(Map<String, dynamic> map) {
    return OrderResultModel(
      orderResultId: map['ORDR_ID'] != null ? map['ORDR_ID'] as int : null,
      orderResultValue:  GeneralModel.fromMap(map,"ORDR"),
      orderResultType:OrderResultTypes.values.firstWhere((element) => element.name == map["ORDR_TYPE"],orElse: () => OrderResultTypes.NEW),
      order: OrderModel.fromMap(map),
    );
  }

  String toJson(bool forUpdate) => json.encode(toMap(forUpdate));

  factory OrderResultModel.fromJson(String source) => OrderResultModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OrderResultModel(orderResultId: $orderResultId, orderResultValue: $orderResultValue, orderResultType: $orderResultType, order: $order)';
  }

  @override
  bool operator ==(covariant OrderResultModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.orderResultId == orderResultId &&
      other.orderResultValue == orderResultValue &&
      other.orderResultType == orderResultType &&
      other.order == order;
  }

  @override
  int get hashCode {
    return orderResultId.hashCode ^
      orderResultValue.hashCode ^
      orderResultType.hashCode ^
      order.hashCode;
  }
}

enum OrderState {
  DONE,
  CANCELED,
  FOR_EDIT,
  IN_PROGRESS,
  NEW
}

enum OrderResultTypes{
  DONE,
  FOR_EDIT,
  CANCELED,
  IN_PROGRESS,
  NEW
}