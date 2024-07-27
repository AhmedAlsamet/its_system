import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:intl/intl.dart';
import 'package:its_system/constants.dart';
import 'package:its_system/core/utils/snakbar_dialog.dart';
import 'package:its_system/functions.dart';
import 'package:its_system/helper/db/general_helper.dart';
import 'package:its_system/models/code_model.dart';
import 'package:its_system/models/complaint_model.dart';
import 'package:its_system/models/general_model.dart';
import 'package:its_system/models/institution_model.dart';
import 'package:its_system/models/order_model.dart';
import 'package:its_system/models/service_model.dart';
import 'package:its_system/pages/home/home_screen_for_mobile.dart';
import 'package:its_system/statics_values.dart';
import 'package:localize_and_translate/localize_and_translate.dart';



class HomeController extends GetxController {

  RxList<Rx<InstitutionModel>> institutions = <Rx<InstitutionModel>>[].obs;
  RxList<Rx<ServiceModel>> services = <Rx<ServiceModel>>[].obs;
  RxList<Rx<OrderModel>> orders = <Rx<OrderModel>>[].obs;
  RxList<Rx<CodeModel>> complaintTypes = <Rx<CodeModel>>[].obs;

  Rx<ServiceModel> service = ServiceModel().obs;
  Rx<OrderModel> order = OrderModel().obs;
  Rx<ComplaintModel> complaint = ComplaintModel().obs;
  GeneralHelper db = GeneralHelper();

  RxInt servicePage = 0.obs;
  RxInt currentStep = 0.obs;
  RxInt currentFormStep = 0.obs;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyForForms = GlobalKey<FormState>(debugLabel: "Form");
  List<GlobalKey<FormState>> formKeys = [];
  TextEditingController searchController = TextEditingController();
  
  bool isEdit = false;
 
  @override
  void onInit() async{
    super.onInit();
    await fetchAllInstitutions();
    await fetchAllOrders();
  }

  refreshOrder(ServiceModel service,InstitutionModel institution)async{
    formKeys.clear();
    currentFormStep.value = 0;
    order.value = OrderModel().initialize(
      userCreated: StaticValue.userData,
      institution: institution,
      service:service
    );
    order.value.service!.serviceForms = [];
    await db.getAllAsMap("SELECT sf.* FROM service_forms as sf inner join services s on s.SRV_ID = sf.SRV_ID "
    " WHERE  s.SRV_ID = ${service.serviceId} ").then((value) {
      for (var i = 0; i < value!.length; i++) {
        order.value.service!.serviceForms!.add(ServiceFormModel.fromMap(value[i])..formFields = []);
        formKeys.add(GlobalKey());
      }
    });

    await db.getAllAsMap("SELECT f.* FROM service_forms as sf inner join form_fields f on f.SRVF_ID = sf.SRVF_ID "
      " WHERE sf.SRV_ID = ${service.serviceId} AND SRVF_IS_CANCEL = 0;").then((value) {
        for (var i = 0; i < value!.length; i++) {
          FormFieldModel serviceFormFields = FormFieldModel.fromMap(value[i]);
          int ind = order.value.service!.serviceForms!.indexWhere((s) => s.serviceFormId == serviceFormFields.serviceForm!.serviceFormId);
          order.value.service!.serviceForms![ind].formFields!.add(serviceFormFields..formFieldDetails = []);
        }
      });
      await db.getAllAsMap("SELECT ff.* FROM service_forms as sf inner join form_fields f on f.SRVF_ID = sf.SRVF_ID "
      " INNER JOIN form_field_details as ff on ff.FRMF_ID = f.FRMF_ID "
      " WHERE sf.SRV_ID = ${service.serviceId} AND SRVF_IS_CANCEL = 0;").then((value) {
        for (var i = 0; i < value!.length; i++) {
          CodeModel fieldValue = CodeModel(
                codeId: value[i]["FRMFD_ID"],
                codeName: GeneralModel.fromMap(
                    value[i], "FRMFD"),
                supperId: value[i]["FRMF_ID"],
                    );
          for (var i = 0; i < order.value.service!.serviceForms!.length; i++) {
            int ind = order.value.service!.serviceForms![i].formFields!.indexWhere((s) => s.formFieldId == fieldValue.supperId);
            if(ind >=0) {
              order.value.service!.serviceForms![i].formFields![ind].formFieldDetails!.add(fieldValue);
            }
          }
        }
      });
  }

  refreshOrderWithValues(OrderModel orderCopy, ServiceModel service,InstitutionModel institution)async{
    formKeys.clear();
    currentFormStep.value = 0;
    order.value = OrderModel().copyWith(
      order: orderCopy
    );
    order.value.service!.serviceForms = [];
    await db.getAllAsMap("SELECT sf.* FROM service_forms as sf inner join services s on s.SRV_ID = sf.SRV_ID "
    " WHERE  s.SRV_ID = ${service.serviceId} ").then((value) {
      for (var i = 0; i < value!.length; i++) {
        order.value.service!.serviceForms!.add(ServiceFormModel.fromMap(value[i])..formFields = []);
      }
    });

    await db.getAllAsMap("SELECT f.*,FRMF_VALUE FROM service_forms as sf inner join form_fields f on f.SRVF_ID = sf.SRVF_ID "
      " INNER JOIN order_details as od on od.FRMF_ID = f.FRMF_ID "
      " WHERE sf.SRV_ID = ${service.serviceId} AND ORD_ID = ${order.value.orderId} AND SRVF_IS_CANCEL = 0;").then((value) {
        for (var i = 0; i < value!.length; i++) {
          FormFieldModel serviceFormFields = FormFieldModel.fromMap(value[i]);
          int ind = order.value.service!.serviceForms!.indexWhere((s) => s.serviceFormId == serviceFormFields.serviceForm!.serviceFormId);
          order.value.service!.serviceForms![ind].formFields!.add(serviceFormFields..formFieldDetails = []);
          formKeys.add(GlobalKey());
        }
      });
      await db.getAllAsMap("SELECT ff.* FROM service_forms as sf inner join form_fields f on f.SRVF_ID = sf.SRVF_ID "
      " INNER JOIN form_field_details as ff on ff.FRMF_ID = f.FRMF_ID "
      " WHERE sf.SRV_ID = ${service.serviceId} AND SRVF_IS_CANCEL = 0;").then((value) {
        for (var i = 0; i < value!.length; i++) {
          CodeModel fieldValue = CodeModel(
                codeId: value[i]["FRMFD_ID"],
                codeName: GeneralModel.fromMap(
                    value[i], "FRMFD"),
                supperId: value[i]["FRMF_ID"],
                    );
          for (var i = 0; i < order.value.service!.serviceForms!.length; i++) {
            int ind = order.value.service!.serviceForms![i].formFields!.indexWhere((s) => s.formFieldId == fieldValue.supperId);
            if(ind >=0) {
              order.value.service!.serviceForms![i].formFields![ind].formFieldDetails!.add(fieldValue);
            }
          }
        }
      });
  }

  refreshComplaint(InstitutionModel institution){
    complaint.value = ComplaintModel().initialize(
      user: StaticValue.userData,
      institution: institution,
      complaintType: CodeModel(codeId: 0)
    );
  }

  fetchAllInstitutions() async {
    institutions.clear();

    String additionCondition = await db.getTableColumnWithPutSearchValue("institutions","i",[],[],searchController.value.text);
    await db.getAllAsMap("SELECT * FROM institutions as i inner join municipalities as MUN on i.MUN_ID = MUN.MUN_ID INNER JOIN "
    " cities as c on c.CTY_ID = i.CTY_ID WHERE $additionCondition order by i.INST_MAIN_ID ;").then((value) {
      for (var i = 0; i < value!.length; i++) {
        institutions.add(InstitutionModel.fromMap(value[i]).obs);
      }
    });
    institutions.refresh();
  }

  fetchAllInstitutionServicesAndComplaintTypes(int id)async{
    services.clear();
    complaintTypes.clear();
    await db.getAllAsMap("SELECT * FROM services as s INNER JOIN service_groups as sg on s.SRVG_ID = sg.SRVG_ID  WHERE SRV_STATE != -1 AND s.INST_ID = $id;").then((value) {
      for (var i = 0; i < value!.length; i++) {
        services.add(ServiceModel.fromMap(value[i]).obs);
      }
    });
    await db.getAllAsMap("SELECT * FROM complaint_types WHERE COMT_IS_DELETE = 0 AND INST_ID = $id;").then((value) {
      for (var i = 0; i < value!.length; i++) {
        complaintTypes.add(CodeModel(
          codeId: value[i]["COMT_ID"],
          supperId: value[i]["INST_ID"],
          codeName: GeneralModel.fromMap(value[i], "COMT")
          ).obs);
      }
      complaint.value.complaintType = complaintTypes.firstOrNull?.value;
    });
    services.refresh();
  }

  fetchServiceDetaisl(ServiceModel service)async{
    this.service.value = ServiceModel().copyWith(service: service);
    this.service.value.serviceGuides = [];
    this.service.value.servicePlaces = [];
    this.service.value.serviceForms = [];
    await fetchAllForms(service.serviceId!);
    await fetchAllGuides(service.serviceId!);
    await fetchAllPlaces(service.serviceId!);
    await fetchAllFormFields(service.serviceId!);
    await refreshOrder(service,service.institution!);
  }

  fetchAllGuides(int id) async {

    await db.getAllAsMap("SELECT sg.* FROM service_guides as sg inner join services s on s.SRV_ID = sg.SRV_ID "
    " WHERE s.SRV_STATE != -1 AND SG_IS_CANCEL = 0 AND s.SRV_ID = $id;").then((value) {
      for (var i = 0; i < value!.length; i++) {
        service.value.serviceGuides!.add(ServiceGuideModel.fromMap(value[i]));
      }
    });
  }
  
  fetchAllPlaces(int id) async {
    await db.getAllAsMap("SELECT sp.*,i.* FROM service_places as sp inner join services s on s.SRV_ID = sp.SRV_ID "
    " INNER JOIN institutions as i on i.INST_ID = sp.INST_ID "
    " WHERE s.SRV_STATE != -1 AND s.SRV_ID = $id ;").then((value) {
      for (var i = 0; i < value!.length; i++) {
        service.value.servicePlaces!.add(ServicePlaceModel.fromMap(value[i]));
      }
    });
  }
  
  fetchAllForms(int id) async {
    await db.getAllAsMap("SELECT sf.* FROM service_forms as sf inner join services s on s.SRV_ID = sf.SRV_ID "
    " WHERE s.SRV_STATE != -1 AND SRVF_IS_CANCEL = 0 AND s.SRV_ID = $id;").then((value) {
      for (var i = 0; i < value!.length; i++) {
        service.value.serviceForms!.add(ServiceFormModel.fromMap(value[i])..formFields = []);
      }
    });
  }
  
  fetchAllFormFields(int id) async {
    await db.getAllAsMap("SELECT f.* FROM service_forms as sf inner join form_fields f on f.SRVF_ID = sf.SRVF_ID "
    " WHERE sf.SRV_ID = $id AND SRVF_IS_CANCEL = 0;").then((value) {
      for (var i = 0; i < value!.length; i++) {
        FormFieldModel serviceFormFields = FormFieldModel.fromMap(value[i]);
        int ind = service.value.serviceForms!.indexWhere((s) => s.serviceFormId == serviceFormFields.serviceForm!.serviceFormId);
        service.value.serviceForms![ind].formFields!.add(serviceFormFields..formFieldDetails = []);
      }
    });
    await db.getAllAsMap("SELECT ff.* FROM service_forms as sf inner join form_fields f on f.SRVF_ID = sf.SRVF_ID "
    " INNER JOIN form_field_details as ff on ff.FRMF_ID = f.FRMF_ID "
    " WHERE sf.SRV_ID = $id AND SRVF_IS_CANCEL = 0;").then((value) {
      for (var i = 0; i < value!.length; i++) {
        CodeModel fieldValue = CodeModel(
              codeId: value[i]["FRMFD_ID"],
              codeName: GeneralModel.fromMap(
                  value[i], "FRMFD"),
              supperId: value[i]["FRMF_ID"],
                  );
        for (var i = 0; i < service.value.serviceForms!.length; i++) {
          int ind = service.value.serviceForms![i].formFields!.indexWhere((s) => s.formFieldId == fieldValue.supperId);
          if(ind >=0) {
            service.value.serviceForms![i].formFields![ind].formFieldDetails!.add(fieldValue);
          }
        }
      }
    });
    services.refresh();
  }

  addUpdateOrder()async {
      Get.offAll(()=>const HomeScreenForMoble());
      // if(service.value.serviceGroup!.serviceGroupId == 0){
      //   snakbarDialog(
      //       title: 'errorTitle'.tr(),
      //       content: "youMustChooseServiceGroup".tr(),
      //       durationSecound: 5,
      //       icon: const Icon(Icons.cancel_rounded, color: Colors.white, size: 30));
      //   return;
      // }
      if(!isEdit){
        order.value.orderId = await db.createNew("orders", order.value.toMap());
        if(order.value.orderId! > 0 ){
          await db.createMulti('order_details',await getAllUsersReserver(order.value.orderId!));
          snakbarDialog(title: 'done'.tr(), content: 'theOperatorIsDoneSeccessfuly'.tr(), durationSecound: 3, color: blueColor,icon: const Icon(Icons.check_circle,color: Colors.white,size: 30,));
        }
        else {
          snakbarDialog(
              title: 'errorTitle'.tr(),
              content: 'errorOcoredPleaseTryAgain'.tr(),
              durationSecound: 5,
              icon: const Icon(Icons.cancel_rounded, color: Colors.white, size: 30));
        }
      }
      else{
      if(await db.update(tableName: "orders",primaryKey: "ORD_ID",primaryKeyValue: order.value.orderId,items: order.value.toMap())>0){
        await db.delete(tableName: "order_details", where: "ORD_ID = ${order.value.orderId}");
        await db.createMulti('order_details',await getAllUsersReserver(order.value.orderId!));
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
      }
    }

  addNewComplaint()async {
    Get.back();
    if(await db.createNew("complaints", complaint.value.toMap(false))>0){
      snakbarDialog(title: 'done'.tr(), content: 'theOperatorIsDoneSeccessfuly'.tr(), durationSecound: 3, color: blueColor,icon: const Icon(Icons.check_circle,color: Colors.white,size: 30,));
    }
    else {
      snakbarDialog(
          title: 'errorTitle'.tr(),
          content: 'errorOcoredPleaseTryAgain'.tr(),
          durationSecound: 5,
          icon: const Icon(Icons.cancel_rounded, color: Colors.white, size: 30));
    }
  }

  Future<List<Map<String,dynamic>>> getAllUsersReserver(int orderId)async{
    List<Map<String,dynamic>> result = [];
    for (var i = 0; i < order.value.service!.serviceForms!.length; i++) {
      for (var j = 0; j < order.value.service!.serviceForms![i].formFields!.length; j++) {
        FormFieldModel f = order.value.service!.serviceForms![i].formFields![j];
        if((f.formFieldType == FormFieldTypes.PDF_FILE ||  f.formFieldType == FormFieldTypes.IMAGE_FILE) && f.formFieldValue!.text != "") {
            if(await File(f.formFieldValue!.text).exists()) {
              f.formFieldValue!.text = await postRequestWithFile("order_files",
                int.parse(DateFormat("yyyyMMddHHmmss").format(DateTime.now())),File(f.formFieldValue!.text));
            }
        }
        result.add({"FRMF_ID" : f.formFieldId,"FRMF_VALUE":f.formFieldValue!.text,"FRMF_TYPE" : f.formFieldType!.name ,"ORD_ID":orderId});
      }
    }
    return result;
  }

  fetchAllOrders() async {
    orders.clear();
    await db.getAllAsMap("SELECT * FROM orders as o inner join services as s on s.SRV_ID = o.SRV_ID "
    " INNER JOIN institutions as i ON i.INST_ID = o.INST_ID "
    " WHERE o.USR_ID = ${StaticValue.userData!.userId} "
    " order by o.ORD_ID ;").then((value) {
      for (var i = 0; i < value!.length; i++) {
        orders.add(OrderModel.fromMap(value[i]).obs);
      }
    });
    orders.refresh();
  }

}