

 import 'package:flutter/material.dart';
import 'package:its_system/controllers/service_controller.dart';
import 'package:its_system/core/widgets/popup_menu.dart';
import 'package:its_system/helper/open_dialog_bottom_sheet.dart';
import 'package:its_system/models/service_model.dart';
import 'package:its_system/pages/service/components/add_update_service.dart';
import 'package:its_system/pages/service/service_branch_screen.dart';
import 'package:its_system/pages/service/service_forms_screen.dart';
import 'package:its_system/pages/service/service_guide_screen.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

Container serviceActions(BuildContext context, ServiceController controller,ServiceModel service,int index) {
    return Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle
                        ),
                        // padding: const EdgeInsets.symmetric(horizontal:50),
                        child:  PopupMenuButton(
                          surfaceTintColor: Colors.transparent,
                        icon: Icon(
                          Icons.more_vert,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        onSelected: (v) async{
                          if(v==0){
                              await controller.refreshService();
                              controller.isEdit = true;
                              controller.service.value = ServiceModel().copyWith(service:service);
                              controller.service.value.serviceName!.arabicHint = "serviceName".tr();
                              controller.service.value.serviceName!.englishHint = "serviceName".tr();
                              controller.service.value.serviceDescription!.arabicHint = "serviceDesc".tr();
                              controller.service.value.serviceDescription!.englishHint = "serviceDesc".tr();
                              await openDialogOrBottomSheet(const AddNewServiceBottomSheet());
                          }
                          if(v==1){
                            openDialogOrNewRoute(ServiceGuideScreen(controller: controller, index: index),true);
                          }
                          if(v==2){
                            openDialogOrNewRoute(ServiceBranchScreen(controller: controller, index: index),true);
                          }
                          if(v==3){
                            controller.fetchAllFormFields(index);
                            openDialogOrNewRoute(ServiceFormScreen(controller: controller, index: index),true);
                          }
                          // if(v==1){
                            // await deleteMessage2(
                            //   deleteButton: service.userState! == States.BLOCKED ? "unblock".tr() : "block".tr(),
                            //   title: "confirm".tr(), content: "${"areYouSureFor".tr()} ${service.userState! == States.BLOCKED ? "unblock".tr() : "block".tr()} ${service.userName!.getTitle}", onDelete: ()async{
                            //     await controller.db.update(tableName: "users", primaryKey: "USR_ID", primaryKeyValue: service.userId, items: {"USR_STATE": service.userState! == States.BLOCKED ? "ACTIVE" : "BLOCKED"});
                            //     Get.back();
                            //     await controller.fetchAllEmployees();
                            // }, onCancel: (){Get.back();}, onWillPop: true);
                          // }
                          if(v == 2){
                            //  await deleteMessage2(
                            //   title: "confirm".tr(), content: "${"areYouSureFor".tr()} ${"delete".tr()} ${userType != UserTypes.CITIZEN ? "deleteEmployee".tr() : "deleteCitizen".tr()} ${service.userName!.getTitle}", onDelete: ()async{
                            //     await controller.db.update(tableName: "users", primaryKey: "USR_ID", primaryKeyValue: service.userId, items: {"USR_STATE": "DELETED"});
                            //     Get.back();
                            //     await controller.fetchAllEmployees();
                            // }, onCancel: (){Get.back();}, onWillPop: true);
                          }
                          if(v==4){
                              // showDialog(
                              //   context: context,
                              //   builder: (context) {
                              //     return ReportSettingDialog(
                              //       index: 1,
                              //       user: service,
                              //       forVisit: false,
                              //       userType: UserTypes.ADMIN,
                              //     );
                              //   });
                          }
                          if(v==5){
                              // showDialog(
                              // context: context,
                              // builder: (context) {
                              //   return ReportSettingDialog(
                              //     index: 2,
                              //     forVisit: false,
                              //     user: service,
                              //     userType: UserTypes.CITIZEN,
                              //   );
                              // });
                          }
                          if(v==6){
                          // showDialog(
                          //   context: context,
                          //   builder: (context) {
                          //     return ReportSettingDialog(
                          //       index: 3,
                          //       forVisit: false,
                          //       user: service,
                          //       userType: UserTypes.CITIZEN,
                          //     );
                          //   });
                          }
                        },
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              value: 0,
                              child: MyPopupMenuItem(
                                icon: Icons.edit,
                                text: "editData".tr(),
                              ),
                            ),
                            PopupMenuItem(
                              value: 1,
                              child: MyPopupMenuItem(
                                icon: Icons.info_outline,
                                text: "infoSteps".tr(),
                              ),
                            ),
                            PopupMenuItem(
                              value: 2,
                              child: MyPopupMenuItem(
                                icon: Icons.broadcast_on_personal_outlined,
                                text: "breanches".tr(),
                              ),
                            ),
                            PopupMenuItem(
                              value: 3,
                              child: MyPopupMenuItem(
                                icon: Icons.format_shapes_outlined,
                                text: "serviceRequirements".tr(),
                              ),
                            ),
                            
                          ];
                        },
                      ),
                                          );
  }
