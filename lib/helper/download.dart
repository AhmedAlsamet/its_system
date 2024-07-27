import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:get/get.dart' hide Trans;
import 'package:its_system/constants.dart';
import 'package:its_system/core/utils/snakbar_dialog.dart';
import 'package:its_system/statics_values.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

downloadFile(String fileName,String name)async{
  Get.defaultDialog(
    onWillPop: () async => false,
    title: "pleaseWait".tr(),
    titleStyle: const TextStyle(fontSize: 18),
    content: const Center(child: CircularProgressIndicator()),
  );
  await FileDownloader.downloadFile(
    url: StaticValue.serverPath! +fileName,
    name: name,//(optional) 
    onDownloadCompleted: (String path) {
        snakbarDialog(title: 'done'.tr(), content: 'theOperatorIsDoneSeccessfuly'.tr(), durationSecound: 3, color: blueColor,icon: const Icon(Icons.check_circle,color: Colors.white,size: 30,));
    },
    onDownloadError: (String error) {
        snakbarDialog(
            title: 'errorTitle'.tr(),
            content: 'errorOcoredPleaseTryAgain'.tr(),
            durationSecound: 5,
            icon: const Icon(Icons.cancel_rounded, color: Colors.white, size: 30));
    });
  Get.back();
}