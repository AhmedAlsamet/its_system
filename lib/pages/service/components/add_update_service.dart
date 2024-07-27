
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:ionicons/ionicons.dart';
import 'package:its_system/controllers/general_controller.dart';
import 'package:its_system/controllers/service_controller.dart';
import 'package:its_system/core/models/dropdown_button_model.dart';
import 'package:its_system/core/utils/get_languages.dart';
import 'package:its_system/core/widgets/bottom_sheet_handel.dart';
import 'package:its_system/core/widgets/dropdown_button.dart';
import 'package:its_system/core/widgets/input_field.dart';
import 'package:its_system/models/service_model.dart';
import 'package:its_system/responsive.dart';
import 'package:localize_and_translate/localize_and_translate.dart';


class AddNewServiceBottomSheet extends StatefulWidget {
  const AddNewServiceBottomSheet({Key? key})
      : super(key: key);

  @override
  State<AddNewServiceBottomSheet> createState() =>
      _AddNewOrderBottomSheetState();
}

class _AddNewOrderBottomSheetState extends State<AddNewServiceBottomSheet> {
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
    return DraggableScrollableSheet(
          initialChildSize: Responsive.isDesktop(context) ?1:0.8,
          maxChildSize: 1,
          minChildSize: 0.4,
          expand: Responsive.isDesktop(context) ?false:true,
      builder: (context,c) {
        return GetX<ServiceController>(
                    init: ServiceController(false),
                    builder: (value) {
                  return Container(
                    color:Colors.transparent, //Theme.of(context).primaryColor,
                    width: Responsive.isDesktop(context) ? 500 : null,
                    child: Column(children: [
                      BottomSheetHandel(
                          cancelIcon: Ionicons.close,
                          cancelTooltip: "cancel".tr(),
                          saveIcon: Ionicons.save,
                          saveTooltip: "save".tr(),
                          controller: c,
                          onSave: () async{
                            if(value.formKey.currentState!.validate()){
                              await value.addUpdateService();
                            }
                          },
                          onCancel: () {
                            Get.back(result: "Ahmed");
                          }),
                      Form(
                        key: value.formKey,
                        child: Expanded(
                          child: Scaffold(
                            body: Container(
                          color: Theme.of(context).cardColor,           
                              padding: const EdgeInsets.all(10),
                              child: NotificationListener<
                                      OverscrollIndicatorNotification>(
                                  onNotification: (overScroll) {
                                    overScroll.disallowIndicator();
                                    return false;
                                  },
                                  child: ListView(
                                    children: [
                                       const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                          width: 150,
                                          child: DropdownButtonWidget(
                                              title: "serviceGroup".tr(),
                                              onChanged: (v) {
                                                value.selectedGroup.value = v!;
                                                value.service.value.serviceGroup!.serviceGroupId = v;
                                              },
                                              selectedItem: value
                                                  .selectedGroup.value,
                                              node: FocusNode(),
                                              items: [
                                                ...value.serviceGroups
                                                    .asMap()
                                                    .entries
                                                    .map((c) =>
                                                        DropdownButtonModel(
                                                            dropName:
                                                                c
                                                                    .value
                                                                    .value
                                                                    .serviceGroupName!
                                                                    .getTitle,
                                                            dropOrder: c.key,
                                                            dropValue: c
                                                                .value
                                                                .value
                                                                .serviceGroupId!))
                                                    .toList(),
                                              ]),
                                        ),
                                       const SizedBox(
                                        height: 10,
                                      ),
                                      InputField(
                                        controller:
                                            value.service.value.serviceNumber!,
                                        keyboardType: TextInputType.text,
                                        isRequired: true,
                                        readOnly: value.isEdit,
                                        node: nodes[0],
                                        label: "${"serviceNumber".tr()} *" ,
                                        onFieldSubmitted: (v) {
                                          nodes[1].requestFocus();
                                        },
                                        isNumber: true,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ...getLanguagesAsWidgets2(value.service.value.serviceName!, nodes[1], 
                            generalController.settings.where((element) => element.settingType == "LANG" && element.settingValue!.text == "1").map((e) => e.settingCode!).toList(),
                                        null,
                                       nodes[2]),
                                      
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ...getLanguagesAsWidgets2(value.service.value.serviceDescription!, nodes[2], 
                            generalController.settings.where((element) => element.settingType == "LANG" && element.settingValue!.text == "1").map((e) => e.settingCode!).toList(),
                                      3,
                                       nodes[3]),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      InputField(
                                        controller:
                                            value.service.value.serviceTime!,
                                        keyboardType: TextInputType.number,
                                        isNumber: true,
                                        isRequired: false,
                                        node: nodes[3],
                                        label: "serviceTime".tr(),
                                        hint: "serviceTimeByDay".tr(),
                                        onFieldSubmitted: (v) {
                                          nodes[4].requestFocus();
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                       Row(
                                        children: [
                                          Expanded(
                                            child:CheckboxListTile(
                                              title: Text("hasStaticValue".tr(),style: Theme.of(context).textTheme.displaySmall,),
                                              value: value.service.value.serviceHasStaticValue,
                                              onChanged: (v){
                                                value.service.update((val) {
                                                  val!.serviceHasStaticValue = v;
                                                });
                                              })
                                          ),
                                          if(value.service.value.serviceHasStaticValue!)
                                          Expanded(child:InputField(
                                              maxLength: 10,
                                              isRequired: true,
                                              node: nodes[6],
                                              isNumber: true,
                                              keyboardType: TextInputType.number,
                                              controller:
                                                  value.service.value.servicePrice!,
                                              label: "${"servicePrice".tr()}*",
                                            ),)
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      DropdownButtonWidget<int>(
                                        title: "serviceAvialabe".tr(),
                                        node: nodes[4],
                                       items: [
                                        DropdownButtonModel(
                                          dropName: "InThisInstAndItsSubInts".tr(),
                                          dropValue: 1,
                                          dropOrder: 1
                                        ),
                                        DropdownButtonModel(
                                          dropName: "JustInItsSubInts".tr(),
                                          dropValue: 2,
                                          dropOrder: 2
                                        ),
                                        DropdownButtonModel(
                                          dropName: "unavailable".tr(),
                                          dropValue: 0,
                                          dropOrder: 3
                                        ),
                                       ],
                                       selectedItem: value.service.value.serviceState!,
                                       onChanged: (v){
                                          value.service.update((val) {
                                            val!.serviceState = v;
                                          });
                                       },
                                       ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      DropdownButtonWidget<ServiceTypes>(
                                        title: "serviceType".tr(),
                                        node: nodes[4],
                                       items: [
                                        ...ServiceTypes.values.map((e) => DropdownButtonModel(
                                          dropName: e.name.tr(),
                                          dropValue: e,
                                          dropOrder: 1
                                        ),
                                        )
                                       ],
                                       selectedItem: value.service.value.serviceType!,
                                       onChanged: (v){
                                          value.service.update((val) {
                                            val!.serviceType = v;
                                          });
                                       },
                                       ),
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
                  );
                });
      }
    );
  }
}