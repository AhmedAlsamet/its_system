import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:intl/intl.dart';
import 'package:its_system/helper/db/general_helper.dart';
import 'package:its_system/models/code_model.dart';
import 'package:its_system/models/complaint_model.dart';
import 'package:its_system/models/general_model.dart';
import 'package:its_system/models/service_model.dart';
import 'package:its_system/models/order_model.dart';
import 'package:its_system/statics_values.dart';


class OrderController extends GetxController {

  RxList<Rx<OrderModel>> orders = <Rx<OrderModel>>[].obs;
  Map<int,List<FormFieldModel>> orderDetails = {};

  GeneralHelper db = GeneralHelper();
  RxBool isOverly = false.obs;
  TextEditingController searchController = TextEditingController();
  FocusNode searchNode = FocusNode();
  RxString orderState = "ALL".obs;
  RxString complaintType = "ALL".obs;
  RxString complaintState = "ALL".obs;

  bool withFetch = false;
  OrderController(this.withFetch);

  
  bool isEdit = false;

  RxInt orderType = 0.obs;

  late Rx<DateTime> fromDate;
  late Rx<DateTime> toDate;

  RxList<Rx<ComplaintModel>> complaints = <Rx<ComplaintModel>>[].obs;
  RxList<Rx<CodeModel>> complaintTypes = <Rx<CodeModel>>[].obs;

 
  @override
  void onInit() {
    super.onInit();
    fromDate = DateTime.now().subtract(const Duration(days: 300)).obs;
    toDate = DateTime.now().obs;
    if(withFetch){
      fetchAllOrders();
      fetchAllComplaints();
      fetchAllInstitutionServicesAndComplaintTypes();
    }
  }

  fetchAllInstitutionServicesAndComplaintTypes()async{
    complaintTypes.clear();
    await db.getAllAsMap("SELECT * FROM complaint_types WHERE COMT_IS_DELETE = 0 AND INST_ID = ${StaticValue.userData!.institution!.institutionId};").then((value) {
      for (var i = 0; i < value!.length; i++) {
        complaintTypes.add(CodeModel(
          codeId: value[i]["COMT_ID"],
          supperId: value[i]["INST_ID"],
          codeName: GeneralModel.fromMap(value[i], "COMT")
          ).obs);
      }
    });
    complaintTypes.refresh();
  }

  fetchAllOrders() async {
    orders.clear();
    orderDetails.clear();

    DateTime newFromDate = DateTime.parse(
        "${DateFormat('yyyy-MM-dd').format(fromDate.value)} 00:00");
    DateTime newToDate = DateTime.parse(
        "${DateFormat('yyyy-MM-dd').format(toDate.value)} 23:59");
    String additionCondition = await db.getTableColumnWithPutSearchValue("orders","o",["ORD_REGISTER_AT"],["USR_NAME","SRV_NAME"],searchController.value.text);

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
    " WHERE  $additionCondition  AND ORD_REGISTER_AT between '$newFromDate' AND '$newToDate' $filterByState "
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
    String additionCondition = await db.getTableColumnWithPutSearchValue("complaints","c",[],["USR_NAME"],searchController.value.text);

    String filterByState = "";
    if(complaintState.value != "ALL"){
      filterByState = " AND c.COMP_STATE = '${complaintState.value}'";
    }

    String filterByType = "";
    if(complaintType.value != "ALL"){
      filterByType = " AND c.COMT_ID = ${complaintType.value}";
    }


    await db.getAllAsMap("SELECT * FROM complaints as c "//inner join qr_codes as q on q.QR_ID = o.QR_ID "
  " INNER JOIN users as us on us.USR_ID = c.USR_ID "
  " LEFT JOIN complaint_types as ct on ct.COMT_ID = c.COMT_ID "
    " WHERE  $additionCondition  AND COMP_CREATED_DATE between '$newFromDate' AND '$newToDate' $filterByState $filterByType "
    "${/*StaticValue.userData!.userType == UserTypes.SUPER_ADMIN ? "" : */" AND c.INST_ID = ${StaticValue.userData!.institution!.institutionId}"};").then((value) {
      for (var i = 0; i < value!.length; i++) {
        complaints.add(ComplaintModel.fromMap(value[i]).obs);
      }
    });
  }
}