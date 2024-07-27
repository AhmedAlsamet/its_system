import 'package:get/get.dart' hide Trans;
import 'package:ionicons/ionicons.dart';
import 'package:its_system/controllers/controller_panel_controller.dart';
import 'package:its_system/models/institution_model.dart';
import 'package:its_system/models/place_model.dart';
import 'package:its_system/models/state_enum.dart';
import 'package:its_system/pages/dashboard/components/recent_users.dart';
import 'package:its_system/pages/system_management/components/add_update_institution.dart';
import 'package:its_system/pages/system_management/components/compound_part.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/constants.dart';
import 'package:its_system/controllers/general_controller.dart';
import 'package:its_system/controllers/system_management_controller.dart';
import 'package:its_system/controllers/user_controller.dart';
import 'package:its_system/core/widgets/setting_item.dart';
import 'package:its_system/helper/open_dialog_bottom_sheet.dart';
import 'package:its_system/models/user_model.dart';
import 'package:its_system/pages/system_management/components/codes.dart';
import 'package:its_system/pages/system_management/components/employee_part.dart';
import 'package:its_system/pages/user/components/add_update_user.dart';
import 'package:its_system/responsive.dart';
import 'package:flutter/material.dart';
import 'package:its_system/statics_values.dart';

class SystemManagementScreen extends StatefulWidget {
  const SystemManagementScreen({
    super.key,
  });

  @override
  State<SystemManagementScreen> createState() => _SystemManagementScreenState();
}

class _SystemManagementScreenState extends State<SystemManagementScreen> {
  late SystemManagementController controller;
  late ControllerPanelController panelController;
  late GeneralController generalController;
  late UserController userController;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SystemManagementController());
    panelController = Get.put(ControllerPanelController());
    generalController = Get.put(GeneralController());
    userController =
        Get.put(UserController(UserTypes.SUPER_ADMIN), tag: "SUPER_ADMIN");
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SafeArea(
        child: Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.all(defaultPadding),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: Responsive.size(context).height / 2,
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListTile(
                          leading: Responsive.isMobile(context)
                              ? IconButton(
                                  icon:
                                      const Icon(Icons.close, color: Colors.red),
                                  onPressed: () async {
                                    StaticValue
                                        .userData!.institution!.institutionId = 0;
                                    await generalController.fetchAllSetting();
                                    controller.institutions.refresh();
                                  },
                                )
                              : null,
                          title: Text("institutionManagement".tr(),
                              style: Theme.of(context).textTheme.displayLarge),
                          trailing: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).primaryColor,
                                  shape: BeveledRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              onPressed: () async {
                                await controller.refreshInstitution();
                                controller.isEdit = false;
                                openDialogOrBottomSheet(
                                    const AddNewInstitutionBottomSheet());
                              },
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              label: Text(
                                "add".tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(color: Colors.white),
                              )),
                        ),
                        const Divider(),
                        SizedBox(
                          width: double.infinity,
                          child: Responsive.isMobile(context)
                              ? Column(
                                  children: controller.institutions
                                      .map((c) => recentInstitutionForMobile(
                                              c.value, controller, (v) async {
                                            StaticValue.userData!.institution = v;
                                            controller.institutions.refresh();
                                            await generalController
                                                .fetchAllSetting();
                                          }, context))
                                      .toList())
                              : DataTable(
                                  horizontalMargin: 0,
                                  columnSpacing: 0,
                                  columns: [
                                    DataColumn(
                                      label: IconButton(
                                        icon: const Icon(Icons.close,
                                            color: Colors.red),
                                        onPressed: () async {
                                          StaticValue.userData!.institution = InstitutionModel(institutionId: 0,city: CityModel(cityId: 1)) ;
                                          await generalController
                                              .fetchAllSetting();
                                          controller.institutions.refresh();
                                        },
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "institutionName".tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "city".tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "municipality".tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "createdDate".tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "state".tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "Operation".tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                  rows: controller.institutions
                                      .map((c) => institutionDataRow(
                                              c.value, controller, (v) async {
                                            StaticValue.userData!.institution = v;
                                            controller.institutions.refresh();
                                            await generalController
                                                .fetchAllSetting();
                                          }, context))
                                      .toList(),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // On Mobile means if the screen is less than 850 we dont want to show it
                    Expanded(
                      flex: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: defaultPadding),
                          Container(
                              padding: const EdgeInsets.all(defaultPadding),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .cardColor
                                    .withOpacity(0.8),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text("employees".tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayLarge),
                                    trailing: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                            shape: BeveledRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5))),
                                        onPressed: () async {
                                          userController.refreshEmployee();
                                          userController.isEdit = false;
                                          userController.user.value.userType =
                                              UserTypes.SUPER_ADMIN;
                                          userController.user.value.institution!
                                              .institutionId = 0;
                                          openDialogOrBottomSheet(
                                              const AddNewUserBottomSheet(
                                            userType: UserTypes.SUPER_ADMIN,
                                          ));
                                        },
                                        icon: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                        label: Text(
                                          "add".tr(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium!
                                              .copyWith(color: Colors.white),
                                        )),
                                  ),
                                  const Divider(),
                                  Container(
                                    // height: Responsive.size(context).height / 2,
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Responsive.isMobile(context)
                                          ? Column(
                                              children: userController.users
                                                  .map((c) =>
                                                      SizedBox(
                                                        width: double.infinity,
                                                        child: employeeDataForMobile(
                                                            c.value,
                                                            userController,
                                                            context),
                                                      ))
                                                  .toList())
                                          : DataTable(
                                              horizontalMargin: 0,
                                              columnSpacing: 0,
                                              columns: [
                                                DataColumn(
                                                  label: Text(
                                                    "employeeName".tr(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displaySmall!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    "lastConnection".tr(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displaySmall!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    "state".tr(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displaySmall!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    "Operation".tr(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displaySmall!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                ),
                                              ],
                                              rows: userController.users
                                                  .map((c) => employeeDataRow(
                                                      c.value,
                                                      userController,
                                                      context))
                                                  .toList(),
                                            ),
                                    ),
                                  ),
                                  
                                ],
                              )),
                              const SizedBox(height: 10,),
                                  RecentUsers(controller: panelController,users: panelController.users.where((u) => u.value.userState == States.INACTIVE && u.value.userType == UserTypes.CITIZEN && u.value.userIDCardPath != "").toList().map((element) => element.value).toList()),                                
                        ],
                      ),
                    ),
                    if (!Responsive.isMobile(context))
                      const SizedBox(width: defaultPadding),
                    if (!Responsive.isMobile(context))
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text("initilize".tr(),
                                  style:
                                      Theme.of(context).textTheme.displayLarge),
                            ),
                            Column(
                              children: [
                                settingItem(
                                    icon: Ionicons.code,
                                    title: "citiesInitialize".tr(),
                                    subtitle: "citiesInitializeDesc".tr(),
                                    iconBackground: Colors.redAccent,
                                    onTap: () async {
                                      await openDialogOrBottomSheet(
                                          CodesBottomSheet(
                                              columnPrefix: "CTY",
                                              table: "cities",
                                              column1: "CTY_ID",
                                              column2: "CTY_NAME"));
                                      await controller.fetchAllPlaces();
                                    }),
                                settingItem(
                                    icon: Ionicons.code,
                                    title: "municipalities".tr(),
                                    subtitle: "municipalitiesDesc".tr(),
                                    iconBackground: Colors.indigoAccent,
                                    onTap: () async {
                                      await openDialogOrBottomSheet(
                                          CodesBottomSheet(
                                        columnPrefix: "MUN",
                                        table: "municipalities",
                                        column1: "MUN_ID",
                                        column2: "MUN_NAME",
                                        column3: "CTY_ID",
                                        column3Table: "cities",
                                        column3Title: "city".tr(),
                                      ));
                                      await controller.fetchAllPlaces();
                                    }),
                                settingItem(
                                    icon: Ionicons.shield_half,
                                    title: "privacyPolicy".tr(),
                                    subtitle: "privacyPolicyDescription".tr(),
                                    iconBackground: const Color(0xffDF2E2E),
                                    onTap: () async {
                                      await openDialogOrBottomSheet(
                                          CodesBottomSheet(
                                              columnPrefix: "POL",
                                              table: "policies",
                                              column1: "POL_ID",
                                              column2: "POL_NAME"));
                                    }),
                              ],
                            )
                          ],
                        ),
                      ),
                  ],
                ),
                if (Responsive.isMobile(context))
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //MyFiels(),
                      //SizedBox(height: defaultPadding),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text("initilize".tr(),
                                style:
                                    Theme.of(context).textTheme.displayLarge),
                          ),
                          Column(
                            children: [
                              settingItem(
                                  icon: Ionicons.code,
                                  title: "citiesInitialize".tr(),
                                  subtitle: "citiesInitializeDesc".tr(),
                                  iconBackground: Colors.redAccent,
                                  onTap: () async {
                                    await openDialogOrBottomSheet(
                                        CodesBottomSheet(
                                            columnPrefix: "CTY",
                                            table: "cities",
                                            column1: "CTY_ID",
                                            column2: "CTY_NAME"));
                                  }),
                              settingItem(
                                  icon: Ionicons.code,
                                  title: "municipalities".tr(),
                                  subtitle: "municipalitiesDesc".tr(),
                                  iconBackground: Colors.indigoAccent,
                                  onTap: () async {
                                    await openDialogOrBottomSheet(
                                        CodesBottomSheet(
                                      columnPrefix: "MUN",
                                      table: "municipalities",
                                      column1: "MUN_ID",
                                      column2: "MUN_NAME",
                                      column3: "CTY_ID",
                                      column3Table: "cities",
                                      column3Title: "city".tr(),
                                    ));
                                  }),
                              settingItem(
                                  icon: Ionicons.shield_half,
                                  title: "privacyPolicy".tr(),
                                  subtitle: "privacyPolicyDescription".tr(),
                                  iconBackground: const Color(0xffDF2E2E),
                                  onTap: () async {
                                    await openDialogOrBottomSheet(
                                        CodesBottomSheet(
                                            columnPrefix: "POL",
                                            table: "policies",
                                            column1: "POL_ID",
                                            column2: "POL_NAME"));
                                  }),
                            ],
                          )
                        ],
                      ),
                      if (Responsive.isMobile(context))
                        const SizedBox(height: defaultPadding),
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
