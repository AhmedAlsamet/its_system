import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:its_system/responsive.dart';

Future openDialogOrBottomSheet(widget) async {
  if (Responsive.isDesktop(Get.overlayContext!)) {
    await showDialog(
        context: Get.overlayContext!,
        builder: (context) {
          return PopScope(
              canPop: false,
              child: Dialog(
                backgroundColor: Colors.transparent,
                child: widget,
              ));
        });
  } else {
    await showModalBottomSheet(
      context: Get.overlayContext!,
      builder: (context) {
        return widget;
      },
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
    // to back to last open page
  }
}

Future openDialogOrNewRoute(widget, [bool canPop = false]) async {
  if (Responsive.isDesktop(Get.overlayContext!)) {
    await showDialog(
        context: Get.overlayContext!,
        builder: (context) {
          return PopScope(
            canPop: canPop,
            // onWillPop: () async => false,
            child: Dialog(child: widget),
          );
        });
  } else {
    await Get.to(widget);
    // to back to last open page
  }
}
