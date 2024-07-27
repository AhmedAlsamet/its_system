import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/controllers/report_controller.dart';
import 'package:its_system/core/utils/date_picker.dart';
import 'package:its_system/core/widgets/input_field.dart';
import 'package:its_system/models/user_model.dart';
import 'package:its_system/responsive.dart';

class ReportSettingDialog extends StatefulWidget {
  final UserTypes userType;
  final UserModel? user;

  final bool forOrder;
  final int index;
  const ReportSettingDialog({
    required this.userType,
    required this.forOrder,
    required this.index,
    this.user,
    super.key,
    // this.image = Image(image: 'assets/imah1.jpg')
  });

  @override
  State<ReportSettingDialog> createState() => _ReportSettingDialogState();
}

class _ReportSettingDialogState extends State<ReportSettingDialog> {

  late ReportController controller;
  @override
  void initState() {
    super.initState();
    controller = Get.put(ReportController(widget.userType.obs));
    if(widget.user != null){
      controller.user.value = UserModel().copyWith(user: widget.user);
    }
  }

  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: Responsive.isDesktop(context)
          ? null
          : const EdgeInsets.symmetric(horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.only(
            top: 16,
            bottom: 16,
            left: 16,
            right: 16,
          ),
          margin: const EdgeInsets.only(
            top: 60,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                blurRadius: 10,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Obx(
              () {
                return Form(
                  key: key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "reportPerper".tr(),
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InputField(
                        isRequired: false,
                        node: FocusNode(),
                        keyboardType: TextInputType.multiline,
                        controller: controller.title,
                        label: "title".tr(),
                        onFieldSubmitted: (v) async {},
                      ),
                      const SizedBox(
                        height: 5,
                      ),

                            if(widget.forOrder)
                            Column(children: [
                                    RadioListTile(
                                      title: Text(
                                        "ALL".tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                      ),
                                      value: "ALL",
                                      groupValue: controller.orderState.value,
                                      onChanged: (v) {
                                        controller.orderState.value = v!;
                                      },
                                    ),
                                    RadioListTile(
                                      title: Text(
                                        "successed".tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                      ),
                                      value: "DONE",
                                      groupValue: controller.orderState.value,
                                      onChanged: (v) {
                                        controller.orderState.value = v!;
                                      },
                                    ),
                                    RadioListTile(
                                      title: Text(
                                        "canceled".tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                      ),
                                      value: "CANCELED",
                                      groupValue: controller.orderState.value,
                                      onChanged: (v) {
                                        controller.orderState.value = v!;
                                      },
                                    ),
                                  ],),
                      const SizedBox(
                        height: 5,
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "fromDate".tr(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                    width: Responsive.isDesktop(context)
                                        ? 200
                                        : 120,
                                    child: Card(
                                      elevation: 5,
                                      color: Theme.of(context).cardColor,
                                      child: ListTile(
                                        onTap: () async {
                                          final newDate = await selectDate(
                                              context: context,
                                              firesDate: DateTime(2020),
                                              lastDate: DateTime.now());
                                          controller.fromDate.value = newDate;
                                        },
                                        title: Text(
                                            DateFormat('yyyy-MM-dd').format(
                                                controller.fromDate.value),
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall!),
                                      ),
                                    )),
                              ],
                            ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "toDate".tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width:
                                    Responsive.isDesktop(context) ? 200 : 120,
                                child: Card(
                                  elevation: 5,
                                  color: Theme.of(context).cardColor,
                                  child: ListTile(
                                    onTap: () async {
                                      final newDate = await selectDate(
                                          context: context,
                                          firesDate: DateTime(2020),
                                          lastDate: DateTime.now());
                                      controller.toDate.value = newDate;
                                    },
                                    title: Text(
                                        DateFormat('yyyy-MM-dd')
                                            .format(controller.toDate.value),
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall!),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]),
                          const SizedBox(height: 10,),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor),
                          onPressed: () async {
                            if(key.currentState!.validate()) {
                              controller.printRrport(widget.index);
                            }
                          },
                          child: Text(
                            "print".tr(),
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(color: Colors.white),
                          )),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }

  dialogContent(BuildContext context) {
    return;
  }
}
