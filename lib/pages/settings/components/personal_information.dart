
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get_storage/get_storage.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/constants.dart';
import 'package:its_system/controllers/user_controller.dart';
import 'package:its_system/core/utils/snakbar_dialog.dart';
import 'package:its_system/core/widgets/input_field.dart';
import 'package:its_system/models/user_model.dart';
import 'package:its_system/responsive.dart';
import 'package:its_system/statics_values.dart';

// ignore: must_be_immutable
class PersonInformation extends StatefulWidget {
  final bool justEditPassword;
  const PersonInformation({Key? key,required this.justEditPassword}) : super(key: key);

  @override
  State<PersonInformation> createState() => _PersonInformationState();
}

class _PersonInformationState extends State<PersonInformation> {
  TextEditingController newPasswordController = TextEditingController();
  late UserController controller;
  @override
  void initState() {
    super.initState();
    controller = Get.put(UserController(UserTypes.CITIZEN, false));
    controller.user = UserModel().copyWith(user: StaticValue.userData).obs;
    if(StaticValue.userData!.userType == UserTypes.SUPER_ADMIN){
      controller.user.value.institution!.institutionId = 0;
    }
    if(widget.justEditPassword){
      controller.user.value.userPassword!.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).cardColor,
        ),
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.all(12),
        width: Responsive.isDesktop(context) ? 300 : null,
        child: Form(
          key: controller.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: Text(
                  widget.justEditPassword ? "changePassword".tr():"changePersonalInf".tr(),
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if(!widget.justEditPassword)...[
                InputField(
                controller: controller.user.value.userName!.getTitleAsFaild,
                keyboardType: TextInputType.text,
                isRequired: true,
                node: FocusNode(),
                label: "name".tr(),
              ),
              const SizedBox(
                height: 10,
              ),
              InputField(
                controller: controller.user.value.userEMail!,
                keyboardType: TextInputType.emailAddress,
                isRequired: true,
                node: FocusNode(),
                label: "emailAddress".tr(),
                additionsalCondection: !EmailValidator.validate(controller.user.value.userEMail!.text,true),
                textForErrorMessage: "wrongValue".tr(),
              ),
              const SizedBox(
                height: 10,
              ),
              InputField(
                controller: controller.user.value.userPhoneNumber!,
                keyboardType: TextInputType.text,
                isRequired: true,
                node: FocusNode(),
                label: "${"phone".tr()} *",
              ),
              const SizedBox(
                height: 10,
              ),
              ],
              if(widget.justEditPassword)...[
                  InputField(
                    obscureText: true,
                    isRequired: true,
                    node: FocusNode(),
                    keyboardType: TextInputType.number,
                    controller: newPasswordController,
                    label: "newPassword".tr(),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  InputField(
                    obscureText: true,
                    isRequired: true,
                    node: FocusNode(),
                    keyboardType: TextInputType.number,
                    controller: controller.user.value.userPassword!,
                    label: "repetPassword".tr(),
                  ),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor),
                      onPressed: () async {
                        if(controller.formKey.currentState!.validate()){
                          if(widget.justEditPassword){
                              if(newPasswordController.text == controller.user.value.userPassword!.text){
                                  controller.isEdit = true;
                                  await controller.addUpdateEmployee();
                                  StaticValue.userData = controller.user.value;
                              }
                              else{
                                snakbarDialog(title: "thisPasswordsIsNotEqual".tr(), content: "thisPasswordsIsNotEqualPleaseTryAgain".tr(), durationSecound: 5, color: redColor, icon: const Icon(Icons.cancel,color: Colors.white, size: 30,));
                              }
                          }
                          else{
                            controller.isEdit = true;
                            await controller.addUpdateEmployee();
                            StaticValue.userData = controller.user.value;
                          }
                          StaticValue.userData = controller.user.value;
                            if(GetStorage().read("its_user")!= null){
                              // await GetStorage().remove("user");
                              await GetStorage().write("its_user",StaticValue.userData!.toMapForSave());
                            }
                        }
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
        ),
      );
    });
  }
}


