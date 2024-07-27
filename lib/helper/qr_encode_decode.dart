// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:its_system/models/institution_model.dart';

// import 'package:its_system/models/user_model.dart';
// import 'package:tlv_decoder/tlv_decoder.dart';

// String convertDataToVAT(QrCodeModel qrcode,int forUserId){
//   qrcode.forUserId = forUserId;
//   List<TLV> tlvList = [
//     TLV(type: 1, length: utf8.encode(qrcode.qrCodeId!.toString()).length, value: utf8.encode(qrcode.qrCodeId!.toString()) ),
//     TLV(type: 2, length: utf8.encode(qrcode.qrCodeType!.name).length, value:utf8.encode(qrcode.qrCodeType!.name) ),
//     TLV(type: 3, length: utf8.encode(qrcode.qrCodeStartDate.toString()).length, value:utf8.encode(qrcode.qrCodeStartDate.toString()) ),
//     TLV(type: 4, length: utf8.encode(qrcode.qrCodeEndDate.toString()).length, value:utf8.encode(qrcode.qrCodeEndDate.toString()) ),
//     TLV(type: 5, length: utf8.encode(qrcode.userCreated!.userId.toString()).length, value:utf8.encode(qrcode.userCreated!.userId.toString()) ),
//     TLV(type: 6, length: utf8.encode(qrcode.userCreated!.institution!.institutionId.toString()).length, value:utf8.encode(qrcode.userCreated!.institution!.institutionId.toString()) ),
//     TLV(type: 7, length: utf8.encode(qrcode.orderors!.length.toString()).length, value: utf8.encode(qrcode.orderors!.length.toString()) ),
//     TLV(type: 8, length: utf8.encode(qrcode.forUserId.toString()).length, value: utf8.encode(qrcode.forUserId.toString()) ),
//    ];
//   Uint8List encodedData = TlvUtils.encode(tlvList);
//   return base64.encode(encodedData);
  
// }
// QrCodeModel convertDataFormVAT(String qrcode){
//   Uint8List u = Uint8List.fromList(base64.decode(qrcode));
//   List<TLV> tlvList = TlvUtils.decode(u);

//   QrCodeModel result = QrCodeModel().initialize(
//     qrCodeId: int.parse(utf8.decode(tlvList[0].value)),
//     qrCodeType: QRCodeTypes.values.firstWhere((element) => element.name == utf8.decode(tlvList[1].value),orElse: () => QRCodeTypes.FOR_ONE_TYPE,),
//     userCreated: UserModel().initialize(
//       userId: int.parse(utf8.decode(tlvList[4].value)),
//       institution: CompoundModel().initialize(institutionId: int.parse(utf8.decode(tlvList[5].value))),
//     ),
//     qrCodeStartDate: DateTime.parse(utf8.decode(tlvList[2].value)),
//     qrCodeEndDate: DateTime.parse(utf8.decode(tlvList[3].value)),
//     orderorsCount: int.parse(utf8.decode(tlvList[6].value)),
//     forUserId: int.parse(utf8.decode(tlvList[7].value)),
    
//   );
//   // for (var i = 0; i < tlvList.length; i++) {
//   //   print(tlvList[i].type);
//   //   print(tlvList[i].value);
//   // }
//   return result;
// }