
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get_storage/get_storage.dart';
import 'package:its_system/controllers/general_controller.dart';
import 'package:its_system/core/models/menu.dart';
import 'package:its_system/core/utils/rive_utils.dart';
import 'package:its_system/pages/home/components/btm_nav_item.dart';
import 'package:its_system/pages/mobile/home_screen.dart';
import 'package:its_system/pages/mobile/notification.dart';
import 'package:its_system/pages/mobile/orders.dart';
import 'package:its_system/pages/mobile/setting.dart';



class HomeScreenForMoble extends StatefulWidget {
  const HomeScreenForMoble({super.key});

  @override
  State<HomeScreenForMoble> createState() => _HomeScreenForMobleState();
}

class _HomeScreenForMobleState extends State<HomeScreenForMoble>{
  late GeneralController controller;
  @override
  void initState() {
    super.initState();
    controller = Get.put(GeneralController());
    // Workmanager().registerPeriodicTask(
    //     "1",
    //     "periodic Notification",
    //     frequency: Duration(minutes: 15),
    //   );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return PopScope(
          canPop: false,
          child: Scaffold(
            // key: controller.scaffoldKey,
            extendBody: true,
            // floatingActionButton: FloatingActionButton(onPressed: (){}),
            resizeToAvoidBottomInset: false,
            backgroundColor: Theme.of(context).primaryColorLight,
            body:
            //  !controller.isConectedWithInternet.value ?
            // Center(
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         const Icon(Icons.cast_connected_outlined,size: 70,color: Colors.grey),
            //         Text("youAreNotConnected".tr(),style: Theme.of(context).textTheme.displayLarge!.copyWith(
            //           color: Colors.grey
            //         ),)
            //       ],
            //     ),
            //   ):
            controller.mainPageIndex.value == 0 || controller.mainPageIndex.value == 11 || controller.mainPageIndex.value == 12 || controller.mainPageIndex.value == 13
            ? MobileHomeScreen(controller:controller) : controller.mainPageIndex.value == 1? const OrdersForMobile():  controller.mainPageIndex.value == 3 ? const SettingPageForMobile() :  controller.mainPageIndex.value == 2 ? const NotificationPageForMobile(withClose: false,) :const SizedBox(),
            bottomNavigationBar: SafeArea(
              child: Container(
                padding:
                    const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      offset: const Offset(0, 10),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ...List.generate(
                      controller.bottomNavItems.length,
                      (index) {
                        Menu navBar = controller.bottomNavItems[index];
                        return Expanded(
                          child: BtmNavItem(
                            controller: controller,
                            showNotificationSign: controller.notificationController.lastNotification.value > controller.lastNotificationReserved.value,
                            navBar: navBar,
                            press: () async{
                              if(controller.entry != null && controller.isOverly.value) {
                                controller.entry!.remove();
                              }
                              controller.entry = null;
                              controller.isOverly.value = false;
                              if(navBar.index == 2 && controller.notificationController.lastNotification.value > controller.lastNotificationReserved.value){
                                controller.lastNotificationReserved.value =  controller.notificationController.lastNotification.value;
                                GetStorage().write("last_not", controller.lastNotificationReserved.value);
                              }
                              RiveUtils.chnageSMIBoolState(navBar.rive.status!,controller.selectedBottonNav.value.index == 3 ? null : controller.selectedBottonNav.value.rive.status!,navBar.index);
                              controller.selectedBottonNav.value = navBar;
                              controller.mainPageIndex.value = navBar.index;
                            },
                            riveOnInit: (artboard) {
                              navBar.rive.status = RiveUtils.getRiveInput(artboard,
                                  stateMachineName: navBar.rive.stateMachineName);
                            },
                            selectedNav: controller.selectedBottonNav.value,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
