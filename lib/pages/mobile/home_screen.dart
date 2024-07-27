import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:its_system/constants.dart';
import 'package:its_system/controllers/home_controller.dart';
import 'package:its_system/core/widgets/search_box.dart';
import 'package:its_system/models/institution_model.dart';
import 'package:its_system/models/state_enum.dart';
import 'package:its_system/models/user_model.dart';
import 'package:its_system/pages/mobile/components/add_id_card.dart';
import 'package:its_system/pages/mobile/services.dart';
import 'package:its_system/responsive.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/controllers/general_controller.dart';
import 'package:its_system/core/widgets/cash_image.dart';
import 'package:its_system/helper/open_dialog_bottom_sheet.dart';
import 'package:its_system/pages/settings/profile_screen.dart';
import 'package:its_system/statics_values.dart';

// ignore: must_be_immutable
class MobileHomeScreen extends StatefulWidget {
  GeneralController controller;
  MobileHomeScreen({super.key, required this.controller});

  @override
  State<MobileHomeScreen> createState() => _MobileHomeScreenState();
}

class _MobileHomeScreenState extends State<MobileHomeScreen> {
  late GeneralController generalController;
  late HomeController controller;
  @override
  void initState() {
    super.initState();
    generalController = Get.put(GeneralController());
    controller = Get.put(HomeController());
  }

  toggleOverlay() {
    if (generalController.isOverly.value) {
      generalController.entry!.remove();
    } else {
      final overlay = Overlay.of(context);
      // final renderBox = context.findRenderObject() as RenderBox;
      // final size = renderBox.size;

      generalController.entry = OverlayEntry(
          builder: (context) => Positioned(
              left: Responsive.isMobile(context) ? 3 : 20,
              right: Responsive.isMobile(context) ? 3 : null,
              top: 100,
              child: buildOverly()));

      overlay.insert(generalController.entry!);
    }
    generalController.isOverly.value = !generalController.isOverly.value;
  }

  Widget buildOverly() => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Theme.of(context).cardColor,
        child: Container(
          height: 400,
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.all(15),
          width: Responsive.isDesktop(context)
              ? 500
              : Responsive.size(context).width,
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(20)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  child: Text(
                    "searchFilter".tr(),
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(color: Colors.white),
                  )),
              const Divider(
                height: 30,
              ),
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
                  //       SizedBox(
                  //           width: 130,
                  //           child: Card(
                  //             elevation: 5,
                  //             color: Theme.of(context).cardColor,
                  //             child: ListTile(
                  //               onTap: () async {
                  // toggleOverlay();
                  //                 final newDate = await selectDate(
                  //                     context: context,
                  //                     firesDate: DateTime(2020),
                  //                     lastDate: DateTime.now());
                  //                 controller.fromDate.value = newDate;
                  // toggleOverlay();
                  //               },
                  //               title: FittedBox(
                  //         fit: BoxFit.scaleDown,
                  //                 child: Text(
                  //                     DateFormat('yyyy-MM-dd')
                  //                         .format(controller.fromDate.value),
                  //                     style: Theme.of(context).textTheme.displaySmall!),
                  //               ),
                  //             ),
                  //           )),

                  Text(
                    "${"to".tr()} :",
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  // SizedBox(
                  //   width: 130,
                  //   child: Card(
                  //     elevation: 5,
                  //     color: Theme.of(context).cardColor,
                  //     child: ListTile(
                  //       onTap: () async {
                  //         toggleOverlay();
                  //         final newDate = await selectDate(
                  //             context: context,
                  //             firesDate: DateTime(2020),
                  //             lastDate: DateTime.now());
                  //         controller.toDate.value = newDate;
                  //         toggleOverlay();

                  //       },
                  //       title: FittedBox(
                  //   fit: BoxFit.scaleDown,
                  //         child: Text(
                  //             DateFormat('yyyy-MM-dd')
                  //                 .format(controller.toDate.value),
                  //             style: Theme.of(context).textTheme.displaySmall!),
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  // Obx(
                  //    () {
                  //     return Column(
                  //       children: [
                  //         ExpansionTile(title: Text( widget.userType != UserTypes.CITIZEN ? "employeeType".tr():"citizenType".tr() ,style: Theme.of(context).textTheme.displayMedium),children: [
                  //           SizedBox(
                  //             height: 150,
                  //             child: SingleChildScrollView(
                  //               child: Column(children: [
                  //         RadioListTile(
                  //             title: Text("ALL".tr(),style: Theme.of(context).textTheme.displaySmall,),
                  //             value: "ALL", groupValue: controller.userTypeForFilter.value,
                  //           onChanged: (v){
                  //             controller.userTypeForFilter.value = v!;
                  //          },),
                  //          ...UserTypes.values.map((element) {
                  //           if(widget.userType == UserTypes.CITIZEN && (element == UserTypes.CITIZEN )) {
                  //             return RadioListTile(
                  //             title: Text(element.name.tr(),style: Theme.of(context).textTheme.displaySmall,),
                  //             value: element.name, groupValue: controller.userTypeForFilter.value,
                  //           onChanged: (v){
                  //             controller.userTypeForFilter.value = v!;
                  //          },);
                  //           }
                  //           if(widget.userType != UserTypes.CITIZEN && (element == UserTypes.ADMIN )) {
                  //             return RadioListTile(
                  //             title: Text(element.name.tr(),style: Theme.of(context).textTheme.displaySmall,),
                  //             value: element.name, groupValue: controller.userTypeForFilter.value,
                  //           onChanged: (v){
                  //             controller.userTypeForFilter.value = v!;
                  //          },);
                  //           }
                  //           return const SizedBox();
                  //          }),

                  //          ]),
                  //             ),
                  //           )
                  //         ],),
                  //         ExpansionTile(title: Text( "connectionState".tr() ,style: Theme.of(context).textTheme.displayMedium),children: [
                  //           SizedBox(
                  //             height: 150,
                  //             child: SingleChildScrollView(
                  //               child: Column(children: [
                  //         RadioListTile(
                  //             title: Text("ALL".tr(),style: Theme.of(context).textTheme.displaySmall,),
                  //             value: "ALL", groupValue: controller.connectingState.value,
                  //           onChanged: (v){
                  //             controller.connectingState.value = v!;
                  //          },),
                  //         RadioListTile(
                  //             title: Text("connected".tr(),style: Theme.of(context).textTheme.displaySmall,),
                  //             value: "connected", groupValue: controller.connectingState.value,
                  //           onChanged: (v){
                  //             controller.connectingState.value = v!;
                  //          },),
                  //         RadioListTile(
                  //             title: Text("unconnected".tr(),style: Theme.of(context).textTheme.displaySmall,),
                  //             value: "unconnected", groupValue: controller.connectingState.value,
                  //           onChanged: (v){
                  //             controller.connectingState.value = v!;
                  //          },),

                  //          ]),
                  //             ),
                  //           )
                  //         ],),
                  //       ],
                  //     );
                  //   }
                  // )
                ],
              ),
              const Divider(
                height: 30,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor),
                    icon: const Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      toggleOverlay();
                      // await controller.fetchAllEmployees();
                    },
                    // Edit
                    label: Text(
                      "ok".tr(),
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: redColor),
                    icon: const Icon(
                      Icons.cancel_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      toggleOverlay();
                    },
                    // Delete
                    label: Text(
                      "cancel".tr(),
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      );
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        onTap: generalController.isOverly.value
            ? () {
                toggleOverlay();
              }
            : null,
        child: PopScope(
          canPop: true,
          onPopInvoked: (v) {
            if (v && generalController.isOverly.value) {
              toggleOverlay();
            }
          },
          child: Scaffold(
              extendBody: true,
              resizeToAvoidBottomInset: false,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: SafeArea(
                child: Column(
                  children: [
                    userHeader(context),
                    const SizedBox(
                      height: 5,
                    ),
                    SearchBox(
                      controller: controller.searchController,
                      node: FocusNode(),
                      onChanged: (v) {},
                      showIcon: false,
                      onFilter: () async{
                        await controller.fetchAllInstitutions();
                      },
                      onEnd: () {},
                      onStart: () {},
                      onSubmitted: (v) async{
                        await controller.fetchAllInstitutions();
                      },
                      searchTitle: "search".tr(),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                            child: Column(
                      children: [
                        if (controller.institutions.isNotEmpty)
                          ...controller.institutions
                              .where((i) => i.value.institutionMainId == controller.institutions.first.value.institutionMainId)
                              .map((i) => institutionTreeCard(
                                  i.value,
                                  controller.institutions
                                      .map((i) => i.value)
                                      .toList(),5))
                      ],
                    )))
                  ],
                ),
              )),
        ),
      );
    });
  }

  Card userHeader(BuildContext context) {
    return Card(
                    color: Theme.of(context).cardColor,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                if (generalController.isOverly.value) {
                                  toggleOverlay();
                                }
                                openDialogOrNewRoute(UpdateProfile(
                                    controller: widget.controller));
                                // showDialog(context: context, builder: (context) {
                                //   return Dialog(child: UpdateProfile(controller:widget.controller));
                                // },);
                              },
                              child: Row(
                                children: [
                                  ImageWidget(
                                      imagePath:
                                          generalController.imagePath.value),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          FittedBox(
                                              child: Text(
                                            StaticValue
                                                .userData!.userName!.getTitle,
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayLarge,
                                          )),
                                          Row(
                                            children: [
                                              FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                      "${"uniuqeKey".tr()} : ",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .displaySmall)),
                                              Expanded(
                                                child: FittedBox(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                        StaticValue
                                                            .userData!
                                                            .userUniqueKey!
                                                            .text,
                                                        style: Theme.of(
                                                                context)
                                                            .textTheme
                                                            .displaySmall)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (StaticValue.userData!.userType !=
                              UserTypes.GUEST)
                            IconButton(
                                style: IconButton.styleFrom(
                                    disabledForegroundColor:
                                        StaticValue.userData!.userState ==
                                                States.INACTIVE
                                            ? Colors.black
                                            : blueColor),
                                tooltip: 
                                StaticValue.userData!.userState ==
                                            States.INACTIVE &&
                                        generalController.imageIdPath.value ==
                                            ""
                                    ? "yourIdintity".tr()
                                    : StaticValue.userData!.userState ==
                                            States.INACTIVE && generalController.imageIdPath.value !=
                                            ""
                                        ? "docomentYourAccountInProgress".tr()
                                        : "docomented".tr(),
                                onPressed: StaticValue.userData!.userState ==
                                            States.INACTIVE &&
                                        generalController.imageIdPath.value ==
                                            ""
                                    ? () {
                                        if (generalController
                                            .isOverly.value) {
                                          toggleOverlay();
                                        }
                                        showDialog(
                                            context: context,
                                            builder: (context) => Dialog(
                                                  child: AddIdCard(),
                                                ));
                                      }
                                    : null,
                                icon: Icon(
                                  StaticValue.userData!.userState ==
                                              States.INACTIVE &&
                                          generalController
                                                  .imageIdPath.value ==
                                              ""
                                      ? Icons.block_rounded
                                      : generalController.imageIdPath.value !=
                                              ""
                                          ? Icons
                                              .admin_panel_settings_outlined
                                          : Icons.check_circle,
                                  size: 28,
                                ))
                        ],
                      ),
                    ),
                  );
  }

  Widget institutionTreeCard(
      InstitutionModel institution, List<InstitutionModel> institutions,double padding) {
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(side: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.3)),borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.only(right: padding,top: 5),
      child: 
        institutions
              .where((i) => i.institutionMainId == institution.institutionId!).isEmpty?
              ListTile(
        leading: icon(institution),
                title: Text(
                          institution.institutionName!.getTitle,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
              ):
      ExpansionTile(
        title: Text(
          institution.institutionName!.getTitle,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        leading: icon(institution),
        children: [
          ...institutions
              .where((i) => i.institutionMainId == institution.institutionId!)
              .map((i) => institutionTreeCard(i, institutions,padding+5))
        ],
      ),
    );
  }
  Widget icon(InstitutionModel institution){
    return IconButton(onPressed: (){
      controller.fetchAllInstitutionServicesAndComplaintTypes(institution.institutionId!);
      Get.to(()=>ServicePageForMobile(institution: institution,));
    }, icon: Icon(Icons.open_in_new_outlined,color: Theme.of(context).primaryColor,));
  }
}
