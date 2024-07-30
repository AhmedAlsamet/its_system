import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get_storage/get_storage.dart';
import 'package:ionicons/ionicons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/controllers/entry_controller.dart';
import 'package:its_system/core/widgets/dropdown_button.dart';
import 'package:its_system/core/widgets/input_field.dart';
import 'package:its_system/core/widgets/row_or_column.dart';
import 'package:its_system/core/models/dropdown_button_model.dart';
import 'package:its_system/helper/db/general_helper.dart';
import 'package:its_system/models/notification_model.dart';
import 'package:its_system/models/user_model.dart';
import 'package:its_system/responsive.dart';
import 'package:workmanager/workmanager.dart';




late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future showNotification(int id,String title,String description) async {


  // for (var i = 0; i < notifications.length; i++) {
    
  AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    "1",
    'appName'.tr(),
    channelDescription:  'companyName'.tr(),
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    enableVibration: true,

  );
  var iOSPlatformChannelSpecifics = DarwinNotificationDetails(
    categoryIdentifier: "plainCategory",
    threadIdentifier: 'thread_id',
  );
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics
  );


    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      description,
      platformChannelSpecifics,
    );
    // await flutterLocalNotificationsPlugin.show(
    //   notifications[0].value.notificationId!,
    //   notifications[0].value.notificationTitle!.getTitle,
    //   notifications[0].value.notificationDetails!.getTitle,
    //   platformChannelSpecifics,
    // );
  // }


  /// periodically...but const id && const title,body
  /*await flutterLocalNotificationsPlugin.periodicallyShow(
    Random().nextInt(azkar.length-1),
    'السلام عليكم',
    azkar[Random().nextInt(azkar.length-1)],
    RepeatInterval.everyMinute,
    platformChannelSpecifics,
    androidAllowWhileIdle: true,
    payload: '',
  );*/

}



void callbackDispatcher() async{

  // initial notifications
  var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
   DarwinInitializationSettings initializationSettingsDarwin =
      const DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );

  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  WidgetsFlutterBinding.ensureInitialized();

  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );


  Workmanager().executeTask((task, inputData) async{
    
      Connectivity connectivity = Connectivity();
    // connectivity.onConnectivityChanged.listen((ConnectivityResult event) async{ 
    // if(event == ConnectivityResult.none){
      ConnectivityResult c = await connectivity.checkConnectivity();
      if(c != ConnectivityResult.none) {
      // showNotification(1,"محمد","صلى الله عليه وسلم");
        await getNotifications();
      }
      // showNotification(11,"Offline${DateTime.now()}","Hello");
      // }
      // else{
        // await getNotifications();
      // }
    // },cancelOnError: true);
    return Future.value(true);
  });
}
Future<void> getNotifications()async{
 GeneralHelper db = GeneralHelper();
  await GetStorage.init();
  Map<String, dynamic>? u = GetStorage().read("its_user");
  // for save last notifications revived
  if(u != null){
    UserModel user = UserModel.fromMap(u);
    int userId = user.userId!;
    String userType = user.userType!.name;
    int institutionId = user.institution!.institutionId!;

    int lastId = GetStorage().read("last_not")??0;
    List? l = await db.getAllAsMap("SELECT * FROM notifications as n "
        " INNER JOIN notfication_reservers as nr on nr.NOT_ID = n.NOT_ID "
        " INNER JOIN users as u on u.USR_ID = n.USR_ID "
        " WHERE n.USR_ID != $userId AND (nr.INST_ID = $institutionId OR nr.INST_ID = 0) AND (nr.USR_ID = $userId or (nr.USR_id = 0 and nr.NOT_TYPE = '$userType' )) AND n.NOT_ID > $lastId"
        " /*ORDER BY n.NOT_ID DESC;*/");
    if(l != null && l.isNotEmpty){
      NotificationModel n = NotificationModel.fromMap(l.first);
      showNotification(n.notificationId!,n.notificationTitle!.getTitle,n.notificationDetails!.getTitle);
    }
  }
}


class EntryPage extends StatefulWidget {
  const EntryPage({super.key});

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {

  @override
  void initState() {
    super.initState();
    if(Platform.isAndroid || Platform.isIOS) {
      // Workmanager().initialize(
      //   callbackDispatcher
      // );
    }
  }
  @override
  Widget build(BuildContext context) {
    return GetX(
        init: EntryController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              // backgroundColor: Theme.of(context).primaryColor,
              // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 5,
              title: Row(
                mainAxisAlignment: !Responsive.isMobile(context)
                    ? MainAxisAlignment.spaceEvenly
                    : MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        right: Responsive.isMobile(context) ? 10 : 0),
                    child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          // backgroundColor: Colors.transparent,
                          padding: const EdgeInsets.all(10),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        label: Text(
                          controller.isLight.value ? "light".tr() : "dark".tr(),
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          if (GetStorage().read("darkMode")) {
                            Get.changeThemeMode(ThemeMode.light);
                            GetStorage().write("darkMode", false);
                          } else {
                            Get.changeThemeMode(ThemeMode.dark);
                            GetStorage().write("darkMode", true);
                          }
                          controller.isLight.value = !controller.isLight.value;
                        },
                        icon: Icon(
                          !controller.isLight.value
                              ? Ionicons.moon
                              : Ionicons.sunny,
                          color: Theme.of(context).iconTheme.color,
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: Responsive.isMobile(context) ? 10 : 0),
                    child: PopupMenuWidget(
                        node: FocusNode(),
                        selectedItem: controller.activeLanguageCode.value,
                        onChanged: (v) {
                          controller.activeLanguageCode.value = v!;
                          translator.setNewLanguage(
                            context,
                            newLanguage: v,
                            remember: true,
                          );
                        },
                        items: [
                          DropdownButtonModel(
                              dropName: "arabic".tr(),
                              dropOrder: 0,
                              dropImage: "assets/icons8-iraq.png",
                              dropValue: 'ar'),
                          DropdownButtonModel(
                              dropName: "English",
                              dropOrder: 1,
                              dropImage: "assets/icons8-british-flag.png",
                              dropValue: 'en'),
                          // ], title: (controller.activeLanguageCode.value == 'ar' ? "arabic".tr() : controller.activeLanguageCode.value == 'en' ? "Englis":"كردي")),
                        ]),
                  ),
                ],
              ),
            ),
            body: PageView(
              scrollDirection: Axis.horizontal,
              onPageChanged: (v) {},
              controller: controller.pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(
                      decelerationRate: ScrollDecelerationRate.fast,
                    ),
                    child: PopScope(
                      canPop: false,
                      onPopInvoked: (v)async{
                        if(!v){
                          await controller
                              .pageController
                              .animateToPage(1,
                                  duration:
                                      const Duration(
                                          milliseconds:
                                              500),
                                  curve:
                                      Curves.bounceOut);
                        }
                      },
                      child: Column(
                        children: [
                          Dialog(
                            insetPadding: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 400),
                              padding: const EdgeInsets.only(
                                top: 15,
                                bottom: 12,
                                left: 12,
                                right: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Form(
                                key: controller.signAsVisitorFormKey,
                                child: controller.loginIn.value
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                            Center(
                                                child: Image.asset(
                                              "assets/logo.png",
                                              width: 100,
                                              height: 100,
                                            )),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Center(
                                              child: Text(
                                                "continue".tr(),
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayLarge!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            InputField(
                                              isRequired: true,
                                              node: controller.emailNode,
                                              autoFocus: true,
                                              keyboardType: TextInputType.text,
                                              
                                              controller:
                                                  controller.emailController,
                                              hint:
                                                  "userName".tr(),
                                              onFieldSubmitted: (v) async {
                                                if (v.trim() != "") {
                                                  await controller.onSignAsGuest();
                                                }
                                              },
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              margin: const EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      padding:
                                                          const EdgeInsets.all(20),
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                      shape: BeveledRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  3))),
                                                  onPressed: () async {
                                                    await controller.onSignAsGuest();
                                                  },
                                                  child: Text(
                                                    "continue".tr(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displaySmall!
                                                        .copyWith(
                                                            color: Colors.white),
                                                  )),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ])
                                    : const SizedBox(),
                              ),
                            ),
                          ),
                            TextButton.icon(
                              onPressed: () async {
                                await controller
                                    .pageController
                                    .animateToPage(1,
                                        duration:
                                            const Duration(
                                                milliseconds:
                                                    500),
                                        curve:
                                            Curves.bounceOut);
                              },
                              label: const Icon(Icons.arrow_back,color: Colors.blue,),
                              icon : Text("back".tr(),style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.blue),),),
                               const SizedBox(width: 100,child: Divider(color: Colors.blue,),)
                        ],
                      ),
                    ),
                  ),
                ),
                
                Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(
                      decelerationRate: ScrollDecelerationRate.fast,
                    ),
                    child: PopScope(
                      canPop: false,
                      child: Column(
                        children: [
                          Dialog(
                            insetPadding: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 400),
                              padding: const EdgeInsets.only(
                                top: 15,
                                bottom: 12,
                                left: 12,
                                right: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Form(
                                key: controller.loginFormKey,
                                child: controller.loginIn.value
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                            Center(
                                                child: Image.asset(
                                              "assets/logo.png",
                                              width: 100,
                                              height: 100,
                                            )),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Center(
                                              child: Text(
                                                "login".tr(),
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayLarge!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            Directionality(
                                              textDirection: TextDirection.ltr,
                                              child: InputField(
                                                isRequired: true,
                                                node: controller.emailNode,
                                                autoFocus: true,
                                                keyboardType: TextInputType.text,
                                                
                                                controller:
                                                    controller.emailController,
                                                hint:
                                                    "emailAddressOrPhoneNumber".tr(),
                                                onFieldSubmitted: (v) async {
                                                  if (v.trim() != "") {
                                                    controller.passwordNode.requestFocus();
                                                    // await controller.onClickEnter();
                                                  }
                                                },
                                              ),
                                            ),
                                            // const SizedBox(
                                            //   height: 5,
                                            // ),
                                            // InputField(
                                            //   isRequired: false,
                                            //   readOnly: true,
                                            //   node: nameNode,
                                            //   keyboardType: TextInputType.text,
                                            //   controller: name,
                                            //   label: "${"employeeName.tr()"}",
                                            //   onFieldSubmitted: (v) async {
                                            //     passwordNode.requestFocus();
                                            //   },
                                            // ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Directionality(
                                              textDirection: TextDirection.ltr,
                                              child: InputField(
                                                obscureText: true,
                                                isRequired: true,
                                                node: controller.passwordNode,
                                                keyboardType: TextInputType.text,
                                                controller:
                                                    controller.passwordController,
                                                hint: "password".tr(),
                                                onFieldSubmitted: (v) async {
                                                  await controller.onLogin();
                                                },
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            CheckboxListTile(
                                              activeColor: Theme.of(context).primaryColor,
                                              title: Text("rememberMe".tr(),style: Theme.of(context).textTheme.labelLarge,),
                                              value: controller.rememberMe.value,
                                             onChanged: (v){
                                              controller.rememberMe.value = v!;
                                             }),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              margin: const EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      padding:
                                                          const EdgeInsets.all(20),
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                      shape: BeveledRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  3))),
                                                  onPressed: () async {
                                                    await controller.onLogin();
                                                    controller.loginIn.value = true;
                                                  },
                                                  child: Text(
                                                    "login".tr(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displaySmall!
                                                        .copyWith(
                                                            color: Colors.white),
                                                  )),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Flexible(
                                                    child: Text(
                                                  "ifYouDoNotHaveAccountMessage"
                                                      .tr(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium,
                                                )),
                                                TextButton(
                                                    onPressed: () async {
                                                      await controller
                                                          .pageController
                                                          .animateToPage(2,
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          500),
                                                              curve:
                                                                  Curves.bounceOut);
                                                    },
                                                    child: Text(
                                                      "signup".tr(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelMedium!
                                                          .copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor),
                                                    ))
                                              ],
                                            ),
                                          ])
                                    : const SizedBox(),
                              ),
                            ),
                          ),
                            TextButton.icon(
                              onPressed: () async {
                                await controller
                                    .pageController
                                    .animateToPage(0,
                                        duration:
                                            const Duration(
                                                milliseconds:
                                                    500),
                                        curve:
                                            Curves.bounceOut);
                              },
                              label: const Icon(Icons.arrow_forward,color: Colors.blue,),
                              icon : Text("pass".tr(),style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.blue),),),
                               const SizedBox(width: 100,child: Divider(color: Colors.blue,),)
                        ],
                      ),
                    ),
                  ),
                ),
                
                Center(
                  child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(
                        decelerationRate: ScrollDecelerationRate.fast,
                      ),
                      child: PopScope(
                          canPop: false,
                          child: Dialog(
                            insetPadding: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 600),
                              padding: const EdgeInsets.only(
                                top: 15,
                                bottom: 12,
                                left: 12,
                                right: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Form(
                                key: controller.signupFormKey,
                                child: controller.loginIn.value
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                            Center(
                                                child: Image.asset(
                                              "assets/logo.png",
                                              width: 100,
                                              height: 100,
                                            )),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Center(
                                              child: Text(
                                                "signup".tr(),
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayLarge!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            // Wrap(
                                            //   spacing: 10,
                                            //   alignment: WrapAlignment.center,
                                            //   crossAxisAlignment:
                                            //       WrapCrossAlignment.center,
                                            //   children: [
                                            //     SizedBox(
                                            //       width: 150,
                                            //       child: DropdownButtonWidget(
                                            //           title: "city".tr(),
                                            //           onChanged: (v) {
                                            //             controller.selectedCountry.value = v!;
                                            //             controller.selectedCity.value = controller.municipalities.firstWhere((c) => c.value.city!.cityId == controller.selectedCountry.value,orElse: () => MunicipalityModel(municipalityId:0).obs,).value.municipalityId!;
                                            //             controller.selectedCompound.value = controller.institutions.firstWhere((c) => c.value.municipality!.municipalityId == controller.selectedCity.value,orElse: () => InstitutionModel(institutionId:0).obs,).value.institutionId!;
                                            //           },
                                            //           selectedItem: controller.selectedCountry.value,
                                            //           node: FocusNode(),
                                            //           items: [
                                            //             ...controller.cities.asMap().entries.map((c) => DropdownButtonModel(
                                            //               dropName: c.value.value.cityName!.getTitle,
                                            //               dropOrder: c.key,
                                            //               dropValue: c.value.value.cityId!
                                            //             )).toList(),
                                            //           ]),
                                            //     ),
                                            //     SizedBox(
                                            //       width: 150,
                                            //       child: DropdownButtonWidget(
                                            //           title: "municipality".tr(),
                                            //           onChanged: (v) {
                                            //             controller.selectedCity.value = v!;
                                            //             controller.selectedCompound.value = controller.institutions.firstWhere((c) => c.value.municipality!.municipalityId == controller.selectedCity.value,orElse: () => InstitutionModel(institutionId:0).obs,).value.institutionId!;
                                            //           },
                                            //           selectedItem: controller.selectedCity.value,
                                            //           node: FocusNode(),
                                            //           items: [
                                            //             if(controller.municipalities.where((c) => c.value.city!.cityId == controller.selectedCountry.value).isEmpty)
                                            //             DropdownButtonModel(
                                            //               dropName: "unknown".tr(),
                                            //               dropOrder: 0,dropValue: 0
                                            //             ),
                                            //              ...controller.municipalities.where((c) => c.value.city!.cityId == controller.selectedCountry.value).toList().asMap().entries.map((c) => DropdownButtonModel(
                                            //               dropName: c.value.value.municipalityName!.getTitle,
                                            //               dropOrder: c.key,
                                            //               dropValue: c.value.value.municipalityId!
                                            //             )),
                                            //           ]),
                                            //     ),
                                            //     SizedBox(
                                            //       width: 250,
                                            //       child: DropdownButtonWidget(
                                            //           title:
                                            //               "${"institution".tr()}*",
                                            //           onChanged: (v) {
                                            //             controller.selectedCompound.value = v!;
                                            //           },
                                            //           selectedItem: controller.selectedCompound.value,
                                            //           node: FocusNode(),
                                            //           items: [
                                            //             if(controller.institutions.where((c) => c.value.municipality!.municipalityId == controller.selectedCity.value).isEmpty)
                                            //             DropdownButtonModel(
                                            //               dropName: "unknown".tr(),
                                            //               dropOrder: 0,dropValue: 0
                                            //             ),
                                            //             ...controller.institutions.where((c) => c.value.municipality!.municipalityId == controller.selectedCity.value).toList().asMap().entries.map((c) => DropdownButtonModel(
                                            //               dropName: c.value.value.institutionName!.getTitle,
                                            //               dropOrder: c.key,
                                            //               dropValue: c.value.value.institutionId
                                            //             )),
                                            //           ]),
                                            //     ),
                                            //   ],
                                            // ),
                                            // const SizedBox(
                                            //   height: 10,
                                            // ),
                                            RowOrColumn(
                                                isRow: !Responsive.isMobile(
                                                    context),
                                                childrenFlexes: const [
                                                  4,
                                                  3
                                                ],
                                                children: [
                                                  InputField(
                                                    maxLength: 100,
                                                    isRequired: true,
                                                    node: FocusNode(),
                                                    keyboardType:
                                                        TextInputType.text,
                                                    controller: controller.user.value
                                                        .userName!.arabicTitle!,
                                                    hint: "${"userName".tr()}*",
                                                  ),
                                                SizedBox(
                                                  width: 150,
                                                  child: DropdownButtonWidget(
                                                      title: "city".tr(),
                                                      onChanged: (v) {
                                                        controller.selectedCity.value = v!;
                                                      },
                                                      selectedItem: controller.selectedCity.value,
                                                      node: FocusNode(),
                                                      items: [
                                                        ...controller.cities.asMap().entries.map((c) => DropdownButtonModel(
                                                          dropName: c.value.value.cityName!.getTitle,
                                                          dropOrder: c.key,
                                                          dropValue: c.value.value.cityId!
                                                        )).toList(),
                                                      ]),
                                                ),
                                                ]),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                                  InputField(
                                                    maxLength: 20,
                                                    isRequired: true,
                                                    node: FocusNode(),
                                                    keyboardType:
                                                        TextInputType.text,
                                                    controller: controller
                                                        .user.value.userPhoneNumber!,
                                                    hint: "${"phoneNumber".tr()}*",
                                                  ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            InputField(
                                              maxLength: 100,
                                              isRequired: false,
                                              node: FocusNode(),
                                              keyboardType: TextInputType.text,
                                              controller:
                                                  controller.user.value.userAddress1!,
                                              hint: "address1Desc".tr(),
                                              label: "address1".tr(),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            InputField(
                                              maxLength: 100,
                                              isRequired: false,
                                              node: FocusNode(),
                                              keyboardType: TextInputType.text,
                                              controller:
                                                  controller.user.value.userEMail!,
                                              additionsalCondection: !EmailValidator.validate(controller.user.value.userEMail!.text,true),
                                              textForErrorMessage: "wrongValue".tr(),
                                              hint: "emailAddress".tr(),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                             RowOrColumn(
                                                isRow: !Responsive.isMobile(
                                                    context),
                                                childrenFlexes: const [
                                                  4,
                                                  3
                                                ],
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text("gender".tr(),style: Theme.of(context).textTheme.displayMedium,),
                                                      SizedBox(
                                                        width: 130,
                                                        child: RadioListTile(
                                                          title: Text("male".tr(),style: Theme.of(context).textTheme.displaySmall,),
                                                          value: true, groupValue: controller.user.value.userGender,
                                                          onChanged: (v){
                                                            controller.user.update((val) {
                                                              val!.userGender = v;
                                                            });
                                                          }),
                                                      ),
                                                      SizedBox(
                                                        width: 130,
                                                        child: RadioListTile(
                                                          title: Text("fmale".tr(),style: Theme.of(context).textTheme.displaySmall,),
                                                          value: false, groupValue: controller.user.value.userGender,
                                                          onChanged: (v){
                                                            controller.user.update((val) {
                                                              val!.userGender = v;
                                                            });
                                                          }),
                                                      )
                                                    ],
                                                  ),
                                                  InputField(
                                                    maxLength: 20,
                                                    isRequired: false,
                                                    node: FocusNode(),
                                                    keyboardType:
                                                        TextInputType.text,
                                                    controller: controller
                                                        .user.value.userAge!,
                                                    hint: "age".tr(),
                                                  ),
                                                ]),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            InputField(
                                              maxLength: 30,
                                              isRequired: true,
                                              node: FocusNode(),
                                              keyboardType: TextInputType.text,
                                              controller:
                                                  controller.user.value.userPassword!,
                                              obscureText: controller.showPassword1.value,
                                              suffix: IconButton(onPressed: (){
                                                controller.showPassword1.value = !controller.showPassword1.value;
                                              }, icon: Icon(controller.showPassword1.value?Ionicons.eye: Ionicons.eye_off,color: Theme.of(context).primaryColor,)),
                                              hint: "${"password".tr()}*",
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            InputField(
                                              maxLength: 30,
                                              isRequired: true,
                                              node: controller.passwordNode,
                                              obscureText: controller.showPassword2.value,
                                              suffix: IconButton(onPressed: (){
                                                controller.showPassword2.value = !controller.showPassword2.value;
                                              }, icon: Icon(controller.showPassword2.value?Ionicons.eye: Ionicons.eye_off,color: Theme.of(context).primaryColor,)),
                                              keyboardType: TextInputType.text,
                                              controller:
                                                  controller.passwordController,
                                              hint: "${"passwordAgain".tr()}*",
                                              onFieldSubmitted: (v) async {
                                                await controller.onLogin();
                                              },
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20),
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                      shape:
                                                          BeveledRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          3))),
                                                  onPressed: () async {
                                                    await controller.onSignUp();
                                                    controller.loginIn.value =
                                                        true;
                                                  },
                                                  child: Text(
                                                    "signup".tr(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displaySmall!
                                                        .copyWith(
                                                            color:
                                                                Colors.white),
                                                  )),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Flexible(
                                                    child: Text(
                                                  "ifYouAlridyHaveAccountMessage"
                                                      .tr(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium,
                                                )),
                                                TextButton(
                                                    onPressed: () async {
                                                      await controller
                                                          .pageController
                                                          .animateToPage(1,
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          500),
                                                              curve: Curves
                                                                  .bounceOut);
                                                    },
                                                    child: Text(
                                                      "login".tr(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelMedium!
                                                          .copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor),
                                                    ))
                                              ],
                                            ),
                                          ])
                                    : const SizedBox(),
                              ),
                            ),
                          ))),
                ),
              
              ],
            ),
          );
        });
  }
}
