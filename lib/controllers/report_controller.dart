import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:intl/intl.dart';
import 'package:its_system/core/reports/complaint_report.dart';
import 'package:its_system/core/reports/service_report.dart';
import 'package:its_system/models/complaint_model.dart';
import 'package:its_system/models/service_model.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pdf/pdf.dart';
import 'package:its_system/constants.dart';
import 'package:its_system/controllers/general_controller.dart';
import 'package:its_system/core/reports/order_report.dart';
import 'package:its_system/core/utils/snakbar_dialog.dart';
import 'package:its_system/helper/db/general_helper.dart';
import 'package:its_system/helper/excel.dart';
import 'package:its_system/models/user_model.dart';
import 'package:its_system/models/order_model.dart';
import 'package:its_system/pages/notification/components/chooes_user.dart';
import 'package:its_system/pages/report_page.dart';
import 'package:its_system/statics_values.dart';

class ReportController extends GetxController {

  RxList<Rx<OrderModel>> orders = <Rx<OrderModel>>[].obs;
  RxList<Rx<ComplaintModel>> complaints = <Rx<ComplaintModel>>[].obs;
  RxList<Rx<ServiceModel>> services = <Rx<ServiceModel>>[].obs;

  Map<int,List<FormFieldModel>> orderDetails = {};
  RxString orderState = "ALL".obs;

  GeneralHelper db = GeneralHelper();

  Rx<UserModel> user = UserModel().initialize().obs;
  Rx<UserTypes> searchType;

  ReportController(this.searchType);

  bool isEdit = false;


  late Rx<DateTime> fromDate;
  late Rx<DateTime> toDate;
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController title = TextEditingController();
 
  @override
  void onInit() {
    super.onInit();
    fromDate = DateTime.now().subtract(const Duration(days: 300)).obs;
    toDate = DateTime.now().obs;
  }


  fetchAllOrders([String additionalCondetion = ""]) async {
    orders.clear();
    orderDetails.clear();

    DateTime newFromDate = DateTime.parse(
        "${DateFormat('yyyy-MM-dd').format(fromDate.value)} 00:00");
    DateTime newToDate = DateTime.parse(
        "${DateFormat('yyyy-MM-dd').format(toDate.value)} 23:59");

    String filterByState = "";
    if(orderState.value != "ALL"){
      filterByState = " AND o.ORD_STATE = '${orderState.value}'";
    }

    await db.getAllAsMap("SELECT * FROM order_details as od inner join orders o on o.ORD_ID = od.ORD_ID "
    " INNER join form_fields as f on f.FRMF_ID = od.FRMF_ID WHERE o.INST_ID = ${StaticValue.userData!.institution!.institutionId} ").then((value) {
      for (var i = 0; i < value!.length; i++) {
        if(orderDetails[value[i]["ORD_ID"]] == null){
          orderDetails[value[i]["ORD_ID"]] = [];
        }
        orderDetails[value[i]["ORD_ID"]]!.add(FormFieldModel.fromMap(value[i]));
      }
    });
    await db.getAllAsMap("SELECT * FROM orders as o "//inner join qr_codes as q on q.QR_ID = o.QR_ID "
    " INNER JOIN users as us on us.USR_ID = o.USR_ID "
    " INNER JOIN services as s on s.SRV_ID = o.SRV_ID "
    " INNER JOIN institutions as i ON i.INST_ID = o.INST_ID "
    " WHERE ORD_REGISTER_AT between '$newFromDate' AND '$newToDate' $filterByState "
    "${/*StaticValue.userData!.userType == UserTypes.SUPER_ADMIN ? "" : */" AND o.INST_ID = ${StaticValue.userData!.institution!.institutionId}"};").then((value) {
      for (var i = 0; i < value!.length; i++) {
        orders.add(OrderModel.fromMap(value[i]).obs);
        orders[i].value.orderDetails = orderDetails[orders[i].value.orderId];
      }
    });
  }

  fetchAllComplaints() async {
    complaints.clear();
    
    DateTime newFromDate = DateTime.parse(
        "${DateFormat('yyyy-MM-dd').format(fromDate.value)} 00:00");
    DateTime newToDate = DateTime.parse(
        "${DateFormat('yyyy-MM-dd').format(toDate.value)} 23:59");

    await db.getAllAsMap("SELECT * FROM complaints as c "//inner join qr_codes as q on q.QR_ID = o.QR_ID "
  " INNER JOIN users as us on us.USR_ID = c.USR_ID "
  " LEFT JOIN complaint_types as ct on ct.COMT_ID = c.COMT_ID "
    " WHERE COMP_CREATED_DATE between '$newFromDate' AND '$newToDate' "
    "${/*StaticValue.userData!.userType == UserTypes.SUPER_ADMIN ? "" : */" AND c.INST_ID = ${StaticValue.userData!.institution!.institutionId}"};").then((value) {
      for (var i = 0; i < value!.length; i++) {
        complaints.add(ComplaintModel.fromMap(value[i]).obs);
      }
    });
  }
  
  fetchAllService() async {
    services.clear();
    await db.getAllAsMap("SELECT * FROM services as s "
    " WHERE s.INST_ID = ${StaticValue.userData!.institution!.institutionId} AND s.SRV_STATE != -1;").then((value) {
      for (var i = 0; i < value!.length; i++) {
        services.add(ServiceModel.fromMap(value[i]).obs);
      }
    });
  }

  Future<bool> getAllUsersDialog() async {
      int userId = StaticValue.userData!.userId!;

    List<UserModel> users =[];
        await db.getAllAsMap("SELECT * FROM users where USR_ID != $userId And INST_ID = ${StaticValue.userData!.institution!.institutionId} AND (USR_NUMBER Like '%${user.value.userNumber!.text}%' or USR_NAME Like '%${user.value.userNumber!.text}%') AND (USR_TYPE = ${searchType.value == UserTypes.CITIZEN ? "'CITIZEN'":searchType.value.name})").then((value) {
          for (var i = 0; i < value!.length; i++) {
            users.add(UserModel.fromMap(value[i]));
          }
        });
    if (users.length > 1) {
      UserModel result = await showDialog(
          context: Get.overlayContext!,
          builder: (context) {
            return ChooseUserDialog(
                isTablet: MediaQuery.of(context).size.width > 600,
                users: users);
          });
      if (result.userId != -1) {
        user.value = result;
        return true;
      } 
      // else {
      //   order[orderInstanceIndex.value].update((val) {
      //     val!.sellDetails![index].mainCategoryName = TextEditingController();
      //     val.sellDetails![index].mainCategoryId = 0;
      //   });
      // }
    } else if (users.isNotEmpty) {
      UserModel result = users[0];
        user.value = result;

        return true;
    } else {
      snakbarDialog(title: 'thisAccountIsNotExist'.tr(), content: 'pleaseMakeSureOfUserNumber'.tr(),
       durationSecound: 10, color: redColor, icon: const Icon(Icons.cancel_rounded, color: Colors.white, size: 30));
       return false;
    }
       return false;
  }

  printRrport(int reportIndex)async{
    GeneralController controller = Get.put(GeneralController());
    // await fetchAllOrders(reportIndex==1?" AND v.USR_SCANED_ID = ${user.value.userId}"
    // : reportIndex==2? " AND v.USR_CREATED_ID = ${user.value.userId} AND QR_ID != 0"
    // : reportIndex==3? " AND v.USR_CREATED_ID = ${user.value.userId} AND QR_ID = 0":"");
    if(reportIndex == 0){
      await fetchAllOrders();
      List details = [];
      for (var j = 0; j < orders.length; j++) {
          for (var i = 0; i < orders[j].value.orderDetails!.length; i++) {
            details.add([
              orders[j].value.orderId,
              orders[j].value.orderDetails![i].formFieldName!.getTitle,
              orders[j].value.orderDetails![i].formFieldType!.name,
              orders[j].value.orderDetails![i].formFieldValue!.text,
            ]); 
          }
      }
      Get.to(()=>ReportPage(
        exportExcel: ()async{
            await exportToExcelInTowSheets("orders-data.xlsx", [
          [
            "orderNumber",
            "orderCitizen".tr(),
            "phone".tr(),
            "orderState".tr(),
            "orderDate".tr(),
            "notes".tr(),
          ],
          ...orders.map((u) => [
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
            orders.map((element) => element.value).toList(),
            controller.settings.map((s) => s).toList(),
            title:"${"orderReport".tr()}\n${title.text}",
            showDetails: true,
            format: format,
          );
        },
      ));
    }
    else if(reportIndex == 1){
      await fetchAllComplaints();
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
                      ...complaints.map((u) => [
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
                complaints.map((element) => element.value).toList(),
                controller.settings.map((s) => s).toList(),
                title:"${"complaintReport".tr()}\n${title.text}",
                format: format,
              );
            },
          ));
    }
     else if(reportIndex == 2){
      await fetchAllService();
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
                    ...services.map((u) => [
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
            reportTitle: "printReport".tr(),
            widget: (PdfPageFormat format) async {
              return await serviceReport(
                services.map((element) => element.value).toList(),
                controller.settings.map((s) => s).toList(),
                title:"${"servicesReport".tr()}\n${title.text}",
                format: format,
              );
            },
          ));
    }
  }

}