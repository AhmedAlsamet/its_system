import 'dart:io';

import 'package:flutter/material.dart';


class DropdownButtonModel{

    int? dropOrder;
  String? dropName;
  String? dropImage;
  IconData? dropIcon;
  dynamic dropValue;
DropdownButtonModel({this.dropName,this.dropOrder,this.dropValue,this.dropImage});
}



class MainCategoryModel{
  int? mainCategoryId;
  TextEditingController? mainCategoryName;
  TextEditingController? mainCategoryDescription;
  TextEditingController? mainCategoryCode;
  File? mainCategoryImage;
  bool? mainCategoryIsShow;

  MainCategoryModel({
    this.mainCategoryCode,
    this.mainCategoryId,this.mainCategoryImage,this.mainCategoryName,this.mainCategoryIsShow,this.mainCategoryDescription});

}
