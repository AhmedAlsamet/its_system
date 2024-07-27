
import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:its_system/functions.dart';
import 'package:share_plus/share_plus.dart';

extension PrettyQrImageExtension on QrImage {
  Future<String?> exportAsImage(
    final BuildContext context, {
    required final int size,
    required final PrettyQrDecoration decoration,
  }) async {
    try{
    final configuration = createLocalImageConfiguration(context);
  if(Platform.isAndroid){
    await requestStoragePermission();
  }
  if (await checkStoragePermission()){
    Get.defaultDialog(
  onWillPop: () async => false,
  title: "pleaseWait".tr(),
  titleStyle: const TextStyle(fontSize: 16),
  content: const Center(child: CircularProgressIndicator()),
);
    final bytes = await toImageAsBytes(
      size: size,
      decoration: decoration,
      configuration: configuration,
      format: ImageByteFormat.png,
    );
String? docDirectory = await FilePicker.platform.saveFile(
  dialogTitle: 'Please select an output file:',
  fileName: "qr-code${DateFormat("yyyy-MM-dd_HH:mm:ss").format(DateTime.now())}.png",
  bytes: bytes!.buffer.asUint8List(),
  type: FileType.image,
  lockParentWindow: true
  );

Get.back();
    if (docDirectory == null) return null;


    // final file = await File(docDirectory).create();
    // await file.writeAsBytes(bytes!.buffer.asUint8List());
    return docDirectory;
  }
    }
    catch(e){
      print(e);
    }
}


  Future<String?> shareAsImage(
    final BuildContext context, {
    required final int size,
    required final String massage,
    required final PrettyQrDecoration decoration,
  }) async {
    final configuration = createLocalImageConfiguration(context);
    if(Platform.isAndroid){
      await requestStoragePermission();
    }
  if (await checkStoragePermission()){
      final bytes = await toImageAsBytes(
        size: size,
        decoration: decoration,
        configuration: configuration,
      );
      
    final file = await File("${(await getApplicationDocumentsDirectory()).path}/qr-code${DateFormat("yyyy-MM-dd_HH:mm:ss").format(DateTime.now())}.png").create();
    await file.writeAsBytes(bytes!.buffer.asUint8List());
      // final result = await Share.shareXFiles([XFile.fromData(bytes!.buffer.asUint8List(),name:"qr-code${DateFormat("yyyy-MM-dd_HH:mm:ss").format(DateTime.now())}.png",length: bytes.buffer.asUint8List().length)], text: 'Great picture');
    final result = await Share.shareXFiles([XFile(file.path)], text: massage);
    await file.delete();
    if (result.status == ShareResultStatus.success) {
        return "Done";
    }
  }
    return "Error";
  }
}