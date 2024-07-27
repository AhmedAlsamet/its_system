// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';
import 'package:its_system/constants.dart';
import 'package:its_system/controllers/general_controller.dart';
import 'package:its_system/controllers/service_controller.dart';
import 'package:its_system/core/models/button_model.dart';
import 'package:its_system/core/reports/service_report.dart';
import 'package:its_system/core/utils/import_excel_dialog.dart';
import 'package:its_system/core/widgets/button_bar_widget.dart';
import 'package:its_system/core/widgets/input_field.dart';
import 'package:its_system/core/widgets/search_box.dart';
import 'package:its_system/core/widgets/setting_item.dart';
import 'package:its_system/helper/excel.dart';
import 'package:its_system/helper/open_dialog_bottom_sheet.dart';
import 'package:its_system/models/service_model.dart';
import 'package:its_system/pages/report_page.dart';
import 'package:its_system/pages/service/components/add_update_service.dart';
import 'package:its_system/pages/service/components/service_actions.dart';
import 'package:its_system/pages/system_management/components/codes.dart';
import 'package:its_system/statics_values.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/responsive.dart';
import 'package:pdf/pdf.dart';

// import 'package:restaurant/Model/restaurantCategory.dart';

class ServiceManagementScreen extends StatefulWidget {
  const ServiceManagementScreen({Key? key}) : super(key: key);

  @override
  State<ServiceManagementScreen> createState() => _ServiceManagementScreenState();
}

class _ServiceManagementScreenState extends State<ServiceManagementScreen> {
 late GeneralController generalController;
//  late ControllerPanelController  controllerPanelController;
 late ServiceController controller;

  @override
  void initState() {
    super.initState();
    generalController = Get.put(GeneralController());
    // controllerPanelController = Get.put(ControllerPanelController());
    controller = Get.put(ServiceController(true));
  }

    

   toggleOverlay(){
    if(generalController.isOverly.value){
      generalController.entry!.remove();
    }
    else{
      final overlay = Overlay.of(context);
      // final renderBox = context.findRenderObject() as RenderBox;
      // final size = renderBox.size;

      generalController.entry = OverlayEntry(builder: (context)=>Positioned(
        left: Responsive.isMobile(context) ? 3: 20,
        right: Responsive.isMobile(context) ? 3: null,
        top: 100,
        child: buildOverly(context)));
      
      overlay.insert(generalController.entry!);
    }
    generalController.isOverly.value= !generalController.isOverly.value;
  }


  Widget buildOverly(context) => Card(
    shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(20)),
      color: Theme.of(context).cardColor,
    child: Container(
      height: 400,
      decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(20)
      ),
      padding: const EdgeInsets.all(15),
          width: Responsive.isDesktop(context) ? 500 : Responsive.size(context).width,
          child: SingleChildScrollView(
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
                  Obx(
                     () {
                      return Column(
                        children: [
                          ExpansionTile(title: Text( "serviceState".tr() ,style: Theme.of(context).textTheme.displayMedium),children: [
                            SizedBox(
                              height: 150,
                              child: SingleChildScrollView(
                                child: Column(children: [
                                            RadioListTile(
                              title: Text("ALL".tr(),style: Theme.of(context).textTheme.displaySmall,),
                              value: "ALL", groupValue: controller.orderState.value,                  
                            onChanged: (v){
                              controller.orderState.value = v!;
                           },),
                                            RadioListTile(
                              title: Text("successed".tr(),style: Theme.of(context).textTheme.displaySmall,),
                              value: "DONE", groupValue: controller.orderState.value,                  
                            onChanged: (v){
                              controller.orderState.value = v!;
                           },),
                                            RadioListTile(
                              title: Text("blocked".tr(),style: Theme.of(context).textTheme.displaySmall,),
                              value: "BLOCK", groupValue: controller.orderState.value,                  
                            onChanged: (v){
                              controller.orderState.value = v!;
                           },),
                                          
                           ]),
                              ),
                            )
                          ],),
                        
                        ],
                      );
                    }
                  )
                  
                  // DropdownButtonWidget(
                  //   node: FocusNode(),
                  //  items: [
                  //   ...controller.exceptionTypes.map((element) => DropdownButtonModel(
                  //     dropName: element.value.exceptionTypeName!.getTitle,
                  //     dropOrder: 0,
                  //     dropValue: element.value
                  //   )),
                  //  ], 
                  //  selectedItem: controller.exceptionType.value,
                  //  onChanged: (v){
                  //     controller.exceptionType.value = v!;
                  //  },
                  //  title: "exceptionType".tr())
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
                  await controller.fetchAll();
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
                  settingItem(
                    icon: Ionicons.code,
                    title: "serviceGroups".tr(),
                    subtitle:
                        "enterServiceGroup".tr(),
                    iconBackground: Colors.redAccent,
                    onTap: () async{
                      await openDialogOrBottomSheet(CodesBottomSheet(
                        columnPrefix: "SRVG",
                        table: "service_groups", column1: "SRVG_ID", column2: "SRVG_NAME",column3: "INST_ID",column3Val: StaticValue.userData!.institution!.institutionId!.toString(),));
                    }),
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
                                showIcon: false,
                                onFilter: ()async{
                                  await controller.fetchAll();
                                  // toggleOverlay();
                                },
                                onSubmitted: (v)async{
                                  await controller.fetchAll();
                                  if(controller.searchController.text.trim() != "") {
                                    controller.searchNode.requestFocus();
                                  }
                                },
                                searchTitle:"${"searchFor".tr()} ${"service".tr()}",
                              ),
                            ),
                          ),
                    ],
                  ),
                const SizedBox(
                  height: 10,
                ),
                // Card(
                //   color: Theme.of(context).primaryColorLight,
                //   child: ExpansionTile(title: Text("الإحصائيات",style: Theme.of(context).textTheme.displayMedium!),children: [statistics(context)],)),
                const Divider(),
                const SizedBox(height: 10,),
                ButtonBarWidget(
                  isMain: false,
                  allButtons: [
                    if(controller.serviceGroups.isNotEmpty)
                          ButtonModel(foregroundColor: Colors.white,
                                    backgroundColor:  Theme.of(context).primaryColor,
                                    title:  "addService".tr(),
                                    onPressed: ()async{
                                      if(generalController.isOverly.value) {
                                        toggleOverlay();
                                      }
                                          controller.refreshService();
                                          controller.isEdit = false;
                                          await openDialogOrBottomSheet(const AddNewServiceBottomSheet());
                                    },
                                    icon: Iconsax.add_circle),
                                ButtonModel(foregroundColor:   Colors.white,
                                    backgroundColor: Colors.brown,
                                    title:"printService".tr(),
                                    onPressed: ()async{
                                      if(generalController.isOverly.value) {
                                        toggleOverlay();
                                      }
                                       Get.to(()=>ReportPage(
                               exportExcel: ()async{
                                       await exportToExcel("services-data.xlsx", [
                                        [
                                        "id".tr(),
                                        "serviceName".tr(),
                                        "serviceDesc".tr(),
                                        "servicePrice".tr(),
                                        "serviceTime".tr(),
                                        "serviceType".tr(),
                                        ],
                                        ...controller.services.map((u) => [
                                        u.value.serviceId,
                                        u.value.serviceName!.getTitle,
                                        u.value.serviceDescription!.getTitle,
                                        u.value.serviceHasStaticValue! ? u.value.servicePrice!.text :"unSelelected".tr(),
                                        u.value.serviceTime!.text,
                                        u.value.serviceType!.name.tr()
                                      ]).toList()]);
                                },
                                canChangeOrientation: true,
                                pageFormats: const {"A4": PdfPageFormat.a4},
                                reportTitle: "",
                                widget: (PdfPageFormat format) async {
                                  return await serviceReport(
                                    controller.services.map((element) => element.value).toList(),
                                    generalController.settings.map((s) => s).toList(),
                                    title:"serviceReport".tr(),
                                    format: format,
                                  );
                                },
                              ));
                                    },
                                    icon: Iconsax.printer),
                                ButtonModel(foregroundColor: Colors.white,
                                    backgroundColor:  Colors.green,
                                    title: "exportToExcelFile".tr(),
                                    onPressed: ()async{
                                     if(generalController.isOverly.value) {
                                        toggleOverlay();
                                      }
                                      await exportToExcel("services-data.xlsx", [
                                        [
                                        "id".tr(),
                                        "serviceName".tr(),
                                        "serviceDesc".tr(),
                                        "servicePrice".tr(),
                                        "serviceTime".tr(),
                                        "serviceType".tr(),
                                        ],
                                        ...controller.services.map((u) => [
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
                                      if(generalController.isOverly.value) {
                                        toggleOverlay();
                                      }
                                      await showDialog(
                                        context: Get.overlayContext!,
                                        builder: (context) {
                                          return ImportExcelDialog(
                                            excelName: "employees-sample-data.xlsx",
                                              onImport: (List<Map<String,dynamic>> data)async{
                                                await controller.db.createMulti("services", data.map((e) {
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
          ));
        });
  }

  Container servicesList(BuildContext context) {
    return Container(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: 
                            Responsive.isMobile(context) ?  
                              Column(
                                children: controller.services.asMap().entries.map((v) => serviceCard(context,v.value.value,controller,v.key,true)).toList()
                              ):
                        Table(
                          border: TableBorder.all(
                              color: Theme.of(context).dividerColor),
                          columnWidths: const {
                            0: FlexColumnWidth(3),
                            1: FlexColumnWidth(3),
                            2: FlexColumnWidth(1.5),
                            3: FlexColumnWidth(1.5),
                            4: FlexColumnWidth(1),
                          },
                          children: [
                            TableRow(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Center(
                                      child: FittedBox(
                                        child: Text(
                                          "serviceName".tr(),
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
                                          "serviceDesc".tr(),
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
                                          "serviceTime".tr(),
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
                                          "servicePrice".tr(),
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
                            ...controller.services.asMap().entries.map((s) {
                              return TableRow(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor),
                                  children: [
                                    InputField(
                                      withBorder: false,
                                      isRequired: true,
                                      node: FocusNode(),
                                      keyboardType: TextInputType.text,
                                      controller: s.value.value.serviceName!.getTitleAsFaild,
                                      isNumber: true,
                                      readOnly: true,
                                    ),
                                    InputField(
                                      withBorder: false,
                                      isRequired: true,
                                      node: FocusNode(),
                                      keyboardType: TextInputType.text,
                                      controller: s.value.value.serviceDescription!.getTitleAsFaild,
                                      isNumber: true,
                                      readOnly: true,
                                    ),
                                    InputField(
                                      withBorder: false,
                                      isRequired: true,
                                      node: FocusNode(),
                                      keyboardType: TextInputType.text,
                                      controller: s.value.value.serviceTime!,
                                      isNumber: true,
                                      readOnly: true,
                                    ),
                                    InputField(
                                      withBorder: false,
                                      isRequired: true,
                                      node: FocusNode(),
                                      keyboardType: TextInputType.text,
                                      controller:s.value.value.serviceHasStaticValue! ?s.value.value.servicePrice! : TextEditingController(text: "unSelelected".tr()) ,
                                      isNumber: true,
                                      readOnly: true,
                                    ),
                                    serviceActions(context, controller, s.value.value,s.key)
                                  ]);
                            })
                          ],
                        ),
                      );
  }

//   Wrap statistics(BuildContext context) {
//     return Wrap(
//                 alignment: WrapAlignment.start,
//                 crossAxisAlignment: WrapCrossAlignment.start,
//                 runSpacing: 10,
//                 spacing: 10,
//                 children: [
//                   InkWell(
//                     onTap: (){
//                       controller.orderType.value = 0;
//                     },
//                     child: SizedBox(
//                       width: Responsive.isMobile(context) ? (Responsive.size(context).width/2)-10 : 220,
//                       child: MiniInformationWidget(
//                         controller: controllerPanelController,
//                           dailyData: controllerPanelController.chartsData[2].value..title = "الكل"..volumeData =
//                       (controllerPanelController.chartsData[3].value.volumeData! + controllerPanelController.chartsData[2].value.volumeData!)
                          
//                           ),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: (){
//                       controller.orderType.value = 1;
//                     },
//                     child: SizedBox(
//                       width: Responsive.isMobile(context) ? (Responsive.size(context).width/2)-10 : 220,
//                       child: MiniInformationWidget(
//                         controller: controllerPanelController,
//                           dailyData:controllerPanelController.chartsData[2].value..title = "الناجحة"
//                               ),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: (){
//                       controller.orderType.value = 2;
//                     },
//                     child: SizedBox(
//                       width: Responsive.isMobile(context) ? (Responsive.size(context).width/2)-10 : 220,
//                       child: MiniInformationWidget(
//                         controller: controllerPanelController,
//                       dailyData:controllerPanelController.chartsData[3].value..title = "المحظورة"
// ),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: (){
//                       controller.orderType.value = 3;
//                     },
//                     child: SizedBox(
//                       width: Responsive.isMobile(context) ? (Responsive.size(context).width/2)-10 : 220,
//                       child: MiniInformationWidget(
//                         controller: controllerPanelController,
//                         dailyData:controllerPanelController.chartsData[4].value
// ),
//                     ),
//                   ),
//                 ],
//               );
//   }
}

Widget serviceCard(BuildContext context,ServiceModel service,ServiceController controller,int index,[bool withDetails = false]){
  return Card(
      color: Theme.of(context).cardColor,
      child: ListTile(
        title: Text(
              service.serviceName!.getTitle,
              style: Theme.of(context).textTheme.displayMedium,
            ),
        subtitle: Text(
              service.serviceDescription!.getTitle,
              style: Theme.of(context).textTheme.displayMedium,
            ),
        trailing: serviceActions(context, controller, service, index),
      ));
}

Widget  orderDetailsCard(FormFieldModel formfield,BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              child: Icon(
                Iconsax.user,
                size: 20,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                        child: Text(
                      formfield.formFieldValue!.text,
                      style: Theme.of(context).textTheme.displayLarge,
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

