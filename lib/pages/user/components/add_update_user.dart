import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:ionicons/ionicons.dart';
import 'package:its_system/constants.dart';
import 'package:its_system/controllers/general_controller.dart';
import 'package:its_system/controllers/user_controller.dart';
import 'package:its_system/core/models/dropdown_button_model.dart';
import 'package:its_system/core/utils/delete_dialog2.dart';
import 'package:its_system/core/utils/get_languages.dart';
import 'package:its_system/core/widgets/bottom_sheet_handel.dart';
import 'package:its_system/core/widgets/circle_button.dart';
import 'package:its_system/core/widgets/dropdown_button.dart';
import 'package:its_system/core/widgets/input_field.dart';
import 'package:its_system/helper/open_camera_gallery.dart';
import 'package:its_system/models/state_enum.dart';
import 'package:its_system/models/user_model.dart';
import 'package:its_system/responsive.dart';
import 'package:localize_and_translate/localize_and_translate.dart';


class AddNewUserBottomSheet extends StatefulWidget {
  final UserTypes userType;
  const AddNewUserBottomSheet({Key? key,required this.userType})
      : super(key: key);

  @override
  State<AddNewUserBottomSheet> createState() =>
      _AddNewOrderBottomSheetState();
}

class _AddNewOrderBottomSheetState extends State<AddNewUserBottomSheet> {
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
    return DraggableScrollableSheet(
          initialChildSize: Responsive.isDesktop(context) ?1:0.8,
          maxChildSize: 1,
          minChildSize: 0.4,
          expand: Responsive.isDesktop(context) ?false:true,
      builder: (context,c) {
        return GetX<UserController>(
                    init: UserController(widget.userType),
                    tag: widget.userType.name.toString(),
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
                              await value.addUpdateEmployee();
                            }
                          },
                          onCancel: () {
                            Get.back(result: "Ahmed");
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
                                  child: ListView(
                                    children: [
                                       const SizedBox(
                                        height: 10,
                                      ),
                                      InputField(
                                        controller:
                                            value.user.value.userNumber!,
                                        keyboardType: TextInputType.text,
                                        isRequired: true,
                                        readOnly: value.isEdit,
                                        node: nodes[0],
                                        label: widget.userType != UserTypes.CITIZEN ? "${"employeeNumber".tr()} *" : "${"citizenNumber".tr()} *" ,
                                        onFieldSubmitted: (v) {
                                          nodes[1].requestFocus();
                                        },
                                        isNumber: true,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ...getLanguagesAsWidgets2(value.user.value.userName!, nodes[1], 
                            generalController.settings.where((element) => element.settingType == "LANG" && element.settingValue!.text == "1").map((e) => e.settingCode!).toList(),
                            null,
                                       nodes[2]),
                                      
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      InputField(
                                        controller:
                                            value.user.value.userEMail!,
                                        keyboardType: TextInputType.text,
                                        isRequired: false,
                                        node: nodes[2],
                                        // additionsalCondection: !EmailValidator.validate(value.user.value.userEMail!.text,true),
                                        // textForErrorMessage: "wrongValue".tr(),
                                        label: "emailAddress".tr(),
                                        onFieldSubmitted: (v) {
                                          nodes[3].requestFocus();
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      InputField(
                                        controller:
                                            value.user.value.userPhoneNumber!,
                                        keyboardType: TextInputType.text,
                                        isRequired: true,
                                        node: nodes[3],
                                        label: "${"phone".tr()} *",
                                        onFieldSubmitted: (v) {
                                          nodes[4].requestFocus();
                                        },
                                      ),
                                      
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      if(widget.userType == UserTypes.CITIZEN)...[
                                        InputField(
                                          maxLength: 100,
                                          isRequired: false,
                                          node: FocusNode(),
                                          keyboardType: TextInputType.text,
                                          controller:
                                              value.user.value.userAddress1!,
                                          hint: "address1Desc".tr(),
                                          label: "address1".tr(),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                       Row(
                                        children: [
                                          Text("gender".tr(),style: Theme.of(context).textTheme.displayMedium,),
                                          SizedBox(
                                            width: 130,
                                            child: RadioListTile(
                                              title: Text("male".tr(),style: Theme.of(context).textTheme.displaySmall,),
                                              value: true, groupValue: value.user.value.userGender,
                                              onChanged: (v){
                                                value.user.update((val) {
                                                  val!.userGender = v;
                                                });
                                              }),
                                          ),
                                          SizedBox(
                                            width: 130,
                                            child: RadioListTile(
                                              title: Text("fmale".tr(),style: Theme.of(context).textTheme.displaySmall,),
                                              value: false, groupValue: value.user.value.userGender,
                                              onChanged: (v){
                                                value.user.update((val) {
                                                  val!.userGender = v;
                                                });
                                              }),
                                          )
                                        ],
                                      ),
                                      ],
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      if(!value.isEdit)...[
                                         InputField(
                                              maxLength: 30,
                                              isRequired: true,
                                              node: nodes[6],
                                              obscureText: true,
                                              keyboardType: TextInputType.text,
                                              controller:
                                                  value.user.value.userPassword!,
                                              label: "${"password".tr()}*",
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            InputField(
                                              maxLength: 30,
                                              isRequired: true,
                                              node: nodes[7],
                                              obscureText: true,
                                              keyboardType: TextInputType.text,
                                              additionsalCondection: value.user.value.userPassword!.text != value.passwordController.text,
                                              textForErrorMessage: "",
                                              controller:
                                                  value.passwordController,
                                              label: "${"passwordAgain".tr()}*",
                                            ),
                                      ],
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      if(widget.userType == UserTypes.ADMIN)
                                      DropdownButtonWidget<UserTypes>(
                                        title: "accountType".tr(),
                                        node: nodes[4],
                                       items: [
                                        ...UserTypes.values.skip(3).map((e) {
                                          return DropdownButtonModel(
                                          dropName: e.name.tr(),
                                          dropValue: e,
                                          dropOrder: e.index
                                        );
                                        })
                                       ],
                                       selectedItem: value.user.value.userType!,
                                       onChanged: (v){
                                          value.user.update((val) {
                                            val!.userType = v;
                                          });
                                       },
                                       ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      DropdownButtonWidget<States>(
                                        title: "accountState".tr(),
                                        node: nodes[5],
                                       items: [
                                        ...States.values.take(3).map((e) => DropdownButtonModel(
                                          dropName: e.name.tr(),
                                          dropValue: e,
                                          dropOrder: e.index
                                        ))
                                       ],
                                       selectedItem: value.user.value.userState!,
                                       onChanged: (v){
                                          value.user.update((val) {
                                            val!.userState = v;
                                          });
                                       },
                                       ),
                                       const SizedBox(
                                        height: 10,
                                      ),
                                      (value.user.value.userImage!.path == '')
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
                                              value.user.update((val) {
                                                val!.userImage = File(path);
                                              });
                                        },
                                        icon: Icons.storage_outlined),
                                    CircleButton(

                                        iconSize: 30,
                                        onPressed:
                                        () async {
                                          String path = await openCamera();
                                          value.user.update((val) {
                                            val!.userImage = File(path);
                                          });
                                        },
                                        icon: Icons.camera_outlined),
                                              ],
                                            )
                                          : CircleButton(

                                              iconSize: 30,
                                              onPressed: () {
                                              value.user.update((val) {
                                                val!.userImage = File("");
                                              });
                                              },
                                          icon: Icons.cancel),
                                       const SizedBox(
                                        height: 10,
                                      ),

                                      if(value.isEdit)
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(backgroundColor: redColor),
                                        onPressed: (){
                                          deleteMessage2(
                                            title: "worry".tr(), content: "areYouSureAboutReSetPassword".tr(), onDelete: ()async{
                                            if(await value.db.update(tableName: 'users', primaryKey: 'USR_ID', primaryKeyValue: value.user.value.userId!, items: {"USR_PASSWORD":"1"}) > 0){
                                              value.user.value.userPassword!.text = "1";
                                              Get.back();
                                            }
                                          }, onCancel: (){Get.back();}, onWillPop: true,deleteButton: "reSet".tr());
                                      },
                                       child: Text("putZeroForPassword".tr(),style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white),))
                                      // Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom))
                                      // for save the keyboard position
                                    ],
                                  )),
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