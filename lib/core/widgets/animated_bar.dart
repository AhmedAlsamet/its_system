import 'package:flutter/material.dart';

class AnimatedBar extends StatelessWidget {
  const AnimatedBar({
    Key? key,
    required this.isActive,
    required this.isHorizontal,
  }) : super(key: key);

  final bool isActive;
  final bool isHorizontal;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: const EdgeInsets.only(bottom: 2),
      duration: const Duration(milliseconds: 200),
      width:isHorizontal ?(isActive ? 20 : 0):  4,
      height: !isHorizontal? (isActive ? 20 : 0):4,
      decoration: const BoxDecoration(
          color: Color(0xFF81B4FF),
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          )),
    );
  }
}
