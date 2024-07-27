import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get_storage/get_storage.dart';
import 'package:ionicons/ionicons.dart';
import 'package:its_system/pages/mobile/components/add_id_card.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/controllers/general_controller.dart';
import 'package:its_system/controllers/user_controller.dart';
import 'package:its_system/core/utils/delete_dialog2.dart';
import 'package:its_system/core/widgets/cash_image.dart';
import 'package:its_system/core/widgets/nav_bar_icon.dart';
import 'package:its_system/core/widgets/setting_item.dart';
import 'package:its_system/helper/open_camera_gallery.dart';
import 'package:its_system/models/state_enum.dart';
import 'package:its_system/models/user_model.dart';
import 'package:its_system/pages/entry/entry_page.dart';
import 'package:its_system/pages/settings/components/personal_information.dart';
import 'package:its_system/responsive.dart';
import 'package:its_system/statics_values.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';


class UpdateProfile extends StatefulWidget {
  GeneralController controller;

  UpdateProfile({Key? key, required this.controller}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  late List<FocusNode> nodes;
  late UserController controller;
  late GeneralController generalController;
  int curentCompound = 0;
  @override
  void initState() {
    super.initState();
    controller = Get.put(UserController(UserTypes.CITIZEN, false));
    generalController = Get.put(GeneralController());
    controller.user = UserModel().copyWith(user: StaticValue.userData).obs;
    curentCompound = controller.user.value.institution!.institutionId!;
    if(StaticValue.userData!.userType == UserTypes.SUPER_ADMIN){
      controller.user.value.institution!.institutionId = 0;
    }
    super.initState();
    nodes = [
      FocusNode(),
      FocusNode(),
      FocusNode(),
      FocusNode(),
      FocusNode(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Container(
        color: Theme.of(context).primaryColor,
        width: Responsive.isDesktop(context) ? 500 : null,
        child: Column(children: [
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: NavBarIcon(
                            icon: Icons.arrow_back,
                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                          foregroundColor: Theme.of(context).primaryColor,
                          shadowColor: Theme.of(context).shadowColor.withOpacity(0),
                            iconEvent: (){
                              Get.back();
                              controller.user.value.institution!.institutionId = curentCompound;
                            },
                            tooltip: "back".tr()),
                ),
                Container(
                  height: 200,
                  width: 200,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle),
                  child: Stack(
                    children: [
                      Positioned.fill(
                          child: ImageWidget(imagePath: StaticValue.userData!.userImagePath!)
                      //     CircleAvatar(
                      //   backgroundImage: NetworkImage(
                      //     StaticValue.serverPath! + StaticValue.userData!.userImage!.path,
                      //   ),
                      //   onBackgroundImageError: (exception, stackTrace) => SizedBox(
                      //     child: Image.asset("assets/images/profile_pic.png"),
                      //   ),
                      // )
                      ),
                      Positioned(
                        top: 140,
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Container(
                          color: Colors.black.withOpacity(0.2),
                          child: IconButton(onPressed: ()async{
                            String path = await openGallery();
                            if(path != ""){
                              controller.user.value.userImage = File(path);
                              controller.isEdit = true;
                              await controller.addUpdateEmployee();
                              StaticValue.userData = controller.user.value;
                              await DefaultCacheManager().removeFile(StaticValue.serverPath! + StaticValue.userData!.userImagePath!);
                              // await DefaultCacheManager().emptyCache();
                              generalController.imagePath.value = StaticValue.userData!.userImagePath!;
                              if(GetStorage().read("user")!= null){
                                await GetStorage().write("user",StaticValue.userData!.toMapForSave());
                              }
                            }
                          }, icon: const Icon(Icons.edit,color: Colors.white,))))
                    ],
                  ),
                ),
                const SizedBox(
                  width: 60,
                )
              ],
            ),
          ),
          Form(
            // key: value.mainCategoryFormKey,
            child: Expanded(
              child: Scaffold(
                body: Container(
                  color: Theme.of(context).cardColor,
                  padding: const EdgeInsets.all(10),
                  child: NotificationListener<OverscrollIndicatorNotification>(
                      onNotification: (overScroll) {
                        overScroll.disallowIndicator();
                        return false;
                      },
                      child: ListView(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          if(StaticValue.userData!.userType != UserTypes.GUEST)...[
                          settingItem(
                              icon: Ionicons.person_circle_outline,
                              title: "personalInformation".tr(),
                              subtitle: "",
                              iconBackground: Colors.deepPurple,
                              onTap: () async{
                                showDialog(context: context,
                                 builder: (context) => 
                                const Dialog(
                                  child: PersonInformation(justEditPassword: false),
      
                                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                ),);
                              }),
                          if(StaticValue.userData!.userState == States.INACTIVE && generalController.imageIdPath.value == "")
                          settingItem(
                              icon: Icons.block_rounded,
                              title: "yourIdintity".tr(),
                              subtitle: "",
                              iconBackground: Colors.teal,
                              onTap: () async{
                                showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                          child: AddIdCard(),
                                        ));
                              }),
                           settingItem(
                            icon: Icons.password,
                            title: "putZeroForPassword".tr(),
                            subtitle: "",
                            iconBackground: Colors.blue,
                              onTap: () async{
                                showDialog(context: context,
                                 builder: (context) => 
                                const Dialog(
                                  child: PersonInformation(justEditPassword: true),
      
                                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                ),);
                              }),
                          ],
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
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      )),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
