
import 'package:flutter/material.dart';

Widget circleIcon(
    {required Widget icon,
      required Color backgroundColor,
      Function()? onTap}) {
  return  Container(
    margin: EdgeInsets.only(left: 5,right: 5),
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor
    ),
    child: IconButton(
      icon: icon,
      onPressed: onTap,
    ),
  );
}