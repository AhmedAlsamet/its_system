// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RowOrColumn extends StatelessWidget {
  List<Widget> children;
  List<int> childrenFlexes;
  double sizeBetweenWidth;
  double sizeBetweenHeigh;
  bool isRow;
  RowOrColumn({
    Key? key,
    required this.children,
    required this.childrenFlexes,
    this.sizeBetweenWidth = 10,
    this.sizeBetweenHeigh = 10,
    required this.isRow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(isRow){
      return Row(
        children: children.asMap().entries.map((e) {
          return Expanded(flex: childrenFlexes[e.key],child: Container(
            margin: EdgeInsets.only(right: (e.key + 1) % 2 == 0 ? sizeBetweenWidth : 0),
            child: e.value),);
        }).toList(),
      );
    }
    for (var i = 1; i < children.length; i+=2) {
      children.insert(i, SizedBox(height: sizeBetweenHeigh,));
    }
    return Column(
      children: children,
    );
  }
}
