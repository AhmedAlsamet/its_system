import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/constants.dart';
import 'package:its_system/core/utils/report_setting_dialog.dart';
import 'package:its_system/models/user_model.dart';
import 'package:its_system/pages/dashboard/components/report_mini_card.dart';
import 'package:flutter/material.dart';

class ReportsWidget extends StatelessWidget {
  const ReportsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
                color: Theme.of(context).cardColor.withOpacity(0.8) ,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CalendarWidget(),
          Text(
            "reports".tr(),
            style: Theme.of(context).textTheme.displayLarge!.copyWith(fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: defaultPadding),
          ReportMiniCard(
            onPressed: (){
              showDialog(
                context: context,
                builder: (context) {
                  return const ReportSettingDialog(
                    index: 0,
                    forOrder: true,
                    userType: UserTypes.SUPER_ADMIN,
                  );
                });
            },
            color: const Color(0xff0293ee),
            title: "ordersReport".tr(),
          ),
            ReportMiniCard(
            onPressed: (){
              showDialog(
                context: context,
                builder: (context) {
                  return const ReportSettingDialog(
                    index: 1,
                    forOrder: false,
                    userType: UserTypes.ADMIN,
                  );
                });
            },
            color: redColor,
            title: "complaintReport".tr(),
          ),
          ReportMiniCard(
          onPressed: (){
              showDialog(
                context: context,
                builder: (context) {
                  return const ReportSettingDialog(
                    index: 2,
                    forOrder: false,
                    userType: UserTypes.CITIZEN,
                  );
                });
            },
            color: const Color(0xff845bef),
            title: "servicesReport".tr(),
          ),
        ],
      ),
    );
  }
}
