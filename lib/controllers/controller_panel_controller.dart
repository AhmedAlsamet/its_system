import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:ionicons/ionicons.dart';
import 'package:its_system/models/complaint_model.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/constants.dart';
import 'package:its_system/core/models/daily_info_model.dart';
import 'package:its_system/helper/db/general_helper.dart';
import 'package:its_system/models/user_model.dart';
import 'package:its_system/models/order_model.dart';
import 'package:its_system/statics_values.dart';

class ControllerPanelController extends GetxController {


  RxList<Rx<UserModel>> users = <Rx<UserModel>>[].obs;
  RxList<Rx<OrderModel>> orders = <Rx<OrderModel>>[].obs;
  RxList<Rx<ComplaintModel>> complaints = <Rx<ComplaintModel>>[].obs;

  GeneralHelper db = GeneralHelper();
  RxDouble defaultPadding = 10.0.obs;


  
  Rx<UserModel> user = UserModel().obs;
  String externalImageStorage = '';
  bool isEdit = false;
  late GlobalKey<FormState> formKey;

  TextEditingController passwordController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  FocusNode searchNode = FocusNode();

  RxList<Rx<DailyInfoModel>> chartsData = <Rx<DailyInfoModel>>[].obs;

  late Timer timer;

  RxBool showArchiveComplaint = false.obs;



  @override
  void onInit() async{
    super.onInit();
    refershAll();
    timer = Timer.periodic(
      const Duration(minutes: 10), (t) async{ 
        int id = StaticValue.userData!.userId!;
        if(id != 0) {
          await fetchAllEmployees();
          await fetchAllOrders();
          await fetchAllComplaints();
          for (var i = 0; i < 3; i++) {
            changeChartData(i);
          }
        }
    });
  }


initializeCharts()async{
  int userLength = users.where((u) => u.value.userType == UserTypes.ADMIN).length;
  int ordersNumber = orders.length;
  int successOrders = orders.where((u) => u.value.orderState ==  OrderState.DONE).length;
  int failsOrders = orders.where((u) => u.value.orderState ==  OrderState.CANCELED).length;
  int complaintsNumber = complaints.length;

  List newList = [
    {
    "id":1,
    "selectedBy" : "ALL",
    "title": "employees".tr(),
    "volumeData": userLength,
    "allVolumeData":userLength,
    "icon": Icons.business_sharp,
    "totalStorage": "employee".tr(),
    "color": primaryColor,
    "percentage": userLength == 0 ? 0 : 100,
    "multiChoise":true,
    "colors": [
      const Color(0xff23b6e6),
      const Color(0xff02d39a),
    ],
    "spots": [
      FlSpot(
        1,
        2,
      ),
      FlSpot(
        2,
        1.0,
      ),
      FlSpot(
        3,
        1.8,
      ),
      FlSpot(
        4,
        1.5,
      ),
      FlSpot(
        5,
        1.0,
      ),
      FlSpot(
        6,
        2.2,
      ),
      FlSpot(
        7,
        1.8,
      ),
      FlSpot(
        8,
        1.5,
      )
    ]
  },
    {
    "id":2,
    "selectedBy" : "ALL",
    "title": "process".tr(),
    "volumeData": ordersNumber,
    "allVolumeData":ordersNumber,
    "icon": Icons.policy,
    "totalStorage": "order".tr(),
    "color": const Color(0xFF00F260),
    "percentage": ordersNumber == 0 ?0:100,
    "colors": [const Color(0xff0575E6), const Color(0xff00F260)],
    "spots": [
      FlSpot(
        1,
        1.3,
      ),
      FlSpot(
        2,
        1.0,
      ),
      FlSpot(
        3,
        1.8,
      ),
      FlSpot(
        4,
        1.5,
      ),
      FlSpot(
        5,
        1.0,
      ),
      FlSpot(
        6,
        2.2,
      ),
      FlSpot(
        7,
        1.8,
      ),
      FlSpot(
        8,
        1.5,
      )
    ]
  },
    {
    "id":3,
    "selectedBy" : "ALL",
    "title": "completed".tr(),
    "volumeData": successOrders,
    "allVolumeData": successOrders,
    "multiChoise":true,
    "color": const Color(0xFFA4CDFF),
    "colors": [const Color(0xff2980B9), const Color(0xff6DD5FA)],
    "icon": Icons.done,
    "totalStorage": "order".tr(),
    "percentage": successOrders == 0 ? 0 : 100,
    "spots": [
      FlSpot(
        1,
        1.3,
      ),
      FlSpot(
        2,
        1.0,
      ),
      FlSpot(
        3,
        4,
      ),
      FlSpot(
        4,
        1.5,
      ),
      FlSpot(
        5,
        1.0,
      ),
      FlSpot(
        6,
        3,
      ),
      FlSpot(
        7,
        1.8,
      ),
      FlSpot(
        8,
        1.5,
      )
    ]
  },
    {
    "id":4,
    "selectedBy" : "ALL",
    "title": "canceled".tr(),
    "volumeData": failsOrders,
    "allVolumeData":failsOrders,
    "icon": Ionicons.close_circle_outline,
    "totalStorage": "order".tr(),
    "percentage": failsOrders == 0 ? 0 : 100,
    "color": const Color(0xFFd50000),
    "colors": [const Color(0xff93291E), const Color(0xffED213A)],
    "spots": [
      FlSpot(
        1,
        1.3,
      ),
      FlSpot(
        2,
        5,
      ),
      FlSpot(
        3,
        1.8,
      ),
      FlSpot(
        4,
        6,
      ),
      FlSpot(
        5,
        1.0,
      ),
      FlSpot(
        6,
        2.2,
      ),
      FlSpot(
        7,
        1.8,
      ),
      FlSpot(
        8,
        1,
      )
    ]
  },
    {
    "id":5,
    "selectedBy" : "ALL",
    "title": "complaints".tr(),
    "volumeData": complaintsNumber,
    "allVolumeData":complaintsNumber,
    "icon": Ionicons.people_outline,
    "totalStorage": "complaint".tr(),
    "color": const Color(0xFFFFA113),
    "colors": [const Color(0xfff12711), const Color(0xfff5af19)],
    "percentage": complaintsNumber==0 ? 0 : 100,
    "spots": [
      FlSpot(
        1,
        3,
      ),
      FlSpot(
        2,
        4,
      ),
      FlSpot(
        3,
        1.8,
      ),
      FlSpot(
        4,
        1.5,
      ),
      FlSpot(
        5,
        1.0,
      ),
      FlSpot(
        6,
        2.2,
      ),
      FlSpot(
        7,
        1.8,
      ),
      FlSpot(
        8,
        1.5,
      )
    ]
  },
  ];

  for (var item in newList) {
    chartsData.add(DailyInfoModel.fromJson(item).obs);
  }
}

changeChartData(int index){
  DateTime date = DateTime.now().subtract(
    Duration(days: 
      chartsData[index].value.selectedBy == SelectedBy.DAY ? 1 :
      chartsData[index].value.selectedBy == SelectedBy.MONTH ? 30 :
      chartsData[index].value.selectedBy == SelectedBy.YEAR ? 365 : 0
      ));
  if(index == 0){
    chartsData[index].update((val) {
      if(chartsData[index].value.selectedBy == SelectedBy.ALL){
      val!.volumeData = val.allVolumeData;
      val.percentage = val.allVolumeData ==0 ? 0 : 100 ;
      }
      else{
      val!.volumeData = users.where((u) => (u.value.userType == UserTypes.ADMIN ) && u.value.userName!.createDate!.compareTo(date) >=0).length;
      val.percentage = val.allVolumeData ==0?0:(( val.volumeData! * 100) ~/ val.allVolumeData!);
      }
    });
  }
  if(index == 1){
    chartsData[index].update((val) {
      if(chartsData[index].value.selectedBy == SelectedBy.ALL){
      val!.volumeData = val.allVolumeData;
      val.percentage = val.allVolumeData ==0 ? 0 :100 ;
      }
      else{
      val!.volumeData = orders.where((u) => (u.value.orderRegisteredAt!.compareTo(date) >=0)).length;
      val.percentage = val.allVolumeData ==0?0:(( val.volumeData! * 100) ~/ val.allVolumeData!);
      }
    });
  }
  if(index == 2){
    chartsData[index].update((val) {
      if(chartsData[index].value.selectedBy == SelectedBy.ALL){
      val!.volumeData = val.allVolumeData;
      val.percentage = val.allVolumeData ==0 ? 0 :100 ;
      }
      else{
      val!.volumeData = orders.where((u) =>u.value.orderState == OrderState.DONE && u.value.orderRegisteredAt!.compareTo(date) >=0).length;
      val.percentage = val.allVolumeData ==0?0:(( val.volumeData! * 100) ~/ val.allVolumeData!);
      }
    });
  }
  if(index == 3){
    chartsData[index].update((val) {
      if(chartsData[index].value.selectedBy == SelectedBy.ALL){
      val!.volumeData = val.allVolumeData;
      val.percentage = val.allVolumeData ==0 ? 0 :100 ;
      }
      else{
      val!.volumeData = orders.where((u) =>u.value.orderState == OrderState.CANCELED && u.value.orderRegisteredAt!.compareTo(date) >=0).length;
      val.percentage = val.allVolumeData ==0?0:(( val.volumeData! * 100) ~/ val.allVolumeData!);
      }
    });
  }
  if(index == 4){
    chartsData[index].update((val) {
      if(chartsData[index].value.selectedBy == SelectedBy.ALL){
      val!.volumeData = val.allVolumeData;
      val.percentage = val.allVolumeData ==0 ? 0 :100 ;
      }
      else{
      val!.volumeData = complaints.where((u) =>u.value.date!.createDate!.compareTo(date) >=0).length;
      val.percentage = val.allVolumeData ==0?0:(( val.volumeData! * 100) ~/ val.allVolumeData!);
      }
    });
  }
  chartsData.refresh();
  }

fetchAllEmployees() async {
  users.clear();
  await db.getAllAsMap("SELECT * FROM users "
    " WHERE USR_STATE != 'DELETED';"
    ).then((value) {
      for (var i = 0; i < value!.length; i++) {
        users.add(UserModel.fromMap(value[i]).obs);
      }
      users.refresh();
    });
  }

fetchAllOrders() async {
  orders.clear();
  await db.getAllAsMap("SELECT * FROM orders as o "//inner join qr_codes as q on q.QR_ID = o.QR_ID "
  " INNER JOIN users as us on us.USR_ID = o.USR_ID "
  " WHERE o.INST_ID = ${StaticValue.userData!.institution!.institutionId};").then((value) {
    for (var i = 0; i < value!.length; i++) {
      orders.add(OrderModel.fromMap(value[i]).obs);
    }
  });
}

fetchAllComplaints() async {
  complaints.clear();
  await db.getAllAsMap("SELECT * FROM complaints as c "//inner join qr_codes as q on q.QR_ID = o.QR_ID "
  " INNER JOIN users as us on us.USR_ID = c.USR_ID "
  " LEFT JOIN complaint_types as ct on ct.COMT_ID = c.COMT_ID "
  " WHERE c.INST_ID = ${StaticValue.userData!.institution!.institutionId};").then((value) {
    for (var i = 0; i < value!.length; i++) {
      complaints.add(ComplaintModel.fromMap(value[i]).obs);
    }
    complaints.refresh();
  });
}

refershAll() async{
  chartsData.clear();
  await fetchAllComplaints();
  await fetchAllEmployees();
  await fetchAllOrders();
  initializeCharts();
  chartsData.refresh();
}



//List<FlSpot> spots = yValues.asMap().entries.map((e) {
//  return FlSpot(e.key.toDouble(), e.value);
//}).toList();

}