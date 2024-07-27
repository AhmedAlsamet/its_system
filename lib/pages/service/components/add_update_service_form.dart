import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:its_system/constants.dart';
import 'package:its_system/controllers/general_controller.dart';
import 'package:its_system/controllers/service_controller.dart';
import 'package:its_system/core/utils/get_languages.dart';
import 'package:its_system/core/widgets/input_field.dart';
import 'package:its_system/responsive.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class AddUpdateServiceForm extends StatefulWidget {
  final int index;
  const AddUpdateServiceForm({Key? key, required this.index})
      : super(key: key);

  @override
  State<AddUpdateServiceForm> createState() => _AddNewOrderBottomSheetState();
}

class _AddNewOrderBottomSheetState extends State<AddUpdateServiceForm> {
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
                        InputField(
                          controller:
                              value.serviceForm.value.serviceFormOrder!,
                          keyboardType: TextInputType.text,
                          isRequired: true,
                          readOnly: value.isEdit,
                          node: nodes[0],
                          label: "FormOrder".tr() ,
                          onFieldSubmitted: (v) {
                            nodes[1].requestFocus();
                          },
                          isNumber: true,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ...getLanguagesAsWidgets2(
                            value.serviceForm.value.serviceFormName!,
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
                        ...getLanguagesAsWidgets2(
                            value.serviceForm.value.serviceFormDescription!,
                            nodes[2],
                            generalController.settings
                                .where((element) =>
                                    element.settingType == "LANG" &&
                                    element.settingValue!.text == "1")
                                .map((e) => e.settingCode!)
                                .toList(),
                                3,
                            nodes[3]),
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
                                  await value.addUpdateServiceForm(widget.index);
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
