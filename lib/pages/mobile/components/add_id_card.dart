import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get_storage/get_storage.dart';
import 'package:its_system/controllers/general_controller.dart';
import 'package:its_system/core/widgets/circle_button.dart';
import 'package:its_system/core/widgets/input_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/constants.dart';
import 'package:its_system/controllers/user_controller.dart';
import 'package:its_system/core/utils/snakbar_dialog.dart';
import 'package:its_system/helper/open_camera_gallery.dart';
import 'package:its_system/models/user_model.dart';
import 'package:its_system/responsive.dart';
import 'package:its_system/statics_values.dart';

class AddIdCard extends StatefulWidget {

  AddIdCard({Key? key}) : super(key: key);

  @override
  State<AddIdCard> createState() => _AddNewOrderBottomSheetState();
}

class _AddNewOrderBottomSheetState extends State<AddIdCard> {
  late UserController controller;
  late GeneralController generalController;
  @override
  void initState() {
    super.initState();
    generalController = Get.put(GeneralController());
    controller = Get.put(UserController(UserTypes.CITIZEN, false));
    controller.user = UserModel().copyWith(user: StaticValue.userData).obs;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return SizedBox(
          width: Responsive.isDesktop(context) ? 500 : null,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10,),
                (controller.user.value.userIDCardImage!.path == '')
                  ? Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Text(
                          "IDCard".tr(),
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                        ),
                        CircleButton(
                iconSize: 30,
                onPressed:
                  () async {
                      String path = await openGallery();
                      controller.user.update((val) {
                        val!.userIDCardImage = File(path);
                      });
                },
                icon: Icons.storage_outlined),
            CircleButton(
                iconSize: 30,
                onPressed:
                () async {
                  String path = await openCamera();
                  controller.user.update((val) {
                    val!.userIDCardImage = File(path);
                  });
                },
                icon: Icons.camera_outlined),
                      ],
                    )
                  : Center(
                    child: CircleButton(
                        iconSize: 30,
                        onPressed: () {
                        controller.user.update((val) {
                          val!.userIDCardImage = File("");
                        });
                        },
                    icon: Icons.cancel),
                  ),                  
                const SizedBox(
                  width: 10,
                ),
                InputField(
                  maxLength: 100,
                  isRequired: false,
                  node: FocusNode(),
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  controller:controller.user.value.userNote!,
                  hint: "anotherNotes".tr(),
                ),
                const SizedBox(
                  width: 10,
                ),
                              Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor),
                    onPressed: () async {
                      if(controller.user.value.userIDCardImage!.path == ""){
                        snakbarDialog(title: "errorTitle".tr(), content: "youMustChooseIDCard".tr(), durationSecound: 10);
                        return;
                      }
                        controller.isEdit = true;
                        await controller.addUpdateEmployee();
                        StaticValue.userData!.userIDCardPath = controller.user.value.userIDCardPath;
                        generalController.imageIdPath.value = StaticValue.userData!.userIDCardPath!;
                        if(GetStorage().read("user")!= null){
                          await GetStorage().write("user",StaticValue.userData!.toMapForSave());
                        }
                    },
                    child: Text(
                      "send".tr(),
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
          ),
        );
      }
    );
  }
}
