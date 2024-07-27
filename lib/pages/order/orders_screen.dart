// ignore_for_file: use_build_context_synchronously

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:its_system/constants.dart';
import 'package:its_system/controllers/general_controller.dart';
import 'package:its_system/controllers/home_controller.dart';
import 'package:its_system/controllers/order_controller.dart';
import 'package:its_system/core/models/button_model.dart';
import 'package:its_system/core/reports/complaint_report.dart';
import 'package:its_system/core/reports/order_report.dart';
import 'package:its_system/core/utils/date_picker.dart';
import 'package:its_system/core/utils/delete_dialog2.dart';
import 'package:its_system/core/widgets/button_bar_widget.dart';
import 'package:its_system/core/widgets/cash_image.dart';
import 'package:its_system/core/widgets/input_field.dart';
import 'package:its_system/core/widgets/popup_menu.dart';
import 'package:its_system/core/widgets/search_box.dart';
import 'package:its_system/helper/excel.dart';
import 'package:its_system/helper/open_dialog_bottom_sheet.dart';
import 'package:its_system/models/complaint_model.dart';
import 'package:its_system/models/service_model.dart';
import 'package:its_system/models/order_model.dart';
import 'package:its_system/models/user_model.dart';
import 'package:its_system/pages/mobile/orders.dart';
import 'package:its_system/pages/order/components/show_user.dart';
import 'package:its_system/pages/report_page.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/responsive.dart';
import 'package:pdf/pdf.dart';

// import 'package:restaurant/Model/restaurantCategory.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late GeneralController generalController;
//  late ControllerPanelController  controllerPanelController;
  late OrderController controller;

  @override
  void initState() {
    super.initState();
    generalController = Get.put(GeneralController());
    // controllerPanelController = Get.put(ControllerPanelController());
    controller = Get.put(OrderController(true));
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
              child: buildOverly(context)));

      overlay.insert(generalController.entry!);
    }
    generalController.isOverly.value = !generalController.isOverly.value;
  }

  Widget buildOverly(context) => Card(
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
                    "${controller.orderType.value == 0 ? "orderDate".tr() : "complaintDate".tr()} ${"from".tr()}",
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
                                style:
                                    Theme.of(context).textTheme.displaySmall!),
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
                  Obx(() {
                    return Column(
                      children: [
                        ExpansionTile(
                          title: Text(
                              controller.orderType.value == 0
                                  ? "orderState".tr()
                                  : "complaintState".tr(),
                              style: Theme.of(context).textTheme.displaySmall),
                          children: [
                            SizedBox(
                              height: 150,
                              child: SingleChildScrollView(
                                child: Column(children: [
                                  if (controller.orderType.value == 0) ...[
                                    RadioListTile(
                                      title: Text(
                                        "ALL".tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                      ),
                                      value: "ALL",
                                      groupValue: controller.orderState.value,
                                      onChanged: (v) {
                                        controller.orderState.value = v!;
                                      },
                                    ),
                                    RadioListTile(
                                      title: Text(
                                        "successed".tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                      ),
                                      value: "DONE",
                                      groupValue: controller.orderState.value,
                                      onChanged: (v) {
                                        controller.orderState.value = v!;
                                      },
                                    ),
                                    RadioListTile(
                                      title: Text(
                                        "canceled".tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                      ),
                                      value: "CANCELED",
                                      groupValue: controller.orderState.value,
                                      onChanged: (v) {
                                        controller.orderState.value = v!;
                                      },
                                    ),
                                  ],
                                  if (controller.orderType.value == 1) ...[
                                    RadioListTile(
                                      title: Text(
                                        "ALL".tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                      ),
                                      value: "ALL",
                                      groupValue: controller.complaintState.value,
                                      onChanged: (v) {
                                        controller.complaintState.value = v!;
                                      },
                                    ),
                                    ...ComplaintStates.values.map((ct) => 
                                      RadioListTile(
                                        title: Text(
                                          ct.name.tr(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall,
                                        ),
                                        value: ct.name,
                                        groupValue: controller.complaintState.value,
                                        onChanged: (v) {
                                          controller.complaintState.value = v!;
                                        },
                                      ),
                                    ),
                                  ]
                                ]),
                              ),
                            )
                          ],
                        ),
                        if(controller.orderType.value == 1 )
                          ExpansionTile(
                            title: Text("complaintType".tr(),
                                style:
                                    Theme.of(context).textTheme.displayMedium),
                            children: [
                              SizedBox(
                                height: 150,
                                child: SingleChildScrollView(
                                  child: Column(children: [
                                    // if(controller.orderType.value == 0)...[
                                    // RadioListTile(
                                    //   title: Text(
                                    //     "ALL".tr(),
                                    //     style: Theme.of(context)
                                    //         .textTheme
                                    //         .displaySmall,
                                    //   ),
                                    //   value: "ALL",
                                    //   groupValue:
                                    //       controller.orderTypeForFilter.value,
                                    //   onChanged: (v) {
                                    //     controller.orderTypeForFilter.value =
                                    //         v!;
                                    //   },
                                    // ),
                                    // RadioListTile(
                                    //   title: Text(
                                    //     "justCitizensMovements".tr(),
                                    //     style: Theme.of(context)
                                    //         .textTheme
                                    //         .displaySmall,
                                    //   ),
                                    //   value: " = 0 ",
                                    //   groupValue:
                                    //       controller.orderTypeForFilter.value,
                                    //   onChanged: (v) {
                                    //     controller.orderTypeForFilter.value =
                                    //         v!;
                                    //   },
                                    // ),
                                    // RadioListTile(
                                    //   title: Text(
                                    //     "justCitizensVisits".tr(),
                                    //     style: Theme.of(context)
                                    //         .textTheme
                                    //         .displaySmall,
                                    //   ),
                                    //   value: " != 0 ",
                                    //   groupValue:
                                    //       controller.orderTypeForFilter.value,
                                    //   onChanged: (v) {
                                    //     controller.orderTypeForFilter.value =
                                    //         v!;
                                    //   },
                                    // ),
                                    // ],
                                   if (controller.orderType.value == 1) ...[
                                    RadioListTile(
                                      title: Text(
                                        "ALL".tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                      ),
                                      value: "ALL",
                                      groupValue: controller.complaintType.value,
                                      onChanged: (v) {
                                        controller.complaintType.value = v!;
                                      },
                                    ),
                                    ...controller.complaintTypes.map((ct) => 
                                      RadioListTile(
                                        title: Text(
                                          ct.value.codeName!.getTitle,
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall,
                                        ),
                                        value: ct.value.codeId!.toString(),
                                        groupValue: controller.complaintType.value,
                                        onChanged: (v) {
                                          controller.complaintType.value = v!;
                                        },
                                      ),
                                    ),
                                  ]
                                  ]),
                                ),
                              )
                            ],
                          ),
                      ],
                    );
                  })

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
                      if (controller.orderType.value == 0) {
                        await controller.fetchAllOrders();
                      } else {}
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
          child: Scaffold(
            body: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SearchBox(
                          node: controller.searchNode,
                          controller: controller.searchController,
                          onChanged: (v) {},
                          onStart: () {},
                          onEnd: () {},
                          onFilter: () {
                            toggleOverlay();
                          },
                          onSubmitted: (v) async {
                            if (controller.orderType.value == 0) {
                              await controller.fetchAllOrders();
                            }
                            if (controller.orderType.value == 1) {
                              await controller.fetchAllComplaints();
                            }
                            if (controller.searchController.text.trim() != "") {
                              controller.searchNode.requestFocus();
                            }
                          },
                          searchTitle: controller.orderType.value == 0
                              ? "${"searchFor".tr()} ${"proces".tr()}"
                              : "${"searchFor".tr()} ${"complaint".tr()}",
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                ButtonBarWidget(isMain: false, allButtons: [
                  ButtonModel(
                      icon: Icons.policy,
                      title: "process".tr(),
                      foregroundColor: controller.orderType.value == 0
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                      backgroundColor: controller.orderType.value != 0
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                      onPressed: () {
                        controller.orderType.value = 0;
                      }),
                  ButtonModel(
                      icon: Icons.people,
                      title: "complaints".tr(),
                      foregroundColor: controller.orderType.value != 0
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                      backgroundColor: controller.orderType.value == 0
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                      onPressed: () {
                        controller.orderType.value = 1;
                      }),
                ]),
                // Card(
                //   color: Theme.of(context).primaryColorLight,
                //   child: ExpansionTile(title: Text("الإحصائيات",style: Theme.of(context).textTheme.displayMedium!),children: [statistics(context)],)),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                ButtonBarWidget(
                  isMain: false,
                  allButtons: [
                    if (controller.orderType.value == 0)
                      ButtonModel(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.brown,
                          title: "ordersReport".tr(),
                          onPressed: () async {
                            Get.to(()=>ReportPage(
                                  exportExcel: ()async{
                                    List details = [];
                                    for (var j = 0; j < controller.orders.length; j++) {
                                        for (var i = 0; i < controller.orders[j].value.orderDetails!.length; i++) {
                                          details.add([
                                            controller.orders[j].value.orderId,
                                            controller.orders[j].value.orderDetails![i].formFieldName!.getTitle,
                                            controller.orders[j].value.orderDetails![i].formFieldType!.name,
                                            controller.orders[j].value.orderDetails![i].formFieldValue!.text,
                                          ]); 
                                        }
                                    }
                                    await exportToExcelInTowSheets("orders-data.xlsx", [
                                        [
                                          "orderNumber",
                                          "orderCitizen".tr(),
                                          "phone".tr(),
                                          "orderState".tr(),
                                          "orderDate".tr(),
                                          "notes".tr(),
                                        ],
                                        ...controller.orders.map((u) => [
                                          u.value.orderId!,
                                          u.value.userCreated!.userName!.getTitle,
                                          u.value.userCreated!.userPhoneNumber!.text,
                                          u.value.orderState!.name.tr(),
                                          u.value.orderRegisteredAt!,
                                          u.value.orderNote!.text,
                                        ]).toList()],
                                        [
                                          ["FormFieldName".tr(),"formType".tr(),"value".tr()],
                                          ...details
                                        ]
                                        );
                                  },
                                  canChangeOrientation: true,
                                  pageFormats: const {"A4": PdfPageFormat.a4},
                                  reportTitle: "printReport".tr(),
                                  widget: (PdfPageFormat format) async {
                                    return await orderorReport(
                                      controller.orders.map((element) => element.value).toList(),
                                      generalController.settings.map((s) => s).toList(),
                                      title:"orderReport".tr(),
                                      showDetails: true,
                                      format: format,
                                    );
                                  },
                                ));
                          },
                          icon: Iconsax.printer),
                    if (controller.orderType.value == 1)
                      ButtonModel(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.teal,
                          title: "complaintsReport".tr(),
                          onPressed: () async {
                             Get.to(()=>ReportPage(
                                exportExcel: ()async{
                                          Get.to(()=>ReportPage(
                                            exportExcel: ()async{
                                              await exportToExcel("complaints-data.xlsx", [
                                                      [
                                                        "citizenName".tr(),
                                                        "phone".tr(),
                                                        "date".tr(),
                                                        "complaintType".tr(),
                                                        "complaintTopic".tr(),
                                                      ],
                                                      ...controller.complaints.map((u) => [
                                                        u.value.user!.userName!.getTitle,
                                                        u.value.user!.userPhoneNumber!.text,
                                                        u.value.date!.createDate!.toString(),
                                                        u.value.complaintType!.codeName!.getTitle,
                                                        u.value.complaintTitle!.text
                                                      ]).toList()]);
                                              },
                                            canChangeOrientation: true,
                                            pageFormats: const {"A4": PdfPageFormat.a4},
                                            reportTitle: "printReport".tr(),
                                            widget: (PdfPageFormat format) async {
                                              return await complaintReport(
                                                controller.complaints.map((element) => element.value).toList(),
                                                generalController.settings.map((s) => s).toList(),
                                                title:"complaintReport".tr(),
                                                format: format,
                                              );
                                            },
                                          ));
                                  },
                                canChangeOrientation: true,
                                pageFormats: const {"A4": PdfPageFormat.a4},
                                reportTitle: "printReport".tr(),
                                widget: (PdfPageFormat format) async {
                                  return await complaintReport(
                                    controller.complaints.map((element) => element.value).toList(),
                                    generalController.settings.map((s) => s).toList(),
                                    title:"complaintReport".tr(),
                                    format: format,
                                  );
                                },
                              ));
                          },
                          icon: Iconsax.printer),
                    // ButtonModel(
                    //     foregroundColor: Colors.white,
                    //     backgroundColor: Colors.orange,
                    //     title: "تقرير الدعوات",
                    //     onPressed: () async {},
                    //     icon: Iconsax.printer),
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
                        if (controller.orderType.value == 0)
                          ordersList(context),
                        if (controller.orderType.value == 1)
                          complaintList(context),
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

Container ordersList(BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 24),
    child: Responsive.isMobile(context)
        ? Column(
            children: controller.orders
                .map((v) => orderCard(context, v.value, true))
                .toList())
        : Table(
            border: TableBorder.all(color: Theme.of(context).dividerColor),
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1.5),
              3: FlexColumnWidth(1.2),
              4: FlexColumnWidth(1.5),
              5: FlexColumnWidth(1),
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
                            "citizenName".tr(),
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
                            "regesteredDate".tr(),
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
                            "orderState".tr(),
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
                            "notes".tr(),
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
              ...controller.orders.asMap().entries.map((s) {
                return TableRow(
                    decoration:
                        BoxDecoration(color: Theme.of(context).cardColor),
                    children: [
                      InputField(
                        withBorder: false,
                        isRequired: true,
                        node: FocusNode(),
                        keyboardType: TextInputType.number,
                        controller: s.value.value.userCreated!.userName!
                            .getTitleAsFaild,
                        isNumber: true,
                        readOnly: true,
                      ),
                      InputField(
                        withBorder: false,
                        isRequired: true,
                        node: FocusNode(),
                        keyboardType: TextInputType.number,
                        controller: TextEditingController(
                            text: DateFormat("yyyy-MM-dd HH:mm")
                                .format(s.value.value.orderRegisteredAt!)),
                        isNumber: true,
                        readOnly: true,
                      ),
                      InputField(
                        withBorder: false,
                        isRequired: true,
                        node: FocusNode(),
                        keyboardType: TextInputType.number,
                        controller: s.value.value.service!.serviceName!
                            .getTitleAsFaild,
                        isNumber: true,
                        readOnly: true,
                      ),
                      InputField(
                        withBorder: false,
                        isRequired: true,
                        node: FocusNode(),
                        keyboardType: TextInputType.number,
                        controller: TextEditingController(
                            text: s.value.value.orderState!.name.tr()),
                        isNumber: true,
                        readOnly: true,
                      ),
                      InputField(
                        withBorder: false,
                        isRequired: true,
                        node: FocusNode(),
                        keyboardType: TextInputType.number,
                        controller: s.value.value.orderNote!,
                        isNumber: true,
                        readOnly: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                            onPressed: () async{
                              HomeController homeController = Get.put(HomeController());
                              homeController.isEdit = true;
                              await homeController.refreshOrderWithValues(s.value.value, s.value.value.service!, s.value.value.institution!);
                              openDialogOrNewRoute(ShowOrderOrEditIt(title: "showData".tr(),forRead: true,));
                            },
                            icon: const Icon(Icons.remove_red_eye_outlined),
                            label: FittedBox(
                              child: Text(
                                "view".tr(),
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                            )),
                      )
                    ]);
              })
            ],
          ),
  );
}

Container complaintList(BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 24),
    child: Responsive.isMobile(context)
        ? Column(
            children: controller.complaints
                .map((e) => recentComplaintForMobile(e.value, controller,context))
                .toList())
        : Table(
            border: TableBorder.all(color: Theme.of(context).dividerColor),
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(3),
              3: FlexColumnWidth(3),
              4: FlexColumnWidth(1.5),
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
                            "complaintType".tr(),
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
                            "complaintTopic".tr(),
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
                            "citizenName".tr(),
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
                            "complaintState".tr(),
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
              ...controller.complaints.asMap().entries.map((s) {
                return TableRow(
                    decoration:
                        BoxDecoration(color: Theme.of(context).cardColor),
                    children: [
                      InputField(
                        withBorder: false,
                        isRequired: true,
                        node: FocusNode(),
                        keyboardType: TextInputType.number,
                        controller: s.value.value.complaintType!.codeName!.getTitleAsFaild,
                        isNumber: true,
                        readOnly: true,
                      ),
                      InputField(
                        withBorder: false,
                        isRequired: true,
                        node: FocusNode(),
                        keyboardType: TextInputType.number,
                        controller: s.value.value.complaintTitle!,
                        isNumber: true,
                        readOnly: true,
                      ),
                      InputField(
                        withBorder: false,
                        isRequired: true,
                        node: FocusNode(),
                        keyboardType: TextInputType.number,
                        controller: s.value.value.user!.userName!.getTitleAsFaild,
                        isNumber: true,
                        readOnly: true,
                      ),
                      InputField(
                        withBorder: false,
                        isRequired: true,
                        node: FocusNode(),
                        keyboardType: TextInputType.number,
                        controller: TextEditingController(text: s.value.value.complaintState!.name.tr()),
                        isNumber: true,
                        readOnly: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PopupMenuButton(
                          surfaceTintColor: Colors.transparent,
                        icon: Icon(
                          Icons.more_vert,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        onSelected: (v) async{
                          if(v==0){
                            deleteMessage2(
                              deleteButton: "archiveComplaint".tr(),
                              title: "areYouSureFor".tr(), content: "archiveThisComplaint".tr() , onDelete: ()async{
                                await controller.db.update(tableName: "complaints", primaryKey: "COMP_ID", primaryKeyValue: s.value.value.complaintId, items: {"COMP_STATE": "ARCHIVE"});
                                await controller.fetchAllComplaints();
                              Get.back();
                            },
                            onCancel: (){Get.back();}, onWillPop: true);
                          }
                          if(v==1){
                            showDialog(context: context, builder: (context)=>Dialog(child: ShowUser(user: s.value.value.user!),));
                          }
                        },
                        itemBuilder: (context) {
                          return [
                            if(s.value.value.complaintState == ComplaintStates.EXIST)
                            PopupMenuItem(
                              value: 0,
                              child: MyPopupMenuItem(
                                icon: Icons.edit,
                                text: "archiveComplaint".tr(),
                              ),
                            ),
                            PopupMenuItem(
                              value: 1,
                              child: MyPopupMenuItem(
                                icon: Icons.remove_red_eye,
                                text: "view".tr(),
                              ),
                            ),
                          ];
                        },
                      ),
                      ),
                    ]);
              })
            ],
          ),
  );
}
}

Widget orderCard(BuildContext context, OrderModel order,
    [bool withDetails = false]) {
  return Card(
    color: Theme.of(context).cardColor,
    child: ListTile(
      title: Text(
              order.service!.serviceName!.getTitle,
              style: Theme.of(context).textTheme.displayMedium,
            ),
      subtitle: Text(
              order.userCreated!.userName!.getTitle,
              style: Theme.of(context).textTheme.displayMedium,
            ),
      trailing: ElevatedButton.icon(
                            onPressed: () async{
                              HomeController homeController = Get.put(HomeController());
                              homeController.isEdit = true;
                              await homeController.refreshOrderWithValues(order, order.service!, order.institution!);
                              openDialogOrNewRoute(ShowOrderOrEditIt(title: "showData".tr(),forRead: true,));
                            },
                            icon: const Icon(Icons.remove_red_eye_outlined),
                            label: FittedBox(
                              child: Text(
                                "view".tr(),
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                            ),
    )
    // ExpansionTile(
    //   title: Row(
    //     children: [
    //       Text(
    //         "orderFor".tr(),
    //         style: Theme.of(context).textTheme.displayMedium,
    //       ),
    //       const SizedBox(
    //         width: 5,
    //       ),
    //       ImageWidget(imagePath: order.userCreated!.userImage!.path),
    //       const SizedBox(
    //         width: 5,
    //       ),
    //       Text(
    //         order.userCreated!.userName!.getTitle,
    //         style: Theme.of(context).textTheme.displayMedium,
    //       ),
    //     ],
    //   ),
    //   children: [
    //     ...order.orderDetails!.map((e) => orderDetailsCard(e, context)),
    //     const SizedBox(
    //       height: 10,
    //     ),
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceAround,
    //       children: [
    //         const SizedBox(
    //           width: 5,
    //         ),
    //         Expanded(
    //           child: Container(
    //             padding: const EdgeInsets.all(8),
    //             decoration: BoxDecoration(
    //                 color: Colors.teal, borderRadius: BorderRadius.circular(5)),
    //             child: Row(
    //               children: [
    //                 const Icon(
    //                   Icons.person_outline,
    //                   color: Colors.white,
    //                 ),
    //                 const SizedBox(
    //                   width: 5,
    //                 ),
    //                 Expanded(
    //                   child: FittedBox(
    //                     fit: BoxFit.scaleDown,
    //                     child: Text(
    //                       order.userCreated!.userName!.getTitle,
    //                       style: Theme.of(context)
    //                           .textTheme
    //                           .displaySmall!
    //                           .copyWith(color: Colors.white),
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //         const SizedBox(
    //           width: 10,
    //         ),
    //         Expanded(
    //           child: Container(
    //             padding: const EdgeInsets.all(8),
    //             decoration: BoxDecoration(
    //                 color: Colors.red.withOpacity(0.9),
    //                 borderRadius: BorderRadius.circular(5)),
    //             child: Row(
    //               children: [
    //                 const Icon(
    //                   Iconsax.calendar,
    //                   color: Colors.white,
    //                 ),
    //                 const SizedBox(
    //                   width: 5,
    //                 ),
    //                 Expanded(
    //                   child: FittedBox(
    //                     fit: BoxFit.scaleDown,
    //                     child: Text(
    //                       DateFormat("yyyy-MM-dd")
    //                           .format(order.orderRegisteredAt!),
    //                       style: Theme.of(context)
    //                           .textTheme
    //                           .displaySmall!
    //                           .copyWith(color: Colors.white),
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //         const SizedBox(
    //           width: 10,
    //         ),
    //         if (withDetails)
    //           Expanded(
    //             child: InkWell(
    //               onTap: () async {
    //                 // showDialog(context: context, builder: (context) {
    //                 // return Dialog(
    //                 //   child: showQrDetails(order,context),
    //                 // );
    //                 // },);
    //               },
    //               child: Container(
    //                 padding: const EdgeInsets.all(8),
    //                 decoration: BoxDecoration(
    //                     color: Theme.of(context).primaryColor,
    //                     borderRadius: BorderRadius.circular(5)),
    //                 child: Row(
    //                   children: [
    //                     const Icon(
    //                       Iconsax.eye,
    //                       color: Colors.white,
    //                     ),
    //                     const SizedBox(
    //                       width: 5,
    //                     ),
    //                     Expanded(
    //                       child: FittedBox(
    //                         fit: BoxFit.scaleDown,
    //                         child: Text(
    //                           "view".tr(),
    //                           style: Theme.of(context)
    //                               .textTheme
    //                               .displaySmall!
    //                               .copyWith(color: Colors.white),
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ),
    //       ],
    //     ),
    //   ],
    ),
  );
}

Widget orderDetailsCard(FormFieldModel formfield, BuildContext context) {
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
 

Widget recentComplaintForMobile(ComplaintModel complaint,OrderController controller, BuildContext context){
  return Card(
    child: Column(
      children: [
        if(Responsive.isMobile(context))
        Container(
          width: 100,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).primaryColor
          ),
          child: Text(
                complaint.complaintState!.name.tr(),
                style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
      ),
        ListTile(
          leading: 
        (!Responsive.isMobile(context)) ? 
              Container(
          width: 100,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).primaryColor
          ),
          child: Text(
                complaint.complaintState!.name.tr(),
                style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
      ) : null,
          title: Text(complaint.complaintType!.codeName!.getTitle,style: Theme.of(context).textTheme.displaySmall,),
          subtitle: Text(complaint.complaintTitle!.text,style: Theme.of(context).textTheme.labelLarge,),
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if(complaint.complaintState == ComplaintStates.EXIST)
              Expanded(
                child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: redColor
                ),
                icon: const Icon(Icons.cancel_outlined,color: Colors.white,),
                onPressed: () async{
                  deleteMessage2(
                    deleteButton: "archiveComplaint".tr(),
                    title: "areYouSureFor".tr(), content: "archiveThisComplaint".tr() , onDelete: ()async{
                      await controller.db.update(tableName: "complaints", primaryKey: "COMP_ID", primaryKeyValue: complaint.complaintId, items: {"COMP_STATE": "ARCHIVE"});
                      await controller.fetchAllComplaints();
                    Get.back();
                  },
                  onCancel: (){Get.back();}, onWillPop: true);
                },
                // Delete
                label: Text("archiveComplaint".tr(),style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white),),
              ),
              ),
            ],
          ),
          ),
      ],
    ),
  );
}