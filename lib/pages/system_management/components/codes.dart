import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';
import 'package:its_system/core/utils/delete_dialog2.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/constants.dart';
import 'package:its_system/controllers/general_controller.dart';
import 'package:its_system/controllers/coding_controller.dart';
import 'package:its_system/core/models/dropdown_button_model.dart';
import 'package:its_system/core/widgets/bottom_sheet_handel.dart';
import 'package:its_system/core/widgets/dropdown_button.dart';
import 'package:its_system/core/widgets/input_field.dart';
import 'package:its_system/pages/system_management/components/add_update_code.dart';
import 'package:its_system/responsive.dart';

// ignore: must_be_immutable
class CodesBottomSheet extends StatefulWidget {
  String table;
  String column1;
  String column2;
  String column3;
  String column3Val;
  String column3Title;
  String columnPrefix;
  String additionalCondectionForTableTow;
  String column3Table;
  CodesBottomSheet({
    Key? key,
    required this.table,
    required this.column1,
    required this.column2,
    required this.columnPrefix,
    this.column3 = "",
    this.column3Val = "",
    this.column3Title = "",
    this.additionalCondectionForTableTow = "",
    this.column3Table = "",
  }) : super(key: key);

  @override
  State<CodesBottomSheet> createState() => _AddNewOrderBottomSheetState();
}

class _AddNewOrderBottomSheetState extends State<CodesBottomSheet> {
  late List<FocusNode> nodes;
  @override
  void initState() {
    super.initState();
    nodes = [
      FocusNode(),
      FocusNode(),
      FocusNode(),
      FocusNode(),
      FocusNode(),
      FocusNode(),
    ];
    generalController = Get.put(GeneralController());
  }

  late GeneralController generalController;
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: Responsive.isDesktop(context) ? 1 : 0.8,
        maxChildSize: 1,
        minChildSize: 0.4,
        expand: Responsive.isDesktop(context) ? false : true,
        builder: (context, c) {
          return GetX<CodingController>(
              tag: widget.table,
              init: CodingController(
                columnPrefix: widget.columnPrefix,
                column1: widget.column1,
                column2: widget.column2,
                column3: widget.column3,
                column3Val: widget.column3Val,
                table: widget.table,
                column3Table: widget.column3Table,
                additionalCondectionForTableTow: widget.additionalCondectionForTableTow,
                column3Title: widget.column3Title,
              ),
              builder: (controller) {
                return Container(
                  color: Colors.transparent, //Theme.of(context).primaryColor,
                  width: Responsive.isDesktop(context) ? 500 : null,
                  child: Column(children: [
                    BottomSheetHandel(
                        cancelIcon: Ionicons.close,
                        cancelTooltip: "cancel".tr(),
                        saveIcon: Ionicons.add_circle,
                        saveTooltip: "add".tr(),
                        controller: c,
                        onSave: () async {
                          controller.isEdit = false;
                          controller.refershCode();
                          await showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: AddUpdateCode(
                                      controller: controller),
                                );
                              });
                        },
                        onCancel: () {
                          Get.back(result: "NONE");
                        }),
                    Expanded(
                      child: Scaffold(
                        body: Container(
                          color: Theme.of(context).cardColor,
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              InputField(
                                  label: "بحث",
                                  isRequired: false,
                                  node: FocusNode(),
                                  keyboardType: TextInputType.text,
                                  onFieldSubmitted: (v) {
                                    v = v.toLowerCase();
                                    controller.copyCodes.value =
                                        controller.codes.where((e) {
                                      return e.value.codeId!.toString() == v ||
                                          e.value.codeName!.arabicTitle!.text
                                              .toLowerCase()
                                              .contains(v) ||
                                          e.value.codeName!.englishTitle!.text
                                              .toLowerCase()
                                              .contains(v);
                                    }).toList();
                                  },
                                  controller: controller.search),
                              if (widget.column3 != "" &&
                                  controller.column3Values!.isNotEmpty)
                                DropdownButtonWidget(
                                    selectedItem: controller.column3Value.value,
                                    node: FocusNode(),
                                    onChanged: (v) {
                                      controller.column3Value.value = v!;
                                    },
                                    items: [
                                      ...controller.column3Values!.map((e) =>
                                          DropdownButtonModel(
                                              dropName:
                                                  e.codeName!.getTitle,
                                              dropValue: e))
                                    ],
                                    title: widget.column3Title),
                              Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                                                    children: controller.copyCodes
                                      .where((c) {
                                        if (widget.column3 == "" ) return true;
                                        if(widget.column3Val != ""){
                                          return c.value.supperId ==
                                            int.parse(widget.column3Val);
                                        }
                                        return c.value.supperId ==
                                            controller.column3Value.value.codeId;
                                      })
                                      .toList()
                                      .map((c) => Card(
                                            color: Theme.of(context).cardColor,
                                            child: ListTile(
                                              title: Text(
                                                c.value.codeName!.getTitle,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displaySmall,
                                              ),
                                              subtitle: Text(
                                                c.value.codeId!.toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge,
                                              ),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                      onPressed: () async {
                                                        controller.isEdit = true;
                                                        controller.code.value =
                                                            c.value.copyWith();
                                                        await showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return Dialog(
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                child:
                                                                    AddUpdateCode(
                                                                        controller:
                                                                            controller),
                                                              );
                                                            });
                                                      },
                                                      icon: Icon(Iconsax.edit)),
                                                  IconButton(
                                                      onPressed: () async {
                                                        deleteMessage2(
                                                          deleteButton: "delete".tr(),
                                                          title: "areYouSureFor".tr(), content: "${"delete".tr()} ${c.value.codeName!.getTitle}", onDelete: ()async{
                                                          await controller.deleteCode(c.value.codeId!);
                                                        }, onCancel: Get.back, onWillPop: true);
                                                      },
                                                      icon: const Icon(Icons.delete,color: redColor,)),
                                                
                                                ],
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                                                  ),
                                  )),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: redColor),
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text(
                                    "cancel".tr(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(color: Colors.white),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    )
                  ]),
                );
              });
        });
  }
}