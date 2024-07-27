import 'package:get/get.dart' hide Trans;
import 'package:ionicons/ionicons.dart';
import 'package:its_system/pages/service/service_screen.dart';
import 'package:its_system/controllers/general_controller.dart';
import 'package:its_system/core/widgets/nav_bar_icon.dart';
import 'package:its_system/models/user_model.dart';
import 'package:its_system/pages/notification/notification_screen.dart';
import 'package:its_system/pages/settings/setting_screen.dart';
import 'package:its_system/pages/system_management/system_screen.dart';
import 'package:its_system/pages/user/user_screen.dart';
import 'package:its_system/pages/order/orders_screen.dart';
import 'package:its_system/responsive.dart';
import 'package:its_system/pages/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';

import 'components/side_menu.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: GeneralController(),
        builder: (controller) {
          return PopScope(
            canPop: false,
            child: Scaffold(
              key: controller.scaffoldKey,
              drawer: SideMenu(
                        showNotificationSign: controller.notificationController.lastNotification.value > controller.lastNotificationReserved.value,
              ),
              body: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // We want this side menu only for large screen
                  if (Responsive.isDesktop(context))
                    Expanded(
                      // default flex = 1
                      // and it takes 1/6 part of the screen
                      child: SideMenu(
                        showNotificationSign: controller.notificationController.lastNotification.value > controller.lastNotificationReserved.value,
                      ),
                    ),
                  Expanded(
                    // It takes 5/6 part of the screen
                    flex: 5,
                    child: Column(
                      children: [
                        AppBar(
                          backgroundColor: Theme.of(context).primaryColor,
                          flexibleSpace: SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (!Responsive.isDesktop(context))
                                    NavBarIcon(
                                      backgroundColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      foregroundColor:
                                          Theme.of(context).primaryColor,
                                      shadowColor:
                                          Theme.of(context).shadowColor,
                                      icon: Ionicons.menu_outline,
                                      iconEvent: () {
                                        controller.openDrawer();
                                      },
                                    ),
                                  if (Responsive.isDesktop(context))
                                    const SizedBox(),
                                  // for space between
                                  Center(
                                    child: Text(
                                      controller.appBarTitle.value,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(),
                                ],
                              ),
                            ),
                          ),
                          automaticallyImplyLeading: false,
                        ),
                        Expanded(
                          child: AnimatedSwitcher(
                              transitionBuilder: (child, animation) {
                                return ScaleTransition(
                                  scale: animation,
                                  child: child,
                                );
                                // return SlideTransition(position: animationOf,child: child,);
                              },
                              duration: const Duration(milliseconds: 100),
                              child:
                              // !controller.isConectedWithInternet.value ?
                              //   Center(
                              //       child: Column(
                              //         mainAxisAlignment: MainAxisAlignment.center,
                              //         children: [
                              //           Icon(Icons.cast_connected_outlined,size: 70,color: Colors.grey),
                              //           Text("youAreNotConnected".tr(),style: Theme.of(context).textTheme.displayLarge!.copyWith(
                              //             color: Colors.grey
                              //           ),)
                              //         ],
                              //       ),
                              //     ):
                               controller.mainPageIndex.value == 0
                                  ? const SystemManagementScreen()
                                  : controller.mainPageIndex.value == 1
                                  ? const ServiceManagementScreen()
                                  : controller.mainPageIndex.value == 2
                                  ? const DashboardScreen()
                                  : controller.mainPageIndex.value == 3
                                      ? UserScreen(debugLabel: "Emplyee",userType: UserTypes.ADMIN,)
                                  : controller.mainPageIndex.value == 4
                                      ? UserScreen(debugLabel: "Citizen",userType: UserTypes.CITIZEN,)
                                  : controller.mainPageIndex.value == 5
                                      ? const OrderScreen()
                                  : controller.mainPageIndex.value == 6
                                  ? const SettingScreen()
                                  : controller.mainPageIndex.value == 7
                                  ? const NotificationScreen()
                                      : const SizedBox()),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
