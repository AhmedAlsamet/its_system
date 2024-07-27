// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';
import 'package:its_system/controllers/general_controller.dart';
import 'package:its_system/controllers/service_controller.dart';
import 'package:its_system/core/models/button_model.dart';
import 'package:its_system/core/utils/import_excel_dialog.dart';
import 'package:its_system/core/widgets/bottom_sheet_handel.dart';
import 'package:its_system/core/widgets/button_bar_widget.dart';
import 'package:its_system/core/widgets/circle_icon.dart';
import 'package:its_system/helper/excel.dart';
import 'package:its_system/models/service_model.dart';
import 'package:its_system/pages/service/components/add_update_service_guide.dart';
import 'package:its_system/responsive.dart';
import 'package:its_system/statics_values.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

// import 'package:restaurant/Model/restaurantCategory.dart';

class ServiceGuideScreen extends StatefulWidget {
  final ServiceController controller;
  final int index;

  const ServiceGuideScreen({Key? key, required this.controller, required this.index}) : super(key: key);

  @override
  State<ServiceGuideScreen> createState() => _ServiceGuideScreenState();
}

class _ServiceGuideScreenState extends State<ServiceGuideScreen> {
  late GeneralController generalController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generalController = Get.put(GeneralController());
  }


  @override
  Widget build(BuildContext context) {

    return Obx(
         () {
          return Container(
                    color:Colors.transparent, //Theme.of(context).primaryColor,
                    width: Responsive.isDesktop(context) ? 500 : null,
            child: Scaffold(
              backgroundColor:  Colors.transparent,
              body: Column(
                children: [
                      BottomSheetHandel(
                          cancelIcon: Ionicons.close,
                          cancelTooltip: "cancel".tr(),
                          saveIcon: Ionicons.arrow_forward,
                          saveTooltip: "back".tr(),
                          controller: ScrollController(),
                          onSave: Get.back,
                          onCancel: Get.back),
                const SizedBox(height: 10,),
                ButtonBarWidget(
                  isMain: false,
                  allButtons: [
                          ButtonModel(foregroundColor: Colors.white,
                                    backgroundColor:  Theme.of(context).primaryColor,
                                    title:  "addServiceGuide".tr(),
                                    onPressed: ()async{
                                          widget.controller.refreshServiceGuide(widget.index,0);
                                          widget.controller.isEdit = false;
                                          showDialog(context: context, builder: (context)=>Dialog(child: AddUpdateServiceGuide(index: widget.index),));
                                    },
                                    icon: Iconsax.add_circle),
                                 ButtonModel(foregroundColor: Colors.white,
                                    backgroundColor:  Colors.green,
                                    title: "exportToExcelFile".tr(),
                                    onPressed: ()async{
                                      await exportToExcel("services-data.xlsx", [
                                        [
                                        "id".tr(),
                                        "serviceName".tr(),
                                        "serviceDesc".tr(),
                                        "servicePrice".tr(),
                                        "serviceTime".tr(),
                                        "serviceType".tr(),
                                        ],
                                        ...widget.controller.services.map((u) => [
                                        u.value.serviceId,
                                        u.value.serviceName!.getTitle,
                                        u.value.serviceDescription!.getTitle,
                                        u.value.serviceHasStaticValue! ? u.value.servicePrice!.text :"unSelelected".tr(),
                                        u.value.serviceTime!.text,
                                        u.value.serviceType!.name.tr()
                                      ]).toList()]);
                                    },
                                    icon: Iconsax.export),
                                ButtonModel(foregroundColor: Colors.white,
                                    backgroundColor:  Colors.green,
                                    title: "importFromExcelFile".tr(),
                                    onPressed: ()async{
                                      await showDialog(
                                        context: Get.overlayContext!,
                                        builder: (context) {
                                          return ImportExcelDialog(
                                            excelName: "employees-sample-data.xlsx",
                                              onImport: (List<Map<String,dynamic>> data)async{
                                                await widget.controller.db.createMulti("services", data.map((e) {
                                                  e["INST_ID"] = StaticValue.userData!.institution!.institutionId!;
                                                  e["SRV_STATE"] = 1;
                                                  e["SRV_HAS_STATIC_PRICE"] = e["SRV_PRICE"].toString()!="0"? true:false;
                                                  return e;
                                                }).toList());
                                                Get.back();
                                              },
                                              isTablet: MediaQuery.of(context).size.width > 600,
                                              dataDetails: [
                                                DataDetails(number: "A", title: "serviceNumber".tr(), columnName: "SRV_NUMBER", dataType: "رقم", allowValues: []),
                                                DataDetails(number: "B", title: "serviceName".tr(), columnName: "SRV_NAME", dataType: "نص", allowValues: []),
                                                DataDetails(number: "C", title: "serviceDesc".tr(), columnName: "SRV_DESCRIPTION", dataType: "نص", allowValues: []),
                                                DataDetails(number: "D", title: "serviceType".tr(), columnName: "SRV_TYPE", dataType: "نص", allowValues: ["NEW","RENEWAL"]),
                                                DataDetails(number: "E", title: "servicePrice".tr(), columnName: "SRV_PRICE", dataType: "رقم", allowValues: []),
                                                DataDetails(number: "F", title: "serviceTime".tr(), columnName: "SRV_TIME", dataType: "رقم", allowValues: []),
                                                DataDetails(number: "G", title:"serviceGroup".tr(), columnName: "SRVG_ID", dataType: "رقم", allowValues: []),
                                              ]);
                                        });
                                    
                                    },
                                    icon: Iconsax.import)
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).primaryColorLight,
                    child: ListView(
                      children: [
                          servicesList(context),
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

  Container servicesList(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            ...widget.controller.serviceGuides
                .where((s) =>
                    s.value.serviceGuideMainId == 0 &&
                    s.value.service!.serviceId ==
                        widget.controller.services[widget.index].value.serviceId)
                .toList()
                .asMap()
                .entries
                .map((s) {
                  return ExpansionTile(title: serviceGuideItem(s.value.value),children: [
                                ...widget.controller.serviceGuides
                .where((ss) =>
                    ss.value.serviceGuideMainId == s.value.value.serviceGuideId &&
                    ss.value.service!.serviceId ==
                        widget.controller.services[widget.index].value.serviceId)
                .toList()
                .asMap()
                .entries
                .map((s) {
                  return Container(
                    margin: const EdgeInsets.only(right: 16),
                    child: serviceGuideItem(s.value.value));
                }),
                const SizedBox(height: 5,),
                ElevatedButton.icon(
                  onPressed: ()async{
                  widget.controller.refreshServiceGuide(widget.index,s.value.value.serviceGuideId!);
                  widget.controller.isEdit = false;
                  showDialog(context: context, builder: (context)=>Dialog(child: AddUpdateServiceGuide(index: widget.index),));
                }, icon: const Icon(Icons.add), label: Text("add".tr(),style: Theme.of(context).textTheme.displaySmall,)),
                const SizedBox(height: 5,),
                  ],);
                })
          ],
        ));
  }

  Widget serviceGuideItem(ServiceGuideModel service){
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text(service.serviceGuideName!.getTitle,style: Theme.of(context).textTheme.displaySmall,),
          trailing: circleIcon(onTap: (){
              widget.controller.refreshServiceGuide(widget.index,service.serviceGuideMainId!);
              widget.controller.isEdit = true;
              widget.controller.serviceGuide.value = ServiceGuideModel().copyWith(serviceGuides: service);
              showDialog(context: context, builder: (context)=>Dialog(child: AddUpdateServiceGuide(index: widget.index),));
          }, icon: const Icon(Icons.edit,color: Colors.white,), backgroundColor: Theme.of(context).primaryColor),
        ),
      ),
    );
  }
}
