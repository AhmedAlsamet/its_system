import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:its_system/constants.dart';

Future snakbarDialog({required String title,required String content,required int durationSecound,Color color = redColor,Icon icon = const Icon(Icons.cancel_rounded, color: Colors.white, size: 30),TextButton? mainButton})async{
      Get.closeAllSnackbars();
      Get.snackbar("", "",
      mainButton: mainButton,
      isDismissible: true,
          messageText: Text(
              content,
              style: Theme.of(Get.overlayContext!)
                  .textTheme
                  .displaySmall!
                  .copyWith(color: Colors.white)),
          titleText: Text(title,
              style: Theme.of(Get.overlayContext!).textTheme.displaySmall!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
              textAlign: TextAlign.center),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: color,
          duration: Duration(seconds: durationSecound),
          maxWidth: 500,
          icon: IconButton(onPressed: ()async{
            Get.closeAllSnackbars();
            await Get.closeCurrentSnackbar();
          }, icon: icon)
          // margin: const EdgeInsets.only(bottom: 100)
           );
    }
  
// deleteDialog({required BuildContext context,required String title,required String description,required IconData icon,required Function deleteEvent}) {
//   AwesomeDialog(
//     context: context,
//     animType: AnimType.leftSlide,
//     headerAnimationLoop: false,
//     dialogType: DialogType.question,
//     showCloseIcon: true,
//     title: title,
//     titleTextStyle: Theme.of(context).textTheme.displayLarge!.copyWith(color: Colors.black),
//     descTextStyle: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.black),
//     btnOkColor: redColor,
//     btnCancelColor: headColor,
//     customHeader: FittedBox(
//       child: Icon(
//         icon,
//         color: headColor,
//         size: 150,
//       ),
//     ),
//     btnOkText: "delete".tr(),
//     btnCancelText: "cancel".tr(),
//     desc:
//         '$description',
//     btnOkOnPress: () {
//       // debugPrint('OnClcik');
//       deleteEvent();
//     },
//     btnCancelOnPress: (){
//     },
//     // btnOkIcon: Icons.check_circle,
//     onDismissCallback: (type) {
//       // debugPrint('Dialog Dissmiss from callback $type');
//     },
//     dialogBackgroundColor: Colors.white
//   ).show();
// }
