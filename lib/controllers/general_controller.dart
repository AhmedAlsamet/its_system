import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get_storage/get_storage.dart';
import 'package:its_system/controllers/controller_panel_controller.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/constants.dart';
import 'package:its_system/controllers/notification_controller.dart';
import 'package:its_system/controllers/user_controller.dart';
import 'package:its_system/controllers/order_controller.dart';
import 'package:its_system/core/models/menu.dart';
import 'package:its_system/core/models/rive_model.dart';
import 'package:its_system/helper/db/general_helper.dart';
import 'package:its_system/helper/db/setting_helper.dart';
import 'package:its_system/models/policy_model.dart';
import 'package:its_system/models/setting_model.dart';
import 'package:its_system/models/user_model.dart';
import 'package:its_system/statics_values.dart';

class GeneralController extends GetxService {

  RxString appBarTitle = "servicesManagement".tr().obs;
  RxInt mainPageIndex = 0.obs;
  late GlobalKey<ScaffoldState> scaffoldKey;

  List<SettingModel> settings = <SettingModel>[];
  SettingHelper settingDB = SettingHelper();
  RxBool hasData = false.obs;

  late Rx<Menu> selectedBottonNav;
  OverlayEntry? entry;
  RxBool isOverly = false.obs;

  GeneralHelper db = GeneralHelper();

  RxString imagePath = ''.obs;
  RxString imageIdPath = ''.obs;

  RxInt lastNotificationReserved = 0.obs;
  TextEditingController searchController = TextEditingController();

  
  RxBool isConectedWithInternet = true.obs;
  late Rx<Menu> selecteditem;
  late NotificationController notificationController;

  Connectivity connectivity = Connectivity();

  late Timer timer;

  RxList<Rx<PolicyModel>> policies = <Rx<PolicyModel>>[].obs;

  @override
  void onInit() async{
    super.onInit();
    GetStorage().writeIfNull("last_not", 0);
    lastNotificationReserved.value = GetStorage().read("last_not");
     mainPageIndex = 0.obs;
     selecteditem = menuItems.first.obs;
     selectedBottonNav = bottomNavItems.first.obs;
    scaffoldKey = GlobalKey<ScaffoldState>();
    imagePath.value = StaticValue.userData!.userImagePath!;
    imageIdPath.value = StaticValue.userData!.userIDCardPath!;
    changePage(StaticValue.userData!.userType! == UserTypes.GUEST || StaticValue.userData!.userType! == UserTypes.CITIZEN ? 0 : StaticValue.userData!.userType! == UserTypes.SUPER_ADMIN ? 0 : 1);
    connectivity.onConnectivityChanged.listen((ConnectivityResult event) async{ 
    if(event == ConnectivityResult.none){
      ConnectivityResult c = await connectivity.checkConnectivity();
      if(c == ConnectivityResult.none) {
        isConectedWithInternet.value = false;
      }
      else{
        isConectedWithInternet.value = true;
      }
      }else{
        isConectedWithInternet.value = true;
      }
    },cancelOnError: true);
    notificationController = Get.put(NotificationController(true),tag: "true");
    fetchAllSetting();
    fetchAllPolicies();
    if(StaticValue.userData!.userType == UserTypes.SUPER_ADMIN){
      appBarTitle.value = "systemManagement".tr();
    }
    timer = Timer.periodic(
      const Duration(minutes: 4), (t) async{ 
        int id = StaticValue.userData!.userId!;
        if(id != 0) {
          await db.update(withMassage: false, tableName: 'users', primaryKey: 'USR_ID', primaryKeyValue: id, items: {"USR_LAST_CONNECTED":DateTime.now()});
          await notificationController.fetchAllNotifications();
        }
    });
  }

    @override
  void onClose() {
    timer.cancel();
    super.onClose();
  }
  fetchAllPolicies()async{
    policies.clear();
    await db.getAllAsMap("SELECT * FROM policies WHERE POL_IS_DELETE = 0").then((value) {
      for (var i = 0; i < value!.length; i++) {
        policies.add(PolicyModel.fromMap(value[i]).obs);
      }
    });
  }


  fetchAllSetting() async {
    settings.clear();
    await settingDB.getAllSettings(" WHERE INST_ID = ${StaticValue.userData!.institution!.institutionId}").then((value) {
      for (var i = 0; i < value.length; i++) {
        settings.add(value[i]);
      }
    });
  }

// this function for navigator
  changePage(int index,[int id = 0,DateTime? fromDate,DateTime? toDate]) async{
    if(index == 2 && StaticValue.userData!.userType! == UserTypes.SUPER_ADMIN) {
      ControllerPanelController controller = Get.put(ControllerPanelController());
      await controller.refershAll();
    }
    if(id!=0){
      if(id == 1){
        UserController controller = Get.put( UserController(UserTypes.ADMIN,false),tag: UserTypes.ADMIN.name);
        controller.fromDate.value = fromDate!;
        controller.toDate.value = toDate!;
        await controller.fetchAllEmployees();
      }
      if(id == 2 || id == 3 || id == 4 || id == 5){
        OrderController controller = Get.put(OrderController(false));
        controller.fromDate.value = fromDate!;
        controller.toDate.value = toDate!;
        controller.orderType.value = id == 5 ? 1 : 0;
        if(id == 5){
          controller.orderState.value =  "ALL";
        }
        else{
          controller.orderState.value =  id == 3 ? "DONE" : id == 4? "CANCELED" : "ALL";
        }
        await controller.fetchAllOrders();
      }
    }
    mainPageIndex.value = index;
    if(entry != null && isOverly.value) {
      entry!.remove();
    }
    entry = null;
    isOverly.value = false;
    if(scaffoldKey.currentState!=null&& scaffoldKey.currentState!.isDrawerOpen){
      scaffoldKey.currentState!.closeDrawer();
    }
  }
    void updateSelectedItem(Menu menu) {
    if (selecteditem.value != menu) {
        selecteditem.value = menu;
    }
  }

  void openDrawer() {
    if(isOverly.value && entry != null && mainPageIndex.value != 6&& mainPageIndex.value != 0&& mainPageIndex.value != 2) {
      entry!.remove();
    }
    scaffoldKey.currentState!.openDrawer();
  }


  List<Menu> menuItems = [
  if(StaticValue.userData!.userType == UserTypes.SUPER_ADMIN)
  Menu(
    index: 0,
    iconBackground: headColor,
    rive: RiveModel(
        src: "assets/rive/icons.riv",
        artboard: "HOME",
        stateMachineName: "HOME_interactivity"),
  ),
  Menu(
    index: 1,
    iconBackground: redColor,
    rive: RiveModel(
        src: "assets/rive/icons.riv",
        artboard: "HOME",
        stateMachineName: "HOME_interactivity"),
  ),
  Menu(
    index: 2,
    iconBackground: Colors.brown,
    rive: RiveModel(
        src: "assets/rive/little_icons.riv",
        artboard: "DASHBOARD",
        stateMachineName: "DASHBOARD_Interactivity"),
  ),
  Menu(
    index: 3,
    iconBackground: Colors.orange,
    rive: RiveModel(
        src: "assets/rive/little_icons.riv",
        artboard: "LOADING",
        stateMachineName: "LOADING_Interactivity"),
  ),
  if(StaticValue.userData!.userType == UserTypes.SUPER_ADMIN)
  Menu(
    index: 4,
    iconBackground: Colors.yellow,
    rive: RiveModel(
        src: "assets/rive/little_icons.riv",
        artboard: "USER",
        stateMachineName: "USER_Interactivity"),
  ),
  Menu(
    index: 5,
    iconBackground: Colors.blue,
    rive: RiveModel(
        src: "assets/rive/little_icons.riv",
        artboard: "RULES",
        stateMachineName: "RULES_Interactivity"),
  ),
  Menu(
    index: 6,
    iconBackground: Colors.pink,
    rive: RiveModel(
        src: "assets/rive/icons.riv",
        artboard: "SETTINGS",
        stateMachineName: "SETTINGS_Interactivity"),
  ),
  Menu(
    index: 7,
    iconBackground: Colors.teal,
    rive: RiveModel(
        src: "assets/rive/icons.riv",
        artboard: "BELL",
        stateMachineName: "BELL_Interactivity"),
  ),
];

List<Menu> bottomNavItems = [
    Menu(
    iconBackground: Colors.black,
    index: 0,
    rive: RiveModel(
        src: "assets/rive/icons.riv",
        artboard: "HOME",
        stateMachineName: "HOME_interactivity"),
  ),

if(StaticValue.userData!.userType != UserTypes.GUEST)...[
  Menu(
    iconBackground: Colors.black,
    index: 1,
    rive: RiveModel(
        src: "assets/rive/little_icons.riv",
        artboard: "RULES",
        stateMachineName: "RULES_Interactivity"),
  ),
  Menu(
    iconBackground: Colors.black,
    index: 2,
    rive: RiveModel(
        src: "assets/rive/icons.riv",
        artboard: "BELL",
        stateMachineName: "BELL_Interactivity"),
  ),
],
  Menu(
    iconBackground: Colors.black,
    index: 3,
    rive: RiveModel(
        src: "assets/rive/icons.riv",
        artboard: "SETTINGS",
        stateMachineName: "SETTINGS_Interactivity"),
  ),
];

}
    // title: "home".tr(),
    // title: "myOrders".tr(),
    // title: "notifications".tr(),
    // title: "settings".tr(),