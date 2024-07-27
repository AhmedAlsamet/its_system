// ignore_for_file: public_member_api_docs, sort_constructors_first, constant_identifier_names
import 'dart:convert';


import 'package:its_system/models/institution_model.dart';
import 'package:its_system/models/general_model.dart';
import 'package:its_system/models/user_model.dart';
import 'package:its_system/statics_values.dart';

class NotificationModel {
  int? notificationId;
  GeneralModel? notificationTitle;
  GeneralModel? notificationDetails;
  NotificationTypes? notificationType;
  UserModel? user;
  InstitutionModel? institution;
  List<UserModel>? notificationReservers;
  // [INST_ID , USR_ID]
  NotificationModel({
    this.notificationId,
    this.notificationTitle,
    this.notificationDetails,
    this.notificationType,
    this.user,
    this.notificationReservers,
    this.institution,
  });

  NotificationModel copyWith({NotificationModel? notification}) {
    return NotificationModel(
      notificationId: notification!.notificationId ?? notificationId,
      notificationTitle: notification.notificationTitle ?? GeneralModel().copyWith(general: notificationTitle),
      notificationDetails: notification.notificationDetails ??GeneralModel().copyWith(general: notificationDetails),
      notificationType: notification.notificationType ?? notificationType,
      user: notification.user ?? UserModel().copyWith(user: user),
      notificationReservers: notification.notificationReservers ?? notificationReservers,
      institution: notification.institution ?? institution!.copyWith(),
    );
  }
  NotificationModel initialize({
    int? notificationId,
    GeneralModel? notificationTitle,
    GeneralModel? notificationDetails,
    NotificationTypes? notificationType,
    UserModel? userId,
    InstitutionModel? institution,
  List<UserModel>? notificationReservers
  }) {
    return NotificationModel(
      notificationId: notificationId ?? 0,
      notificationTitle: notificationTitle ?? GeneralModel().initialize(),
      notificationDetails: notificationDetails ?? GeneralModel().initialize(),
      notificationType: notificationType ?? NotificationTypes.FOR_ALL,
      user: userId ?? UserModel().initialize(userId: StaticValue.userData!.userId!),
      institution: institution ?? InstitutionModel().initialize(),
      notificationReservers: notificationReservers ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    Map <String, dynamic> m = {
      // 'NOT_ID': notificationId,
      'NOT_TYPE': notificationType!.name,
      'USR_ID': user!.userId,
      'INST_ID': institution!.institutionId,
    };
      m.addAll(notificationTitle!.toMapAsItIs("NOT_TITLE","NOT",false));
      m.addAll(notificationDetails!.toMapAsItIs("NOT_DETAILS","NOT",false));
    return m;
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      notificationId: map['NOT_ID'] != null ? map['NOT_ID'] as int : null,
      notificationTitle:  GeneralModel.fromMapAsItIs(map,"NOT","NOT_TITLE"),
      notificationDetails: GeneralModel.fromMapAsItIs(map,"NOT","NOT_DETAILS"),
      notificationType: NotificationTypes.values.firstWhere((element) => element.name == map['NOT_TYPE'],orElse: () => NotificationTypes.FOR_ALL,),
      user: UserModel.fromMap(map),
      institution: InstitutionModel.fromMap(map)
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) => NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NotificationModel(notificationId: $notificationId, notificationTitle: $notificationTitle, notificationDETAILS: $notificationDetails, notificationType: $notificationType, userId: $user)';
  }

  @override
  bool operator ==(covariant NotificationModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.notificationId == notificationId &&
      other.notificationTitle == notificationTitle &&
      other.notificationDetails == notificationDetails &&
      other.notificationType == notificationType &&
      other.user == user;
  }

  @override
  int get hashCode {
    return notificationId.hashCode ^
      notificationTitle.hashCode ^
      notificationDetails.hashCode ^
      notificationType.hashCode ^
      user.hashCode;
  }
}

enum NotificationTypes {
  FOR_ALL,
  FOR_ALL_CITIZENS,
  FOR_ALL_ADMINS,
  FOR_ALL_SECURITIES,
  FOR_SPECIFIC_COMPOUND,
  FOR_SPECIFIC_USER,
  FOR_SPECIFIC_FAMILY,
}
