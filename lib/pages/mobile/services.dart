import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:its_system/constants.dart';
import 'package:its_system/controllers/home_controller.dart';
import 'package:its_system/core/widgets/popup_menu.dart';
import 'package:its_system/models/institution_model.dart';
import 'package:its_system/models/service_model.dart';
import 'package:its_system/models/user_model.dart';
import 'package:its_system/pages/mobile/components/institution_action.dart';
import 'package:its_system/pages/mobile/service_screen.dart';
import 'package:its_system/statics_values.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/core/widgets/nav_bar_icon.dart';

class ServicePageForMobile extends StatefulWidget {
  final InstitutionModel institution;
  const ServicePageForMobile({super.key, required this.institution});

  @override
  State<ServicePageForMobile> createState() => _ServicePageForMobileState();
}

class _ServicePageForMobileState extends State<ServicePageForMobile> {
  @override
  Widget build(BuildContext context) {
    return GetX(
        init: HomeController(),
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
                        NavBarIcon(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          foregroundColor: Theme.of(context).primaryColor,
                          shadowColor: Theme.of(context).shadowColor,
                          icon: Icons.arrow_back,
                          iconEvent: () {
                            Get.back();
                          },
                        ),
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "${"services".tr()} (${widget.institution.institutionName!.getTitle})",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                            ),
                          ),
                        ),
                        InstitutionActions(institution: widget.institution)
                      ],
                    ),
                  ),
                ),
                // backgroundColor: headColor,
                centerTitle: true,
                automaticallyImplyLeading: false,
              ),
              body: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ...controller.services.map((element) => ServiceCard(
                          service: element.value,
                          institution: widget.institution,
                          controller: controller,
                        ))
                  ]));
        });
  }
}

// ignore: must_be_immutable
class ServiceCard extends StatefulWidget {
  final InstitutionModel institution;
  final ServiceModel service;
  HomeController controller;
  ServiceCard(
      {super.key,
      required this.service,
      required this.institution,
      required this.controller});

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
        title: Text(
          widget.service.serviceName!.getTitle,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        subtitle: Text(
          widget.service.serviceDescription!.getTitle,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        trailing: serviceAction(),
        leading: Container(
          width: 80,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: randomColors[int.parse(widget
                  .service.serviceGroup!.serviceGroupId
                  .toString()
                  .split("")
                  .last)],
              borderRadius: BorderRadius.circular(20)),
          child: FittedBox(
            child: Text(
              widget.service.serviceGroup!.serviceGroupName!.getTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget serviceAction() {
    return Container(
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: PopupMenuButton(
        surfaceTintColor: Colors.transparent,
        icon: Icon(
          Icons.more_vert,
          color: Theme.of(context).iconTheme.color,
        ),
        onSelected: (v) async {
            await widget.controller.fetchServiceDetaisl(widget.service);
              widget.controller.servicePage.value = 0;
                            if(StaticValue.userData!.userType != UserTypes.GUEST && widget.controller.service.value.serviceForms!.isNotEmpty)
                            {widget.controller.servicePage.value = v;}
                            if(widget.controller.service.value.servicePlaces!.isNotEmpty)
                            {widget.controller.servicePage.value = v;}
                            if(widget.controller.service.value.serviceGuides!.isNotEmpty)
                            {widget.controller.servicePage.value = v;}
            Get.to(()=>ServiceScreen(
              institution: widget.institution,
              title: widget.service.serviceName!.getTitle,
            ));
        },
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              value: 0,
              child: MyPopupMenuItem(
                icon: Icons.info_outline,
                text: "infoSteps".tr(),
              ),
            ),
            PopupMenuItem(
              value: 1,
              child: MyPopupMenuItem(
                icon: Icons.broadcast_on_personal_outlined,
                text: "breanches".tr(),
              ),
            ),
            if(StaticValue.userData!.userType != UserTypes.GUEST)
            PopupMenuItem(
              value: 2,
              child: MyPopupMenuItem(
                icon: Icons.format_shapes_outlined,
                text: "serviceOrder".tr(),
              ),
            ),
          ];
        },
      ),
    );
  }
}
