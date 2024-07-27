import 'package:intl/intl.dart';
import 'package:its_system/responsive.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/constants.dart';
import 'package:flutter/material.dart';
import 'package:its_system/models/user_model.dart';
// ignore: must_be_immutable
class RecentDiscussions extends StatelessWidget {
  List<UserModel> users;
  RecentDiscussions({
    Key? key,
    required this.users
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor ,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "employees".tr(),
            style: Theme.of(context).textTheme.displayLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
        const Divider(height: 20,),
          SizedBox(
            width: double.infinity,
            child: 
            Responsive.isMobile(context) ?  
            Column(
              children: users.map((u) => recentUserForMobile(u, context)).toList()
            ):
            DataTable(
              horizontalMargin: 0,
              columnSpacing: defaultPadding,
              columns: [
                DataColumn(
                    label: Text("employeeName".tr(),style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold),),
                ),
                DataColumn(
                    label: Text("employeeType".tr(),style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold),),
                ),
                DataColumn(
                    label: Text("lastConnection".tr(),style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold),),
                ),
              ],
                rows: users.map((u) => recentUserDataRow(u, context)).toList()
            ),
          ),
        ],
      ),
    );
  }
}

DataRow recentUserDataRow(UserModel userInfo, BuildContext context) {
  return DataRow(
    cells: [
      // DataCell(Container(
      //     padding: const EdgeInsets.all(5),
      //     decoration: BoxDecoration(
      //       color: getRoleColor(userInfo.role).withOpacity(.2),
      //       border: Border.all(color: getRoleColor(userInfo.role)),
      //       borderRadius: const BorderRadius.all(Radius.circular(5.0) //
      //           ),
      //     ),
      //     child: Text(userInfo.role!))),
      DataCell(Text(userInfo.userName!.getTitle,style: Theme.of(context).textTheme.displayMedium,)),
      DataCell(Text(userInfo.userType!.name.tr(),style: Theme.of(context).textTheme.displayMedium,)),
      DataCell(Text(DateFormat("yyyy-MM-dd HH:ss a").format(userInfo.userLastConnected!),style: Theme.of(context).textTheme.displayMedium,)),
      // DataCell(Text("2")),
    ],
  );
}


Widget recentUserForMobile(UserModel user, BuildContext context){
  return ListTile(
    title: Text(user.userName!.getTitle,style: Theme.of(context).textTheme.displaySmall,),
    subtitle: Text(user.userLastConnected!.toString(),style: Theme.of(context).textTheme.labelLarge,),
    );
}