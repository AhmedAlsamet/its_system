import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/constants.dart';
import 'package:its_system/controllers/user_controller.dart';
import 'package:its_system/core/utils/delete_dialog2.dart';
import 'package:its_system/helper/open_dialog_bottom_sheet.dart';
import 'package:its_system/models/state_enum.dart';
import 'package:its_system/models/user_model.dart';
import 'package:its_system/pages/user/components/add_update_user.dart';

DataRow employeeDataRow(UserModel user,UserController controller, BuildContext context) {
  return DataRow(
    cells: [
      DataCell(Text(user.userName!.getTitle,
                style: Theme.of(context).textTheme.displayMedium,
      )),
      DataCell(Text(user.userLastConnected!.add(const Duration(minutes: 5)).compareTo(DateTime.now()) > 0 ?"connected".tr():"unconnected".tr() .toString(),
                style: Theme.of(context).textTheme.displayMedium,
      )),
      DataCell(Text(user.userState!.name.tr(),
                style: Theme.of(context).textTheme.displayMedium,
      )),
      DataCell(
        Row(
          children: [
            if(user.userId != 1)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor
              ),
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () {
                controller.user.value = UserModel().copyWith(user: user);
                controller.user.value.userName!.arabicHint = "employeeName".tr();
                controller.user.value.userName!.englishHint = "employeeName".tr();
                controller.isEdit = true;
                openDialogOrBottomSheet(const AddNewUserBottomSheet(userType: UserTypes.SUPER_ADMIN,));
              },
              // Edit
              label: Text("edit".tr(),style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white),),
            ),
            const SizedBox(
              width: 6,
            ),
            if(user.userId != 1)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: redColor
              ),
              icon: const Icon(Icons.cancel_outlined,color: Colors.white,),
                onPressed: () async{
                  await deleteMessage2(
                    deleteButton: user.userState! == States.BLOCKED ? "unblock".tr() : "block".tr(),
                    title: "confirm".tr(), content: "${"areYouSureFor".tr()} ${user.userState! == States.BLOCKED ? "unblock".tr() : "block".tr()} ${user.userName!.getTitle}", onDelete: ()async{
                      await controller.db.update(tableName: "users", primaryKey: "USR_ID", primaryKeyValue: user.userId, items: {"USR_STATE": user.userState! == States.BLOCKED ? "ACTIVE" : "BLOCKED"});
                      Get.back();
                      await controller.fetchAllEmployees();
                  }, onCancel: (){Get.back();}, onWillPop: true);
              },
              // Delete
              label: Text(user.userState! == States.BLOCKED ? "unblock".tr() : "block".tr(),style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white),),
            ),
          ],
        ),
      ),
    ],
  );
}


Widget employeeDataForMobile(UserModel user,UserController controller, BuildContext context){
  return Card(
    color: Theme.of(context).cardColor,
    child: ListTile(
      title: Text(user.userName!.getTitle,style: Theme.of(context).textTheme.displaySmall,),
      subtitle: Text(user.userLastConnected!.toString(),style: Theme.of(context).textTheme.labelLarge,),
      trailing: user.userId == 1 ? null : Row(
        mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor
                ),
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                onPressed: () {
                  controller.user.value = UserModel().copyWith(user: user);
                  controller.isEdit = true;
                  openDialogOrBottomSheet(const AddNewUserBottomSheet(userType: UserTypes.SUPER_ADMIN,));
                },
                // Edit
                tooltip: "edit".tr(),
              ),
              const SizedBox(
                width: 6,
              ),
              IconButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: redColor
                ),
                icon: const Icon(Icons.cancel_outlined,color: Colors.white,),
                onPressed: () async{
                              await deleteMessage2(
                                deleteButton: user.userState! == States.BLOCKED ? "unblock".tr() : "block".tr(),
                                title: "confirm".tr(), content: "${"areYouSureFor".tr()} ${user.userState! == States.BLOCKED ? "unblock".tr() : "block".tr()} ${user.userName!.getTitle}", onDelete: ()async{
                                  await controller.db.update(tableName: "users", primaryKey: "USR_ID", primaryKeyValue: user.userId, items: {"USR_STATE": user.userState! == States.BLOCKED ? "ACTIVE" : "BLOCKED"});
                                  Get.back();
                                  await controller.fetchAllEmployees();
                              }, onCancel: (){Get.back();}, onWillPop: true);
                },
                // Delete
                tooltip: user.userState! == States.BLOCKED ? "unblock".tr() : "block".tr(),
              ),
            ],
          ),
      ),
  );
}
