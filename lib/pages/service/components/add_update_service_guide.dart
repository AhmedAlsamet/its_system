import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:its_system/constants.dart';
import 'package:its_system/controllers/general_controller.dart';
import 'package:its_system/controllers/service_controller.dart';
import 'package:its_system/core/models/dropdown_button_model.dart';
import 'package:its_system/core/utils/get_languages.dart';
import 'package:its_system/core/widgets/circle_button.dart';
import 'package:its_system/core/widgets/dropdown_button.dart';
import 'package:its_system/core/widgets/switch_list_widget.dart';
import 'package:its_system/helper/open_camera_gallery.dart';
import 'package:its_system/responsive.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class AddUpdateServiceGuide extends StatefulWidget {
  final int index;
  const AddUpdateServiceGuide({Key? key, required this.index})
      : super(key: key);

  @override
  State<AddUpdateServiceGuide> createState() => _AddNewOrderBottomSheetState();
}

class _AddNewOrderBottomSheetState extends State<AddUpdateServiceGuide> {
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
      FocusNode(),
      FocusNode(),
    ];
    generalController = Get.put(GeneralController());
  }

  late GeneralController generalController;

  // @override
  // void dispose() {
  //   generalController.dispose();
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    return GetX<ServiceController>(
        init: ServiceController(false),
        builder: (value) {
          return Container(
            color: Colors.transparent, //Theme.of(context).primaryColor,
            width: Responsive.isDesktop(context) ? 400 : null,
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Form(
                  key: value.formKey,
                  child: Container(
                    color: Theme.of(context).cardColor,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        SwitchListTileWidget(
                            title: "serviceGuideType".tr(),
                            subTitle:
                                value.serviceGuide.value.serviceGuideMainId == 0
                                    ? "main".tr()
                                    : "sub".tr(),
                            value:
                                value.serviceGuide.value.serviceGuideMainId ==
                                    0,
                            onChanged: (v) {
                              value.serviceGuide.update((val) {
                                if (value.serviceGuide.value
                                        .serviceGuideMainId ==
                                    0) {
                                  val!.serviceGuideMainId = value
                                      .serviceGuides.firstWhere((s) =>
                                        s.value.serviceGuideMainId == 0 &&
                                        s.value.service!.serviceId ==
                                            value.services[widget.index].value
                                                .serviceId).value.serviceGuideId;
                                } else {
                                  val!.serviceGuideMainId = 0;
                                }
                              });
                            }),
                        if (value.serviceGuide.value.serviceGuideMainId !=
                            0) ...[
                          const SizedBox(
                            height: 10,
                          ),
                          DropdownButtonWidget(
                              title: "serviceGuide".tr(),
                              onChanged: (v) {
                                value.serviceGuide.update((val) {
                                  val!.serviceGuideMainId = v!;
                                });
                              },
                              selectedItem: value.serviceGuide.value.serviceGuideMainId,
                              node: FocusNode(),
                              items: [
                                ...value.serviceGuides
                                    .where((s) =>
                                        s.value.serviceGuideMainId == 0 &&
                                        s.value.service!.serviceId ==
                                            value.services[widget.index].value
                                                .serviceId)
                                    .toList()
                                    .asMap()
                                    .entries
                                    .map((c) => DropdownButtonModel(
                                        dropName: c.value.value
                                            .serviceGuideName!.getTitle,
                                        dropOrder: c.key,
                                        dropValue:
                                            c.value.value.serviceGuideId!))
                                    .toList(),
                              ]),
                        ],
                        const SizedBox(
                          height: 10,
                        ),
                        ...getLanguagesAsWidgets2(
                            value.serviceGuide.value.serviceGuideName!,
                            nodes[1],
                            generalController.settings
                                .where((element) =>
                                    element.settingType == "LANG" &&
                                    element.settingValue!.text == "1")
                                .map((e) => e.settingCode!)
                                .toList(),
                                null,
                            nodes[2]),
                        const SizedBox(
                          height: 10,
                        ),
                         Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("chooesFile".tr(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall!),
                                  if(value.serviceGuide.value.serviceGuideFile!.path == '')
                                  CircleButton(
                                      iconSize: 30,
                                      onPressed: () async {
                                        String path = await pickFile();
                                        value.serviceGuide.update((val) {
                                          val!.serviceGuideFile = File(path);
                                        });
                                      },
                                      icon: Icons.storage_outlined),
                                  if(value.serviceGuide.value.serviceGuideFile!.path != '')
                                  CircleButton(
                                    iconSize: 30,
                                    onPressed: () {
                                      value.serviceGuide.update((val) {
                                        val!.serviceGuideFile = File("");
                                      });
                                    },
                                    icon: Icons.cancel),
                                ],
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor),
                              icon: const Icon(
                                Icons.check_circle_outline,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                if (value.formKey.currentState!.validate()) {
                                  await value.addUpdateServiceGuide();
                                }
                              },
                              // Edit
                              label: Text(
                                "save".tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: redColor),
                              icon: const Icon(
                                Icons.cancel_outlined,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                Get.back();
                              },
                              // Delete
                              label: Text(
                                "cancel".tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                )
              ]),
            ),
          );
        });
  }
}
