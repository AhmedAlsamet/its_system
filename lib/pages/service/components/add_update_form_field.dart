import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:its_system/constants.dart';
import 'package:its_system/controllers/coding_controller.dart';
import 'package:its_system/controllers/general_controller.dart';
import 'package:its_system/controllers/service_controller.dart';
import 'package:its_system/core/models/dropdown_button_model.dart';
import 'package:its_system/core/utils/delete_dialog2.dart';
import 'package:its_system/core/utils/get_languages.dart';
import 'package:its_system/core/widgets/dropdown_button.dart';
import 'package:its_system/core/widgets/input_field.dart';
import 'package:its_system/core/widgets/switch_list_widget.dart';
import 'package:its_system/models/code_model.dart';
import 'package:its_system/models/service_model.dart';
import 'package:its_system/pages/system_management/components/add_update_code.dart';
import 'package:its_system/responsive.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class AddUpdateFormField extends StatefulWidget {
  final int index;
  const AddUpdateFormField({Key? key, required this.index})
      : super(key: key);

  @override
  State<AddUpdateFormField> createState() => _AddNewOrderBottomSheetState();
}

class _AddNewOrderBottomSheetState extends State<AddUpdateFormField> {
  late List<FocusNode> nodes;
  @override
  void initState() {
    super.initState();
    nodes = [
      FocusNode(),
      FocusNode(),
      FocusNode(),
      FocusNode(),
      FocusNode(),
      FocusNode(),
      FocusNode(),
      FocusNode(),
    ];
    generalController = Get.put(GeneralController());
  }

  late GeneralController generalController;

  // @override
  // void dispose() {
  //   generalController.dispose();
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    return GetX<ServiceController>(
        init: ServiceController(false),
        builder: (value) {
          return Container(
            color: Colors.transparent, //Theme.of(context).primaryColor,
            width: Responsive.isDesktop(context) ? 400 : null,
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Form(
                  key: value.formKey,
                  child: Container(
                    color: Theme.of(context).cardColor,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        InputField(
                          controller:
                              value.formField.value.formFieldOrder!,
                          keyboardType: TextInputType.text,
                          isRequired: true,
                          readOnly: value.isEdit,
                          node: nodes[0],
                          label: "FormFieldOrder".tr() ,
                          onFieldSubmitted: (v) {
                            nodes[1].requestFocus();
                          },
                          isNumber: true,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ...getLanguagesAsWidgets2(
                            value.formField.value.formFieldName!,
                            nodes[1],
                            generalController.settings
                                .where((element) =>
                                    element.settingType == "LANG" &&
                                    element.settingValue!.text == "1")
                                .map((e) => e.settingCode!)
                                .toList(),
                                null,
                            nodes[2]),
                        const SizedBox(
                          height: 10,
                        ),
                        SwitchListTileWidget(
                          title: "isRequired".tr(),
                          subTitle: value.formField.value.formFieldIsNull! ?"INACTIVE".tr(): "ACTIVE".tr(), value: !value.formField.value.formFieldIsNull!, onChanged: (v){
                            value.formField.update((val) {
                              val!.formFieldIsNull = !v;
                            });
                          }),
                        const SizedBox(
                          height: 10,
                        ),
                         DropdownButtonWidget(
                              title: "formType".tr(),
                              onChanged: (v) {
                                value.formField.update((val) {
                                  val!.formFieldType = v!;
                                });
                              },
                              selectedItem: value.formField.value.formFieldType,
                              node: FocusNode(),
                              items: [
                                ...FormFieldTypes.values.map((e) => DropdownButtonModel(
                                        dropName: e.name.tr(),
                                        dropOrder: 0,
                                        dropValue:e))
                              ]),
                        if(value.isEdit && (value.formField.value.formFieldType! == FormFieldTypes.CHECKBOX || 
                            value.formField.value.formFieldType! == FormFieldTypes.RADIO ||
                            value.formField.value.formFieldType! == FormFieldTypes.COMPOBOX))...[
                          ExpansionTile(title: Text("listOfValues".tr(),style: Theme.of(context).textTheme.displayMedium,),children: [
                            ...value.formField.value.formFieldDetails!.map((e) => fieldValue(e, value)),
                            ElevatedButton.icon(
                              icon: const Icon(
                                Icons.check_circle_outline,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                CodingController controller = Get.put(CodingController(table: "form_field_details", column1: "FRMFD_ID", column2: "FRMFD_NAME", columnPrefix: "FRMFD",
                                        column3: "FRMF_ID",
                                        column3Val: value.formField.value.formFieldId!.toString()
                                ));
                                controller.refershCode();
                                await showDialog(context: context, builder: (context)=>Dialog(
                                  child:  AddUpdateCode(controller: controller)));
                                await value.fetchAllFormFields(widget.index);
                              },
                              // Edit
                              label: Text(
                                "add".tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                              ),
                            ),
                            const SizedBox(height: 5,)
                          ],),
                        const SizedBox(
                          height: 10,
                        ),
                        ],
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor),
                              icon: const Icon(
                                Icons.check_circle_outline,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                if (value.formKey.currentState!.validate()) {
                                  await value.addUpdateFormField(widget.index);
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
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: redColor),
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
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                )
              ]),
            ),
          );
        });
  }
  Widget fieldValue(CodeModel fieldValue,ServiceController controller){
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text(fieldValue.codeName!.getTitle,style: Theme.of(context).textTheme.displaySmall,),
          trailing: IconButton(onPressed: (){
            deleteMessage2(
              deleteButton: "delete".tr(),
              title: "areYouSureFor".tr(), content: "${"delete".tr()} ${fieldValue.codeName!.getTitle}", onDelete: ()async{
              await controller.db.delete(tableName: "form_field_details", where: " FRMFD_ID = ${fieldValue.codeId}");
              await controller.fetchAllFormFields(widget.index);
              Get.back();
            }, onCancel: Get.back, onWillPop: true);
          }, icon: const Icon(Icons.delete,color: redColor,),),
        ),
      ),
    );
  }
}
