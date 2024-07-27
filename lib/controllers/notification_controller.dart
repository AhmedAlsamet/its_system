import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/constants.dart';
import 'package:its_system/core/utils/snakbar_dialog.dart';
import 'package:its_system/helper/db/general_helper.dart';
import 'package:its_system/models/institution_model.dart';
import 'package:its_system/models/general_model.dart';
import 'package:its_system/models/notification_model.dart';
import 'package:its_system/models/user_model.dart';
import 'package:its_system/pages/notification/components/chooes_user.dart';
import 'package:its_system/statics_values.dart';


class NotificationController extends GetxController {

  RxInt selectedItem = 0.obs;
  RxBool isOpenKeyboard = false.obs;
  bool forGetJustNotification = false;
  RxList<Rx<NotificationModel>> notifications = <Rx<NotificationModel>>[].obs;
  Rx<NotificationModel> notification = NotificationModel().initialize(
    notificationTitle: GeneralModel().initialize(
      arabicHint: "notificationTitle".tr(),
      englishHint: "notificationTitle".tr()
    ),
    notificationDetails: GeneralModel().initialize(
      arabicHint: "notificationDetails".tr(),
      englishHint: "notificationDetails".tr(),
    ),
  ).obs;
  GeneralHelper db = GeneralHelper();

  GlobalKey<FormState> formKey = GlobalKey();

  RxBool isOverly = false.obs;
  RxString searchType = "CITIZEN".obs;
  RxBool forAll = false.obs;

  RxBool forAllCitizens = false.obs;
  RxBool forAllAdmins = false.obs;
  RxBool forAllSuperAdmin = false.obs;

  TextEditingController searchController = TextEditingController();
  FocusNode searchNode = FocusNode();

  
  String externalImageStorage = '';
  bool isEdit = false;

  RxInt orderType = 0.obs;
  late Rx<DateTime> fromDate;
  late Rx<DateTime> toDate;

  RxInt lastNotification = 0.obs;

NotificationController(this.forGetJustNotification);
 
  @override
  void onInit() {
    super.onInit();
    fromDate = DateTime.now().subtract(const Duration(days: 360)).obs;
    toDate = DateTime.now().obs;
    fetchAllNotifications();
  }


  refreshNotification()async{
    notification.value = NotificationModel().initialize(
      institution: InstitutionModel(institutionId: StaticValue.userData!.institution!.institutionId),
      notificationTitle: GeneralModel().initialize(
        arabicHint: "notificationTitle".tr(),
        englishHint: "notificationTitle".tr(),
      ),
      notificationDetails: GeneralModel().initialize(
        arabicHint: "notificationDetails".tr(),
        englishHint: "notificationDetails".tr(),
      ),
    );
  }


  fetchAllNotifications() async {
    DateTime newFromDate = DateTime.parse(
        "${DateFormat('yyyy-MM-dd').format(fromDate.value)} 00:00");
    DateTime newToDate = DateTime.parse(
        "${DateFormat('yyyy-MM-dd').format(toDate.value)} 23:59");
    String additionCondition = await db.getTableColumnWithPutSearchValue("notifications","n",["NOT_CREATED_DATE","USR_ID","INST_ID"],[],searchController.value.text);
    notifications.clear();
    if(forGetJustNotification){ 
      int userId = StaticValue.userData!.userId!;
      String userType = StaticValue.userData!.userType!.name;
      int institutionId = StaticValue.userData!.institution!.institutionId!;
      await db.getAllAsMap("SELECT * FROM notifications as n "
      " INNER JOIN notfication_reservers as nr on nr.NOT_ID = n.NOT_ID "
      " INNER JOIN users as u on u.USR_ID = n.USR_ID "
      " LEFT JOIN institutions as i on i.INST_ID = n.INST_ID "
      " WHERE n.NOT_CREATED_DATE > u.USR_CREATED_DATE AND n.USR_ID != $userId AND /*(nr.INST_ID = $institutionId OR nr.INST_ID = 0) AND*/ (nr.USR_ID = $userId or (nr.USR_id = 0 and nr.NOT_TYPE = '$userType' ))"
      " ORDER BY n.NOT_ID DESC;").then((value) {
        for (var i = 0; i < value!.length; i++) {
          notifications.add(NotificationModel.fromMap(value[i]).obs);
        }
        if(notifications.isNotEmpty) {
          lastNotification.value = notifications.first.value.notificationId ?? 0;
        }
      });
    }
    else {
      await db.getAllAsMap("SELECT * FROM notifications as n INNER JOIN users as u on u.USR_ID = n.USR_ID "
      " WHERE  $additionCondition  AND NOT_CREATED_DATE between '$newFromDate' AND '$newToDate' "
      /*"${StaticValue.userData!.userType == UserTypes.SUPER_ADMIN ? " AND n.INST_ID = 0;" : */" AND n.INST_ID = ${StaticValue.userData!.institution!.institutionId};").then((value) {
      for (var i = 0; i < value!.length; i++) {
        notifications.add(NotificationModel.fromMap(value[i]).obs);
      }
    });
    }
    notifications.refresh();
  }

    addUpdateNotification()async {
    if(!isEdit){
      int id = await db.createNew("notifications",notification.value.toMap());
      if(id>0){
        await db.createMulti('notfication_reservers',getAllUsersReserver(id));
        snakbarDialog(title: 'done'.tr(), content: 'theOperatorIsDoneSeccessfuly'.tr(), durationSecound: 3, color: blueColor,icon: const Icon(Icons.check_circle,color: Colors.white,size: 30,));
      }
      else {
        snakbarDialog(
            title: 'errorTitle'.tr(),
            content: 'errorOcoredPleaseTryAgain'.tr(),
            durationSecound: 5,
            icon: const Icon(Icons.cancel_rounded, color: Colors.white, size: 30));
      }
      await fetchAllNotifications();
      Get.back();
    }
    else{

    if(await db.update(tableName: "notifications",primaryKey: "NOT_ID",primaryKeyValue: notification.value.notificationId,items: notification.value.toMap())>0){
        await db.delete(tableName: "notfication_reservers", where: "NOT_ID = ${notification.value.notificationId}");
        await db.createMulti('notfication_reservers',getAllUsersReserver(notification.value.notificationId!));
      snakbarDialog(title: 'done'.tr(),
       content: 'theOperatorIsDoneSeccessfuly'.tr(),
       durationSecound: 3, 
       color: blueColor,
       icon: const Icon(Icons.check_circle,color: Colors.white,size: 30,));
    }
          else {
        snakbarDialog(
            title: 'errorTitle'.tr(),
            content: 'errorOcoredPleaseTryAgain'.tr(),
            durationSecound: 5,
            color: redColor,
            icon: const Icon(Icons.cancel_rounded, color: Colors.white, size: 30));
      }
    await fetchAllNotifications();
    Get.back();
    }
  }

  List<Map<String,dynamic>> getAllUsersReserver(int notificationId){
    List<Map<String,dynamic>> result = [];
    if(forAll.value){
      if(forAllCitizens.value){
        result.add({"USR_ID" : 0,"INST_ID":StaticValue.userData!.institution!.institutionId,"NOT_TYPE" : "CITIZEN" ,"NOT_ID":notificationId});
      }
      if(forAllAdmins.value){
        result.add({"USR_ID" : 0,"INST_ID":StaticValue.userData!.institution!.institutionId,"NOT_TYPE" : "ADMIN" ,"NOT_ID":notificationId});
      }
      if(forAllSuperAdmin.value){
        result.add({"USR_ID" : 0,"INST_ID":StaticValue.userData!.institution!.institutionId,"NOT_TYPE" : "SUPER_ADMIN" ,"NOT_ID":notificationId});
      }
      return result;
    }
    for (var i = 0; i < notification.value.notificationReservers!.length; i++) {
      UserModel u = notification.value.notificationReservers![i];
        result.add({"USR_ID" : u.userId,"INST_ID":u.institution!.institutionId,"NOT_TYPE" : "CITIZEN" ,"NOT_ID":notificationId});
    }
    return result;
  }


Future<bool> getAllUsersDialog(int index) async {
      int userId = StaticValue.userData!.userId!;

    List<UserModel> users =[];
        await db.getAllAsMap("SELECT * FROM users where USR_ID != $userId "
        " And USR_NAME Like '%${notification.value.notificationReservers![index].userNumber!.text}%'"
        " And USR_UNIQUE_KEY Like '%${notification.value.notificationReservers![index].userNumber!.text}%' AND (USR_TYPE = ${searchType.value})").then((value) {
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
        notification.update((val) {
          val!.notificationReservers![index] = UserModel().copyWith(user: result);
        });
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
        notification.update((val) {
          val!.notificationReservers![index] = UserModel().copyWith(user: result);
        });

        return true;
    } else {
      snakbarDialog(title: 'thisAccountIsNotExist'.tr(), content: 'pleaseMakeSureOfUserNumber'.tr(),
       durationSecound: 10, color: redColor, icon: const Icon(Icons.cancel_rounded, color: Colors.white, size: 30));
       return false;
    }
       return false;
  }
}