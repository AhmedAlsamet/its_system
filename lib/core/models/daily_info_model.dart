import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DailyInfoModel {
  int? id;
SelectedBy? selectedBy;
  IconData? icon;
  String? title;
  String? totalStorage;
  int? allVolumeData;
  int? volumeData;
  int? percentage;
  Color? color;
  bool? multiChoise;
  bool? withBorder;
  List<Color>? colors;
  List<FlSpot>? spots;

  DailyInfoModel({
    this.icon,
    this.title,
    this.id,
    this.selectedBy,
    this.totalStorage,
    this.allVolumeData,
    this.volumeData,
    this.percentage,
    this.color,
    this.colors,
    this.spots,
    this.multiChoise,
    this.withBorder,
  });

  DailyInfoModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    id = json['id'];
    selectedBy = SelectedBy.values.firstWhere((element) => json['selectedBy'] == element.name);
    volumeData = json['volumeData'];
    allVolumeData = json['allVolumeData'];
    icon = json['icon'];
    totalStorage = json['totalStorage'];
    color = json['color'];
    percentage = json['percentage'];
    colors = json['colors'];
    spots = json['spots'];
    multiChoise = json['multiChoise'] ?? true;
    withBorder = json['withBorder'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['volumeData'] = this.volumeData;
    data['icon'] = this.icon;
    data['totalStorage'] = this.totalStorage;
    data['color'] = this.color;
    data['percentage'] = this.percentage;
    data['colors'] = this.colors;
    data['spots'] = this.spots;
    return data;
  }
}

enum SelectedBy{
  ALL,
  DAY,
  MONTH,
  YEAR,
}

//final List<double> yValues = [
//  2.3,
//  1.8,
//  1.9,
//  1.5,
//  1.0,
//  2.2,
//  1.8,
//  1.5,
//];
