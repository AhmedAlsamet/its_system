import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:ionicons/ionicons.dart';
import 'package:its_system/constants.dart';
import 'package:its_system/controllers/general_controller.dart';
import 'package:its_system/controllers/notification_controller.dart';
import 'package:its_system/core/utils/get_languages.dart';
import 'package:its_system/core/widgets/bottom_sheet_handel.dart';
import 'package:its_system/core/widgets/input_field.dart';
import 'package:its_system/core/widgets/visitor_cart.dart';
import 'package:its_system/core/widgets/switch_list_widget.dart';
import 'package:its_system/models/user_model.dart';
import 'package:its_system/responsive.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/statics_values.dart';

class AddNewNotificationBottomSheet extends StatefulWidget {
  const AddNewNotificationBottomSheet({Key? key}) : super(key: key);

  @override
  State<AddNewNotificationBottomSheet> createState() =>
      _AddNewOrderBottomSheetState();
}

class _AddNewOrderBottomSheetState
    extends State<AddNewNotificationBottomSheet> {
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
        initialChildSize: Responsive.isDesktop(context) ? 1 : 0.8,
        maxChildSize: 1,
        minChildSize: 0.4,
        expand: Responsive.isDesktop(context) ? false : true,
        builder: (context, c) {
          return GetX<NotificationController>(
              init: NotificationController(false),
              builder: (value) {
                return Container(
                  color: Colors.transparent, //Theme.of(context).primaryColor,
                  width: Responsive.isDesktop(context) ? 500 : null,
                  child: Column(children: [
                    BottomSheetHandel(
                        cancelIcon: Ionicons.close,
                        cancelTooltip: "cancel".tr(),
                        saveIcon: Ionicons.save,
                        saveTooltip: "save".tr(),
                        controller: c,
                        onSave: () async {
                          if (value.formKey.currentState!.validate()) {
                            await value.addUpdateNotification();
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
                                    ...getLanguagesAsWidgets2(value.notification.value
                                          .notificationTitle!, nodes[0], 
                            generalController.settings.where((element) => element.settingType == "LANG" && element.settingValue!.text == "1").map((e) => e.settingCode!).toList(),
                            null,
                                           nodes[1]),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ...getLanguagesAsWidgets2(value.notification.value
                                          .notificationDetails!, nodes[1], 
                            generalController.settings.where((element) => element.settingType == "LANG" && element.settingValue!.text == "1").map((e) => e.settingCode!).toList(),
                            2,
                                           nodes[2]),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    if(!value.forAll.value)
                                      Wrap(
                                        children: [
                                          Text(
                                            "for".tr(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium,
                                          ),
                                          SizedBox(
                                            width: 130,
                                            child: RadioListTile(
                                                title: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    "citizens".tr(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displaySmall,
                                                  ),
                                                ),
                                                value: " 'CITIZEN'",
                                                groupValue:
                                                    value.searchType.value,
                                                onChanged: (v) {
                                                  value.searchType.value = v!;
                                                }),
                                          ),
                                          SizedBox(
                                            width: 170,
                                            child: RadioListTile(
                                                title: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    "employees".tr(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displaySmall,
                                                  ),
                                                ),
                                                value: "'ADMIN'",
                                                groupValue:
                                                    value.searchType.value,
                                                onChanged: (v) {
                                                  value.searchType.value = v!;
                                                }),
                                          ),
                                          if(StaticValue.userData!.userType == UserTypes.SUPER_ADMIN)
                                          SizedBox(
                                            width: 150,
                                            child: RadioListTile(
                                                title: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    "SUPER_ADMIN".tr(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displaySmall,
                                                  ),
                                                ),
                                                value: "'SUPER_ADMIN'",
                                                groupValue:
                                                    value.searchType.value,
                                                onChanged: (v) {
                                                  value.searchType.value = v!;
                                                }),
                                          ),
                                        ],
                                      ),
                                      if(!value.forAll.value)
                                        usersList(value),
                                      if(value.forAll.value)
                                        ...[
                                          if(StaticValue.userData!.userType == UserTypes.SUPER_ADMIN)
                                          SwitchListTileWidget(title: "allSuperAdmin".tr(), subTitle: "SendNotificationForAllSuperAdmin".tr(), value: value.forAllSuperAdmin.value, onChanged: (v){value.forAllSuperAdmin.value = v;}),
                                          SwitchListTileWidget(title: "allCitizens".tr(), subTitle: "SendNotificationForAllCitizens".tr(), value: value.forAllCitizens.value, onChanged: (v){value.forAllCitizens.value = v;}),
                                          SwitchListTileWidget(title: "allEmployees".tr(), subTitle: "SendNotificationForAllEmployees".tr(), value: value.forAllAdmins.value, onChanged: (v){value.forAllAdmins.value = v;}),
                                        ]
                                  ],
                                )),
                          ),
                        ),
                      ),
                    )
                  ]),
                );
              });
        });
  }

  Widget usersList(NotificationController controller) {
    return Obx(
      () {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              color: Theme.of(context).secondaryHeaderColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${"usersList".tr()} : ",
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: blueColor),
                    onPressed: () {
                      controller.notification.update((val) {
                        val!.notificationReservers!.add(UserModel().initialize());
                      });
                    },
                    label: Text(
                      "add".tr(),
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(color: Colors.white),
                    ),
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            // const Divider(color: headColor,thickness: 2),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: AppBar().preferredSize.height,
              ),
              child: Table(
                border: TableBorder.all(color: Theme.of(context).dividerColor),
                columnWidths: const {
                  0: FlexColumnWidth(2.5),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(0.8),
                },
                children: [
                  TableRow(
                      decoration: BoxDecoration(
                          color: Theme.of(context)
                              .secondaryHeaderColor
                              .withOpacity(0.5)),
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.all(5.0),
                        //   child: Center(
                        //     child: FittedBox(
                        //       child: Text(
                        //         "المستخدم",
                        //         style: Theme.of(context)
                        //             .textTheme
                        //             .labelLarge!
                        //             .copyWith(fontWeight: FontWeight.bold),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Center(
                            child: FittedBox(
                              child: Text(
                                "uniuqeKey".tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(5.0),
                        //   child: Center(
                        //     child: FittedBox(
                        //       child: Text(
                        //         "مع العائلة",
                        //         style: Theme.of(context)
                        //             .textTheme
                        //             .labelLarge!
                        //             .copyWith(fontWeight: FontWeight.bold),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Center(
                            child: FittedBox(
                              child: Text(
                                "delete".tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ]),
                  ...controller.notification.value.notificationReservers!.asMap().entries.map((s) {
                    return TableRow(children: [
                      // Focus(
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(top: 8.0),
                      //     child: FittedBox(
                      //       fit: BoxFit.scaleDown,
                      //       child: PopupMenuButton<bool>(
                      //         enabled: s.value.userId != 0,
                      //         child: Row(
                      //           mainAxisSize: MainAxisSize.min,
                      //           children: [
                      //             Text(
                      //               s.value.userGender!
                      //                   ? "citizen".tr()
                      //                   : "employee".tr(),
                      //               style: Theme.of(context)
                      //                   .textTheme
                      //                   .displaySmall!
                      //                   .copyWith(fontWeight: FontWeight.bold),
                      //             ),
                      //             const Icon(Icons.arrow_drop_down)
                      //           ],
                      //       ),
                      //       onSelected: (v) async {
                      //         controller.notification.update((val) {
                      //           val!.notificationReservers![s.key].userGender = v;
                      //         });
                      //       },
                      //       itemBuilder: (context) {
                      //         return [
                      //           PopupMenuItem(
                      //                 value: true,
                      //                 child: Text(
                      //                   "citizen".tr(),
                      //                   style: Theme.of(context)
                      //                       .textTheme
                      //                       .displaySmall!
                      //                       .copyWith(fontWeight: FontWeight.bold),
                      //                 )),
                      //             PopupMenuItem(
                      //                 value: false,
                      //                 child: Text(
                      //                   "employee".tr(),
                      //                   style: Theme.of(context)
                      //                       .textTheme
                      //                       .displaySmall!
                      //                       .copyWith(fontWeight: FontWeight.bold),
                      //                 )),
                      //           ];
                      //         },
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      s.value.userId == 0
                          ? InputField(
                              hint: "uniuqeKey".tr(),
                              withBorder: false,
                              isRequired: true,
                              node: FocusNode(),
                              keyboardType: TextInputType.text,
                              controller: s.value.userNumber!,
                              onFieldSubmitted: (v)async{
                                await controller.getAllUsersDialog(s.key);
                              },
                            )
                          : VisitorCart(
                              orderorcode: s.value.userUniqueKey!.text,
                              orderorImage: s.value.userImage!,
                              orderorName: s.value.userName!.getTitle,
                            ),
                      //       (s.value.userType == UserTypes.CITIZEN)?
                      // Checkbox(value: s.value.userLedName!.text == "FAMILY", onChanged: (v){
                      //       controller.notification.update((val) {
                      //       if(v!){
                      //           val!.notificationReservers![s.key].userLedName!.text == "FAMILY";
                      //       }else{
                      //           val!.notificationReservers![s.key].userLedName!.text == "";
                      //       }
                      //     });
                      // }) : const SizedBox(),
                      IconButton(
                          onPressed: () {
                            controller.notification.update((val) {
                              val!.notificationReservers!.removeAt(s.key);
                            });
                          },
                          icon: const Icon(
                            Ionicons.close_circle,
                            color: redColor,
                          ))
                    ]);
                  })
                ],
              ),
            ),
          ],
        );
      }
    );
  }
}
