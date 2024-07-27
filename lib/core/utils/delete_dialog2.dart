import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:its_system/core/widgets/input_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/constants.dart';

Future deleteMessage2({required String title,required String content,required Function onDelete,required Function onCancel,required bool onWillPop,String? deleteButton = "delete"})async{
      await Get.defaultDialog<bool>(
        titleStyle: Theme.of(Get.overlayContext!).textTheme.displayLarge!.copyWith(
          fontWeight: FontWeight.bold
          // color: Colors.black
        ),
        middleTextStyle: Theme.of(Get.overlayContext!).textTheme.displaySmall!.copyWith(
          // color: Colors.black
        ),
                      title: title,
                      middleText: content,
                      titlePadding: const EdgeInsets.only(top:30),
                      // onCancel: ()=>Get.back(result:false),
                      onWillPop: () async=>onWillPop,
                      // onConfirm:()async {
                      //   Get.back(result:true);
                      // } ,
                      radius: 20,
                      actions: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: redColor
                          ),
                          onPressed: ()async{
                            await onDelete();
                        }, child: Text(deleteButton!,style:
                        Theme.of(Get.overlayContext!).textTheme.displaySmall!.copyWith(color: Colors.white))),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(Get.overlayContext!).primaryColor
                          ),
                          onPressed: (){
                            onCancel();
                        }, child: Text("ignore".tr(),style:
                        Theme.of(Get.overlayContext!).textTheme.displaySmall!.copyWith(color: Colors.white))),
                      ],
                      backgroundColor: Theme.of(Get.overlayContext!).cardColor,
                    );
    }

    Future deleteMessageWithReason({required String title,required String content,required Function(String) onDelete,required Function onCancel,required bool onWillPop,String forNoteTitle = "ملاحظات",String deleteText = ""})async{
      TextEditingController controller = TextEditingController();
      GlobalKey<FormState> key = GlobalKey<FormState>();
      await Get.defaultDialog<bool>(
        titleStyle: Theme.of(Get.overlayContext!).textTheme.displayLarge!.copyWith(
          fontWeight: FontWeight.bold
          // color: Colors.black
        ),
        middleTextStyle: Theme.of(Get.overlayContext!).textTheme.displaySmall!.copyWith(
          // color: Colors.black
        ),
                      title: title,
                      middleText: content,
                      // textConfirm: "نعم",
                      // textCancel: "لا",
                      titlePadding: const EdgeInsets.only(top:30),
                      // onCancel: ()=>Get.back(result:false),
                      onWillPop: () async=>onWillPop,
                      // onConfirm:()async {
                      //   Get.back(result:true);
                      // } ,
                      radius: 20,
                      content: Column(
                        children: [
                          Text(content,style:Theme.of(Get.overlayContext!).textTheme.displaySmall!.copyWith(
          // color: Colors.black
        ) ,),
        const SizedBox(height: 10,),
                          Form(
                            key: key,
                            child: Center(
                              
                              child: InputField(
                                label: forNoteTitle,
                                maxLines: 3,
                                isRequired: true,
                                node: FocusNode(),
                                keyboardType: TextInputType.text,
                                controller: controller),
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:  blueColor
                          ),
                          onPressed: (){
                            if(key.currentState!.validate()){
                              onDelete(controller.text);
                            }
                        }, child: Text(deleteText == "" ?"save".tr() : deleteText,style:
                        Theme.of(Get.overlayContext!).textTheme.displaySmall!.copyWith(color: Colors.white))),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: redColor
                          ),
                          onPressed: (){
                            onCancel();
                        }, child: Text("cancel".tr(),style:
                        Theme.of(Get.overlayContext!).textTheme.displaySmall!.copyWith(color: Colors.white))),
                      ],
                      backgroundColor: Theme.of(Get.overlayContext!).cardColor,
                    );
    }
  
  
// deleteDialog({required BuildContext context,required String title,required String description,required IconData icon,required Function deleteEvent}) {
//   AwesomeDialog(
//     context: context,
//     animType: AnimType.leftSlide,
//     headerAnimationLoop: false,
//     dialogType: DialogType.question,
//     showCloseIcon: true,
//     title: title,
//     titleTextStyle: Theme.of(context).textTheme.displayLarge!.copyWith(color: Colors.black),
//     descTextStyle: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.black),
//     btnOkColor: redColor,
//     btnCancelColor: headColor,
//     customHeader: FittedBox(
//       child: Icon(
//         icon,
//         color: headColor,
//         size: 150,
//       ),
//     ),
//     btnOkText: "delete".tr(),
//     btnCancelText: "cancel".tr(),
//     desc:
//         '$description',
//     btnOkOnPress: () {
//       // debugPrint('OnClcik');
//       deleteEvent();
//     },
//     btnCancelOnPress: (){
//     },
//     // btnOkIcon: Icons.check_circle,
//     onDismissCallback: (type) {
//       // debugPrint('Dialog Dissmiss from callback $type');
//     },
//     dialogBackgroundColor: Colors.white
//   ).show();
// }
