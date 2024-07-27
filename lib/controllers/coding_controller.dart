import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/helper/db/general_helper.dart';
import 'package:its_system/helper/db/setting_helper.dart';
import 'package:its_system/models/general_model.dart';
import 'package:its_system/models/setting_model.dart';
import 'package:its_system/models/code_model.dart';

class CodingController extends GetxController {
  RxList<Rx<SettingModel>> settings = <Rx<SettingModel>>[].obs;
  GeneralHelper generalDB = GeneralHelper();
  SettingHelper db = SettingHelper();
  String externalImageStorage = '';
  RxList<Rx<CodeModel>> codes = <Rx<CodeModel>>[].obs;
  RxList<Rx<CodeModel>> copyCodes = <Rx<CodeModel>>[].obs;
  // for search
  late Rx<CodeModel> code;
  Rx<CodeModel> column3Value = CodeModel().obs;
  String column1 = "",
      column2 = "",
      column3 = "",
      columnPrefix = "",
      table = "",
      column3Title = "",
      column3Table = "",
      additionalCondectionForTableTow = "",
      column3Val = "";
  RxList<CodeModel>? column3Values = <CodeModel>[].obs;
  bool isEdit = false;
  TextEditingController search = TextEditingController();

  late GlobalKey<FormState> formKey;

  @override
  void onInit() {
    super.onInit();
    formKey = GlobalKey<FormState>();
    refershCode();
    fetchAllSetting();
    fetchAllCoding();
  }

  CodingController(
      {required this.table,
      required this.column1,
      required this.column2,
      required this.columnPrefix,
      this.column3 = "",
      this.column3Val = "",
      this.column3Title = "",
      this.additionalCondectionForTableTow = "",
      this.column3Table = ""});

  refershCode() {
    code =
        CodeModel(codeId: 0, codeName: GeneralModel().initialize(
          arabicHint: "name".tr(),
          englishHint: "name".tr(),
        ), supperId: 0)
            .obs;
    if(column3Values != null && column3Values!.isNotEmpty){
      code.value.supperId = column3Value.value.codeId;
    }
  }

  fetchAllSetting() async {
    // settings.clear();
    // await db.getAllSettings("").then((value) {
    //   for (var i = 0; i < value.length; i++) {
    //     settings.add(value[i].obs);
    //   }
    // });
  }

  fetchAllCoding() async {
    codes.clear();
    copyCodes.clear();
    column3Values!.clear();
    await generalDB.getAllAsMap("SELECT * FROM $table WHERE ${columnPrefix}_IS_DELETE = 0 ${column3Val != "" ? "AND $column3 = $column3Val" : ""}").then((value) {
      for (var i = 0; i < value!.length; i++) {
        codes.add(CodeModel(
                codeId: value[i][column1],
                codeName: GeneralModel.fromMap(value[i], columnPrefix),
                supperId: value[i][column3])
            .obs);
            codes[i].value.codeName!.arabicHint = "name".tr();
            codes[i].value.codeName!.englishHint = "name".tr();
        copyCodes.add(CodeModel(
                codeId: value[i][column1],
                codeName: GeneralModel.fromMap(value[i], columnPrefix),
                supperId: value[i][column3])
            .obs);
            copyCodes[i].value.codeName!.arabicHint = "name".tr();
            copyCodes[i].value.codeName!.englishHint = "name".tr();
      }
    });
    if (column3 != "" && column3Val == "") {
      await generalDB.getAllAsMap("SELECT * FROM $column3Table WHERE ${column3.replaceFirst("_ID", "")}_IS_DELETE = 0 $additionalCondectionForTableTow").then((value) {
        for (var i = 0; i < value!.length; i++) {
          column3Values!.add(CodeModel(
              codeId: value[i][column3],
              codeName: GeneralModel.fromMap(
                  value[i], column3.replaceAll("_ID", ""))));
        }
        column3Value.value = column3Values!.first;
      });
    }
  }

  addUpdateCode() async {
    Map<String, dynamic> forUpdateInsert = {};
    forUpdateInsert.addAll(
        code.value.codeName!.toMap(column1.replaceAll("_ID", ""), isEdit));
    if (column3 != "") {
      if(column3Val != ""){
        forUpdateInsert[column3] = column3Val;
      }
      else{
        forUpdateInsert[column3] = code.value.supperId;
      }
    }
    if (isEdit) {
      await generalDB.update(
          tableName: table,
          primaryKey: column1,
          primaryKeyValue: code.value.codeId,
          items: forUpdateInsert);
    } else {
      await generalDB.createNew(table, forUpdateInsert);
    }
    Get.back();
    await fetchAllCoding();
  }
  deleteCode(int id) async {
      await generalDB.update(
          tableName: table,
          primaryKey: column1,
          primaryKeyValue: id,
          items: {"${columnPrefix}_IS_DELETE":1});
    
    Get.back();
    await fetchAllCoding();
  }
}
