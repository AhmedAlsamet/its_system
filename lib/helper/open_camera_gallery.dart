import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:its_system/core/utils/snakbar_dialog.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/constants.dart';
import 'package:its_system/functions.dart';


Future<String> openCamera() async{
  try{
    if(Platform.isWindows){
          XFile? xFile =
    await ImagePicker()
        .pickImage(
        source:
        ImageSource
            .camera);
            return xFile!.path;
    }

        if(Platform.isAndroid){
      await requestPermission();
    }
  if (await checkPermission() || Platform.isAndroid) {
    PickedFile? xFile =
    await ImagePickerAndroid()
        .pickImage(
        source:
        ImageSource
            .camera);
            return xFile!.path;
  } else {
    Get.closeAllSnackbars();
    Get.snackbar("", "",
        messageText: Text(
            'youShouldGivePremissionToTheApp'.tr(),
            style: Theme.of(Get.overlayContext!)
                .textTheme
                .displaySmall!
                .copyWith(
                color:
                headColor
                )),
        titleText: Text(
            'noPremission'.tr(),
            style: Theme.of(Get.overlayContext!)
                .textTheme
                .displaySmall!
                .copyWith(
                fontWeight:
                FontWeight
                    .w800,
                color:
                headColor),
            textAlign: TextAlign.center),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.only(bottom: 100));
    return "";
  }
  }
  catch(e){
    return "";
  }
}


Future<String> openGallery() async{
  try{
        if(Platform.isWindows){
          XFile? xFile =
    await ImagePicker()
        .pickImage(
        source:
        ImageSource
            .gallery);
            return xFile!.path;
    }
    if(Platform.isAndroid){
      await requestPermission();
    }
  if (await checkPermission()|| Platform.isWindows) {
    PickedFile? xFile =
    await ImagePickerAndroid()
        .pickImage(
        source:
        ImageSource
            .gallery);
    return xFile!.path;
  } else {
    Get.closeAllSnackbars();
    Get.snackbar("", "",
        messageText: Text(
            'youShouldGivePremissionToTheApp'.tr(),
            style: Theme.of(
                Get.overlayContext!)
                .textTheme
                .displaySmall!
                .copyWith(
                color:
                headColor)),
        titleText: Text(
            'noPremission'.tr(),
            style:
            Theme.of(Get.overlayContext!)
                .textTheme
                .displaySmall!
                .copyWith(
              color:
              headColor,
              fontWeight:
              FontWeight
                  .w800,
            ),
            textAlign:
            TextAlign.center),
        snackPosition:
        SnackPosition.BOTTOM,
        margin:
        const EdgeInsets.only(
            bottom: 100));
    return "";
  }
  }
  catch(e){
    return "";
  }
}

Future<String> pickFile() async{
  try{
    if(Platform.isAndroid){
      await requestPermission();
    }
  if (await checkPermission()|| Platform.isWindows) {
    Get.defaultDialog(
  onWillPop: () async => false,
  title: "pleaseWait".tr(),
  titleStyle: TextStyle(fontSize: 18),
  content: const Center(child: CircularProgressIndicator()),
);
    FilePickerResult? xFile =
    await FilePicker.platform
        .pickFiles(
        allowMultiple: false,dialogTitle: "chooseFile".tr(),allowedExtensions: ["pdf","doc","docx","xls","xlsx"],type: FileType.custom,lockParentWindow: true);
        Get.back();
    return xFile!.files.single.path!;
  } else {
    snakbarDialog(title: 'noPremission'.tr(), content: 'youShouldGivePremissionToTheApp'.tr(),
      durationSecound: 10, color: redColor, icon: const Icon(Icons.close));
    return "";
  }
  }
  catch(e){
    return "";
  }
}