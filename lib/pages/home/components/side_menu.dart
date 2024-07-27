// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get_storage/get_storage.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/constants.dart';
import 'package:its_system/controllers/general_controller.dart';
import 'package:its_system/core/utils/rive_utils.dart';
import 'package:its_system/core/utils/snakbar_dialog.dart';
import 'package:its_system/core/widgets/cash_image.dart';
import 'package:its_system/core/widgets/menu_item.dart';
import 'package:its_system/helper/open_dialog_bottom_sheet.dart';
import 'package:its_system/pages/mobile/notification.dart';
import 'package:its_system/pages/settings/profile_screen.dart';
import 'package:its_system/statics_values.dart';

class SideMenu extends StatefulWidget {
  bool showNotificationSign;
  SideMenu({
    Key? key,
    this.showNotificationSign = false
  }) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {

  @override
  Widget build(BuildContext context) {
      List<String> titles = [    
        "systemManagement".tr(),
        "servicesManagement".tr(),
        'controlPanel'.tr(),
        "employees".tr(),
        "citizens".tr(),
        "orders".tr(),
        "settings".tr(),
        "notifications".tr(),
     ];
    return Drawer(
      shape: BeveledRectangleBorder(borderRadius:translator.activeLanguageCode == "en" ? const BorderRadius.only(bottomRight: Radius.circular(30)) : const BorderRadius.only(bottomLeft: Radius.circular(30))),
      backgroundColor: Theme.of(context).primaryColor,
      child: GetX(
        init: GeneralController(),
        builder: (controller) {
          return SingleChildScrollView(
            // it enables scrolling
            child: Stack(
              children: [
                // Positioned(
                //   top: 5,
                //   left: 10,
                //   child: NavBarIcon(
                //   icon: Ionicons.notifications_outline,
                //   backgroundColor:Theme.of(context).primaryColorLight,
                //   foregroundColor: Theme.of(context).primaryColor,
                //   shadowColor: Theme.of(context).primaryColor)),
                // Positioned(
                //   top: 5,
                //   right: 10,
                //   child: NavBarIcon(
                //   icon: Ionicons.settings,
                //   backgroundColor:Theme.of(context).primaryColorLight,
                //   foregroundColor: Theme.of(context).primaryColor,
                //   shadowColor: Theme.of(context).primaryColor)),
                Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 150,
                      height: 150,
                      decoration:const BoxDecoration(
                        shape: BoxShape.circle
                      ),
                      child: const CircleAvatar(
                      // width: 150,
                      // decoration: const BoxDecoration(
                      //   color: Colors.white,
                      //   shape: BoxShape.circle
                      // ),
                      
                      minRadius: 100,
                      backgroundImage: AssetImage(
                      "assets/logo.png",
                    ),
                    ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: Theme.of(context).cardColor,
                      padding: const EdgeInsets.all(8),
                      child: Row(
                              children: [
                            ImageWidget(imagePath: controller.imagePath.value),
                      Expanded(
                        child: InkWell(
                          onTap: ()async{
                              openDialogOrNewRoute(UpdateProfile(controller:controller));
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FittedBox(child: Text(StaticValue.userData!.userName!.getTitle,style: Theme.of(context).textTheme.displayLarge,)),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                  child: Text("${"uniuqeKey".tr()} : ",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .displaySmall)),
                                            ),
                                            Expanded(flex: 2,
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                  child: Text(StaticValue.userData!.userUniqueKey!.text,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .displaySmall)),
                                            ),
                                          ],
                                        ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if(widget.showNotificationSign)
                            Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(shape: BoxShape.circle,color: redColor),),
                          IconButton(onPressed: ()async{
                            if(controller.notificationController.lastNotification.value > controller.lastNotificationReserved.value){
                              controller.lastNotificationReserved.value =  controller.notificationController.lastNotification.value;
                              await GetStorage().write("last_not", controller.lastNotificationReserved.value);
                            }
                            openDialogOrNewRoute(const NotificationPageForMobile(withClose: true,));
                          }, icon: Icon(Icons.notifications,color: Theme.of(context).primaryColor,)),
                        ],
                      )
                              ],
                            ),
                    ),
                      Divider(
                color: Theme.of(context).primaryColorLight,
                height: 20,
                      ),
                      ...controller.menuItems.map((item){
                        return MenuItem(
                          navBar: item,
                          press: () async{
                            // (item.index == 5 || item.index == 6)
                            if((item.index != 0 && item.index != 4 && item.index != 7) && StaticValue.userData!.institution!.institutionId==0){
                              snakbarDialog(title: "errorTitle".tr(), content: "youMustChooseCompoundInTheBeging".tr(), durationSecound:  8,color: blueColor);
                              return;
                            }
                            await controller.changePage(item.index);
                            RiveUtils.chnageSMIBoolState(item.rive.status!,controller.selecteditem.value.rive.status!,item.index);
                            controller.updateSelectedItem(item);
                            controller.appBarTitle.value = titles[item.index];
                            // await exportToExcel("new-excel.xlsx", [[1,2,3],[11,22,33]]);
                            // print(await readFromExcel(["col1","col2","col3"], {}));
                          },
                          riveOnInit: (artboard) {
                            item.rive.status = RiveUtils.getRiveInput(artboard,
                                stateMachineName: item.rive.stateMachineName);
                          },
                          selectedNav: controller.selecteditem.value,
                        );
                      },)
                  ],
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}