import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:ionicons/ionicons.dart';
import 'package:its_system/controllers/general_controller.dart';
import 'package:its_system/controllers/system_management_controller.dart';
import 'package:its_system/core/models/dropdown_button_model.dart';
import 'package:its_system/core/utils/get_languages.dart';
import 'package:its_system/core/widgets/bottom_sheet_handel.dart';
import 'package:its_system/core/widgets/circle_button.dart';
import 'package:its_system/core/widgets/dropdown_button.dart';
import 'package:its_system/core/widgets/input_field.dart';
import 'package:its_system/helper/open_camera_gallery.dart';
import 'package:its_system/models/place_model.dart';
import 'package:its_system/models/state_enum.dart';
import 'package:its_system/responsive.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class AddNewInstitutionBottomSheet extends StatefulWidget {
  const AddNewInstitutionBottomSheet({Key? key}) : super(key: key);

  @override
  State<AddNewInstitutionBottomSheet> createState() =>
      _AddNewOrderBottomSheetState();
}

class _AddNewOrderBottomSheetState extends State<AddNewInstitutionBottomSheet> {
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
    return DraggableScrollableSheet(
        initialChildSize: Responsive.isDesktop(context) ? 1 : 0.8,
        maxChildSize: 1,
        minChildSize: 0.4,
        expand: Responsive.isDesktop(context) ? false : true,
        builder: (context, c) {
          return GetX<SystemManagementController>(
              init: SystemManagementController(),
              builder: (controller) {
                return Container(
                  color: Colors.transparent, //Theme.of(context).primaryColor,
                  width: Responsive.isDesktop(context) ? 500 : null,
                  child: Column(children: [
                    BottomSheetHandel(
                        cancelIcon: Ionicons.close,
                        cancelTooltip: "cancel".tr(),
                        saveIcon: Ionicons.save,
                        saveTooltip: "save".tr(),
                        controller: c,
                        onSave: () async {
                          if (controller.formState.currentState!.validate()) {
                            await controller.addUpdateCompound();
                          }
                        },
                        onCancel: () {
                          Get.back(result: "Ahmed");
                        }),
                    Form(
                      key: controller.formState,
                      child: Expanded(
                        child: Scaffold(
                          body: Container(
                            color: Theme.of(context).cardColor,
                            padding: const EdgeInsets.all(10),
                            child: NotificationListener<
                                    OverscrollIndicatorNotification>(
                                onNotification: (overScroll) {
                                  overScroll.disallowIndicator();
                                  return false;
                                },
                                child: ListView(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                      DropdownButtonWidget<int>(
                                          title: "followFro".tr(),
                                          onChanged: (v) {
                                            controller.institution.update((val) {
                                              val!.institutionMainId = v;
                                            });
                                          },
                                          selectedItem: controller
                                              .institution.value.institutionMainId,
                                          node: FocusNode(),
                                          items: [
                                              DropdownButtonModel(
                                                  dropName:"mainInstitution".tr(),
                                                  dropOrder: 0,
                                                  dropValue: 0),
                                            ...controller.institutions
                                                .asMap()
                                                .entries
                                                .map((c) =>
                                                    DropdownButtonModel(
                                                        dropName:
                                                            c.value
                                                                .value
                                                                .institutionName!
                                                                .getTitle,
                                                        dropOrder: c.key,
                                                        dropValue: c
                                                            .value
                                                            .value
                                                            .institutionId!)),
                                          ]),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Wrap(
                                      spacing: 10,
                                      alignment: WrapAlignment.center,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 150,
                                          child: DropdownButtonWidget(
                                              title: "city".tr(),
                                              onChanged: (v) {
                                                controller
                                                    .selectedCity.value = v!;
                                                controller.selectedMunicipality.value =
                                                    controller.municipalities
                                                        .firstWhere(
                                                          (c) =>
                                                              c.value.city!
                                                                  .cityId ==
                                                              controller
                                                                  .selectedCity
                                                                  .value,
                                                          orElse: () =>
                                                              MunicipalityModel(
                                                                      municipalityId: 0)
                                                                  .obs,
                                                        )
                                                        .value
                                                        .municipalityId!;
                                                controller.institution.value.municipality!
                                                        .municipalityId =
                                                    controller.selectedMunicipality.value;
                                                controller.institution.value.city!
                                                        .cityId =
                                                    controller.selectedCity.value;
                                              },
                                              selectedItem: controller
                                                  .selectedCity.value,
                                              node: FocusNode(),
                                              items: [
                                                ...controller.cities
                                                    .asMap()
                                                    .entries
                                                    .map((c) =>
                                                        DropdownButtonModel(
                                                            dropName:
                                                                c
                                                                    .value
                                                                    .value
                                                                    .cityName!
                                                                    .getTitle,
                                                            dropOrder: c.key,
                                                            dropValue: c
                                                                .value
                                                                .value
                                                                .cityId!))
                                                    .toList(),
                                              ]),
                                        ),
                                        SizedBox(
                                          width: 150,
                                          child: DropdownButtonWidget(
                                              title: "municipality".tr(),
                                              onChanged: (v) {
                                                controller.selectedMunicipality.value =
                                                    v!;
                                                controller.institution.value.municipality!
                                                    .municipalityId = v;
                                              },
                                              selectedItem:
                                                  controller.selectedMunicipality.value,
                                              node: FocusNode(),
                                              items: [
                                                if (controller.municipalities
                                                    .where((c) =>
                                                        c.value.city!
                                                            .cityId ==
                                                        controller
                                                            .selectedCity
                                                            .value)
                                                    .isEmpty)
                                                  DropdownButtonModel(
                                                      dropName: "unknown".tr(),
                                                      dropOrder: 0,
                                                      dropValue: 0),
                                                ...controller.municipalities
                                                    .where((c) =>
                                                        c.value.city!
                                                            .cityId ==
                                                        controller
                                                            .selectedCity
                                                            .value)
                                                    .toList()
                                                    .asMap()
                                                    .entries
                                                    .map((c) =>
                                                        DropdownButtonModel(
                                                            dropName:
                                                                c.value
                                                                    .value
                                                                    .municipalityName!
                                                                    .getTitle,
                                                            dropOrder: c.key,
                                                            dropValue: c.value.value.municipalityId!)),
                                              ]),
                                        ),
                                      
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                      ...getLanguagesAsWidgets2(controller.institution.value
                                          .institutionName!, nodes[0], 
                            generalController.settings.where((element) => element.settingType == "LANG" && element.settingValue!.text == "1").map((e) => e.settingCode!).toList(),
                            null,
                                           nodes[1]),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InputField(
                                      controller: controller
                                          .institution.value.institutionAddress!,
                                      keyboardType: TextInputType.text,
                                      isRequired: true,
                                      node: nodes[1],
                                      label: "institutionAddress".tr(),
                                      onFieldSubmitted: (v) {
                                        nodes[2].requestFocus();
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InputField(
                                      controller: controller
                                          .institution.value.institutionPhone!,
                                      keyboardType: TextInputType.phone,
                                      isRequired: true,
                                      node: nodes[2],
                                      label: "phone".tr(),
                                      onFieldSubmitted: (v) {
                                        nodes[3].requestFocus();
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InputField(
                                      controller: controller
                                          .institution.value.institutionPhone2!,
                                      keyboardType: TextInputType.text,
                                      isRequired: false,
                                      node: nodes[3],
                                      label: "phone2".tr(),
                                      onFieldSubmitted: (v) {
                                        nodes[4].requestFocus();
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InputField(
                                      controller: controller
                                          .institution.value.institutionEMail!,
                                      keyboardType: TextInputType.text,
                                      isRequired: false,
                                      node: nodes[4],
                                      label: "emailAddress".tr(),
                                      onFieldSubmitted: (v) {
                                        nodes[5].requestFocus();
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InputField(
                                      controller: controller
                                          .institution.value.institutionUniqueKey!,
                                      keyboardType: TextInputType.text,
                                      isRequired: true,
                                      node: nodes[5],
                                      label: "institutionUniqeCode".tr(),
                                      onFieldSubmitted: (v) {
                                        nodes[6].requestFocus();
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    // DropdownButtonWidget<SubscripeType>(
                                    //   title: "subscriptionType".tr(),
                                    //   node: nodes[4],
                                    //   items: [
                                    //     ...SubscripeType.values.map((e) {
                                    //       return DropdownButtonModel(
                                    //           dropName: e.name.tr(),
                                    //           dropValue: e,
                                    //           dropOrder: e.index);
                                    //     })
                                    //   ],
                                    //   selectedItem: controller
                                    //       .institution.value.subscripeType!,
                                    //   onChanged: (v) {
                                    //     controller.institution.update((val) {
                                    //       val!.subscripeType = v;
                                    //     });
                                    //   },
                                    // ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    DropdownButtonWidget<States>(
                                      title: "state".tr(),
                                      node: nodes[7],
                                      items: [
                                        ...States.values.take(3).map((e) =>
                                            DropdownButtonModel(
                                                dropName: e.name.tr(),
                                                dropValue: e,
                                                dropOrder: e.index))
                                      ],
                                      selectedItem: controller
                                          .institution.value.institutionState!,
                                      onChanged: (v) {
                                        controller.institution.update((val) {
                                          val!.institutionState = v;
                                        });
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                        (controller.institution.value.institutionLogo!.path == '')
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "chooesImage".tr(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displaySmall!
                                                ),
                                                CircleButton(
                                        iconSize: 30,
                                        onPressed:
                                         () async {
                                              String path = await openGallery();
                                              controller.institution.update((val) {
                                                val!.institutionLogo = File(path);
                                              });
                                        },
                                        icon: Icons.storage_outlined),
                                    CircleButton(

                                        iconSize: 30,
                                        onPressed:
                                        () async {
                                          String path = await openCamera();
                                          controller.institution.update((val) {
                                            val!.institutionLogo = File(path);
                                          });
                                        },
                                        icon: Icons.camera_outlined),
                                              ],
                                            )
                                          : CircleButton(

                                              iconSize: 30,
                                              onPressed: () {
                                              controller.institution.update((val) {
                                                val!.institutionLogo = File("");
                                              });
                                              },
                                          icon: Icons.cancel),
                                       const SizedBox(
                                        height: 10,
                                      ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                )),
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
