// ignore_for_file: must_be_immutable

import 'package:get/get.dart' hide Trans;
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:its_system/core/utils/delete_dialog2.dart';
import 'package:its_system/core/utils/snakbar_dialog.dart';
import 'package:its_system/functions.dart';
import 'package:its_system/models/general_model.dart';
import 'package:its_system/models/notification_model.dart';
import 'package:its_system/pages/system_management/components/show_id_card.dart';
import 'package:its_system/statics_values.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/constants.dart';
import 'package:flutter/material.dart';
import 'package:its_system/controllers/controller_panel_controller.dart';
import 'package:its_system/core/widgets/cash_image.dart';
import 'package:its_system/models/user_model.dart';
import 'package:its_system/responsive.dart';

class RecentUsers extends StatelessWidget {
  List<UserModel> users;
  ControllerPanelController controller;
  RecentUsers({
    required this.users,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor ,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "regesterOrders".tr(),
            style: Theme.of(context).textTheme.displayLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
        const Divider(height: 20,),
          SingleChildScrollView(
            //scrollDirection: Axis.horizontal,
            child: 
            SizedBox(
              width: double.infinity,
              child:  
            Responsive.isMobile(context) ?  
            Column(
              children: users.map((u) => recentUserForMobile(u,controller, context)).toList()
            ):
              DataTable(
                horizontalMargin: 0,
                columnSpacing: 0,
                columns: [
                   DataColumn(
                    label: Text("citizenName".tr(),style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold),),
                  ),
                  //  DataColumn(
                  //   label: Text("phone".tr(),style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold),),
                  // ),
                   DataColumn(
                    label: Text("regesteredDate".tr(),style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold),),
                  ),
                   DataColumn(
                    label: Text("Operation".tr(),style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold),),
                  ),
                ],
                rows: users.map((u) => recentUserDataRow(u,controller, context)).toList()
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataRow recentUserDataRow(UserModel user,ControllerPanelController controller, BuildContext context) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            SizedBox(
              height: 70,
              width: 70,
              child: ImageWidget(imagePath: user.userImage!.path),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(
                user.userName!.getTitle,
                style: Theme.of(context).textTheme.displayMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      // DataCell(Container(
      //     padding: EdgeInsets.all(5),
      //     decoration: BoxDecoration(
      //       color: getRoleColor(userInfo.role).withOpacity(.2),
      //       border: Border.all(color: getRoleColor(userInfo.role)),
      //       borderRadius: BorderRadius.all(Radius.circular(5.0) //
      //           ),
      //     ),
      //     child: Text(userInfo.role!))),
      // DataCell(Text(user.userPhoneNumber!.text,
      //           style: Theme.of(context).textTheme.displayMedium,
      // )),
      DataCell(Text(DateFormat("yyyy-MM-dd").format(user.userName!.createDate!),
                style: Theme.of(context).textTheme.displayMedium,
      )),
      DataCell(
        Row(
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: blueColor
              ),
              icon: const Icon(
                Ionicons.eye_outline,
                color: Colors.white,
              ),
              onPressed: () async{
                showDialog(context: context, builder: (context)=>Dialog(child: ShowIdCard(user: user, controller: controller),));
              },
              // Edit
              label: Text("view".tr(),style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white),),
            ),
            const SizedBox(
              width: 6,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor
              ),
              icon: const Icon(
                Icons.check_circle_outline,
                color: Colors.white,
              ),
              onPressed: () async{
                  await controller.db.update(tableName: "users", primaryKey: "USR_ID", primaryKeyValue: user.userId, items: {"USR_STATE": "ACTIVE"});
                  await controller.fetchAllEmployees();
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
                  await reomoveImageRequest(user.userIDCardPath!);
                  await controller.db.update(tableName: "users", primaryKey: "USR_ID", primaryKeyValue: user.userId, items: {"USR_ID_PATH":"","USR_NOTE":""});
                  int id = await controller.db.createNew("notifications",NotificationModel(
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
                    await controller.db.createNew('notfication_reservers',{"USR_ID" : user.userId,"INST_ID":user.institution!.institutionId,"NOT_TYPE" : "CITIZEN" ,"NOT_ID":id});
                    snakbarDialog(title: 'done'.tr(), content: 'theOperatorIsDoneSeccessfuly'.tr(), durationSecound: 3, color: blueColor,icon: const Icon(Icons.check_circle,color: Colors.white,size: 30,));
                  }
                  await controller.fetchAllEmployees();
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
      ),
    ],
  );
}


Widget recentUserForMobile(UserModel user,ControllerPanelController controller, BuildContext context){
  return ListTile(
    title: Text(user.userName!.getTitle,style: Theme.of(context).textTheme.displaySmall,),
    subtitle: Text(user.userUniqueKey!.text,style: Theme.of(context).textTheme.labelLarge,),
    trailing: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
                    ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: blueColor
              ),
              icon: const Icon(
                Ionicons.eye_outline,
                color: Colors.white,
              ),
              onPressed: () async{
                showDialog(context: context, builder: (context)=>Dialog(child: ShowIdCard(user: user, controller: controller),));
              },
              // Edit
              label: Text("view".tr(),style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white),),
            ),
        // Expanded(
        //   child: ElevatedButton.icon(
        //             style: ElevatedButton.styleFrom(
        //               backgroundColor: Theme.of(context).primaryColor
        //             ),
        //             icon: const Icon(
        //               Icons.check_circle_outline,
        //               color: Colors.white,
        //             ),
        //             onPressed: () async{
        //                 await controller.db.update(tableName: "users", primaryKey: "USR_ID", primaryKeyValue: user.userId, items: {"USR_STATE": "ACTIVE"});
        //                 await controller.fetchAllEmployees();
        //             },
        //             // Edit
        //             label: Text("confirm".tr(),style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white),),
        //           ),
        // ),
        // Expanded(child:ElevatedButton.icon(
        //       style: ElevatedButton.styleFrom(
        //         backgroundColor: redColor
        //       ),
        //       icon: const Icon(Icons.cancel_outlined,color: Colors.white,),
        //       onPressed: () async{
        //           await controller.db.update(tableName: "users", primaryKey: "USR_ID", primaryKeyValue: user.userId, items: {"USR_STATE": "BLOCK"});
        //           await controller.fetchAllEmployees();
        //       },
        //       // Delete
        //       label: Text("block".tr(),style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white),),
        //     ),)
      ],
    ),
    );
}