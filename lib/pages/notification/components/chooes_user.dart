import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/constants.dart';
import 'package:its_system/models/user_model.dart';

// ignore: must_be_immutable
class ChooseUserDialog extends StatefulWidget {
    final bool isTablet;
    List<UserModel> users;
  ChooseUserDialog({super.key,required this.isTablet,required this.users});

  @override
  State<ChooseUserDialog> createState() => _ChooseUserDialogState();
}

class _ChooseUserDialogState extends State<ChooseUserDialog> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Stack(
          children: <Widget>[
            Container(
              height: 500,
              width: widget.isTablet ? 500 : null,
              padding: const EdgeInsets.only(
                top: 75,
                bottom: 15,
                left: 15,
                right: 15,
              ),
              margin: const EdgeInsets.only(
                top: 60,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // const Text("المفضلة", style: FontsStyle.successDialogTitle),
                  // const SizedBox(height: 15),
                  Expanded(
                      child:
                          NotificationListener<OverscrollIndicatorNotification>(
                              onNotification: (overScroll) {
                                overScroll.disallowIndicator();
                                return false;
                              },
                              child: ListView.builder(
                                itemCount: widget.users.length,
                                itemBuilder: (context, index) {
                                  // MainProductModel item = widget.categories[index];
                                  return 
                                    TextButton(
                                      autofocus: index == 0,
                                      onPressed: (){
                                          Get.back(result: widget.users[index]);
                                    }, child: ListTile(
                                            title: Text(widget.users[index].userName!.getTitle,style: Theme.of(context).textTheme.displaySmall,),
                                            subtitle: Text(widget.users[index].userUniqueKey!.text,style: Theme.of(context).textTheme.labelLarge,),
                                            
                                        // onTap: () {
                                        //   Get.back(result: widget.categories[index]);
                                        //   // page.routeEvent(context);
                                        // },
                                    ));
                                  // return CheckboxListTile(value: allPage[in], onChanged: onChanged)
                                },
                              ))),
                  // const SizedBox(height: 15),
                  // // Align(
                  // //   alignment: Alignment.center,
                  // //   child:
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: redColor
                    ),
                    onPressed: (){
                      // print(widget.products[0].unit!.unitName);
                      Get.back(result: UserModel(userId: -1));
                    }, child: Text(
                    "cancel".tr(),style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Colors.white
                    ),
                  )),
                  // ButtonWidget(
                  //     onClick: (context) {
                  //       Navigator.pop(context);
                  //       Navigator.of(context)
                  //           .push(MaterialPageRoute(builder: (context) {
                  //         return const ChangeSelectsPage();
                  //       }));
                  //     },
                  //     icon: Icons.edit,
                  //     text: "تعديل عناصر المفضلة"),
                  // ),
                ],
              ),
            ),
            Positioned(
              left: 15,
              right: 15,
              child: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                radius: 60,
                child: const FittedBox(
                  child: Icon(
                    Icons.production_quantity_limits,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
