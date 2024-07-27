// ignore_for_file: must_be_immutable

import 'package:get/get.dart' hide Trans;
import 'package:its_system/core/utils/delete_dialog2.dart';
import 'package:its_system/core/widgets/popup_menu.dart';
import 'package:its_system/models/complaint_model.dart';
import 'package:its_system/pages/order/components/show_user.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/constants.dart';
import 'package:flutter/material.dart';
import 'package:its_system/controllers/controller_panel_controller.dart';
import 'package:its_system/responsive.dart';

class RecentComplaints extends StatelessWidget {
  List<ComplaintModel> complaints;
  ControllerPanelController controller;
  RecentComplaints({
    required this.complaints,
    required this.controller,
    Key? key,
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
              Row(
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "complaints".tr(),
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  // const Spacer(),
                  // Expanded(
                  //   flex: 2,
                  //   child: SwitchListTile(title: FittedBox(
                  //     fit: BoxFit.scaleDown,
                  //     child: Text("showArchive".tr(),style: Theme.of(context).textTheme.displayMedium!.copyWith(fontWeight: FontWeight.bold),)), value: controller.showArchiveComplaint.value, onChanged: (v){
                  //     controller.showArchiveComplaint.value = v;
                  //   }),
                  // )
                ],
              ),
            const Divider(height: 20,),
              SingleChildScrollView(
                //scrollDirection: Axis.horizontal,
                child: 
                SizedBox(
                  width: double.infinity,
                  child:  
                // Responsive.isMobile(context) || Responsive.isTablet(context) ?  
                Column(
                  children: complaints.map((u) => recentComplaintForMobile(u,controller, context)).toList()
                )
                // :
                //   DataTable(
                //     horizontalMargin: 0,
                //     columnSpacing: 0,
                //     columns: [
                //        DataColumn(
                //         label: Text("complaintType".tr(),style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold),),
                //       ),
                //       //  DataColumn(
                //       //   label: Text("phone".tr(),style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold),),
                //       // ),
                //        DataColumn(
                //         label: Text("complaintTopic".tr(),style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold),),
                //       ),
                //        DataColumn(
                //         label: Text("citizenName".tr(),style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold),),
                //       ),
                //        DataColumn(
                //         label: Text("complaintState".tr(),style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold),),
                //       ),
                //        DataColumn(
                //         label: Text("",style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold),),
                //       ),
                //     ],
                //     rows: complaints.map((u) => recentComplaintDataRow(u,controller, context)).toList()
                //   ),
                ),
              ),
            ],
          ),
        );
  }
}

DataRow recentComplaintDataRow(ComplaintModel complaint,ControllerPanelController controller, BuildContext context) {
  return DataRow(
    cells: [
      DataCell(
        Text(
          complaint.complaintType!.codeName!.getTitle,
          style: Theme.of(context).textTheme.displayMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      DataCell(
        Text(
          complaint.complaintTitle!.text,
          style: Theme.of(context).textTheme.displayMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      DataCell(
        Text(
          complaint.user!.userName!.getTitle,
          style: Theme.of(context).textTheme.displayMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      DataCell(
        Text(
          complaint.complaintState!.name.tr(),
          style: Theme.of(context).textTheme.displayMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      DataCell(
        (complaint.complaintState == ComplaintStates.EXIST)?
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: redColor
          ),
          icon: const Icon(Icons.cancel_outlined,color: Colors.white,),
          onPressed: () async{
            deleteMessage2(
              deleteButton: "archiveComplaint".tr(),
              title: "areYouSureFor".tr(), content: "archiveThisComplaint".tr() , onDelete: ()async{
                await controller.db.update(tableName: "complaints", primaryKey: "COMP_ID", primaryKeyValue: complaint.complaintId, items: {"COMP_STATE": "ARCHIVE"});
                await controller.fetchAllComplaints();
              Get.back();
            },
            onCancel: (){Get.back();}, onWillPop: true);
          },
          // Delete
          label: Text("archiveComplaint".tr(),style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white),),
        ):const SizedBox(),
      ),
    ],
  );
}


Widget recentComplaintForMobile(ComplaintModel complaint,ControllerPanelController controller, BuildContext context){
  return Card(
    child: Column(
      children: [
        if(Responsive.isMobile(context))
        Container(
          width: 100,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).primaryColor
          ),
          child: Text(
                complaint.complaintState!.name.tr(),
                style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
      ),
        ListTile(
          leading: 
        (!Responsive.isMobile(context)) ? 
              Container(
          width: 100,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).primaryColor
          ),
          child: Text(
                complaint.complaintState!.name.tr(),
                style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
      ) : null,
          title: Text(complaint.complaintType!.codeName!.getTitle,style: Theme.of(context).textTheme.displaySmall,),
          subtitle: Text(complaint.complaintTitle!.text,style: Theme.of(context).textTheme.labelLarge,),
          trailing: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PopupMenuButton(
                          surfaceTintColor: Colors.transparent,
                        icon: Icon(
                          Icons.more_vert,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        onSelected: (v) async{
                          if(v==0){
                            deleteMessage2(
                              deleteButton: "archiveComplaint".tr(),
                              title: "areYouSureFor".tr(), content: "archiveThisComplaint".tr() , onDelete: ()async{
                                await controller.db.update(tableName: "complaints", primaryKey: "COMP_ID", primaryKeyValue: complaint.complaintId, items: {"COMP_STATE": "ARCHIVE"});
                                await controller.fetchAllComplaints();
                              Get.back();
                            },
                            onCancel: (){Get.back();}, onWillPop: true);
                          }
                          if(v==1){
                            showDialog(context: context, builder: (context)=>Dialog(child: ShowUser(user: complaint.user!),));
                          }
                        },
                        itemBuilder: (context) {
                          return [
                            if(complaint.complaintState == ComplaintStates.EXIST)
                            PopupMenuItem(
                              value: 0,
                              child: MyPopupMenuItem(
                                icon: Icons.edit,
                                text: "archiveComplaint".tr(),
                              ),
                            ),
                            PopupMenuItem(
                              value: 1,
                              child: MyPopupMenuItem(
                                icon: Icons.remove_red_eye,
                                text: "view".tr(),
                              ),
                            ),
                          ];
                        },
                      ),
                      ),
          ),
      ],
    ),
  );
}