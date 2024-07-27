// import "package:flutter/material.dart";
// import "package:iconsax/iconsax.dart";
// import "package:intl/intl.dart";
// import "package:localize_and_translate/localize_and_translate.dart";
// import "package:pretty_qr_code/pretty_qr_code.dart";
// import "package:its_system/models/qr_code_model.dart";
// import "package:its_system/pages/mobile/components/invitation_card.dart";
// import "package:its_system/pages/settings/components/io_save_image.dart";
// import "package:its_system/responsive.dart";



// class QrShowWithDetails extends StatelessWidget {
//   QrCodeModel qrcode;
//   final int id;
//   final QrImage qrImage;
//   final PrettyQrDecoration decoration;
//   bool forPersonalQr; 
//   QrShowWithDetails({super.key, required this.qrImage, required this.decoration, required this.qrcode, required this.id,this.forPersonalQr = false});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: Theme.of(context).cardColor,
//         ),
//         width: Responsive.isDesktop(context) ? 300 : null,
//         child: Column(mainAxisSize: MainAxisSize.min, children: [
//           Container(
//               color: Theme.of(context).cardColor,
//               padding: const EdgeInsets.all(10),
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.all(10),
//                       child: PrettyQrView(
//                         qrImage: qrImage,
//                         decoration:decoration),
//                     ),
//                     const SizedBox(height: 10,),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: InkWell(
//                             onTap: ()async{
//                               await qrImage.shareAsImage(context, size: 512, decoration: decoration,massage: "");
//                             },
//                             child: Container(
//                                 padding: const EdgeInsets.all(8),
//                                 decoration: BoxDecoration(
//                                     color: Theme.of(context).primaryColor,
//                                     borderRadius: BorderRadius.circular(5)),
//                                 child: Row(
//                                   children: [
//                                     const Icon(
//                                       Iconsax.share4,
//                                       color: Colors.white,
//                                     ),
//                                     const SizedBox(
//                                       width: 5,
//                                     ),
//                                     Expanded(
//                                       child: FittedBox(
//                                         fit: BoxFit.scaleDown,
//                                         child: Text(
//                                           "share".tr(),
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .displaySmall!
//                                               .copyWith(color: Colors.white),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                           ),
//                         ),
//                     const SizedBox(width: 10,),
//                         Expanded(
//                           child: InkWell(
//                             onTap: ()async{
//                               await qrImage.exportAsImage(context, size: 512, decoration: decoration);
//                             },
//                             child: Container(
//                                 padding: const EdgeInsets.all(8),
//                                 decoration: BoxDecoration(
//                                     color: Theme.of(context).primaryColor,
//                                     borderRadius: BorderRadius.circular(5)),
//                                 child: Row(
//                                   children: [
//                                     const Icon(
//                                       Iconsax.import,
//                                       color: Colors.white,
//                                     ),
//                                     const SizedBox(
//                                       width: 5,
//                                     ),
//                                     Expanded(
//                                       child: FittedBox(
//                                         fit: BoxFit.scaleDown,
//                                         child: Text(
//                                           "install".tr(),
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .displaySmall!
//                                               .copyWith(color: Colors.white),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                           ),
//                         ),
                      
//                       ],
//                     ),
//                     if(!forPersonalQr)...[
                      
//                     const SizedBox(height: 10,),
//                      Row(
//                       children: [
//                         Expanded(child: Text("invType".tr(),style: Theme.of(context).textTheme.displaySmall,)),
//                         const SizedBox(width: 10,),
//                         Expanded(
//                           flex: 2,
//                           child: Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                                 color: Colors.green,
//                                 borderRadius: BorderRadius.circular(5)),
//                             child: Row(
//                               children: [
//                                 const Icon(
//                                   Iconsax.activity,
//                                   color: Colors.white,
//                                 ),
//                                 const SizedBox(
//                                   width: 5,
//                                 ),
//                                 Expanded(
//                                   child: FittedBox(
//                                     fit: BoxFit.scaleDown,
//                                     child: Text(
//                                       qrcode.qrCodeType!.name.tr(),
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .displaySmall!
//                                           .copyWith(color: Colors.white),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 10,),
//                     Row(
//                       children: [
//                         Expanded(child: Text("invStartDate".tr(),style: Theme.of(context).textTheme.displaySmall,)),
//                         const SizedBox(width: 10,),
//                         Expanded(
//                           flex: 2,
//                           child: Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                                 color: Colors.red.withOpacity(0.9),
//                                 borderRadius: BorderRadius.circular(5)),
//                             child: Row(
//                               children: [
//                                 const Icon(
//                                   Iconsax.calendar,
//                                   color: Colors.white,
//                                 ),
//                                 const SizedBox(
//                                   width: 5,
//                                 ),
//                                 Expanded(
//                                   child: FittedBox(
//                                     fit: BoxFit.scaleDown,
//                                     child: Text(
//                                       DateFormat("yyyy-MM-dd HH:mm")
//                                           .format(qrcode.qrCodeStartDate!),
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .displaySmall!
//                                           .copyWith(color: Colors.white),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 10,),
//                     if(qrcode.qrCodeType == QRCodeTypes.FOR_SPECIFIC_DATE)
//                     Row(
//                       children: [
//                         Text("invEndDate".tr(),style: Theme.of(context).textTheme.displaySmall,),
//                         const SizedBox(width: 10,),
//                         Expanded(
//                           flex: 2,
//                           child: Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                                 color: Colors.red.withOpacity(0.9),
//                                 borderRadius: BorderRadius.circular(5)),
//                             child: Row(
//                               children: [
//                                 const Icon(
//                                   Iconsax.calendar,
//                                   color: Colors.white,
//                                 ),
//                                 const SizedBox(
//                                   width: 5,
//                                 ),
//                                 Expanded(
//                                   child: FittedBox(
//                                     fit: BoxFit.scaleDown,
//                                     child: Text(
//                                       DateFormat("yyyy-MM-dd HH:mm")
//                                           .format(qrcode.qrCodeEndDate!),
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .displaySmall!
//                                           .copyWith(color: Colors.white),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ]
//                       ),
//                     const SizedBox(height: 10,),
//                   if (qrcode.userCreated!.userId == id &&
//                         qrcode.orderors!.length > 1)
//                     Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.all(10),
//                       color: Theme.of(context).secondaryHeaderColor,
//                       child: Text(
//                         "${"orderorsList".tr()} : ",
//                         style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                             color: Colors.white, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     if (qrcode.userCreated!.userId == id &&
//                           qrcode.orderors!.length > 1)
//                         ...qrcode.orderors!.map((e) => userCard(e,context)),
//                     ]
//                   ],
//                 ),
//               )),
            
//         ]));
//   }
// }
