import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Trans;
import 'package:intl/intl.dart';
import 'package:its_system/core/utils/snakbar_dialog.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/constants.dart';
import 'package:its_system/controllers/system_management_controller.dart';
import 'package:its_system/core/utils/delete_dialog2.dart';
import 'package:its_system/helper/open_dialog_bottom_sheet.dart';
import 'package:its_system/models/institution_model.dart';
import 'package:its_system/models/state_enum.dart';
import 'package:its_system/pages/system_management/components/add_update_institution.dart';
import 'package:its_system/statics_values.dart';

DataRow institutionDataRow(InstitutionModel institution,SystemManagementController controller,Function(InstitutionModel?)? onChanged, BuildContext context) {
  return DataRow(
    cells: [
      DataCell(Radio(
        groupValue: StaticValue.userData!.institution,
        onChanged: onChanged,
        value: institution,)),
      DataCell(Text(institution.institutionName!.getTitle,
                style: Theme.of(context).textTheme.displayMedium,
      )),
      DataCell(Text(institution.city!.cityName!.getTitle,
                style: Theme.of(context).textTheme.displayMedium,
      )),
      DataCell(Text(institution.municipality!.municipalityName!.getTitle,
                style: Theme.of(context).textTheme.displayMedium,
      )),
      DataCell(Text(DateFormat("yyyy-MM-dd").format(institution.institutionName!.createDate!),
                style: Theme.of(context).textTheme.displayMedium,
      )),
      // DataCell(Text(institution.subscripeType!.name,
      //           style: Theme.of(context).textTheme.displayMedium,
      // )),
      DataCell(Text(institution.institutionState!.name,
                style: Theme.of(context).textTheme.displayMedium,
      )),
      DataCell(
        Row(
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor
              ),
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () {
                int cityId = controller.cities.firstWhere((c) => c.value.cityId == controller.municipalities.firstWhere((municipality) => municipality.value.municipalityId == institution.municipality!.municipalityId!).value.city!.cityId).value.cityId!;
                controller.selectedCity.value = cityId;
                controller.selectedMunicipality.value = institution.municipality!.municipalityId!;
                controller.institution.value = InstitutionModel().copyWith(institution: institution);
                controller.institution.value.institutionName!.arabicHint= "institutionName".tr();
                controller.institution.value.institutionName!.englishHint="institutionName".tr();
                controller.isEdit = true;
                openDialogOrBottomSheet(const AddNewInstitutionBottomSheet());
              },
              // Edit
              label: Text("edit".tr(),style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white),),
            ),
            const SizedBox(
              width: 6,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: blueColor
              ),
              icon: const Icon(Icons.copy,color: Colors.white,),
                onPressed: () async{
                  await Clipboard.setData(ClipboardData(text: institution.institutionUniqueKey!.text));
                  snakbarDialog(title: 'done'.tr(), content: 'theOperatorIsDoneSeccessfuly'.tr(), durationSecound: 5, color: blueColor,icon: const Icon(Icons.check_circle,color: Colors.white,size: 30,));
                },
              // Delete
              label: Text("token".tr(),style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white),),
            ),
          ],
        ),
      
      ),
    ],
  );
}



Widget recentInstitutionForMobile(InstitutionModel institution,SystemManagementController  controller,Function(InstitutionModel?)? onChanged, BuildContext context){
  return Card(
    color: Theme.of(context).cardColor,
    child: ListTile(
      title: Text(institution.institutionName!.getTitle,style: Theme.of(context).textTheme.displaySmall,),
      // subtitle: Text(institution.subscripeType!.name.tr(),style: Theme.of(context).textTheme.labelLarge,),
      leading: Radio(
        groupValue: StaticValue.userData!.institution,
        onChanged: onChanged,
        value: institution,),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor
                ),
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                onPressed: () async{
                    int cityId = controller.cities.firstWhere((c) => c.value.cityId == controller.municipalities.firstWhere((municipality) => municipality.value.municipalityId == institution.municipality!.municipalityId!).value.city!.cityId).value.cityId!;
                    controller.selectedCity.value = cityId;
                    controller.selectedMunicipality.value = institution.municipality!.municipalityId!;
                    controller.institution.value = InstitutionModel().copyWith(institution: institution);
                    controller.institution.value.institutionName!.arabicHint= "institutionName".tr();
                    controller.institution.value.institutionName!.englishHint="institutionName".tr();
                    controller.isEdit = true;
                    openDialogOrBottomSheet(const AddNewInstitutionBottomSheet());
                },
                // Delete
                tooltip: institution.institutionState! == States.BLOCKED ? "unblock".tr() : "block".tr(),
              ),
            ],
          ),
      ),
  );
}
