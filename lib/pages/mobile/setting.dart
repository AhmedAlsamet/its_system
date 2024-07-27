import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get_storage/get_storage.dart';
import 'package:ionicons/ionicons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/controllers/general_controller.dart';
import 'package:its_system/core/utils/delete_dialog2.dart';
import 'package:its_system/core/widgets/setting_item.dart';
import 'package:its_system/helper/open_dialog_bottom_sheet.dart';
import 'package:its_system/pages/entry/entry_page.dart';
import 'package:its_system/pages/settings/profile_screen.dart';
import 'package:its_system/responsive.dart';

class SettingPageForMobile extends StatefulWidget {
  const SettingPageForMobile({super.key});

  @override
  State<SettingPageForMobile> createState() => _SettingPageForMobileState();
}

class _SettingPageForMobileState extends State<SettingPageForMobile> {

 late GeneralController controller;
 @override
  void initState() {
    super.initState();
    controller = Get.put(GeneralController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "settings".tr(),
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          // backgroundColor: headColor,
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: ListView(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
      Column(
        children: [
            ListTile(
                    title: Text("settings".tr(),
                        style: Theme.of(context).textTheme.displayLarge),
                  ),
                //   Container(
                // margin: EdgeInsets.only(
                //     left: Responsive.isMobile(context) ? 10 : 0),
                // child: PopupMenuWidget(
                //     node: FocusNode(),
                //     selectedItem: controller.activeLanguageCode.value,
                //     onChanged: (v) {
    
                //     },
                //     items: [
                //       DropdownButtonModel(
                //           dropName: "arabic".tr(),
                //           dropOrder: 0,
                //           dropImage: "assets/icons8-iraq.png",
                //           dropValue: 'ar'),
                //       DropdownButtonModel(
                //           dropName: "English",
                //           dropOrder: 1,
                //           dropImage: "assets/icons8-british-flag.png",
                //           dropValue: 'en'),
                //       // ], title: (controller.activeLanguageCode.value == 'ar' ? "arabic".tr() : controller.activeLanguageCode.value == 'en' ? "Englis":"كردي")),
                //     ]),
                settingItem(
                  icon: Ionicons.globe_outline,
                  title: "language".tr(),
                  subtitle: translator.activeLanguageCode,
                  iconBackground: const Color(0xff3DB2FF),
                  onTap: () {
                    translator.setNewLanguage(
                      context,
                      newLanguage:
                      translator.activeLanguageCode == 'ar' ? "en" : 'ar',
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
                          onTap: ()async{
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
                      onTap: () {
                        showDialog(context: context, builder: (context)=>Dialog(
                          insetPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
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
                                    width: double.infinity,
                                    color: Theme.of(context).cardColor,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ...controller.policies.map((element) => Padding(
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
    
           
            ]));
  }
}
