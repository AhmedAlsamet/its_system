import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:its_system/constants.dart';
import 'package:its_system/controllers/general_controller.dart';
import 'package:its_system/controllers/setting_controller.dart';
import 'package:its_system/core/utils/delete_dialog2.dart';
import 'package:its_system/core/widgets/setting_item.dart';
import 'package:its_system/core/widgets/switch_list_widget.dart';
import 'package:its_system/helper/open_dialog_bottom_sheet.dart';
import 'package:its_system/models/setting_model.dart';
import 'package:its_system/pages/entry/entry_page.dart';
import 'package:its_system/pages/settings/components/add_update_report_setting.dart';
import 'package:its_system/pages/settings/components/qr_style.dart';
import 'package:its_system/pages/settings/profile_screen.dart';
import 'package:its_system/pages/system_management/components/codes.dart';
import 'package:its_system/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/statics_values.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({
    super.key,
  });

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late QrImage qrImage;

  late PrettyQrDecoration decoration;

  late QrCode qrCode;

  late GeneralController generalController;

  @override
  void initState() {
    super.initState();
    qrCode = QrCode.fromData(
      data: 'https://martmostashar.com',
      errorCorrectLevel: QrErrorCorrectLevel.H,
    );
    generalController = Get.put(GeneralController());

    qrImage = QrImage(qrCode);

    decoration = const PrettyQrDecoration(
      shape: PrettyQrSmoothSymbol(
        color: Color(0xFF74565F),
      ),
      image: PrettyQrSettings.kDefaultPrettyQrDecorationImage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: SettingController(),
        builder: (controller) {
          return SafeArea(
            child: Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.all(defaultPadding),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              //MyFiels(),
                              //SizedBox(height: defaultPadding),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Divider(),
                                  ListTile(
                                    title: Text("initilize".tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayLarge),
                                  ),
                                  Column(
                                    children: [
                                      settingItem(
                                          icon: Ionicons.code,
                                          title: "complaintTypes".tr(),
                                          subtitle: "",
                                          iconBackground: Colors.green,
                                          onTap: () async {
                                            await openDialogOrBottomSheet(
                                                CodesBottomSheet(
                                                    columnPrefix: "COMT",
                                                    table: "complaint_types",
                                                    column1: "COMT_ID",
                                                    column2: "COMT_NAME",
                                                    column3: "INST_ID",
                                                    column3Val:StaticValue.userData!.institution!.institutionId.toString()
                                                    ));
                                          }),
                                      settingItem(
                                          icon: Ionicons.code,
                                          title: "report".tr(),
                                          subtitle: "reportCustomize".tr(),
                                          iconBackground: Colors.orange,
                                          onTap: () async {
                                            openDialogOrBottomSheet(
                                                AddNewReportSettingBottomSheet(
                                                    settingCode: "REPORT"));
                                          }),
                                          settingItem(
                                            icon: Ionicons.code,
                                            title: "serviceGroups".tr(),
                                            subtitle:
                                                "enterServiceGroup".tr(),
                                            iconBackground: Colors.redAccent,
                                            onTap: () async{
                                              await openDialogOrBottomSheet(CodesBottomSheet(
                                                columnPrefix: "SRVG",
                                                table: "service_groups", column1: "SRVG_ID", column2: "SRVG_NAME",column3: "INST_ID",column3Val: StaticValue.userData!.institution!.institutionId!.toString(),));
                                            }),
                                                      ListTile(
                    title: Text("settings".tr(),
                        style: Theme.of(context).textTheme.displayLarge),
                  ),
                                           settingItem(
                  icon: Ionicons.globe_outline,
                  title: "language".tr(),
                  subtitle: translator.activeLanguageCode,
                  iconBackground: const Color(0xff3DB2FF),
                  onTap: () {
                    translator.setNewLanguage(
                      context,
                      newLanguage:
                      translator.activeLanguageCode == 'ar' ? "en": 'ar',
                      remember: true,
                    );
                  }),
             settingItem(
                      icon: GetStorage().read("darkMode")
                          ? Ionicons.moon
                          : Ionicons.sunny,
                      title: "theme".tr(),
                      subtitle: GetStorage().read("darkMode")
                          ? "dark".tr()
                          : "light".tr(),
                      iconBackground: const Color(0xffFC5404),
                      onTap: () {
                        if (GetStorage().read("darkMode")) {
                          setState(() {
                            Get.changeThemeMode(ThemeMode.light);
                            GetStorage().write("darkMode", false);
                          });
                        } else {
                          setState(() {
                            Get.changeThemeMode(ThemeMode.dark);
                            GetStorage().write("darkMode", true);
                          });
                        }
                      }), 
                      settingItem(
                          icon: Icons.manage_accounts_outlined,
                          title: "account".tr(),
                          subtitle: "",
                          iconBackground: Colors.blueAccent,
                          onTap: (){
                            GeneralController controller = Get.put(GeneralController());
                            openDialogOrNewRoute(UpdateProfile(controller:controller));
                          }),
                       settingItem(
                          icon: Ionicons.log_out_outline,
                          title: "logout".tr(),
                          subtitle: "logoutDescription".tr(),
                          iconBackground: const Color(0xffDF2E2E),
                          onTap: () {
                            deleteMessage2(
                              deleteButton: "exit".tr(),
                              title: "areYouSureFor".tr(), content: "logoutDescription".tr(), onDelete: (){
                                GetStorage().remove("user");
                                GetStorage().remove("qr_style");
                                Get.deleteAll();
                                Get.offAll(const EntryPage());
                            },
                             onCancel: (){
                              Get.back();
                             }, onWillPop: true);
                         }),
                 ListTile(
                    title: Text(
                      "aboutApp".tr(),
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                  settingItem(
                      icon: Icons.developer_board,
                      title: "appDevelopment".tr(),
                      subtitle: "companyName".tr(),
                      iconBackground: Colors.teal),
                  settingItem(
                      icon: Ionicons.information,
                      title: "appName".tr(),
                      subtitle: "version".tr(),
                      iconBackground: const Color(0xff3DB2FF)),
                  settingItem(
                      icon: Ionicons.shield_half,
                      title: "privacyPolicy".tr(),
                      subtitle: "privacyPolicyDescription".tr(),
                      iconBackground: const Color(0xffDF2E2E),
                      onTap: ()  {
                          showDialog(context: context, builder: (context)=>Dialog(
                          insetPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                          child: SizedBox(
                            width: Responsive.isMobile(context)?null:500,
                            child: Column(
                              children: [
                                Container(
                                  height: AppBar().preferredSize.height,
                                  color: Theme.of(context).primaryColor,
                                  child: Center(child: Text("privacyPolicy".tr(),style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.white),),),
                                ),
                                  Expanded(child: Container(
                                    color: Theme.of(context).cardColor,
                                    width: double.infinity,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ...generalController.policies.map((element) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(element.value.policyName!.getTitle,style: Theme.of(context).textTheme.displaySmall,),
                                          ))
                                        ],
                                      ),
                                    ),
                                  ),)
                              ],
                            ),
                          ),
                        ));
                      }),
                                 ],
                                  )
                                ],
                              ),
                              if (Responsive.isMobile(context))
                                const SizedBox(height: defaultPadding),
                              if (Responsive.isMobile(context))
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "qrCode".tr(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayLarge,
                                        ),
                                        ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .primaryColor),
                                            onPressed: () async {
                                              openDialogOrBottomSheet(
                                                  const QrStyleScreen());
                                            },
                                            icon: const Icon(
                                              Iconsax.edit,
                                              color: Colors.white,
                                            ),
                                            label: Text(
                                              "customaize".tr(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayMedium!
                                                  .copyWith(
                                                      color: Colors.white),
                                            ))
                                      ],
                                    ),
                                    const Divider(),
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: PrettyQrView(
                                          qrImage: qrImage,
                                          decoration:
                                              controller.decoration.value),
                                    )
                                  ],
                                ),
                            ],
                          ),
                        ),
                        if (!Responsive.isMobile(context))
                          const SizedBox(width: defaultPadding),
                        // On Mobile means if the screen is less than 850 we dont want to show it
                        if (!Responsive.isMobile(context))
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    padding:
                                        const EdgeInsets.all(defaultPadding),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .cardColor
                                          .withOpacity(0.8),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "qrCode".tr(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayLarge,
                                            ),
                                            ElevatedButton.icon(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .primaryColor),
                                                onPressed: () async {
                                                  openDialogOrBottomSheet(
                                                      const QrStyleScreen());
                                                },
                                                icon: const Icon(
                                                  Iconsax.edit,
                                                  color: Colors.white,
                                                ),
                                                label: Text(
                                                  "customaize".tr(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displayMedium!
                                                      .copyWith(
                                                          color: Colors.white),
                                                ))
                                          ],
                                        ),
                                        const Divider(),
                                        Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: PrettyQrView(
                                              qrImage: qrImage,
                                              decoration:
                                                  controller.decoration.value),
                                        )
                                      ],
                                    )),
                                const SizedBox(height: defaultPadding),
                                Container(
                                    padding:
                                        const EdgeInsets.all(defaultPadding),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .cardColor
                                          .withOpacity(0.8),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                    child: languageChoose(context, controller)),
                              ],
                            ),
                          ),
                      ],
                    ),
                    if (Responsive.isMobile(context))
                      languageChoose(context, controller)
                  ],
                ),
              ),
            ),
          );
        });
  }

  Column languageChoose(BuildContext context, SettingController controller) {
    return Column(
      children: [
        Text(
          "appLangs".tr(),
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const Divider(),
        SwitchListTileWidget(
            title: "arabic".tr(),
            subTitle: controller.settings
                        .firstWhere((s) => s.value.settingCode! == "ar",
                            orElse: () => SettingModel(
                                    settingValue:
                                        TextEditingController(text: "0"))
                                .obs)
                        .value
                        .settingValue!
                        .text ==
                    "1"
                ? "ACTIVE".tr()
                : "INACTIVE".tr(),
            value: controller.settings
                    .firstWhere((s) => s.value.settingCode! == "ar",
                        orElse: () => SettingModel(
                                settingValue: TextEditingController(text: "0"))
                            .obs)
                    .value
                    .settingValue!
                    .text ==
                "1",
            onChanged: (v) async {
              controller.settings
                  .firstWhere((s) => s.value.settingCode! == "ar",
                      orElse: () => SettingModel(
                              settingValue: TextEditingController(text: "0"))
                          .obs)
                  .update((val) {
                val!.settingValue!.text = v ? "1" : "0";
              });
              await controller.db.updateOrInsert(SettingModel(
                  institutionId: StaticValue.userData!.institution!.institutionId,
                  settingCode: "ar",
                  settingType: "LANG",
                  settingId: 8,
                  settingValue: TextEditingController(text: v ? "1" : "0")));
              await controller.fetchAllSetting();
            }),
        SwitchListTileWidget(
            title: "English".tr(),
            subTitle: controller.settings
                        .firstWhere((s) => s.value.settingCode! == "en",
                            orElse: () => SettingModel(
                                    settingValue:
                                        TextEditingController(text: "0"))
                                .obs)
                        .value
                        .settingValue!
                        .text ==
                    "1"
                ? "ACTIVE".tr()
                : "INACTIVE".tr(),
            value: controller.settings
                    .firstWhere((s) => s.value.settingCode! == "en",
                        orElse: () => SettingModel(
                                settingValue: TextEditingController(text: "0"))
                            .obs)
                    .value
                    .settingValue!
                    .text ==
                "1",
            onChanged: (v) async {
              controller.settings
                  .firstWhere((s) => s.value.settingCode! == "en",
                      orElse: () => SettingModel(
                              settingValue: TextEditingController(text: "0"))
                          .obs)
                  .update((val) {
                val!.settingValue!.text = v ? "1" : "0";
              });
              await controller.db.updateOrInsert(SettingModel(
                  institutionId: StaticValue.userData!.institution!.institutionId,
                  settingCode: "en",
                  settingType: "LANG",
                  settingId: 10,
                  settingValue: TextEditingController(text: v ? "1" : "0")));
              await controller.fetchAllSetting();
            }),
      ],
    );
  }
}
