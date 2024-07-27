import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/controllers/user_controller.dart';
import 'package:its_system/models/user_model.dart';
import 'package:its_system/pages/user/user_screen.dart';

Widget employeeDataForMobile(
  {required UserTypes userType,
    required UserModel user, required UserController controller, required BuildContext context}) {
  return Card(
    color: Theme.of(context).cardColor,
    child: ListTile(
        title: Text(
          user.userName!.getTitle,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        subtitle: Text(
          user.userType!.name.tr(),
          style: Theme.of(context).textTheme.labelLarge,
        ),
        trailing:userActions(context, controller, user,userType))

        // PopupMenuButton(
        //   surfaceTintColor: Colors.transparent,
        //   icon: Icon(
        //     Icons.more_vert,
        //     color: Theme.of(context).iconTheme.color,
        //   ),
        //   onSelected: (v) async {
        //     if (v == 0) {
        //       await controller.refreshEmployee();
        //       controller.isEdit = true;
        //       controller.user.value =
        //           UserModel().copyWith(user: user);
        //       await openDialogOrBottomSheet(AddNewUserBottomSheet(
        //         userType: userType,
        //       ));
        //     }
        //     if (v == 1) {
        //       await deleteMessage2(
        //           deleteButton: user.userState! == States.BLOCKED
        //               ? "unblock".tr()
        //               : "block".tr(),
        //           title: "confirm".tr(),
        //           content:
        //               "${"areYouSureFor".tr()} ${user.userState! == States.BLOCKED ? "unblock".tr() : "block".tr()} ${user.userName!.getTitle}",
        //           onDelete: () async {
        //             await controller.db.update(
        //                 tableName: "users",
        //                 primaryKey: "USR_ID",
        //                 primaryKeyValue: user.userId,
        //                 items: {
        //                   "USR_STATE":
        //                       user.userState! == States.BLOCKED
        //                           ? "ACTIVE"
        //                           : "BLOCKED"
        //                 });
        //             Get.back();
        //             await controller.fetchAllEmployees();
        //           },
        //           onCancel: () {
        //             Get.back();
        //           },
        //           onWillPop: true);
        //     }
        //     if (v == 2) {
        //       await deleteMessage2(
        //           title: "confirm".tr(),
        //           content:
        //               "${"areYouSureFor".tr()} حذف ${userType != UserTypes.CITIZEN ? "حذف الموظف" : "حذف المقيم"} ${user.userName!.getTitle}",
        //           onDelete: () async {
        //             await controller.db.update(
        //                 tableName: "users",
        //                 primaryKey: "USR_ID",
        //                 primaryKeyValue: user.userId,
        //                 items: {"USR_STATE": "DELETED"});
        //             Get.back();
        //             await controller.fetchAllEmployees();
        //           },
        //           onCancel: () {
        //             Get.back();
        //           },
        //           onWillPop: true);
        //     }
        //   },
        //   itemBuilder: (context) {
        //     return [
        //       PopupMenuItem(
        //         value: 0,
        //         child: MyPopupMenuItem(
        //           icon: Icons.edit,
        //           text: "editData".tr(),
        //         ),
        //       ),
        //       PopupMenuItem(
        //         value: 1,
        //         child: MyPopupMenuItem(
        //           icon: user.userState! == States.BLOCKED
        //               ? Icons.block
        //               : Icons.block,
        //           text: user.userState! == States.BLOCKED
        //               ? "unblock".tr()
        //               : "block".tr(),
        //         ),
        //       ),
        //       PopupMenuItem(
        //         value: 2,
        //         child: MyPopupMenuItem(
        //           icon: Ionicons.remove_circle,
        //           text: userType != UserTypes.CITIZEN
        //               ? "حذف الموظف"
        //               : "حذف المقيم",
        //         ),
        //       ),
        //     ];
        //   },
        // )),

);
}
