import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:its_system/constants.dart';
import 'package:its_system/core/utils/snakbar_dialog.dart';
import 'package:its_system/helper/db/general_helper.dart';
import 'package:its_system/models/code_model.dart';
import 'package:its_system/models/general_model.dart';
import 'package:its_system/models/institution_model.dart';
import 'package:its_system/models/service_model.dart';
import 'package:its_system/pages/service/components/chooes_institution.dart';
import 'package:its_system/statics_values.dart';
import 'package:localize_and_translate/localize_and_translate.dart';


class ServiceController extends GetxController {

  RxList<Rx<ServiceModel>> services = <Rx<ServiceModel>>[].obs;
  Rx<ServiceModel> service = ServiceModel().obs;
  Rx<ServiceGuideModel> serviceGuide = ServiceGuideModel().obs;
  Rx<ServicePlaceModel> servicePlace = ServicePlaceModel().obs;
  Rx<ServiceFormModel> serviceForm = ServiceFormModel().obs;
  Rx<FormFieldModel> formField = FormFieldModel().obs;
  RxList<Rx<ServiceGuideModel>> serviceGuides = <Rx<ServiceGuideModel>>[].obs;
  RxList<Rx<ServicePlaceModel>> servicePlaces = <Rx<ServicePlaceModel>>[].obs;
  RxList<Rx<ServiceFormModel>> serviceForms = <Rx<ServiceFormModel>>[].obs;

  GeneralHelper db = GeneralHelper();
  RxBool isOverly = false.obs;
  TextEditingController searchController = TextEditingController();
  FocusNode searchNode = FocusNode();
  RxString orderState = "ALL".obs;
  RxString orderTypeForFilter = "ALL".obs;
  RxList<Rx<ServiceGroupModel>> serviceGroups = <Rx<ServiceGroupModel>>[].obs;

  bool withFetch = false;
  ServiceController(this.withFetch);

  
  bool isEdit = false;
  late GlobalKey<FormState> formKey;

  RxInt selectedGroup = 0.obs;


 
  @override
  void onInit() async{
    super.onInit();
    formKey = GlobalKey<FormState>();
    if(withFetch){
      await fetchAll();
      await fetchAllGroups();
    }
  }

  refreshService()async{
    service.value = ServiceModel().initialize(
      institution:StaticValue.userData!.institution!,
      serviceName: GeneralModel().initialize(
        arabicHint: "serviceName".tr(),
        englishHint: "serviceName".tr(),
      ),
      serviceDescription: GeneralModel().initialize(
        arabicHint: "serviceDesc".tr(),
        englishHint: "serviceDesc".tr(),
      ),
      serviceGroup : ServiceGroupModel().initialize(serviceGroupId: serviceGroups.first.value.serviceGroupId)
    );
  }
  
  refreshServiceGuide(int serviceIndex,int mainId)async{
    serviceGuide.value = ServiceGuideModel().initialize(
      institution:StaticValue.userData!.institution!,
      serviceGuideName: GeneralModel().initialize(
        arabicHint: "serviceGuideName".tr(),
        englishHint: "serviceGuideName".tr(),
      ),
      service: services[serviceIndex].value,
      serviceGuideMainId: mainId
    );
  }
  
  refreshServiceForm(int serviceIndex)async{
    serviceForm.value = ServiceFormModel().initialize(
      institution:StaticValue.userData!.institution!,
      serviceFormName: GeneralModel().initialize(
        arabicHint: "serviceFormFieldName".tr(),
        englishHint: "serviceFormFieldName".tr(),
      ),
      serviceFormDescription: GeneralModel().initialize(
        arabicHint: "serviceDescName".tr(),
        englishHint: "serviceDescName".tr(),
      ),
      service: services[serviceIndex].value,
    );
  }
  
  refreshServicePlace(int serviceIndex)async{
    servicePlace.value = ServicePlaceModel().initialize(
      institution:StaticValue.userData!.institution!,
      service: services[serviceIndex].value,
    );
  }
  
  refreshFormField(int serviceIndex,ServiceFormModel serviceForm)async{
    formField.value = FormFieldModel().initialize(
      institution:StaticValue.userData!.institution!,
      formFieldName: GeneralModel().initialize(
        arabicHint: "FormFieldName".tr(),
        englishHint: "FormFieldName".tr(),
      ),
      serviceForm: serviceForm
    );
    formField.value.formFieldDetails = [];
  }
  
  fetchAllGroups()async{
    serviceGroups.clear();
    await db.getAllAsMap("SELECT * FROM service_groups WHERE SRVG_IS_DELETE = 0").then((value) {
      for (var i = 0; i < value!.length; i++) {
        serviceGroups.add(ServiceGroupModel.fromMap(value[i]).obs);
      }
      selectedGroup.value = serviceGroups.first.value.serviceGroupId!;
    });
  }
  
  fetchAll() async {
    services.clear();
    servicePlaces.clear();
    String additionCondition = await db.getTableColumnWithPutSearchValue("services","s",[],[],searchController.value.text);
    String filterByState = "";
    if(orderState.value != "ALL"){
      filterByState = " AND o.ORD_STATE = '${orderState.value}'";
    }
    String filterByType = "";
    if(orderTypeForFilter.value != "ALL"){
      filterByType = " AND o.QR_ID ${orderTypeForFilter.value}";
    }

    await db.getAllAsMap("SELECT * FROM services as s "
    " WHERE  $additionCondition $filterByState $filterByType "
    " AND s.INST_ID = ${StaticValue.userData!.institution!.institutionId} AND s.SRV_STATE != -1;").then((value) {
      for (var i = 0; i < value!.length; i++) {
        services.add(ServiceModel.fromMap(value[i]).obs);
        services[i].value.serviceGuides = [];
        services[i].value.serviceForms = [];
        services[i].value.servicePlaces = [];
      }
    });
    await fetchAllForms(additionCondition);
    await fetchAllGuides(additionCondition);
    await fetchAllPlaces(additionCondition);
  }

  fetchAllForms([String additionCondition = ""]) async {
      serviceForms.clear();
      for (var element in services) {element.value.serviceForms!.clear();}
      if(additionCondition=="") {
        additionCondition = await db.getTableColumnWithPutSearchValue("services","s",[],[],searchController.value.text);
      }

      String filterByState = "";
      if(orderState.value != "ALL"){
        filterByState = " AND o.ORD_STATE = '${orderState.value}'";
      }
      String filterByType = "";
      if(orderTypeForFilter.value != "ALL"){
        filterByType = " AND o.QR_ID ${orderTypeForFilter.value}";
      }

      await db.getAllAsMap("SELECT sf.* FROM service_forms as sf inner join services s on s.SRV_ID = sf.SRV_ID "
      " WHERE  $additionCondition $filterByState $filterByType "
      " AND s.INST_ID = ${StaticValue.userData!.institution!.institutionId} AND s.SRV_STATE != -1 AND SRVF_IS_CANCEL = 0;").then((value) {
        for (var i = 0; i < value!.length; i++) {
          serviceForms.add(ServiceFormModel.fromMap(value[i]).obs);
          int index = services.indexWhere((s) {
            return s.value.serviceId == serviceForms[i].value.service!.serviceId;
          });
          services[index].value.serviceForms!.add(serviceForms[i].value..formFields = []);
        }
      });
    }
  
  fetchAllGuides([String additionCondition = ""]) async {
      serviceGuides.clear();
      for (var element in services) {element.value.serviceGuides!.clear();}
      if(additionCondition=="") {
        additionCondition = await db.getTableColumnWithPutSearchValue("services","s",[],[],searchController.value.text);
      }

      String filterByState = "";
      if(orderState.value != "ALL"){
        filterByState = " AND o.ORD_STATE = '${orderState.value}'";
      }
      String filterByType = "";
      if(orderTypeForFilter.value != "ALL"){
        filterByType = " AND o.QR_ID ${orderTypeForFilter.value}";
      }

      await db.getAllAsMap("SELECT sg.* FROM service_guides as sg inner join services s on s.SRV_ID = sg.SRV_ID "
      " WHERE  $additionCondition $filterByState $filterByType "
      " AND s.INST_ID = ${StaticValue.userData!.institution!.institutionId} AND s.SRV_STATE != -1 AND SG_IS_CANCEL = 0;").then((value) {
        for (var i = 0; i < value!.length; i++) {
          serviceGuides.add(ServiceGuideModel.fromMap(value[i]).obs);
          int index = services.indexWhere((s) {
            return s.value.serviceId == serviceGuides[i].value.service!.serviceId;
          });
          services[index].value.serviceGuides!.add(serviceGuides[i].value);
        }
      });
    }

  fetchAllPlaces([String additionCondition = ""]) async {
      servicePlaces.clear();
      for (var element in services) {element.value.servicePlaces!.clear();}
      if(additionCondition=="") {
        additionCondition = await db.getTableColumnWithPutSearchValue("services","s",[],[],searchController.value.text);
      }

      String filterByState = "";
      if(orderState.value != "ALL"){
        filterByState = " AND o.ORD_STATE = '${orderState.value}'";
      }
      String filterByType = "";
      if(orderTypeForFilter.value != "ALL"){
        filterByType = " AND o.QR_ID ${orderTypeForFilter.value}";
      }

      await db.getAllAsMap("SELECT sp.*,i.* FROM service_places as sp inner join services s on s.SRV_ID = sp.SRV_ID "
      " INNER JOIN institutions as i on i.INST_ID = sp.INST_ID "
      " WHERE  $additionCondition $filterByState $filterByType "
      " AND s.INST_ID = ${StaticValue.userData!.institution!.institutionId} AND s.SRV_STATE != -1;").then((value) {
        for (var i = 0; i < value!.length; i++) {
          servicePlaces.add(ServicePlaceModel.fromMap(value[i]).obs);
          int index = services.indexWhere((s) {
            return s.value.serviceId == servicePlaces[i].value.service!.serviceId;
          });
          services[index].value.servicePlaces!.add(servicePlaces[i].value);
        }
      });
    }

  fetchAllFormFields(int index) async {
      for (var element in services) {
        for (var f in element.value.serviceForms!) {
          f.formFields!.clear();
        }
      }
        formField.value.formFieldDetails = [];
      await db.getAllAsMap("SELECT f.* FROM service_forms as sf inner join form_fields f on f.SRVF_ID = sf.SRVF_ID "
      " WHERE sf.SRV_ID = ${services[index].value.serviceId} AND SRVF_IS_CANCEL = 0;").then((value) {
        for (var i = 0; i < value!.length; i++) {
          FormFieldModel serviceFormFields = FormFieldModel.fromMap(value[i]);
          int ind = services[index].value.serviceForms!.indexWhere((s) => s.serviceFormId == serviceFormFields.serviceForm!.serviceFormId);
          services[index].value.serviceForms![ind].formFields!.add(serviceFormFields..formFieldDetails = []);
        }
      });
      await db.getAllAsMap("SELECT ff.* FROM service_forms as sf inner join form_fields f on f.SRVF_ID = sf.SRVF_ID "
      " INNER JOIN form_field_details as ff on ff.FRMF_ID = f.FRMF_ID "
      " WHERE sf.SRV_ID = ${services[index].value.serviceId} AND SRVF_IS_CANCEL = 0;").then((value) {
        for (var i = 0; i < value!.length; i++) {
          CodeModel fieldValue = CodeModel(
                codeId: value[i]["FRMFD_ID"],
                codeName: GeneralModel.fromMap(
                    value[i], "FRMFD"),
                supperId: value[i]["FRMF_ID"],
                    );
          for (var i = 0; i < services[index].value.serviceForms!.length; i++) {
            int ind = services[index].value.serviceForms![i].formFields!.indexWhere((s) => s.formFieldId == fieldValue.supperId);
            if(ind >=0) {
              services[index].value.serviceForms![i].formFields![ind].formFieldDetails!.add(fieldValue);
            }
          }
        }
        if(formField.value.serviceForm!=null) {
          formField.update((val) {
            val!.formFieldDetails = services[index].value.serviceForms!.firstWhereOrNull((s) => s.serviceFormId == formField.value.serviceForm!.serviceFormId!)?.formFields!.firstWhereOrNull((s) => s.formFieldId == formField.value.formFieldId!)?.formFieldDetails;        
          });
        }
      });
      services.refresh();
    }

  addUpdateService()async {
      if(service.value.serviceGroup!.serviceGroupId == 0){
        snakbarDialog(
            title: 'errorTitle'.tr(),
            content: "youMustChooseServiceGroup".tr(),
            durationSecound: 5,
            icon: const Icon(Icons.cancel_rounded, color: Colors.white, size: 30));
        return;
      }
      if(!isEdit){
        if(await db.createNew("services", service.value.toMap(false))>0){
          snakbarDialog(title: 'done'.tr(), content: 'theOperatorIsDoneSeccessfuly'.tr(), durationSecound: 3, color: blueColor,icon: const Icon(Icons.check_circle,color: Colors.white,size: 30,));
        }
        else {
          snakbarDialog(
              title: 'errorTitle'.tr(),
              content: 'errorOcoredPleaseTryAgain'.tr(),
              durationSecound: 5,
              icon: const Icon(Icons.cancel_rounded, color: Colors.white, size: 30));
        }
        await fetchAll();
        Get.back();
      }
      else{

      if(await db.update(tableName: "services",primaryKey: "SRV_ID",primaryKeyValue: service.value.serviceId,items: service.value.toMap(true))>0){
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
      await fetchAll();
      Get.back();
      }
    }

  addUpdateServiceGuide()async {
      if(!isEdit){
        if(await db.createNew("service_guides", await serviceGuide.value.toMap(false))>0){
          snakbarDialog(title: 'done'.tr(), content: 'theOperatorIsDoneSeccessfuly'.tr(), durationSecound: 3, color: blueColor,icon: const Icon(Icons.check_circle,color: Colors.white,size: 30,));
        }
        else {
          snakbarDialog(
              title: 'errorTitle'.tr(),
              content: 'errorOcoredPleaseTryAgain'.tr(),
              durationSecound: 5,
              icon: const Icon(Icons.cancel_rounded, color: Colors.white, size: 30));
        }
        await fetchAllGuides();
        Get.back();
      }
      else{

      if(await db.update(tableName: "service_guides",primaryKey: "SG_ID",primaryKeyValue: serviceGuide.value.serviceGuideId,items: await serviceGuide.value.toMap(true))>0){
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
      await fetchAllGuides();
      Get.back();
      }
    }

  addUpdateServiceForm(int index)async {
      if(!isEdit){
        if(await db.createNew("service_forms", serviceForm.value.toMap(false))>0){
          snakbarDialog(title: 'done'.tr(), content: 'theOperatorIsDoneSeccessfuly'.tr(), durationSecound: 3, color: blueColor,icon: const Icon(Icons.check_circle,color: Colors.white,size: 30,));
        }
        else {
          snakbarDialog(
              title: 'errorTitle'.tr(),
              content: 'errorOcoredPleaseTryAgain'.tr(),
              durationSecound: 5,
              icon: const Icon(Icons.cancel_rounded, color: Colors.white, size: 30));
        }
        await fetchAllForms();
        await fetchAllFormFields(index);
        Get.back();
      }
      else{

      if(await db.update(tableName: "service_forms",primaryKey: "SRVF_ID",primaryKeyValue: serviceForm.value.serviceFormId,items: serviceForm.value.toMap(true))>0){
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
      await fetchAllForms();
      await fetchAllFormFields(index);
      Get.back();
      }
    }

  addUpdateFormField(int index)async {
      if(!isEdit){
        if(await db.createNew("form_fields", formField.value.toMap(false,false))>0){
          snakbarDialog(title: 'done'.tr(), content: 'theOperatorIsDoneSeccessfuly'.tr(), durationSecound: 3, color: blueColor,icon: const Icon(Icons.check_circle,color: Colors.white,size: 30,));
        }
        else {
          snakbarDialog(
              title: 'errorTitle'.tr(),
              content: 'errorOcoredPleaseTryAgain'.tr(),
              durationSecound: 5,
              icon: const Icon(Icons.cancel_rounded, color: Colors.white, size: 30));
        }
        await fetchAllFormFields(index);
        Get.back();
      }
      else{

      if(await db.update(tableName: "form_fields",primaryKey: "FRMF_ID",primaryKeyValue: formField.value.formFieldId,items: formField.value.toMap(true,false))>0){
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
      await fetchAllFormFields(index);
      Get.back();
      }
    }

  addUpdateServicePlace(int index)async {
    List<InstitutionModel>? institutions = [];
    await db.getAllAsMap("SELECT * FROM institutions WHERE INST_STATE = 'ACTIVE' ").then((value) {
      for (var i = 0; i < value!.length; i++) {
        institutions.add(InstitutionModel.fromMap(value[i]));
      }
    });
    InstitutionModel result = await showDialog(context: Get.overlayContext!, builder: (context)=>ChooseInstitutionDialog(isTablet:MediaQuery.of(context).size.width > 600,
    institutions: institutions));
    if(services[index].value.servicePlaces!.indexWhere((element) => element.institution!.institutionId! == result.institutionId!)>=0){
      snakbarDialog(
          title: 'errorTitle'.tr(),
          content: 'thisInstIsExist'.tr(),
          durationSecound: 5,
          color: redColor,
          icon: const Icon(Icons.cancel_rounded, color: Colors.white, size: 30));
      return;
    }
    servicePlace.value.institution = result;
        if(await db.createNew("service_places", servicePlace.value.toMap(false))>0){
          snakbarDialog(title: 'done'.tr(), content: 'theOperatorIsDoneSeccessfuly'.tr(), durationSecound: 3, color: blueColor,icon: const Icon(Icons.check_circle,color: Colors.white,size: 30,));
        }
        else {
          snakbarDialog(
              title: 'errorTitle'.tr(),
              content: 'errorOcoredPleaseTryAgain'.tr(),
              durationSecound: 5,
              icon: const Icon(Icons.cancel_rounded, color: Colors.white, size: 30));
        }
        await fetchAllPlaces();
    }

}