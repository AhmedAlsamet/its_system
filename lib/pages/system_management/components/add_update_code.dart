import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/constants.dart';
import 'package:its_system/controllers/general_controller.dart';
import 'package:its_system/controllers/coding_controller.dart';
import 'package:its_system/core/models/dropdown_button_model.dart';
import 'package:its_system/core/utils/get_languages.dart';
import 'package:its_system/core/widgets/dropdown_button.dart';
import 'package:its_system/responsive.dart';

// ignore: must_be_immutable
class AddUpdateCode extends StatefulWidget {
  CodingController controller;
  AddUpdateCode({Key? key, required this.controller})
      : super(key: key);

  @override
  State<AddUpdateCode> createState() => _AddUpdateCodeState();
}

class _AddUpdateCodeState extends State<AddUpdateCode> {
  late GeneralController generalController;

  @override
  void initState() {
    super.initState();
    generalController = Get.put(GeneralController());    
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).cardColor,
        ),
        width: Responsive.isDesktop(context) ? 300 : null,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            color: Theme.of(context).cardColor,
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                  child: Text(
                    widget.controller.isEdit ? "edit".tr() : "addNew".tr(),
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
                if (widget.controller.column3 != "" &&
                    widget.controller.column3Values!.isNotEmpty)
                  DropdownButtonWidget(
                      selectedItem: widget.controller.code.value.supperId,
                      node: FocusNode(),
                      onChanged: (v) {
                        widget.controller.code.update((val) {val!.supperId = v!;});
                      },
                      items: [
                        ...widget.controller.column3Values!.map((e) =>
                            DropdownButtonModel(
                                dropName: e.codeName!.getTitle,
                                dropValue: e.codeId))
                      ],
                      title: widget.controller.column3Title),
                const Divider(
                  height: 20,
                ),
                ...getLanguagesAsWidgets2(widget.controller.code.value.codeName!, FocusNode(), 
                            generalController.settings.where((element) => element.settingType == "LANG" && element.settingValue!.text == "1").map((e) => e.settingCode!).toList(),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor),
                        onPressed: () async {
                          await widget.controller.addUpdateCode();
                        },
                        child: Text(
                          "save".tr(),
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(color: Colors.white),
                        )),
                    ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(backgroundColor: redColor),
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
                )
              ],
            ),
          )
        ]),
      );
    });
  }
}
