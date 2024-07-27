// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:iconsax/iconsax.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:its_system/constants.dart';
import 'package:its_system/core/utils/snakbar_dialog.dart';
import 'package:its_system/helper/excel.dart';

// ignore: must_be_immutable
class ImportExcelDialog extends StatefulWidget {
  final bool isTablet;
  final String excelName;
  List<DataDetails> dataDetails;
  Function(List<Map<String,dynamic>>) onImport;
  ImportExcelDialog(
      {super.key,
      required this.isTablet,
      required this.excelName,
      required this.dataDetails,
      required this.onImport});

  @override
  State<ImportExcelDialog> createState() => _ImportExcelDialogState();
}

class _ImportExcelDialogState extends State<ImportExcelDialog> {
  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Stack(
          children: <Widget>[
            Container(
              height: 500,
              width: widget.isTablet ? 500 : null,
              padding: const EdgeInsets.only(
                top: 75,
                bottom: 15,
                left: 15,
                right: 15,
              ),
              margin: const EdgeInsets.only(
                top: 60,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      //scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        // width: double.infinity,
                        child: Table(
                          border: TableBorder.all(color: Colors.black),textBaseline: TextBaseline.ideographic,
                          columnWidths:const {
                                0: FlexColumnWidth(1),
                                1: FlexColumnWidth(3),
                                2: FlexColumnWidth(2),
                                3: FlexColumnWidth(2),
                          },
                          children: [
                            TableRow(
                                children: [
                                Container(
                                  margin:const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                                  child:FittedBox(
                                fit: BoxFit.scaleDown,
                                child:Text(
                                  "letter".tr(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),),),
                                Container(
                                  margin:const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                                  child:FittedBox(
                                fit: BoxFit.scaleDown,
                                child:Text(
                                  "columnName".tr(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),),),
                                Container(
                                  margin:const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                                  child:FittedBox(
                                fit: BoxFit.scaleDown,
                                child:Text(
                                  "columnType".tr(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),),),
                                Container(
                                  margin:const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                                  child:FittedBox(
                                fit: BoxFit.scaleDown,
                                child:Text(
                                  "allowValues".tr(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),),),
                            ],
                            ),
                            ...widget.dataDetails
                                .asMap()
                                .entries
                                .map((e) => recentUserDataRow(
                                    widget.dataDetails[e.key], context))
                                .toList()
                          ],),
                      ),
                    ),
                  ),
                          const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                        ElevatedButton.icon(
                          style:
                              ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          onPressed: () async{
                            widget.dataDetails.sort((a, b) {
                              return a.number.compareTo(b.number);
                            },);
                            await exportToExcel(widget.excelName, [[...widget.dataDetails.map((e) => e.title)],[...widget.dataDetails.map((e){
                              if(e.dataType == "رقم")return "1";
                              if(e.dataType == "رقم صحيح")return "1.0";
                              if(e.dataType == "تاريخ")return "2020-01-01";
                              return "text";
                            })]]);
                          },
                          icon: const Icon(Iconsax.info_circle,color: Colors.white,),
                          label: Text(
                            "exportExcelSample".tr(),
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(color: Colors.white),
                          )),
                       ElevatedButton.icon(
                          style:
                              ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          onPressed: () async{
                            widget.dataDetails.sort((a, b) {
                              return a.number.compareTo(b.number);
                            },);
                            Map<String,List> checkingValues = {};
                            for (var i = 0; i < widget.dataDetails.length; i++) {
                              if(widget.dataDetails[i].allowValues.isNotEmpty) {
                                checkingValues[widget.dataDetails[i].columnName] = widget.dataDetails[i].allowValues;
                              }
                            }
                            final data = await readFromExcel(widget.dataDetails.map((e) => e.columnName).toList(),checkingValues );
                            if(data is String) {
                              snakbarDialog(title: "errorTitle".tr(), content: data, durationSecound: 10);
                              return;
                            }
                            widget.onImport(data);
                          },
                          icon: const Icon(Iconsax.folder,color: Colors.white,),
                          label: Text(
                            "chooseFile".tr(),
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(color: Colors.white),
                          )),
                           ElevatedButton.icon(
                          style:
                              ElevatedButton.styleFrom(backgroundColor: redColor),
                          onPressed: () {
                            // print(widget.products[0].unit!.unitName);
                            Get.back();
                          },
                          icon: const Icon(Iconsax.close_circle,color: Colors.white,),
                          label: Text(
                            "cancel".tr(),
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(color: Colors.white),
                          )),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              left: 15,
              right: 15,
              child: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                radius: 60,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Icon(
                      Iconsax.import,
                      size: 100,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  recentUserDataRow(DataDetails recentData, BuildContext context) {
    return TableRow(
      children: [
          TextAvatar(
            size: 35,
            backgroundColor: Colors.white,
            textColor: Colors.white,
            fontSize: 14,
            upperCase: true,
            numberLetters: 1,
            shape: Shape.Rectangle,
            text: recentData.number,
          ),
           Container(
            margin:const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
            child:FittedBox(
            fit: BoxFit.scaleDown,
            child:Text(
            recentData.title,
            style: Theme.of(context).textTheme.displayMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),),),
           Container(
            margin:const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
            child:FittedBox(
            fit: BoxFit.scaleDown,
            child:Text(
            recentData.dataType.tr(),
            style: Theme.of(context).textTheme.displayMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),),),
           Container(
            height: (recentData.allowValues.length + 1) * 20,
            margin:const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
            child:Text(
            recentData.allowValues.isEmpty ? "${"any".tr()} ${recentData.dataType}" : recentData.allowValues.join("\n"),
            softWrap: true,
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
              overflow: TextOverflow.visible
            ),
                      ),)
      ],
   );
  }
}

class DataDetails {
  String number;
  String title;
  String columnName;
  String dataType;
  List<String> allowValues;
  DataDetails({
    required this.number,
    required this.title,
    required this.columnName,
    required this.dataType,
    required this.allowValues,
  });
}
