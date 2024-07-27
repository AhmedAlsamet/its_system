import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:its_system/constants.dart';
import 'package:its_system/core/utils/snakbar_dialog.dart';
import 'package:its_system/functions.dart';
import 'package:its_system/helper/db/general_helper.dart';
import 'package:its_system/helper/db/setting_helper.dart';
import 'package:its_system/models/institution_model.dart';
import 'package:its_system/models/qr_style_model.dart';
import 'package:its_system/models/setting_model.dart';
import 'package:its_system/statics_values.dart';

class SettingController extends GetxController {

  GlobalKey<FormState> formKey = GlobalKey();
  RxList<Rx<SettingModel>> settings = <Rx<SettingModel>>[].obs;
  GeneralHelper generalDB = GeneralHelper();
  SettingHelper db = SettingHelper();
  String externalImageStorage = '';
  // for search
  Rx<QRStyleModel> style = QRStyleModel().initialize(
    institution: InstitutionModel(institutionId: StaticValue.userData!.institution!.institutionId!),
    qrIsDefault: true
  ).obs;

  TextEditingController search = TextEditingController();

  // ignore: non_const_call_to_literal_constructor
  Rx<PrettyQrDecoration> decoration = PrettyQrDecoration().obs;
  @override
  void onInit() async {
    super.onInit();
    fetchAllSetting();
    await getCompoundQrStyle();
  }

  fetchAllSetting() async {
    settings.clear();
    await db.getAllSettings(" WHERE INST_ID = ${StaticValue.userData!.institution!.institutionId}").then((value) {
      for (var i = 0; i < value.length; i++) {
        settings.add(value[i].obs);
      }
    });
  }


  getCompoundQrStyle() async {
    dynamic s = await generalDB.getByIdAsMap(
        "SELECT * FROM qr_styles ${/*StaticValue.userData!.userType == UserTypes.SUPER_ADMIN ? "" : */" WHERE INST_ID = ${StaticValue.userData!.institution!.institutionId}"}");
    if (s != null && s is! String) {
      style.value = QRStyleModel.fromMap(s);
    }
    decoration.value = PrettyQrDecoration(
        shape: style.value.qrStyle == QRStyle.Smooth
            ? PrettyQrSmoothSymbol(
                color: style.value.qrColor!,
                roundFactor: style.value.qrStyleIsRounded! ? 1 : 0)
            : PrettyQrRoundedSymbol(
                color: style.value.qrColor!,
                borderRadius: !style.value.qrStyleIsRounded!
                    ? BorderRadius.zero
                    : const BorderRadius.all(Radius.circular(10)),
              ),
        image: style.value.qrImagePath! == "" ? null : PrettyQrDecorationImage(
          position: style.value.qrImagePosition!,
          image: NetworkImage(StaticValue.serverPath! + style.value.qrImagePath!),
          onError: (exception, stackTrace) => SizedBox(
            child: Image.asset("assets/logo.png"),
          ),
        ));

  }

  addUpdateQrStyle() async {
    if(await generalDB.getByIdAsMap("SELECT * FROM qr_styles WHERE INST_ID = ${StaticValue.userData!.institution!.institutionId}") is String){
      await generalDB.createNew("qr_styles", await style.value.toMap());
    }
    else{
      await generalDB.update(
          tableName: "qr_styles",
          primaryKey: "QRS_ID",
          primaryKeyValue: style.value.qrStyleId,
          items: await style.value.toMap());
    }
    Get.back();
    await getCompoundQrStyle();
  }

  addUpdateSetting(String settingCode) async {
    if (settingCode != "INVOICE") {
      try {

        File file = File(settings
            .where((s) => s.value.settingCode! == "HEAD_LOGO")
            .first
            .value
            .settingValue!
            .text);
        if (file.path != '' && (await file.exists())) {
          
          final newPath =
              await postRequestWithFile("report_photos", StaticValue.userData!.institution!.institutionId!, file);

          settings
              .where((s) => s.value.settingCode! == "HEAD_LOGO")
              .first
              .value
              .settingValue!
              .text = newPath;
        } else {
          settings
              .where((s) => s.value.settingCode! == "HEAD_LOGO")
              .first
              .value
              .settingValue!
              .text = '';
        }
      } catch (e) {}
    } 
    bool result = true;
    for (var i = 0; i < settings.length; i++) {
      result = await db.updateSetting(settings[i].value) > 0;
    }
    if (result) {
      snakbarDialog(
          title: 'done'.tr(),
          content: 'theOperatorIsDoneSeccessfuly'.tr(),
          durationSecound: 3,
          color: blueColor,
          icon: const Icon(
            Icons.check_circle,
            color: Colors.white,
            size: 30,
          ));
    } else {
      snakbarDialog(
          title: 'errorTitle'.tr(),
          content: 'errorOcoredPleaseTryAgain'.tr(),
          durationSecound: 5,
          color: redColor,
          icon:
              const Icon(Icons.cancel_rounded, color: Colors.white, size: 30));
    }
    await fetchAllSetting();
  }
}
