import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:its_system/constants.dart';
import 'package:its_system/core/utils/snakbar_dialog.dart';
import 'package:its_system/helper/db/general_helper.dart';
import 'package:its_system/helper/generate_token.dart';
import 'package:its_system/models/institution_model.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/models/general_model.dart';
import 'package:its_system/models/place_model.dart';
import 'package:its_system/models/user_model.dart';



class SystemManagementController extends GetxController {

  RxInt selectedItem = 0.obs;
  RxBool isOpenKeyboard = false.obs;
  RxList<Rx<InstitutionModel>> institutions = <Rx<InstitutionModel>>[].obs;
  GeneralHelper db = GeneralHelper();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  RxList<Rx<MunicipalityModel>> municipalities = <Rx<MunicipalityModel>>[].obs;
  RxList<Rx<CityModel>> cities = <Rx<CityModel>>[].obs;
  RxList<Rx<UserModel>> users = <Rx<UserModel>>[].obs;


  RxInt selectedCity = 0.obs;
  RxInt selectedMunicipality = 0.obs;

  
  String externalImageStorage = '';
  bool isEdit = false;

  RxInt orderType = 0.obs;
  Rx<InstitutionModel> institution = InstitutionModel().initialize(
    institutionName: GeneralModel().initialize(
      arabicHint: "institutionName".tr(),
      englishHint:"institutionName".tr() ,
    ),
  ).obs;

 
  @override
  void onInit() async{
    super.onInit();
    await fetchAllCompounds();
    await fetchAllPlaces();
  }


  fetchAllCompounds() async {
    await db.getAllAsMap("SELECT * FROM institutions as i inner join municipalities as MUN on i.MUN_ID = MUN.MUN_ID INNER JOIN cities as c on c.CTY_ID = i.CTY_ID ;").then((value) {
    institutions.clear();
      for (var i = 0; i < value!.length; i++) {
        institutions.add(InstitutionModel.fromMap(value[i]).obs);
      }
    });
    institutions.refresh();
  }

  fetchAllPlaces()async{
    cities.clear();
    municipalities.clear();
    await db.getAllAsMap("SELECT * FROM cities WHERE CTY_IS_DELETE = 0").then((value) {
      for (var i = 0; i < value!.length; i++) {
        cities.add(CityModel.fromMap(value[i]).obs);
      }
      selectedCity.value = cities.first.value.cityId!;
    });
    await db.getAllAsMap("SELECT * FROM municipalities WHERE MUN_IS_DELETE = 0").then((value) {
      for (var i = 0; i < value!.length; i++) {
        municipalities.add(MunicipalityModel.fromMap(value[i]).obs);
      }
        selectedMunicipality.value = municipalities.firstWhere((c) => c.value.city!.cityId == selectedCity.value,orElse: () => MunicipalityModel(municipalityId:0).obs,).value.municipalityId!;
        institution.value.municipality!.municipalityId = selectedMunicipality.value; 
    });
  }

  refreshInstitution()async{
    institution.value = InstitutionModel().initialize(
      institutionUniqueKey: TextEditingController(text: generateToken(100))
    );
    institution.value.municipality!.municipalityId = selectedMunicipality.value; 
    institution.value.city!.cityId = selectedCity.value; 
  }

  addUpdateCompound()async {
    if(institution.value.municipality!.municipalityId == 0){
      snakbarDialog(
          title: 'errorTitle'.tr(),
          content: "youMustChooseCity".tr(),
          durationSecound: 5,
          icon: const Icon(Icons.cancel_rounded, color: Colors.white, size: 30));
      return;
    }
    if(!isEdit){
      if(await checkForm(column: "INST_UNIQUE_KEY", value: institution.value.institutionUniqueKey!.text, message: "dublicateinstitutionUniqueKey".tr(),)){
        return;
      }
      int id = await db.createNew("institutions",institution.value.toMap(false));
      if(id>0){
        List? settings =  await db.getAllAsMap("SELECT DISTINCT SET_ID,SET_TYPE,SET_CODE FROM settings");
        await db.createMulti("settings",settings!.map((e) {
          Map<String,dynamic> temp = e;
          temp["INST_ID"] = id;
          temp["SET_VALUE"] = '';
          return temp;
        }).toList());
        snakbarDialog(title: 'done'.tr(), content: 'theOperatorIsDoneSeccessfuly'.tr(), durationSecound: 5, color: blueColor,icon: const Icon(Icons.check_circle,color: Colors.white,size: 30,));
      }
      else {
        snakbarDialog(
            title: 'errorTitle'.tr(),
            content: 'errorOcoredPleaseTryAgain'.tr(),
            durationSecound: 5,
            icon: const Icon(Icons.cancel_rounded, color: Colors.white, size: 30));
      }
      await fetchAllCompounds();
      Get.back();
    }
    else{

    if(await db.update(tableName: "institutions",primaryKey: "INST_ID",primaryKeyValue: institution.value.institutionId,items: institution.value.toMap(true))>0){
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
    await fetchAllCompounds();
    Get.back();
    }
  }

  checkForm({required String column,required dynamic value,required String message,String additionsalCondection = ""})async{
    final e = await db.getByIdAsMap(" SELECT * FROM institutions WHERE ($column = '$value') $additionsalCondection");
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