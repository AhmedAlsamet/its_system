// import 'package:filter_list/filter_list.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
// import 'package:its_system/core/widgets/nav_bar_icon.dart';
// import 'package:its_system/models/institution_model.dart';
// import 'package:its_system/responsive.dart';
// import 'package:flutter/material.dart';
// import 'package:its_system/statics_values.dart';

// class Header extends StatelessWidget {
//   const Header({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         if (!Responsive.isDesktop(context))
//           IconButton(
//             icon: const Icon(Icons.menu),
//             onPressed: () {
//               Scaffold.of(context).openDrawer();
//             },
//           ),
//         if (!Responsive.isMobile(context))
//           Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 StaticValue.userData!.institution!.institutionName!.getTitle,
//                 style: Theme.of(context).textTheme.displayLarge,
//               ),
//               const SizedBox(
//                 height: 8,
//               ),
//               // Text(
//               //   "StaticValue.userData!.institution!.institutionName!.getTitle",
//               //   style: Theme.of(context).textTheme.displaySmall,
//               // ),
//             ],
//           ),
//           const Spacer(),
//           NavBarIcon(
//             backgroundColor: Theme.of(context).primaryColor,
//             foregroundColor: Colors.white,
//             shadowColor: Colors.white,
//             tooltip: "searchFilter".tr(),
//             iconEvent: ()async{
// await FilterListDialog.display<CompoundModel>(
//       context,
//       hideSelectedTextCount: true,
//       themeData: FilterListThemeData(context),
//       headlineText: 'أختر المدن السكنية',
//       height: 500,
//       width: 500,
//       insetPadding: const EdgeInsets.all(5),
//       listData: [],
//       selectedListData: [],
//       choiceChipLabel: (item) => item!.institutionName!.getTitle,
//       validateSelectedItem: (list, val) => list!.contains(val),
//       controlButtons: [ControlButtonType.All, ControlButtonType.Reset],
//       hideSearchField: true,
//       onItemSearch: (user, query) {
//         /// When search query change in search bar then this method will be called
//         ///
//         /// Check if items contains query
//         // return user.name!.toLowerCase().contains(query.toLowerCase());
//         return true;
//       },

//       onApplyButtonClick: (list) {
//         // setState(() {
//         //   selectedUserList = List.from(list!);
//         // });
//         Navigator.pop(context);
//       },

//       /// uncomment below code to create custom choice chip
//       /* choiceChipBuilder: (context, item, isSelected) {
//         return Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//           decoration: BoxDecoration(
//               border: Border.all(
//             color: isSelected! ? Colors.blue[300]! : Colors.grey[300]!,
//           )),
//           child: Text(
//             item.name,
//             style: TextStyle(
//                 color: isSelected ? Colors.blue[300] : Colors.grey[500]),
//           ),
//         );
//       }, */
//     );
//           }, icon:Icons.filter_alt_outlined)
//       ],
//     );
//   }
// }

