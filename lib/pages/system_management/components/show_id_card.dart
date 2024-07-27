import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:its_system/controllers/controller_panel_controller.dart';
import 'package:its_system/core/utils/delete_dialog2.dart';
import 'package:its_system/core/widgets/input_field.dart';
import 'package:its_system/functions.dart';
import 'package:its_system/models/general_model.dart';
import 'package:its_system/models/notification_model.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/constants.dart';
import 'package:its_system/core/utils/snakbar_dialog.dart';
import 'package:its_system/models/user_model.dart';
import 'package:its_system/responsive.dart';
import 'package:its_system/statics_values.dart';

class ShowIdCard extends StatefulWidget {
  ShowIdCard({Key? key,required this.user, required this.controller}) : super(key: key);
  final UserModel user;
  final ControllerPanelController controller;
  @override
  State<ShowIdCard> createState() => _AddNewOrderBottomSheetState();
}

class _AddNewOrderBottomSheetState extends State<ShowIdCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
          width: Responsive.isDesktop(context) ? 700 : null,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10,),
                       Center(
                      child: Image.network(
                        StaticValue.serverPath! + widget.user.userIDCardPath!),
                    ),     
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: InputField(
                      maxLength: 100,
                      isRequired: false,
                      node: FocusNode(),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      readOnly: true,
                      controller:widget.user.userNote!,
                      hint: "anotherNotes".tr(),
                    ),
                  ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                        children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor
                ),
                icon: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                ),
                onPressed: () async{
                    await widget.controller.db.update(tableName: "users", primaryKey: "USR_ID", primaryKeyValue: widget.user.userId, items: {"USR_STATE": "ACTIVE"});
                    await widget.controller.fetchAllEmployees();
                },
                // Edit
                label: Text("confirm".tr(),style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white),),
              ),
              const SizedBox(
                width: 6,
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: redColor
                ),
                icon: const Icon(Icons.cancel_outlined,color: Colors.white,),
                onPressed: () async{
                  deleteMessageWithReason(title: "areYouSureFor".tr(), content: "refuseThisUser".tr(), onDelete: (value)async{
                    await reomoveImageRequest(widget.user.userIDCardPath!);
                    await widget.controller.db.update(tableName: "users", primaryKey: "USR_ID", primaryKeyValue: widget.user.userId, items: {"USR_ID_PATH":"","USR_NOTE":""});
                    int id = await widget.controller.db.createNew("notifications",NotificationModel(
                      institution: StaticValue.userData!.institution,
                      user: StaticValue.userData!,
                      notificationType: NotificationTypes.FOR_ALL,
                      notificationTitle: GeneralModel(
                        arabicTitle: TextEditingController(text: "تم رفض إثبات الهوية"),
                        englishTitle: TextEditingController(text: "تم رفض إثبات الهوية"),
                      ),
                      notificationDetails: GeneralModel(
                        arabicTitle: TextEditingController(text: value),
                        englishTitle: TextEditingController(text: value),
                      ),
                    ).toMap());
                    if(id>0){
                      await widget.controller.db.createNew('notfication_reservers',{"USR_ID" : widget.user.userId,"INST_ID":widget.user.institution!.institutionId,"NOT_TYPE" : "CITIZEN" ,"NOT_ID":id});
                      snakbarDialog(title: 'done'.tr(), content: 'theOperatorIsDoneSeccessfuly'.tr(), durationSecound: 3, color: blueColor,icon: const Icon(Icons.check_circle,color: Colors.white,size: 30,));
                    }
                    await widget.controller.fetchAllEmployees();
                    Get.back();
                  },deleteText: "refuse".tr(),
                  forNoteTitle: "refuseReason".tr(),
                  onCancel: (){Get.back();}, onWillPop: true);
                },
                // Delete
                label: Text("refuse".tr(),style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white),),
              ),
                        ],
                      ),
                       ],
              ),
            ),
          ),
        );
  }
}
