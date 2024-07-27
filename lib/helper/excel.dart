

import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:localize_and_translate/localize_and_translate.dart';

bool checkValue(value,List checkingValues){
  for (var i = 0; i < checkingValues.length; i++) {
    if(value.toString() == checkingValues[i]){
      return true;
    }
  }
  return false;
}

readFromExcel(List<String> columnNames,Map<String,List> checkingValues)async{
  // checkingValues for default valuse like employee type
List<Map<String,dynamic>> result = [];
// var file = filePath;
Get.defaultDialog(
  onWillPop: () async => false,
  title: "pleaseWait".tr(),
  titleStyle: TextStyle(fontSize: 18),
  content: const Center(child: CircularProgressIndicator()),
);
FilePickerResult? file = await FilePicker.platform.pickFiles(
  type: FileType.custom,
  lockParentWindow: true,
  allowedExtensions: ["xlsx"],dialogTitle: "chooseFile".tr(),);
Get.back();
if (file == null) {
  return "";
} 
var bytes = File(file.files.single.path!).readAsBytesSync();

var excel = Excel.decodeBytes(bytes);


for (var table in excel.tables.keys) {
  // print(table); //sheet Name
  // print(excel.tables[table]!.maxColumns);
  // print(excel.tables[table]!.maxRows);
  if(excel.tables[table]!.maxColumns < columnNames.length){
    return "columnNumberInFileIsLessThatNumberThatDBNeed".tr();
  }
  for (List<Data?> row in excel.tables[table]!.rows.skip(1)) {
    result.add({});
    for (Data? cell in row) {
      // print('cell ${cell!.rowIndex}/${cell.columnIndex}');
      CellValue? value = cell!.value;
      // final numFormat = cell.cellStyle?.numberFormat ?? NumFormat.standard_0;
      if(value == null){
        return "${"errorEmptyValueInRowNumber".tr()} ${cell.cellIndex.rowIndex + 1} ${"ColumnNumber".tr()} ${cell.cellIndex.columnIndex + 1}";
      }
      if(checkingValues[columnNames[cell.columnIndex]]!=null && !checkValue(value, checkingValues[columnNames[cell.columnIndex]]!)){
        return "${"errorWrongValueInRowNumber".tr()} ${cell.cellIndex.rowIndex + 1} ${"ColumnNumber".tr()} ${cell.cellIndex.columnIndex + 1}";
      }
      result[cell.rowIndex - 1][columnNames[cell.columnIndex]]= value;
    }
  }
}
  return result;
}

exportToExcel(String fileName,List<List> data)async{
  Excel excel = Excel.createExcel();
  for (var i = 0; i < data.length; i++) {
    List<CellValue> dataList = [...data[i].map((e) => TextCellValue(e.toString()))];
    excel.appendRow(excel.sheets["Sheet1"]!= null ? excel.sheets["Sheet1"]!.sheetName :"Sheet1",dataList);
  }
  List<int>? fileBytes = excel.save(fileName:fileName);
  Get.defaultDialog(
  onWillPop: () async => false,
  title: "pleaseWait".tr(),
  titleStyle: TextStyle(fontSize: 18),
  content: const Center(child: CircularProgressIndicator()),
);
  String? outputFile = await FilePicker.platform.saveFile(
  dialogTitle: 'Please select an output file:',
  lockParentWindow: true,
  fileName: fileName,
  );
  Get.back();

  if (outputFile != null) {
    File(outputFile)
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);
    // User canceled the picker
    return true;
  }
  return false;
}

exportToExcelInTowSheets(String fileName,List<List> data,List<List> data2)async{
  Excel excel = Excel.createExcel();
  for (var i = 0; i < data.length; i++) {
    List<CellValue> dataList = [...data[i].map((e) => TextCellValue(e.toString()))];
    excel.appendRow(excel.sheets["Sheet1"]!= null ? excel.sheets["Sheet1"]!.sheetName :"Sheet1",dataList);
  }
  for (var i = 0; i < data2.length; i++) {
    List<CellValue> dataList = [...data2[i].map((e) => TextCellValue(e.toString()))];
    excel.appendRow(excel.sheets["Sheet2"]!= null ? excel.sheets["Sheet2"]!.sheetName :"Sheet2",dataList);
  }
  List<int>? fileBytes = excel.save(fileName:fileName);

  Get.defaultDialog(
  onWillPop: () async => false,
  title: "pleaseWait".tr(),
  titleStyle: TextStyle(fontSize: 18),
  content: const Center(child: CircularProgressIndicator()),
);

  String? outputFile = await FilePicker.platform.saveFile(
  dialogTitle: 'Please select an output file:',
  lockParentWindow: true,
  fileName: fileName,
  );

  Get.back();

  if (outputFile != null) {
    File(outputFile)
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);
    // User canceled the picker
    return true;
  }
  return false;
}


/**
 case TextCellValue():
          print('  text: ${value.value}');
        case FormulaCellValue():
          print('  formula: ${value.formula}');
          print('  format: ${numFormat}');
        case IntCellValue():
          print('  int: ${value.value}');
          print('  format: ${numFormat}');
        case BoolCellValue():
          print('  bool: ${value.value ? 'YES!!' : 'NO..' }');
          print('  format: ${numFormat}');
        case DoubleCellValue():
          print('  double: ${value.value}');
          print('  format: ${numFormat}');
        case DateCellValue():
          print('  date: ${value.year} ${value.month} ${value.day} (${value.asDateTimeLocal()})');
        case TimeCellValue():
          print('  time: ${value.hour} ${value.minute} ... (${value.asDuration()})');
        case DateTimeCellValue():
          print('  date with time: ${value.year} ${value.month} ${value.day} ${value.hour} ... (${value.asDateTimeLocal()})');
      
 */