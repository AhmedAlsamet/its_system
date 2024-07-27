import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/controllers/notification_controller.dart';
import 'package:its_system/core/widgets/nav_bar_icon.dart';
import 'package:its_system/models/notification_model.dart';
import 'package:its_system/models/user_model.dart';

class NotificationPageForMobile extends StatefulWidget {
  final bool withClose; 
  const NotificationPageForMobile({super.key,required this.withClose});

  @override
  State<NotificationPageForMobile> createState() => _NotificationPageForMobileState();
}

class _NotificationPageForMobileState extends State<NotificationPageForMobile> {

  @override
  Widget build(BuildContext context) {
    return GetX(
      init: NotificationController(true),
      tag: "true",
      builder: (controller) {
        return Scaffold(
            appBar: AppBar(
              flexibleSpace: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SafeArea(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      (widget.withClose) ? NavBarIcon(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    foregroundColor: Theme.of(context).primaryColor,
                    shadowColor: Theme.of(context).shadowColor,
                    icon: Icons.arrow_back,
                    iconEvent: () {
                      Get.back();
                    },
                  ):const SizedBox(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "notifications".tr(),
                          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      const SizedBox()
                    ],
                  ),
                ),
              ),
              // backgroundColor: headColor,
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),
            body: RefreshIndicator(
                onRefresh: ()async{
                  await controller.fetchAllNotifications();
                },
              child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ...controller.notifications.map((element) => NotificationCard(notification: element.value))
                  ]),
            ));
      }
    );
  }
}

// ignore: must_be_immutable
class NotificationCard extends StatelessWidget {
  NotificationModel notification;
  NotificationCard({super.key,required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              height: 50,
              decoration: BoxDecoration(
                color: notification.user!.userType == UserTypes.SUPER_ADMIN ? Theme.of(context).primaryColor : notification.user!.userType == UserTypes.CITIZEN ? Colors.orange : Colors.teal ,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(notification.user!.userType == UserTypes.SUPER_ADMIN ? "companyName".tr() 
                : notification.user!.userType == UserTypes.CITIZEN  ? "invitation".tr()
                : notification.user!.userType == UserTypes.ADMIN ? notification.institution!.institutionName!.getTitle
                : notification.user!.userName!.getTitle.substring(0,10) ,style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white),),
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(notification.notificationTitle!.getTitle,style: Theme.of(context).textTheme.displayLarge!.copyWith(fontWeight: FontWeight.bold),),
                        Text(notification.notificationDetails!.getTitle,style: Theme.of(context).textTheme.displayMedium,),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(notification.user!.userName!.getTitle,style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.blue),))
                      ],
                    ),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
