// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:its_system/models/general_model.dart';

class CityModel {
  int? cityId;
  GeneralModel? cityName;
  CityModel({
    this.cityId,
    this.cityName,
  });

  CityModel copyWith({
    CityModel? city,
  }) {
    return CityModel(
      cityId: city!.cityId ?? cityId,
      cityName: city.cityName ?? cityName!.copyWith(),
    );
  }
  CityModel initialize({
    int? cityId,
    GeneralModel? cityName,
  }) {
    return CityModel(
      cityId: cityId ?? 0,
      cityName: cityName ?? GeneralModel().initialize(),
    );
  }

  Map<String, dynamic> toMap(bool forUpdate) {
    Map<String, dynamic> map = {
      'CTY_ID': cityId,
    };
    map.addAll(cityName!.toMap("CTY",forUpdate));
    return map;
  }

  factory CityModel.fromMap(Map<String, dynamic> map) {
    return CityModel(
      cityId: map['CTY_ID'] != null ? map['CTY_ID'] as int : null,
      cityName: GeneralModel.fromMap(map,"CTY"),
    );
  }

  String toJson(bool forUpdate) => json.encode(toMap(forUpdate));

  factory CityModel.fromJson(String source) => CityModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CountryModel(cityId: $cityId, cityName: $cityName)';

  @override
  bool operator ==(covariant CityModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.cityId == cityId &&
      other.cityName!.arabicTitle!.text == cityName!.arabicTitle!.text&&
      other.cityName!.englishTitle!.text == cityName!.englishTitle!.text;
  }

  @override
  int get hashCode => cityId.hashCode ^ cityName.hashCode;
}
class MunicipalityModel {
  int? municipalityId;
  CityModel? city;
  GeneralModel? municipalityName;
  MunicipalityModel({
    this.municipalityId,
    this.city,
    this.municipalityName,
  });

  MunicipalityModel copyWith({
    MunicipalityModel? municipality,
  }) {
    return MunicipalityModel(
      municipalityId: municipality!.municipalityId ?? municipalityId,
      municipalityName: municipality.municipalityName ?? municipalityName,
      city: municipality.city ?? city!.copyWith(),
    );
  }

  MunicipalityModel initialize({
    int? municipalityId,
    CityModel? city,
    GeneralModel? municipalityName,
  }) {
    return MunicipalityModel(
      municipalityId: municipalityId ?? 0,
      municipalityName: municipalityName ?? GeneralModel().initialize(),
      city: city ?? CityModel().initialize(),
    );
  }

  Map<String, dynamic> toMap(bool forUpdate) {
    Map<String ,dynamic> map = {
      'MUN_ID': municipalityId,
      'CTY_ID': city!.cityId,
    };
    map.addAll(municipalityName!.toMap("MUN",forUpdate));
    return map;
  }

  factory MunicipalityModel.fromMap(Map<String, dynamic> map) {
    return MunicipalityModel(
      municipalityId: map['MUN_ID'] != null ? map['MUN_ID'] as int : null,
      city: CityModel.fromMap(map),
      municipalityName: GeneralModel.fromMap(map,"MUN"),
    );
  }

  String toJson(bool forUpdate) => json.encode(toMap(forUpdate));

  factory MunicipalityModel.fromJson(String source) => MunicipalityModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MunicipalityModel(municipalityId: $municipalityId, municipalityName: $municipalityName)';

  @override
  bool operator ==(covariant MunicipalityModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.municipalityId == municipalityId &&
      other.municipalityName!.arabicTitle!.text == municipalityName!.arabicTitle!.text&&
      other.municipalityName!.englishTitle!.text == municipalityName!.englishTitle!.text;
  }

  @override
  int get hashCode => municipalityId.hashCode ^ municipalityName.hashCode;
}
