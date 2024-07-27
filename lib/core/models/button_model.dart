
import 'package:flutter/material.dart';

class ButtonModel{
  String title;
  void Function()? onPressed;
  Color backgroundColor;
  Color foregroundColor;
  IconData icon;

  ButtonModel({required this.icon,required this.title,required this.foregroundColor,required this.backgroundColor,required this.onPressed});
}