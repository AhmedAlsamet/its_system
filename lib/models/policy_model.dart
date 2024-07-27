// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:its_system/models/general_model.dart';

class PolicyModel {
  int? policyId;
  GeneralModel? policyName;
  PolicyModel({
    this.policyId,
    this.policyName,
  });

  PolicyModel copyWith({
    PolicyModel? policy,
  }) {
    return PolicyModel(
      policyId: policy!.policyId ?? policyId,
      policyName: policy.policyName ?? policyName!.copyWith(),
    );
  }
  PolicyModel initialize({
    int? policyId,
    GeneralModel? policyName,
  }) {
    return PolicyModel(
      policyId: policyId ?? 0,
      policyName: policyName ?? GeneralModel().initialize(),
    );
  }

  Map<String, dynamic> toMap(bool forUpdate) {
    Map<String, dynamic> map = {
      'POL_ID': policyId,
    };
    map.addAll(policyName!.toMap("POL",forUpdate));
    return map;
  }

  factory PolicyModel.fromMap(Map<String, dynamic> map) {
    return PolicyModel(
      policyId: map['POL_ID'] != null ? map['POL_ID'] as int : null,
      policyName: GeneralModel.fromMap(map,"POL"),
    );
  }

  String toJson(bool forUpdate) => json.encode(toMap(forUpdate));

  factory PolicyModel.fromJson(String source) => PolicyModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'policyModel(policyId: $policyId, policyName: $policyName)';

  @override
  bool operator ==(covariant PolicyModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.policyId == policyId &&
      other.policyName!.arabicTitle!.text == policyName!.arabicTitle!.text&&
      other.policyName!.englishTitle!.text == policyName!.englishTitle!.text;
  }

  @override
  int get hashCode => policyId.hashCode ^ policyName.hashCode;
}