// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:its_system/core/widgets/nav_bar_icon.dart';

class BottomSheetHandel extends StatelessWidget {
  final ScrollController controller;
  void Function()? onCancel;
  final IconData cancelIcon;
  final String cancelTooltip;
  void Function()? onSave;
  final IconData saveIcon;
  final String saveTooltip;
  BottomSheetHandel({
    required this.controller,
    required this.onCancel,
    required this.cancelIcon,
    required this.cancelTooltip,
    required this.onSave,
    required this.saveIcon,
    required this.saveTooltip,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowIndicator();
          return false;
        },
        child: ListView(
          controller: controller,
          children: [
            Container(
              decoration:  BoxDecoration(
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15))),
              height: 50,
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NavBarIcon(
                        icon: saveIcon,
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      foregroundColor: Theme.of(context).primaryColor,
                      shadowColor: Theme.of(context).shadowColor.withOpacity(0),
                        iconEvent: onSave,
                        tooltip: saveTooltip),
                    Container(
                      height: 8,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    NavBarIcon(
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      foregroundColor: Theme.of(context).primaryColor,
                      shadowColor: Theme.of(context).shadowColor.withOpacity(0),
                        icon: cancelIcon,
                        iconEvent: onCancel,
                        tooltip: cancelTooltip),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}