import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdf/pdf.dart';
import 'package:its_system/constants.dart';
import 'package:its_system/controllers/general_controller.dart';
import 'package:its_system/controllers/user_controller.dart';
import 'package:its_system/core/models/button_model.dart';
import 'package:its_system/core/reports/user_report.dart';
import 'package:its_system/core/utils/date_picker.dart';
import 'package:its_system/core/utils/delete_dialog2.dart';
import 'package:its_system/core/utils/import_excel_dialog.dart';
import 'package:its_system/core/utils/report_setting_dialog.dart';
import 'package:its_system/core/widgets/button_bar_widget.dart';
import 'package:its_system/core/widgets/input_field.dart';
import 'package:its_system/core/widgets/popup_menu.dart';
import 'package:its_system/core/widgets/search_box.dart';
import 'package:its_system/helper/excel.dart';
import 'package:its_system/helper/open_dialog_bottom_sheet.dart';
import 'package:its_system/models/state_enum.dart';
import 'package:its_system/models/user_model.dart';
import 'package:its_system/pages/report_page.dart';
import 'package:its_system/pages/user/components/add_update_user.dart';
import 'package:get/get.dart' hide Trans;
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/pages/user/components/user_details.dart';
import 'package:its_system/responsive.dart';
import 'package:its_system/statics_values.dart';

// import 'package:restaurant/Model/restaurantCategory.dart';

class UserScreen extends StatefulWidget {
  final UserTypes userType;
  final String debugLabel;
  const UserScreen({Key? key,required this.userType, required this.debugLabel}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  // final List<ModelCategory> _courses = categories.Categorys();
  // double screenHight = 0;
  // double screenwidth = 0;

  late GeneralController generalController;
  late UserController controller;

  @override
  void initState() {
    super.initState();
    generalController = Get.put(GeneralController());
    
  }

    

   toggleOverlay(){
    if(generalController.isOverly.value){
      generalController.entry!.remove();
    }
    else{
      final overlay = Overlay.of(context);
      // final renderBox = context.findRenderObject() as RenderBox;
      // final size = renderBox.size;

      generalController.entry = OverlayEntry(
        builder: (context)=>Positioned(
        left: Responsive.isMobile(context) ? 3: 20,
        right: Responsive.isMobile(context) ? 3: null,
        top: 100,
        child: buildOverly()));
      
      overlay.insert(generalController.entry!);
    }
    generalController.isOverly.value= !generalController.isOverly.value;
  }


  Widget buildOverly() => Card(
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
                  Obx(
                     () {
                      return Column(
                        children: [
                          // ExpansionTile(title: Text( widget.userType != UserTypes.CITIZEN ? "employeeType".tr():"citizenType".tr() ,style: Theme.of(context).textTheme.displayMedium),children: [
                          //   SizedBox(
                          //     height: 150,
                          //     child: SingleChildScrollView(
                          //       child: Column(children: [
                          // RadioListTile(
                          //     title: Text("ALL".tr(),style: Theme.of(context).textTheme.displaySmall,),
                          //     value: "ALL", groupValue: controller.userTypeForFilter.value,                  
                          //   onChanged: (v){
                          //     controller.userTypeForFilter.value = v!;
                          //  },),
                          //  ...UserTypes.values.map((element) {
                          //   if(widget.userType == UserTypes.CITIZEN && (element == UserTypes.CITIZEN )) {
                          //     return RadioListTile(
                          //     title: Text(element.name.tr(),style: Theme.of(context).textTheme.displaySmall,),
                          //     value: element.name, groupValue: controller.userTypeForFilter.value,                  
                          //   onChanged: (v){
                          //     controller.userTypeForFilter.value = v!;
                          //  },);
                          //   }
                          //   if(widget.userType != UserTypes.CITIZEN && (element == UserTypes.ADMIN )) {
                          //     return RadioListTile(
                          //     title: Text(element.name.tr(),style: Theme.of(context).textTheme.displaySmall,),
                          //     value: element.name, groupValue: controller.userTypeForFilter.value,                  
                          //   onChanged: (v){
                          //     controller.userTypeForFilter.value = v!;
                          //  },);
                          //   }
                          //   return const SizedBox();
                          //  }),
                           
                          //  ]),
                          //     ),
                          //   )
                          // ],),
                          ExpansionTile(title: Text( "connectionState".tr() ,style: Theme.of(context).textTheme.displayMedium),children: [
                            SizedBox(
                              height: 150,
                              child: SingleChildScrollView(
                                child: Column(children: [
                          RadioListTile(
                              title: Text("ALL".tr(),style: Theme.of(context).textTheme.displaySmall,),
                              value: "ALL", groupValue: controller.connectingState.value,                  
                            onChanged: (v){
                              controller.connectingState.value = v!;
                           },),
                          RadioListTile(
                              title: Text("connected".tr(),style: Theme.of(context).textTheme.displaySmall,),
                              value: "connected", groupValue: controller.connectingState.value,                  
                            onChanged: (v){
                              controller.connectingState.value = v!;
                           },),
                          RadioListTile(
                              title: Text("unconnected".tr(),style: Theme.of(context).textTheme.displaySmall,),
                              value: "unconnected", groupValue: controller.connectingState.value,                  
                            onChanged: (v){
                              controller.connectingState.value = v!;
                           },),
                           
                           ]),
                              ),
                            )
                          ],),
                        ],
                      );
                    }
                  )
                  
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
                  await controller.fetchAllEmployees();
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
      controller = Get.put( UserController(widget.userType),
        tag: widget.userType.name.toString(),);
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
                                  await controller.fetchAllEmployees();
                                  if(controller.searchController.text.trim() != "") {
                                    controller.searchNode.requestFocus();
                                  }
                                },
                                searchTitle: widget.userType != UserTypes.CITIZEN ? "${"searchFor".tr()} ${"employee".tr()}" : "${"searchFor".tr()} ${"citizen".tr()}",
                              ),
                            ),
                          ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  ButtonBarWidget(
                              isMain: false,
                              allButtons: [
                                if(StaticValue.userData!.userType == UserTypes.SUPER_ADMIN || 
                                  StaticValue.userData!.userNumber!.text == "1")
                                ButtonModel(foregroundColor: Colors.white,
                                    backgroundColor:  Theme.of(context).primaryColor,
                                    title: widget.userType != UserTypes.CITIZEN ? "addEmployee".tr() : "addCitizen".tr(),
                                    onPressed: ()async{
                                      if(generalController.isOverly.value) {
                                        toggleOverlay();
                                      }
                                        controller.refreshEmployee();
                                        controller.isEdit = false;
                                        await openDialogOrBottomSheet(AddNewUserBottomSheet(userType: widget.userType,));
                                    },
                                    icon: Iconsax.add_circle),
                                ButtonModel(foregroundColor:   Colors.white,
                                    backgroundColor: Colors.brown,
                                    title:widget.userType != UserTypes.CITIZEN? "printEmployeesRecord".tr():"printCitizensRecord".tr(),
                                    onPressed: ()async{
                                      if(generalController.isOverly.value) {
                                        toggleOverlay();
                                      }
                                       Get.to(()=>ReportPage(
                               exportExcel: ()async{
                                      await exportToExcel("employees-data.xlsx", [
                                        [
                                          widget.userType != UserTypes.CITIZEN ? "employeeName".tr() : "citizenName".tr(),
                                        // "${"employeeName".tr()} بالإنجليزية",
                                        "phoneNumber".tr(),
                                        "emailAddress".tr(),
                                        "createdDate".tr(),
                                        if(widget.userType != UserTypes.CITIZEN)
                                        "employeeType".tr(),
                                        ],
                                        ...controller.users.map((u) => [
                                        u.value.userName!.getTitle,
                                        // u.value.userName!.englishTitle!.text,
                                        u.value.userPhoneNumber!.text,
                                        u.value.userEMail!.text,
                                        u.value.userRegisterDate!.toString(),
                                        if(widget.userType != UserTypes.CITIZEN)
                                        u.value.userType!.name.tr()
                                      ]).toList()]);
                                },
                                canChangeOrientation: true,
                                pageFormats: const {"A4": PdfPageFormat.a4},
                                reportTitle: "",
                                widget: (PdfPageFormat format) async {
                                  return await userReport(
                                    controller.users.map((element) => element.value).toList(),
                                    generalController.settings.map((s) => s).toList(),
                                    title:"exceptionReport".tr(),
                                    format: format,
                                    forEmployees: widget.userType != UserTypes.CITIZEN
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
                                      await exportToExcel("employees-data.xlsx", [
                                        [
                                          widget.userType != UserTypes.CITIZEN ? "employeeName".tr() : "citizenName".tr(),
                                        // "${"employeeName".tr()} بالإنجليزية",
                                        "id".tr(),
                                        "phoneNumber".tr(),
                                        "emailAddress".tr(),
                                        "createdDate".tr(),
                                        if(widget.userType != UserTypes.CITIZEN)
                                        "employeeType".tr(),
                                        ],
                                        ...controller.users.map((u) => [
                                        u.value.userId,
                                        u.value.userName!.getTitle,
                                        // u.value.userName!.englishTitle!.text,
                                        u.value.userPhoneNumber!.text,
                                        u.value.userEMail!.text,
                                        u.value.userRegisterDate!.toString(),
                                        if(widget.userType != UserTypes.CITIZEN)
                                        u.value.userType!.name.tr()
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
                                                int cityId = StaticValue.userData!.institution!.municipality!.city!.cityId!;
                                                int municipalityId = StaticValue.userData!.institution!.municipality!.municipalityId!;
                                                int institutionId = StaticValue.userData!.institution!.institutionId!;
                                                await controller.db.createMulti("users", data.map((e) {
                                                  if(widget.userType != UserTypes.CITIZEN) {
                                                    e["USR_TYPE"] = "ADMIN";
                                                  }else{
                                                    e["USR_TYPE"] = "CITIZEN";
                                                  }
                                                  e["INST_ID"] = StaticValue.userData!.institution!.institutionId!;
                                                  e["USR_REGISTER_DATE"] = DateFormat("yyyy-MM-dd").format(DateTime.parse(e["USR_REGISTER_DATE"].toString()));
                                                  e["USR_UNIQUE_KEY"] = "$cityId-$institutionId-${e["USR_NUMBER"].toString()}";
                                                  return e;
                                                }).toList());
                                                Get.back();
                                                await controller.fetchAllEmployees();
                                              },
                                              isTablet: MediaQuery.of(context).size.width > 600,
                                              dataDetails: [
                                                DataDetails(number: "A", title:"${widget.userType != UserTypes.CITIZEN ? "employeeNumber".tr() : "citizenNumber".tr()} ${"uniueNumber".tr()}", columnName: "USR_NUMBER", dataType: "رقم", allowValues: []),
                                                DataDetails(number: "B", title: "${widget.userType != UserTypes.CITIZEN ? "employeeName".tr() : "citizenName".tr()} ${"withArabic".tr()}", columnName: "USR_NAME", dataType: "نص", allowValues: []),
                                                // DataDetails(number: "B", title: "${widget.userType != UserTypes.CITIZEN ? "employeeName".tr() : "citizenName".tr()} ${"withEnglish".tr()}", columnName: "USR_NAME_EN", dataType: "نص", allowValues: []),
                                                DataDetails(number: "C", title: "phoneNumber".tr(), columnName: "USR_PHONE", dataType: "نص", allowValues: []),
                                                DataDetails(number: "D", title: "emailAddress".tr(), columnName: "USR_E_MAIL", dataType: "نص", allowValues: []),
                                                DataDetails(number: "E", title: "createdDate".tr(), columnName: "USR_REGISTER_DATE", dataType: "تاريخ", allowValues: []),
                                                // if(widget.userType != UserTypes.CITIZEN)
                                                // DataDetails(number: "F", title: "employeeType".tr(), columnName: "USR_TYPE", dataType: "نص", allowValues: ["ADMIN","SECURITY"]),
                                              ]);
                                        });
                                    },
                                    icon: Iconsax.import)
                              ], ),
                  const SizedBox(height: 10,),
                  const Divider(),
                  NewWidget(userType: widget.userType,key: GlobalKey(debugLabel: widget.debugLabel)),
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

class NewWidget extends StatelessWidget {
  final UserTypes userType;
  const NewWidget({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    return GetX(
      init: UserController(userType),
      tag: userType.name.toString(),
       builder: (controller) {
        return Expanded(
                        child: Container(
                          color: Theme.of(context).primaryColorLight,
                          child: ListView(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 24),
                                child:
                                Responsive.isMobile(context) ?  
                              Column(
                                children: controller.users.where((u) {
                                  if(controller.connectingState.value == "connected")return u.value.userLastConnected!.add(const Duration(minutes: 5)).compareTo(DateTime.now()) >= 0;
                                  if(controller.connectingState.value == "unconnected")return u.value.userLastConnected!.add(const Duration(minutes: 5)).compareTo(DateTime.now()) < 0;
                                  return true;
                                }).map((c) => employeeDataForMobile(userType: userType, user: c.value, controller: controller, context: context)).toList()
                              ):
                                 Table(
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
                                                  userType != UserTypes.CITIZEN ? "employeeNumebr".tr() : "citizenNumber".tr(),
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
                                                  userType != UserTypes.CITIZEN ?  "employeeName".tr() : "citizenName".tr(),
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
                                                  "phone".tr(),
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
                                                  "lastConnection".tr(),
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
                                          if(userType != UserTypes.CITIZEN)
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Center(
                                              child: FittedBox(
                                                child: Text(
                                                  "accountType".tr(),
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
                                                  "accountState".tr(),
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
                                    ...controller.users.where((u) {
                                      if(controller.connectingState.value == "connected")return u.value.userLastConnected!.add(const Duration(minutes: 5)).compareTo(DateTime.now()) >= 0;
                                      if(controller.connectingState.value == "unconnected")return u.value.userLastConnected!.add(const Duration(minutes: 5)).compareTo(DateTime.now()) < 0;
                                      return true;
                                    }).toList().asMap().entries.map((s) {
                                      return TableRow(
                                          decoration: BoxDecoration(
                                              color: Theme.of(context).cardColor),
                                          children: [
                                            InputField(
                                              withBorder: false,
                                              isRequired: true,
                                              node: FocusNode(),
                                              keyboardType: TextInputType.number,
                                              controller:s.value.value.userNumber!,
                                              isNumber: true,
                                              readOnly: true,
                                            ),
                                            InputField(
                                              withBorder: false,
                                              isRequired: true,
                                              node: FocusNode(),
                                              keyboardType: TextInputType.number,
                                              controller: s.value.value.userName!.getTitleAsFaild,
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
                                              controller: s.value.value.userPhoneNumber!,
                                              isNumber: true,
                                              readOnly: true,
                                            ),
                                            InputField(
                                              withBorder: false,
                                              isRequired: true,
                                              node: FocusNode(),
                                              keyboardType: TextInputType.number,
                                              controller: TextEditingController(text: s.value.value.userLastConnected!.add(const Duration(minutes: 5)).compareTo(DateTime.now()) >= 0 ?"connected".tr():"unconnected".tr() .toString()),
                                              isNumber: true,
                                              readOnly: true,
                                            ),
                                            if(userType != UserTypes.CITIZEN)
                                            InputField(
                                              withBorder: false,
                                              isRequired: true,
                                              node: FocusNode(),
                                              keyboardType: TextInputType.number,
                                              controller:TextEditingController(text: s.value.value.userType!.name.tr()),
                                              isNumber: true,
                                              readOnly: true,
                                            ),
                                            InputField(
                                              withBorder: false,
                                              isRequired: true,
                                              node: FocusNode(),
                                              keyboardType: TextInputType.number,
                                              controller:TextEditingController(text: s.value.value.userState!.name.tr()),
                                              isNumber: true,
                                              readOnly: true,
                                            ),
                                            userActions(context, controller, s.value.value,userType)
                                          
                                          ]);
                                    })
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
      }
    );
  }
}
  Container userActions(BuildContext context, UserController controller,UserModel user,UserTypes userType) {
    return Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle
                        ),
                        padding: const EdgeInsets.symmetric(horizontal:50),
                        child:  PopupMenuButton(
                          surfaceTintColor: Colors.transparent,
                        icon: Icon(
                          Icons.more_vert,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        onSelected: (v) async{
                          if(v==0){
                              await controller.refreshEmployee();
                              controller.isEdit = true;
                              controller.user.value = UserModel().copyWith(user:user);
                              controller.user.value.userName!.arabicHint = userType != UserTypes.CITIZEN ?  "employeeName".tr() : "citizenName".tr();
                              controller.user.value.userName!.englishHint = userType != UserTypes.CITIZEN ?  "employeeName".tr() : "citizenName".tr();
                              await openDialogOrBottomSheet(AddNewUserBottomSheet(userType: userType,));
                          }
                          if(v==1){
                            await deleteMessage2(
                              deleteButton: user.userState! == States.BLOCKED ? "unblock".tr() : "block".tr(),
                              title: "confirm".tr(), content: "${"areYouSureFor".tr()} ${user.userState! == States.BLOCKED ? "unblock".tr() : "block".tr()} ${user.userName!.getTitle}", onDelete: ()async{
                                await controller.db.update(tableName: "users", primaryKey: "USR_ID", primaryKeyValue: user.userId, items: {"USR_STATE": user.userState! == States.BLOCKED ? "ACTIVE" : "BLOCKED"});
                                Get.back();
                                await controller.fetchAllEmployees();
                            }, onCancel: (){Get.back();}, onWillPop: true);
                          }
                          if(v == 2){
                             await deleteMessage2(
                              title: "confirm".tr(), content: "${"areYouSureFor".tr()} ${"delete".tr()} ${userType != UserTypes.CITIZEN ? "deleteEmployee".tr() : "deleteCitizen".tr()} ${user.userName!.getTitle}", onDelete: ()async{
                                await controller.db.update(tableName: "users", primaryKey: "USR_ID", primaryKeyValue: user.userId, items: {"USR_STATE": "DELETED"});
                                Get.back();
                                await controller.fetchAllEmployees();
                            }, onCancel: (){Get.back();}, onWillPop: true);
                          }
                          if(v==4){
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return ReportSettingDialog(
                                    index: 1,
                                    user: user,
                                    forOrder: false,
                                    userType: UserTypes.ADMIN,
                                  );
                                });
                          }
                          if(v==5){
                              showDialog(
                              context: context,
                              builder: (context) {
                                return ReportSettingDialog(
                                  index: 2,
                                  forOrder: false,
                                  user: user,
                                  userType: UserTypes.CITIZEN,
                                );
                              });
                          }
                          if(v==6){
                          showDialog(
                            context: context,
                            builder: (context) {
                              return ReportSettingDialog(
                                index: 3,
                                forOrder: false,
                                user: user,
                                userType: UserTypes.CITIZEN,
                              );
                            });
                          }
                        },
                        itemBuilder: (context) {
                          return [
                          if((StaticValue.userData!.userNumber!.text == "1" || StaticValue.userData!.userType == UserTypes.SUPER_ADMIN) /*&& userType != UserTypes.CITIZEN*/)...[
                            PopupMenuItem(
                              value: 0,
                              child: MyPopupMenuItem(
                                icon: Icons.edit,
                                text: "editData".tr(),
                              ),
                            ),
                            PopupMenuItem(
                              value: 1,
                              child: MyPopupMenuItem(
                                icon: user.userState! == States.BLOCKED ? Icons.block :Icons.block,
                                text:user.userState! == States.BLOCKED ? "unblock".tr() : "block".tr(),
                              ),
                            ),
                            PopupMenuItem(
                              value: 2,
                              child: MyPopupMenuItem(
                                icon: Ionicons.remove_circle,
                                text: userType != UserTypes.CITIZEN ? "deleteEmployee".tr() : "deleteCitizen".tr(),
                              ),
                            ),
                          ],
                          ];
                        },
                      ),
                                          );
  }
