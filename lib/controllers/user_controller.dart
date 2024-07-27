import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:intl/intl.dart';
import 'package:its_system/models/institution_model.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/constants.dart';
import 'package:its_system/core/utils/snakbar_dialog.dart';
import 'package:its_system/helper/db/general_helper.dart';
import 'package:its_system/models/general_model.dart';
import 'package:its_system/models/user_model.dart';
import 'package:its_system/statics_values.dart';

class UserController extends GetxController {

  RxInt selectedItem = 0.obs;
  RxBool isOpenKeyboard = false.obs;
  RxList<Rx<UserModel>> users = <Rx<UserModel>>[].obs;
  GeneralHelper db = GeneralHelper();
  late Rx<DateTime> fromDate;
  late Rx<DateTime> toDate;


  
  Rx<UserModel> user = UserModel().obs;
  String externalImageStorage = '';
  bool isEdit = false;
  late GlobalKey<FormState> formKey;

  TextEditingController passwordController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  FocusNode searchNode = FocusNode();


  RxInt testNumber = 5.obs;
  UserTypes userType = UserTypes.ADMIN;
  RxString userTypeForFilter = "ALL".obs;
  RxString connectingState= "ALL".obs;
  bool withFech;

  UserController(this.userType,[this.withFech = true]);

  @override
  void onInit() async{
    super.onInit();
    fromDate = DateTime.now().subtract(const Duration(days: 300)).obs;
    toDate = DateTime.now().obs;
    testNumber = 5.obs;
    formKey = GlobalKey<FormState>();
    if(withFech) {
      await fetchAllEmployees();
    }
  }


  fetchAllEmployees() async {
    users.clear();
    DateTime newFromDate = DateTime.parse(
        "${DateFormat('yyyy-MM-dd').format(fromDate.value)} 00:00");
    DateTime newToDate = DateTime.parse(
        "${DateFormat('yyyy-MM-dd').format(toDate.value)} 23:59");
    String filterByType = "";
    if(userTypeForFilter.value != "ALL"){
      filterByType = " AND USR_TYPE = '${userTypeForFilter.value}'";
    }

    String additionCustomer = await db.getTableColumnWithPutSearchValue("users","users",["USR_TYPE","USR_CREATED_DATE","USR_ID","INST_ID"],[],searchController.value.text);
    if(userType == UserTypes.SUPER_ADMIN){
      await db.getAllAsMap("SELECT * FROM users WHERE USR_STATE != 'DELETED' AND USR_TYPE  = 'SUPER_ADMIN';").then((value) {
        for (var i = 0; i < value!.length; i++) {
          users.add(UserModel.fromMap(value[i]).obs);
        }
      });
    }
    else{
      await db.getAllAsMap("SELECT * FROM users "
      " WHERE  $additionCustomer AND USR_CREATED_DATE between '$newFromDate' AND '$newToDate' AND ( USR_TYPE  ${userType == UserTypes.ADMIN ? " != 'CITIZEN' AND USR_TYPE != 'GUEST')" : "= 'CITIZEN')"} ${/*StaticValue.userData!.userType == UserTypes.SUPER_ADMIN ? "" : */
      " AND USR_STATE != 'DELETED' AND INST_ID = ${userType == UserTypes.CITIZEN ? 0 : StaticValue.userData!.institution!.institutionId}"} $filterByType;"
      ).then((value) {
        for (var i = 0; i < value!.length; i++) {
          users.add(UserModel.fromMap(value[i]).obs);
        }
        users.refresh();
      });
    }
  }

  refreshEmployee()async{

    user.value = UserModel().initialize(
      institution:userType != UserTypes.CITIZEN ? StaticValue.userData!.institution! : InstitutionModel().initialize(),
      city:StaticValue.userData!.institution!.city!,
      userName: GeneralModel().initialize(
        arabicHint: userType != UserTypes.CITIZEN ? "employeeName".tr():"citizenName".tr(),
        englishHint: userType != UserTypes.CITIZEN ? "employeeName".tr():"citizenName".tr(),
      ),
      userType: userType
    );
  }

  int getCurrentAccountId(){
    return users[selectedItem.value].value.userId!;
  }

  addUpdateEmployee()async {
    if(user.value.userNumber!.text == "" || user.value.userNumber!.text == "0"){
      user.value.userNumber!.text = ((await db.getByIdAsMap("SELECT IfNull(MAX(USR_NUMBER),0) AS N FROM users WHERE INST_ID = ${StaticValue.userData!.institution!.institutionId};"))["N"]+1).toString();
    }
    if(user.value.userType == UserTypes.SUPER_ADMIN){
      if(!isEdit){
        user.value.userUniqueKey!.text = user.value.userNumber!.text;
      }
    }else{
      user.value.userUniqueKey!.text = "${user.value.city!.cityId}${user.value.institution!.institutionId}${user.value.userNumber!.text}";
      if(!isEdit){
        if(await checkForm(column: "USR_NUMBER", value: user.value.userNumber!.text, message: "dublicateNumber".tr(),additionsalCondection: " AND INST_ID = ${user.value.institution!.institutionId} AND USR_STATE != 'DELETED' AND USR_ID != ${user.value.userId}")){
          return;
        }
      }
    }
    if(await checkForm(column: "USR_PHONE", value: user.value.userPhoneNumber!.text, message: "dublicatePhoneNumber".tr(),additionsalCondection: " /*AND INST_ID = ${user.value.institution!.institutionId} */ AND USR_STATE != 'DELETED' AND USR_ID != ${user.value.userId}")){
      return;
    }
    if(!isEdit){
      if(await db.createNew("users", await user.value.toMap(false))>0){
        snakbarDialog(title: 'done'.tr(), content: 'theOperatorIsDoneSeccessfuly'.tr(), durationSecound: 3, color: blueColor,icon: const Icon(Icons.check_circle,color: Colors.white,size: 30,));
      }
      else {
        snakbarDialog(
            title: 'errorTitle'.tr(),
            content: 'errorOcoredPleaseTryAgain'.tr(),
            durationSecound: 5,
            icon: const Icon(Icons.cancel_rounded, color: Colors.white, size: 30));
      }
      await fetchAllEmployees();
      Get.back();
    }
    else{

    if(await db.update(tableName: "users",primaryKey: "USR_ID",primaryKeyValue: user.value.userId,items: await user.value.toMap(true))>0){
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
    await fetchAllEmployees();
    Get.back();
    }
  }


  checkForm({required String column,required dynamic value,required String message,String additionsalCondection = ""})async{
    final e = await db.getByIdAsMap(" SELECT * FROM users WHERE ($column = $value) $additionsalCondection");
    if(e == null){
        await snakbarDialog(
          title: "errorTitle".tr(),
          content: "errorDBConnection".tr(),
          durationSecound: 5,
          icon:
              const Icon(Icons.cancel_rounded, color: Colors.white, size: 30));
        return true;
    }
    if(e is String && e == "NO ITEM"){
      return false;
    }
        await snakbarDialog(
          title: "repittedValue".tr(),
          content: message,
          durationSecound: 5,
          icon:
              const Icon(Icons.cancel_rounded, color: Colors.white, size: 30));
        return true;
  }
}