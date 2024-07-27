
import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart' hide Trans;
import 'package:im_stepper/stepper.dart';
import 'package:its_system/constants.dart';
import 'package:its_system/controllers/home_controller.dart';
import 'package:its_system/core/widgets/cash_image.dart';
import 'package:its_system/core/widgets/nav_bar_icon.dart';
import 'package:its_system/helper/download.dart';
import 'package:its_system/models/institution_model.dart';
import 'package:its_system/models/service_model.dart';
import 'package:its_system/models/user_model.dart';
import 'package:its_system/pages/mobile/components/institution_action.dart';
import 'package:its_system/pages/service/components/column_as_widget.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/controllers/general_controller.dart';
import 'package:its_system/core/models/button_model.dart';
import 'package:its_system/core/widgets/button_bar_widget.dart';
import 'package:its_system/statics_values.dart';


// ignore: must_be_immutable
class ServiceScreen extends StatefulWidget {
  final InstitutionModel institution;
  final String title;
  const ServiceScreen({super.key, required this.institution, required this.title});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  late GeneralController generalController;
  late HomeController controller;

  @override
  void initState() {
    super.initState();
    generalController = Get.put(GeneralController());
    controller = Get.put(HomeController());
  }

  @override
    void dispose() {
      // TODO: implement dispose
      super.dispose();
      for (var element in controller.order.value.service!.serviceForms!) {
        element.key!.currentState!.dispose();
      }
    }

  @override
  Widget build(BuildContext context) {
    return Obx(
        () {
          return Scaffold(
            appBar: AppBar(
              flexibleSpace: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SafeArea(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       NavBarIcon(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    foregroundColor: Theme.of(context).primaryColor,
                    shadowColor: Theme.of(context).shadowColor,
                    icon: Icons.arrow_back,
                    iconEvent: () {
                      controller.currentStep.value = 0;
                      controller.currentFormStep.value = 0;
                      Get.back();
                    },),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            widget.title,
                            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                                fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                       InstitutionActions(institution: widget.institution)
                    ],
                  ),
                ),
              ),
              // backgroundColor: headColor,
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),
              extendBody: true,
              resizeToAvoidBottomInset: false,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 5,),
                    SizedBox(
                      height: AppBar().preferredSize.height,
                      child: ButtonBarWidget(isMain: false, allButtons: [
                            if(controller.service.value.serviceGuides!.isNotEmpty)
                        ButtonModel(
                            icon: Icons.info_outline,
                            title: "infoSteps".tr(),
                            foregroundColor:
                                controller.servicePage.value == 0
                                    ? Colors.white
                                    : Theme.of(context).primaryColor,
                            backgroundColor:
                                controller.servicePage.value == 0
                                    ? Theme.of(context).primaryColor
                                    : Colors.white,
                            onPressed: () {
                              controller.servicePage.value = 0;
                            }),
                            if(controller.service.value.servicePlaces!.isNotEmpty)
                        ButtonModel(
                            icon: Icons.broadcast_on_personal_outlined,
                            title: "breanches".tr(),
                            foregroundColor:
                                controller.servicePage.value == 1
                                    ? Colors.white
                                    : Theme.of(context).primaryColor,
                            backgroundColor:
                                controller.servicePage.value == 1
                                    ? Theme.of(context).primaryColor
                                    : Colors.white,
                            onPressed: () {
                              controller.servicePage.value = 1;
                            }),
                            if(StaticValue.userData!.userType != UserTypes.GUEST && controller.service.value.serviceForms!.isNotEmpty)
                        ButtonModel(
                            icon: Icons.format_shapes_outlined,
                            title: "serviceOrder".tr(),
                            foregroundColor:
                                controller.servicePage.value == 2
                                    ? Colors.white
                                    : Theme.of(context).primaryColor,
                            backgroundColor:
                                controller.servicePage.value == 2
                                    ? Theme.of(context).primaryColor
                                    : Colors.white,
                            onPressed: () async{
                              controller.servicePage.value = 2; 
                            }),
                      ]),
                    ),
                    Expanded(
                        child: controller.servicePage.value == 0?
                        _buildStepper(StepperType.vertical):
                        controller.servicePage.value == 1?
                        places():
                        const NewOrder(forRead: false,))
                  ],
                ),
              ));
        });
  }

  Column places() {
    return Column(
    children: [
      ...controller.service.value.servicePlaces!.map((s) => Card(
        child: ListTile(
          leading: ImageWidget(imagePath: s.institution!.institutionLongitude!),
          title: Text(s.institution!.institutionName!.getTitle,style: Theme.of(context).textTheme.displayMedium,),
          subtitle: Text(s.institution!.institutionAddress!.text,style: Theme.of(context).textTheme.displaySmall,),
        ),
      ))
    ],
  );
  }

   CupertinoStepper _buildStepper(StepperType type) {
    return CupertinoStepper(
      type: type,
      controlsBuilder: (context, details) {
        return Row(
          children: [
            if(controller.currentStep.value != controller.service.value.serviceGuides!.where((s) => s.serviceGuideMainId == 0).length - 1 )
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: blueColor,
              ),
              onPressed: (){
                if(details.onStepContinue!= null ) {
                  details.onStepContinue!();
                }
              },
              child: Text("next".tr(),style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white),),
            )
          ],
        );
      },
      currentStep: controller.currentStep.value,
      onStepTapped: (step) => controller.currentStep.value =step,
      onStepCancel:() =>  --controller.currentStep.value,
      onStepContinue:() =>  ++controller.currentStep.value,
      steps: [
        ...controller.service.value.serviceGuides!.where((s) => s.serviceGuideMainId == 0).toList().asMap().entries.map((e) =>           
        _buildStep(
          serviceGuide: e.value,
            title: Text('${"step".tr()} ${e.key + 1}'),
            isActive: e.key == controller.currentStep.value,
            state: e.key == controller.currentStep.value
                ? StepState.editing
                : e.key < controller.currentStep.value ? StepState.complete : StepState.indexed,
          ),)
      ],
    );
  }

  Step _buildStep({
    required Widget title,
    required ServiceGuideModel serviceGuide,
    StepState state = StepState.indexed,
    bool isActive = false,
  }) {
    return Step(
      title: title,
      state: state,
      isActive: isActive,
      content: SizedBox(
        width: double.infinity,
        child: Card(
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(serviceGuide.serviceGuideName!.getTitle,
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold),),
                ...controller.service.value.serviceGuides!.where((s) => s.serviceGuideMainId == serviceGuide.serviceGuideId).map((s) => 
                RichText(text: TextSpan(text:s.serviceGuideName!.getTitle,style: Theme.of(context).textTheme.displaySmall,children: [
                  if(s.serviceGuidePath != "")
                  TextSpan(text:" ${"pressHere".tr()}",style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.blue),recognizer: TapGestureRecognizer()..onTap = ()async{
                    await downloadFile(s.serviceGuideName!.getTitle, s.serviceGuidePath!);
                  })
                ])),)
              ],
            ),
          ),
        ),
      )
    );
  }
}


class NewOrder extends StatefulWidget {
  final bool forRead;
  const NewOrder({super.key, required this.forRead});

  @override
  State<NewOrder> createState() => _NewOrderState();
}

class _NewOrderState extends State<NewOrder> {

  @override
  Widget build(BuildContext context) {
    return GetX(
      init: HomeController(),
      builder: (controller) {
        return Form(
            key: controller.formKeyForForms,
            // key: controller.order.value.service!.serviceForms![controller.currentFormStep.value].key,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: 
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    color: Theme.of(context).cardColor,
                    child: ExpansionTile(
                      trailing: const Icon(Icons.info_outline),
                      title:Text(controller.order.value.service!.serviceForms![controller.currentFormStep.value].serviceFormName!.getTitle,style: Theme.of(context).textTheme.displaySmall!),
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 150),
                        child: SingleChildScrollView(
                          child: Text(controller.order.value.service!.serviceForms![controller.currentFormStep.value].serviceFormDescription!.getTitle,style: Theme.of(context).textTheme.labelLarge!),
                        ),
                      )
                    ],
                    )
                  ),
                ),
                Expanded(
                  child: AbsorbPointer(
                    absorbing: widget.forRead,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...controller.order.value.service!.serviceForms![controller.currentFormStep.value].formFields!.asMap().entries.map((e) => 
                          ColumnsAsWidgets(columnType: e.value.formFieldType!, generalChange: ({value}){
                            controller.order.update((val) {
                              val!.service!.serviceForms![controller.currentFormStep.value].formFields![e.key].formFieldValue!.text = value;
                            });
                            controller.order.refresh();
                          }, value: e.value.formFieldValue!, title: e.value.formFieldName!.getTitle, isNull: e.value.formFieldIsNull!,values: e.value.formFieldDetails!.map((e) => e.codeName!.getTitle).toList(),))
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  color: Theme.of(context).cardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            previousButton(controller),
                            (controller.currentFormStep.value < controller.order.value.service!.serviceForms!.length - 1) ? 
                            nextButton(controller):
                            (!widget.forRead)?
                            saveButton(controller):const SizedBox()
                            ],
                        ),
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Tooltip(
                    message: "forms".tr(),
                    child: IconStepper(
                      enableNextPreviousButtons: false,
                      activeStepColor: Theme.of(context).primaryColor,
                      enableStepTapping: false,
                      icons: [
                        ...controller.order.value.service!.serviceForms!.asMap().entries.map((e) {
                          if(e.key < controller.currentFormStep.value){
                            return const Icon(Icons.check_circle_outline,color: Colors.white,);
                          }
                          return Icon(numberAsIcon[e.key+1],color: Colors.white);
                        })
                      ],
                      stepReachedAnimationDuration:const Duration(milliseconds: 500),
                      activeStep: controller.currentFormStep.value,
                      onStepReached: (index) {
                        controller.currentFormStep.value = index;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
Widget nextButton(HomeController controller) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: blueColor),
      onPressed:() {
        /// ACTIVE STEP MUST BE CHECKED FOR (dotCount - 1) AND NOT FOR dotCount To PREVENT Overflow ERROR.
        if(controller.formKeyForForms.currentState!.validate()){
          controller.currentFormStep.value++;
        }
      },
      child: Text('next'.tr(),style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white),),
    );
  }
Widget saveButton(HomeController controller) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: blueColor),
      onPressed:() async{
        /// ACTIVE STEP MUST BE CHECKED FOR (dotCount - 1) AND NOT FOR dotCount To PREVENT Overflow ERROR.
        if(controller.formKeyForForms.currentState!.validate()){
          await controller.addUpdateOrder();
        }
      },
      child: Text('save'.tr(),style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white),),
    );
  }

  /// Returns the previous button widget.
  Widget previousButton(HomeController controller) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: blueColor),
      child: Text('back'.tr(),style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white),),
      onPressed:controller.currentFormStep.value ==0 ? null: () {
        controller.currentFormStep.value--;
      },
    );
  }
}

Map<int,IconData> numberAsIcon = {
  1:FontAwesomeIcons.one,
  2:FontAwesomeIcons.two,
  3:FontAwesomeIcons.three,
  4:FontAwesomeIcons.four,
  5:FontAwesomeIcons.five,
  6:FontAwesomeIcons.six,
  7:FontAwesomeIcons.seven,
  8:FontAwesomeIcons.eight,
  9:FontAwesomeIcons.nine,
};
// class StepProgressView extends StatelessWidget {
//   final double _width;

//   final List<String> _titles;
//   final int _curStep;
//   final Color _activeColor;
//   final Color _inactiveColor = const Color(0xffE6EEF3);
//   final double lineWidth = 3.0;

//   StepProgressView(
//       {Key? key,
//       required int curStep,
//       required List<String> titles,
//       required double width,
//       required Color color})
//       : _titles = titles,
//         _curStep = curStep,
//         _width = width,
//         _activeColor = color,
//         assert(width > 0),
//         super(key: key);

//   Widget build(BuildContext context) {
//     return SizedBox(
//         width: this._width,
//         child: Column(
//           children: <Widget>[
//             Row(
//               children: _iconViews(),
//             ),
//             const SizedBox(
//               height: 8,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: _titleViews(),
//             ),
//           ],
//         ));
//   }

//   List<Widget> _iconViews() {
//     var list = <Widget>[];
//     _titles.asMap().forEach((i, icon) {
//       var circleColor = (i == 0 || _curStep > i + 1) ? _activeColor : _inactiveColor;
//       var lineColor = _curStep > i + 1 ? _activeColor : _inactiveColor;
//       var iconColor = (i == 0 || _curStep > i + 1) ? _activeColor : _inactiveColor;

//       list.add(
//         Container(
//           width: 20.0,
//           height: 20.0,
//           padding: const EdgeInsets.all(0),
//           decoration: BoxDecoration(
//             /* color: circleColor,*/
//             borderRadius: const BorderRadius.all(Radius.circular(22.0)),
//             border: Border.all(
//               color: circleColor,
//               width: 2.0,
//             ),
//           ),
//           child: Icon(
//             Icons.circle,
//             color: iconColor,
//             size: 12.0,
//           ),
//         ),
//       );

//       //line between icons
//       if (i != _titles.length - 1) {
//         list.add(Expanded(
//             child: Container(
//           height: lineWidth,
//           color: lineColor,
//         )));
//       }
//     });

//     return list;
//   }

//   List<Widget> _titleViews() {
//     var list = <Widget>[];
//     _titles.asMap().forEach((i, text) {
//       list.add(Text(text, style: const TextStyle(color: Color(0xff000000))));
//     });
//     return list;
//   }
// }
