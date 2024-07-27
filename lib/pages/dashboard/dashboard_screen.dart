
import 'package:get/get.dart' hide Trans;
import 'package:its_system/constants.dart';
import 'package:its_system/controllers/controller_panel_controller.dart';
import 'package:its_system/models/complaint_model.dart';
import 'package:its_system/models/user_model.dart';
import 'package:its_system/pages/dashboard/components/mini_information_card.dart';
import 'package:its_system/pages/dashboard/components/recent_complaints.dart';
import 'package:its_system/pages/dashboard/components/recent_forums.dart';
import 'package:its_system/pages/dashboard/components/reports_widget.dart';
import 'package:its_system/responsive.dart';
import 'package:flutter/material.dart';
import 'package:its_system/statics_values.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late ControllerPanelController controller;
  @override
  void initState() {
    super.initState();
    controller =Get.put(ControllerPanelController());
  }
  @override
  Widget build(BuildContext context) {
        return Obx(
          () {
            return Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.all(defaultPadding),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // const Header(),
                    // const SizedBox(height: defaultPadding),
                    const MiniInformation(),
                    const SizedBox(height: defaultPadding),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Column(
                            children: [
                              //MyFiels(),
                              //SizedBox(height: defaultPadding),
                              const SizedBox(height: defaultPadding),
                              RecentDiscussions(users: controller.users.where((u) => ( u.value.userType == UserTypes.ADMIN && u.value.institution!.institutionId == StaticValue.userData!.institution!.institutionId)).map((element) => element.value).toList()),
                              const SizedBox(height: defaultPadding),
                              SizedBox(
                                height: Responsive.size(context).height / 2,
                                child: RecentComplaints(complaints: controller.complaints.where((c) {
                                  if(controller.showArchiveComplaint.value){return true;}
                                  return c.value.complaintState == ComplaintStates.EXIST;
                                }).map((e) => e.value).toList(), controller: controller),
                              ),
                              if (Responsive.isMobile(context))
                                const SizedBox(height: defaultPadding),
                              if (Responsive.isMobile(context)) const ReportsWidget(),
                              // if (Responsive.isMobile(context)) const UserDetailsWidget(),
                            ],
                          ),
                        ),
                        if (!Responsive.isMobile(context))
                          const SizedBox(width: defaultPadding),
                        // On Mobile means if the screen is less than 850 we dont want to show it
                        if (!Responsive.isMobile(context))
                          const Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                ReportsWidget(),
                                SizedBox(height: defaultPadding),
                                // UserDetailsWidget(),
                              ],
                            ),
                          ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        );
  }
}
