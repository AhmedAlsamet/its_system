
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:its_system/constants.dart';
import 'package:its_system/controllers/general_controller.dart';
import 'package:its_system/controllers/notification_controller.dart';
import 'package:its_system/core/models/button_model.dart';
import 'package:its_system/core/utils/date_picker.dart';
import 'package:its_system/core/utils/delete_dialog2.dart';
import 'package:its_system/core/widgets/button_bar_widget.dart';
import 'package:its_system/core/widgets/input_field.dart';
import 'package:its_system/core/widgets/popup_menu.dart';
import 'package:its_system/core/widgets/search_box.dart';
import 'package:its_system/helper/excel.dart';
import 'package:its_system/helper/open_dialog_bottom_sheet.dart';
import 'package:get/get.dart' hide Trans;
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/pages/notification/components/add_update_notification.dart';
import 'package:its_system/responsive.dart';

// import 'package:restaurant/Model/restaurantCategory.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // final List<ModelCategory> _courses = categories.Categorys();
  // double screenHight = 0;
  // double screenwidth = 0;

  late GeneralController generalController;
  late NotificationController controller;

  @override
  void initState() {
    super.initState();
    generalController = Get.put(GeneralController());
    controller = Get.put( NotificationController(false));
  }

    

   toggleOverlay(){
    if(generalController.isOverly.value){
      generalController.entry!.remove();
    }
    else{
      final overlay = Overlay.of(context);
      // final renderBox = context.findRenderObject() as RenderBox;
      // final size = renderBox.size;

      generalController. entry = OverlayEntry(builder: (context)=>Positioned(
        left: Responsive.isMobile(context) ? 3: 20,
        right: Responsive.isMobile(context) ? 3: null,
        top: 100,
        child: buildOverly()));
      
      overlay.insert(generalController. entry!);
    }
    generalController.isOverly.value= !generalController.isOverly.value;
  }

  @override
  void dispose() {
    super.dispose();
    if(generalController.isOverly.value) {
      generalController. entry!.remove();
    }
  }

  Widget buildOverly() => Card(
    shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(20)),
      color: Theme.of(context).cardColor,
    child: Container(
      decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(20)
      ),
      padding: const EdgeInsets.all(15),
          width: Responsive.isDesktop(context) ? 500 : Responsive.size(context).width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                      decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(20)
      ),
                padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 15),
                child: Text("searchFilter".tr(),style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.white),)),
              const Divider(height: 30,),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  "createdDateForm".tr(),
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                    width: 130,
                    child: Card(
                      elevation: 5,
                      color: Theme.of(context).cardColor,
                      child: ListTile(
                        onTap: () async {
                          toggleOverlay();
                          final newDate = await selectDate(
                              context: context,
                              firesDate: DateTime(2020),
                              lastDate: DateTime.now());
                          controller.fromDate.value = newDate;
                          toggleOverlay();
                        },
                        title: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                              DateFormat('yyyy-MM-dd')
                                  .format(controller.fromDate.value),
                              style: Theme.of(context).textTheme.displaySmall!),
                        ),
                      ),
                    )),
                Text(
                  "${"to".tr()} :",
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 130,
                  child: Card(
                    elevation: 5,
                    color: Theme.of(context).cardColor,
                    child: ListTile(
                      onTap: () async {
toggleOverlay();
                        final newDate = await selectDate(
                            context: context,
                            firesDate: DateTime(2020),
                            lastDate: DateTime.now());
                        controller.toDate.value = newDate;
                        toggleOverlay();
                      },
                      title: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                            DateFormat('yyyy-MM-dd')
                                .format(controller.toDate.value),
                            style: Theme.of(context).textTheme.displaySmall!),
                      ),
                    ),
                  ),
                ),
              ],
            ),
              const Divider(height: 30,),
                Row(
          mainAxisSize: MainAxisSize.min,
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
                toggleOverlay();
                await controller.fetchAllNotifications();
              },
              // Edit
              label: Text("ok".tr(),style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white),),
            ),
            const SizedBox(
              width: 6,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: redColor
              ),
              icon: const Icon(Icons.cancel_outlined,color: Colors.white,),
              onPressed: () {
                toggleOverlay();
              },
              // Delete
              label: Text("cancel".tr(),style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white),),
            ),
          ],
                ),
          ]),
        ),
  );

  @override
  Widget build(BuildContext context) {
    return Obx(
         () {
          return GestureDetector(
            onTap: generalController.isOverly.value ? () {
              toggleOverlay();
            }:null,
            child: Scaffold(
              body: Column(
                children: [
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Flexible(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child:  SearchBox(
                                node: controller.searchNode,
                                controller: controller.searchController,
                                onChanged: (v){
                                },
                                onStart: (){
                                },
                                onEnd: (){
                                },
                                onFilter: (){

                                  toggleOverlay();
                                },
                                onSubmitted: (v)async{
                                  await controller.fetchAllNotifications();
                                  if(controller.searchController.text.trim() != "") {
                                    controller.searchNode.requestFocus();
                                  }
                                },
                                searchTitle:  "${"searchFor".tr()} ${"notification".tr()}",
                              ),
                            ),
                          ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  ButtonBarWidget(
                              isMain: false,
                              allButtons: [
                                ButtonModel(foregroundColor: Colors.white,
                                    backgroundColor:  Theme.of(context).primaryColor,
                                    title: "newMultiNotification".tr(),
                                    onPressed: ()async{
                                      if(generalController.isOverly.value) {
                                        toggleOverlay();
                                      }
                                          await controller.refreshNotification();
                                          controller.isEdit = false;
                                          controller.forAll.value = true;
                                          await openDialogOrBottomSheet(AddNewNotificationBottomSheet());
                                    },
                                    icon: Iconsax.people),
                                ButtonModel(foregroundColor:   Colors.white,
                                    backgroundColor: Colors.brown,
                                    title:"newSingleNotification".tr(),
                                    onPressed: ()async{
                                      if(generalController.isOverly.value) {
                                        toggleOverlay();
                                      }
                                        await controller.refreshNotification();
                                        controller.isEdit = false;
                                        controller.forAll.value = false;
                                        await openDialogOrBottomSheet(AddNewNotificationBottomSheet());
                                    },
                                    icon: Ionicons.person_outline),
                                ButtonModel(foregroundColor: Colors.white,
                                    backgroundColor:  Colors.green,
                                    title: "exportToExcel".tr(),
                                    onPressed: ()async{
                                      if(generalController.isOverly.value) {
                                        toggleOverlay();
                                      }
                                      await exportToExcel("notifications-data.xlsx", [
                                        [
                                          "notifcationCreator".tr(),
                                          "notificationTitle".tr(),
                                          "notificationDetails".tr(),
                                          "createdDate".tr(),
                                          "notifiactionType".tr(),
                                        ],
                                        ...controller.notifications.map((u) => [
                                        u.value.user!.userName!.getTitle,
                                        u.value.notificationTitle!.getTitle,
                                        u.value.notificationDetails!.getTitle,
                                        u.value.notificationTitle!.createDate!,
                                        u.value.notificationType!.name.tr(),
                                      ]).toList()]);
                                    },
                                    icon: Iconsax.export),
                                // ButtonModel(foregroundColor: Colors.white,
                                //     backgroundColor:  Colors.green,
                                //     title: "إستيراد من إكسل",
                                //     onPressed: ()async{
                                //       if(generalController.isOverly.value) {
                                //         toggleOverlay();
                                //       }
                                //       await showDialog(
                                //         context: Get.overlayContext!,
                                //         builder: (context) {
                                //           return ImportExcelDialog(
                                //             excelName: "employees-sample-data.xlsx",
                                //               onImport: (List<Map<String,dynamic>> data)async{
                                //                                                                 await controller.db.createMulti("notifications", data.map((e) {
                                //                   e["INST_ID"] = StaticValue.userData!.institution!.institutionId!;
                                //                   return e;
                                //                 }).toList());
                                //               },
                                //               isTablet: MediaQuery.of(context).size.width > 600,
                                //               dataDetails: [
                                //                 DataDetails(number: "A", title: "${"employeeName.tr()"} بالعربية", columnName: "USR_NAME", dataType: "نص", allowValues: []),
                                //                 DataDetails(number: "B", title: "${"employeeName.tr()"} بالإنجليزية", columnName: "USR_NAME_EN", dataType: "نص", allowValues: []),
                                //                 DataDetails(number: "C", title: "رقم الهاتف", columnName: "USR_PHONE", dataType: "نص", allowValues: []),
                                //                 DataDetails(number: "D", title: "emailAddress".tr(), columnName: "USR_E_MAIL", dataType: "نص", allowValues: []),
                                //                 DataDetails(number: "E", title: "تاريخ التسجيل", columnName: "USR_REGISTER_DATE", dataType: "تاريخ", allowValues: []),
                                //                 DataDetails(number: "F", title: "نوع الموظف", columnName: "USR_TYPE", dataType: "نص", allowValues: ["ADMIN","SECURITY"]),
                                //               ]);
                                //         });
                                //     },
                                //     icon: Iconsax.import)
                              ], ),
                  const SizedBox(height: 10,),
                  const Divider(),
                  Expanded(
                    child: Container(
                      color: Theme.of(context).primaryColorLight,
                      child: ListView(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Table(
                              border: TableBorder.all(
                                  color: Theme.of(context).dividerColor),
                              columnWidths: const {
                                0: FlexColumnWidth(1),
                                1: FlexColumnWidth(3),
                                2: FlexColumnWidth(2),
                                3: FlexColumnWidth(1.2),
                                4: FlexColumnWidth(1.5),
                                5: FlexColumnWidth(1.5),
                                6: FlexColumnWidth(2),
                              },
                              children: [
                                TableRow(
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Center(
                                          child: FittedBox(
                                            child: Text(
                                               "employeeName".tr(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge!
                                                  .copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Center(
                                          child: FittedBox(
                                            child: Text(
                                               "notificationTitle".tr(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge!
                                                  .copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Center(
                                          child: FittedBox(
                                            child: Text(
                                              "notificationDetails".tr(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge!
                                                  .copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Center(
                                          child: FittedBox(
                                            child: Text(
                                              "createdDate".tr(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge!
                                                  .copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Padding(
                                      //   padding: const EdgeInsets.all(10),
                                      //   child: Center(
                                      //     child: FittedBox(
                                      //       child: Text(
                                      //         "notifiactionType".tr(),
                                      //         style: Theme.of(context)
                                      //             .textTheme
                                      //             .labelLarge!
                                      //             .copyWith(
                                      //                 fontWeight: FontWeight.bold,
                                      //                 color: Colors.white),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Center(
                                          child: Text(
                                            "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge!
                                                .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ]),
                                ...controller.notifications.asMap().entries.map((s) {
                                  return TableRow(
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor),
                                      children: [
                                        InputField(
                                          withBorder: false,
                                          isRequired: true,
                                          node: FocusNode(),
                                          keyboardType: TextInputType.number,
                                          controller:s.value.value.user!.userName!.getTitleAsFaild,
                                          isNumber: true,
                                          readOnly: true,
                                        ),
                                        InputField(
                                          withBorder: false,
                                          isRequired: true,
                                          node: FocusNode(),
                                          keyboardType: TextInputType.number,
                                          controller: s.value.value.notificationTitle!.getTitleAsFaild,
                                          isNumber: true,
                                          readOnly: true,
                                        ),
                                        // Center(
                                        //   child: Text(,
                                        //     style: Theme.of(context)
                                        //         .textTheme
                                        //         .labelLarge!
                                        //         .copyWith(
                                        //             color: Colors.black,
                                        //             fontWeight: FontWeight.bold),
                                        //   ),
                                        // ),
                                        InputField(
                                          withBorder: false,
                                          isRequired: true,
                                          node: FocusNode(),
                                          keyboardType: TextInputType.number,
                                          controller: s.value.value.notificationDetails!.getTitleAsFaild,
                                          isNumber: true,
                                          readOnly: true,
                                        ),
                                        InputField(
                                          withBorder: false,
                                          isRequired: true,
                                          node: FocusNode(),
                                          keyboardType: TextInputType.number,
                                          controller: TextEditingController(text: DateFormat("yyyy-MM-dd HH:mm").format(s.value.value.notificationTitle!.createDate!)),
                                          isNumber: true,
                                          readOnly: true,
                                        ),
                                        // InputField(
                                        //   withBorder: false,
                                        //   isRequired: true,
                                        //   node: FocusNode(),
                                        //   keyboardType: TextInputType.number,
                                        //   controller: TextEditingController(text: s.value.value.notificationType!.name),
                                        //   isNumber: true,
                                        //   readOnly: true,
                                        // ),
                                        Container(
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
                          deleteMessage2(
                            deleteButton: "delete".tr(),
                            title: "areYouSureFor".tr(), content: "removeThisNotification".tr(), onDelete: ()async{
                              await controller.db.delete(tableName: "notfication_reservers", where: "NOT_ID = ${s.value.value.notificationId}");
                              await controller.db.delete(tableName: "notifications",where: "NOT_ID =  ${s.value.value.notificationId}");
                              await controller.fetchAllNotifications();
                              Get.back();
                          }, onCancel: (){Get.back();}, onWillPop: true);
                            // await controller.refreshNotification();
                            // controller.isEdit = true;
                            // controller.notification.value = NotificationModel().copyWith(notification:s.value.value);
                            // controller.notification.value.notificationTitle!.arabicHint = "notificationTitle".tr();
                            // controller.notification.value.notificationTitle!.kurdishHint = "notificationTitle".tr();
                            // controller.notification.value.notificationTitle!.englishHint = "notificationTitle".tr();
                            // controller.notification.value.notificationDetails!.arabicHint = "notificationDetails".tr();
                            // controller.notification.value.notificationDetails!.kurdishHint = "notificationDetails".tr();
                            // controller.notification.value.notificationDetails!.englishHint = "notificationDetails".tr();
                            // await openDialogOrBottomSheet(AddNewNotificationBottomSheet());
                        }
                        if(v==1 || v==2){
                          
                        }
                        if(v == 3){
                          
                        }
                        if(v==4){
                          
                        }
                        if(v==5){
            
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            value: 0,
                            child: MyPopupMenuItem(
                              icon: Icons.delete,
                              text: "delete".tr(),
                            ),
                          ),
                        ];
                      },
                    ),
                                        )
                                      ]);
                                })
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          );
        });
  }
}
