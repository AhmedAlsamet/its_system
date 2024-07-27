
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:its_system/constants.dart';
import 'package:its_system/controllers/home_controller.dart';
import 'package:its_system/core/models/dropdown_button_model.dart';
import 'package:its_system/core/widgets/dropdown_button.dart';
import 'package:its_system/core/widgets/input_field.dart';
import 'package:its_system/core/widgets/popup_menu.dart';
import 'package:its_system/models/institution_model.dart';
import 'package:its_system/models/user_model.dart';
import 'package:its_system/responsive.dart';
import 'package:its_system/statics_values.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:url_launcher/url_launcher.dart';

class InstitutionActions extends StatefulWidget {
  final InstitutionModel institution;
  InstitutionActions({super.key, required this.institution});

  @override
  State<InstitutionActions> createState() => _InstitutionActionsState();
}

class _InstitutionActionsState extends State<InstitutionActions> {
  @override
  void initState() {
    super.initState();
    items = [
      if(StaticValue.userData!.userType != UserTypes.GUEST)
      PopupMenuItem(
        value: 1,
        child: MyPopupMenuItem(
          icon: Icons.help_outline,
          text: "AskForComplement".tr(),
        ),
      ),
      PopupMenuItem(
        value: 2,
        child: MyPopupMenuItem(
          icon: Icons.location_on_outlined,
          text: "location".tr(),
        ),
      ),
      const PopupMenuDivider(),
      PopupMenuItem(
        value: 3,
        child: MyPopupMenuItem(
          icon: Icons.contact_phone_outlined,
          text: "contactWithUsByPhone".tr(),
        ),
      ),
      PopupMenuItem(
        value: 4,
        child: MyPopupMenuItem(
          icon: Icons.contact_mail_outlined,
          text: "contactWithUsByMail".tr(),
        ),
      ),
    ];
  }

  List<PopupMenuEntry> items = [];

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.5),
                  // offset: Offset(1,-1),
                  spreadRadius: 3,
                  blurRadius: 3),
              BoxShadow(
                  color: Theme.of(context).shadowColor,
                  offset: Offset(-1, 1),
                  spreadRadius: -2,
                  blurRadius: 3)
            ],
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(10)),
        child: PopupMenuButton(
          surfaceTintColor: Colors.transparent,
          tooltip: "more".tr(),
          splashRadius: 15,
          icon: Icon(
            Icons.more_vert,
            color: Theme.of(context).primaryColor,
          ),
          onSelected: (v) async {
            if (v == 1) {
              showDialog(context: context, builder: (context)=>Dialog(
                backgroundColor: Theme.of(context).cardColor,
                insetPadding: const EdgeInsets.symmetric(horizontal: 10),
                child: EnterComplaint(institution: widget.institution,),));
            }
            if (v == 3) {
              await launchUrl(Uri.parse("tel:${widget.institution.institutionPhone!.text}"),);
            }
            if (v == 4) {
              await launchUrl(Uri.parse("mailto:${widget.institution.institutionEMail!.text}"),);
            }
          },
          itemBuilder: (context) {
            return items;
          },
        ));
  }
}

class EnterComplaint extends StatefulWidget {
  final InstitutionModel institution;
  const EnterComplaint({super.key, required this.institution});

  @override
  State<EnterComplaint> createState() => _EnterComplaintState();
}

class _EnterComplaintState extends State<EnterComplaint> {
  late HomeController controller;
  @override
  void initState() {
    super.initState();
    controller= Get.put(HomeController());
    controller.refreshComplaint(widget.institution);
  }
  @override
  Widget build(BuildContext context) {
    return Obx(
         () {
          return Container(
            color: Colors.transparent,
            padding: EdgeInsets.all(10),
            width: Responsive.isDesktop(context) ? 500 : null,
            child: Form(
              key: controller.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.institution.institutionName!.getTitle,style: Theme.of(context).textTheme.displayLarge,),
                  const SizedBox(height: 5,),
                  Text("whatIsYourcomplaint".tr(),style: Theme.of(context).textTheme.displayMedium,),
                  const Divider(),
                  DropdownButtonWidget(
                      selectedItem:
                          controller.complaint.value.complaintType!.codeId,
                      node: FocusNode(),
                      onChanged: (v) {
                        controller.complaint.update((val) {
                          val!.complaintType!.codeId = v!;
                        });
                      },
                      items: [
                        ...controller.complaintTypes.map((e) =>
                            DropdownButtonModel(
                                dropName: e.value.codeName!.getTitle,
                                dropValue: e.value.codeId)),
                        DropdownButtonModel(
                            dropName: "unSelelected".tr(), dropValue: 0)
                      ],
                      title: "complaintType".tr()),
                  const SizedBox(
                    height: 10,
                  ),
                  InputField(
                    isRequired: true,
                    node: FocusNode(),
                    keyboardType: TextInputType.multiline,
                    controller: controller.complaint.value.complaintTitle!,
                    maxLines: 3,
                    maxLength: 1000,
                    hint: "enterYourcomplaint".tr(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor),
                        icon: const Icon(
                          Icons.check_circle_outline,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          if (controller.formKey.currentState!.validate()) {
                            await controller.addNewComplaint();
                          }
                        },
                        // Edit
                        label: Text(
                          "save".tr(),
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      ElevatedButton.icon(
                        style:
                            ElevatedButton.styleFrom(backgroundColor: redColor),
                        icon: const Icon(
                          Icons.cancel_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          Get.back();
                        },
                        // Delete
                        label: Text(
                          "cancel".tr(),
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
