
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:ionicons/ionicons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/controllers/setting_controller.dart';
import 'package:its_system/core/widgets/bottom_sheet_handel.dart';
import 'package:its_system/core/widgets/circle_button.dart';
import 'package:its_system/core/widgets/input_field.dart';
import 'package:its_system/helper/open_camera_gallery.dart';
import 'package:its_system/responsive.dart';

// ignore: must_be_immutable
class AddNewReportSettingBottomSheet extends StatefulWidget {
  String settingCode; 
  AddNewReportSettingBottomSheet({Key? key,required this.settingCode})
      : super(key: key);

  @override
  State<AddNewReportSettingBottomSheet> createState() =>
      _AddNewOrderBottomSheetState();
}

class _AddNewOrderBottomSheetState extends State<AddNewReportSettingBottomSheet> {
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
      FocusNode(),
      FocusNode(),
      FocusNode(),
      FocusNode(),
      FocusNode(),
      FocusNode(),
      FocusNode(),
      FocusNode(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
          initialChildSize: Responsive.isDesktop(context) ?1:0.8,
          maxChildSize: 1,
          minChildSize: 0.4,
          expand: Responsive.isDesktop(context) ?false:true,
      builder: (context,c) {
        return GetX<SettingController>(
                    init: SettingController(),
                    builder: (value) {
                  return Container(
                    color:Colors.transparent, //Theme.of(context).primaryColor,
                    width: Responsive.isDesktop(context) ? 500 : null,
                    child: Column(children: [
                      BottomSheetHandel(
                          cancelIcon: Ionicons.close,
                          cancelTooltip: "cancel".tr(),
                          saveIcon: Ionicons.save,
                          saveTooltip: "save".tr(),
                          controller: c,
                          onSave: () async{
                            if(value.formKey.currentState!.validate()){
                                await value.addUpdateSetting(widget.settingCode);
                                Get.back();
                                value.fetchAllSetting();
                            }
                          },
                          onCancel: () {
                            Get.back(result: "Ahmed");
                            value.fetchAllSetting();
                          }),
                      Form(
                        key: value.formKey,
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
                                  child: 
                                  (value.settings.isNotEmpty && widget.settingCode == "REPORT")?
                                  ListView(
                                    children: [
                                      const SizedBox(height: 10,),
                                      InputField(
                                        controller:
                                            value.settings.where((s) => s.value.settingCode! == "HEAD_RIGHT1").first.value.settingValue!,
                                        keyboardType: TextInputType.multiline,
                                        isRequired: false,
                                        node: nodes[0],
                                        label: "reportHeaderR1".tr(),
                                        onFieldSubmitted: (v) {
                                          nodes[1].requestFocus();
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      InputField(
                                        controller:
                                            value.settings.where((s) => s.value.settingCode! == "HEAD_RIGHT2").first.value.settingValue!,
                                        keyboardType: TextInputType.multiline,
                                        isRequired: false,
                                        node: nodes[1],
                                        label: "reportHeaderR2".tr(),
                                        onFieldSubmitted: (v) {
                                          nodes[2].requestFocus();
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      InputField(
                                        controller:
                                            value.settings.where((s) => s.value.settingCode! == "HEAD_RIGHT3").first.value.settingValue!,
                                        keyboardType: TextInputType.multiline,
                                        isRequired: false,
                                        node: nodes[2],
                                        label: "reportHeaderR3".tr(),
                                        onFieldSubmitted: (v) {
                                          nodes[3].requestFocus();
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      InputField(
                                        controller:
                                            value.settings.where((s) => s.value.settingCode! == "HEAD_LEFT1").first.value.settingValue!,
                                        keyboardType: TextInputType.multiline,
                                        isRequired: false,
                                        node: nodes[3],
                                        label: "reportHeaderL1".tr(),
                                        onFieldSubmitted: (v) {
                                          nodes[4].requestFocus();
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      InputField(
                                        controller:
                                            value.settings.where((s) => s.value.settingCode! == "HEAD_LEFT2").first.value.settingValue!,
                                        keyboardType: TextInputType.multiline,
                                        isRequired: false,
                                        node: nodes[4],
                                        label: "reportHeaderL2".tr(),
                                        onFieldSubmitted: (v) {
                                          nodes[5].requestFocus();
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      InputField(
                                        controller:
                                            value.settings.where((s) => s.value.settingCode! == "HEAD_LEFT3").first.value.settingValue!,
                                        keyboardType: TextInputType.multiline,
                                        isRequired: false,
                                        node: nodes[5],
                                        label: "reportHeaderL3".tr(),
                                        onFieldSubmitted: (v) {
                                          nodes[6].requestFocus();
                                        },
                                      ),
                                      (value.settings.where((s) => s.value.settingCode! == "HEAD_LOGO").first.value.settingValue!.text == '')
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
                                              value.settings.where((s) => s.value.settingCode! == "HEAD_LOGO").first.update((val) {
                                              val!.settingValue!.text = path;
                                            });
                                        },
                                        icon: Icons.storage_outlined),
                                    CircleButton(

                                        iconSize: 30,
                                        onPressed:
                                        () async {
                                          String path = await openCamera();
                                              value.settings.where((s) => s.value.settingCode! == "HEAD_LOGO").first.update((val) {
                                              val!.settingValue!.text = path;
                                            });
                                        },
                                        icon: Icons.camera_outlined),
                                              ],
                                            )
                                          : CircleButton(

                                              iconSize: 30,
                                              onPressed: () {
                                              value.settings.where((s) => s.value.settingCode! == "HEAD_LOGO").first.update((val) {
                                              val!.settingValue!.text = '';
                                            });
                                              },
                                              icon: Icons.cancel),
                                      // Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom))
                                      // for save the keyboard position
                                    ],
                                  ): 
                                  const CircularProgressIndicator()

                                  ),
                            ),
                          ),
                        ),
                      )
                    ]),
                  );
                });
      }
    );
  }
}