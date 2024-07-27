import 'package:flutter/services.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:its_system/core/models/report_helper_model.dart';
import 'package:its_system/core/reports/widgets/group_details.dart';
import 'package:its_system/core/reports/widgets/group_header.dart';
import 'package:its_system/core/reports/widgets/header.dart';
import 'package:its_system/models/setting_model.dart';
import 'package:its_system/models/user_model.dart';
import 'package:its_system/statics_values.dart';

Future<Uint8List> userReport(List<UserModel> report1,
List<SettingModel> rawSettings,
    {PdfPageFormat? format,required String title,required bool forEmployees}) async {
  final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
  final font = await fontFromAssetBundle('assets/tajawal/Aljazeera.ttf');

Map<String, String> settings = {};
  for (var i = 0; i < rawSettings.length; i++) {
    settings.addAll(
        {"${rawSettings[i].settingCode}": rawSettings[i].settingValue!.text});
  }
  pw.Widget logo;
  // File f = File(settings["HEAD_LOGO"].toString());
  if (settings["HEAD_LOGO"] != "") {
    final netImage = await networkImage(StaticValue.serverPath! + settings["HEAD_LOGO"].toString());
    logo = pw.Expanded(
        child:
            // pw.SvgImage(svg: logo,width: 80,height: 80),),
            pw.Image(
                netImage,
                width: 80,
                height: 80));
  } else {
    logo = pw.Expanded(
        child:
            // pw.SvgImage(svg: logo,width: 80,height: 80),),
            pw.Image(
                pw.MemoryImage(
                  (await rootBundle.load('assets/logo.png'))
                      .buffer
                      .asUint8List(),
                ),
                width: 80,
                height: 80));
  }


  pdf.addPage(pw.MultiPage(
    textDirection: pw.TextDirection.rtl,
    // pageTheme: pw.PageTheme(textDirection: pw.TextDirection.rtl),

    pageFormat: format,
    header: (context) {
      return pw.Container(
        decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black)),
        child: pw.Column(
          children: [
              Header(font, logo, settings),
              pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 3),
                  child: pw.Text(
                    title,
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(font: font)
                        .copyWith(fontWeight: pw.FontWeight.bold),
                  )),
            GroupHeader(font,[
          ...<ReportHelperModel>[
                    ReportHelperModel(
      text: forEmployees ? "employeeNumber".tr() : "citizenNumber".tr(),
      fontSize: 14,
      fontColor: PdfColors.black,
      isCenter: true,
      paddingSize: 1,
subTexts: [],
      columnSize: 1
    ),
                    ReportHelperModel(
      text: forEmployees ? "employeeName".tr() : "citizenName".tr(),
      fontSize: 14,
      fontColor: PdfColors.black,
      isCenter: true,
      paddingSize: 1,
subTexts: [],
      columnSize: 3
    ),
        ReportHelperModel(
      text: "createdDate".tr(),
      fontSize: 14,
      fontColor: PdfColors.black,
      isCenter: true,
      paddingSize: 1,
subTexts: ["date".tr(),"time".tr()],
      columnSize: 4
    ),
        ReportHelperModel(
      text: "phoneNumber".tr(),
      fontSize: 14,
      fontColor: PdfColors.black,
      isCenter: true,
      paddingSize: 1,
subTexts: [],
      columnSize: 2
    ),
        ReportHelperModel(
      text: "emailAddress".tr(),
      fontSize: 14,
      fontColor: PdfColors.black,
      isCenter: true,
      paddingSize: 1,
subTexts: [],
      columnSize: 2
    ),
    if(forEmployees)
            ReportHelperModel(
      text: "employeeType".tr(),
      fontSize: 14,
      fontColor: PdfColors.black,
      isCenter: true,
      paddingSize: 1,
subTexts: [],
      columnSize: 2
    ),
          ].reversed
        ])
          
          ]
        ));
    },
    // footer: (context) {
    //   return pw.Row(
    //       children: GroupFooter(font, totalCount, totalOfTotalPrice).children);
    // },
    build: (context) {
      return [
        ...report1.asMap().entries.map((s) {
        return pw.Column(children: [
      GroupDetails(
          font: font,
          backgroundColor: PdfColors.white
          ,items: [
          ...<ReportHelperModel>[
      ReportHelperModel(
      text:s.value.userNumber!.text ,
      fontSize: 12,
      fontColor: PdfColors.black,
      isCenter: true,
      columnSize: 1,
      paddingSize: 1,
    ),
      ReportHelperModel(
      text:s.value.userName!.getTitle ,
      fontSize: 12,
      fontColor: PdfColors.black,
      isCenter: true,
      columnSize: 3,
      paddingSize: 1,
    ),
      ReportHelperModel(
      text:DateFormat("yyyy-MM-dd").format(s.value.userName!.createDate!) ,
      fontSize: 12,
      fontColor: PdfColors.black,
      isCenter: true,
      columnSize: 2,
      paddingSize: 1,
    ),
      ReportHelperModel(
      text:DateFormat("HH:mm").format(s.value.userName!.createDate!) ,
      fontSize: 12,
      fontColor: PdfColors.black,
      isCenter: true,
      columnSize: 2,
      paddingSize: 1,
    ),
     ReportHelperModel(
       text: s.value.userPhoneNumber!.text,
      fontSize: 12,
      fontColor: PdfColors.black,
      isCenter: true,
      columnSize: 2,
      paddingSize: 1,
    ),
     ReportHelperModel(
       text: s.value.userEMail!.text,
      fontSize: 12,
      fontColor: PdfColors.black,
      isCenter: true,
      columnSize: 2,
      paddingSize: 1,
    ),
    if(forEmployees)
      ReportHelperModel(
      text:s.value.userType!.name.tr() ,
      fontSize: 12,
      fontColor: PdfColors.black,
      isCenter: true,
      columnSize: 2,
      paddingSize: 1,
    ),
          ].reversed
        ]),
        ]);
        
        
        }),
      ];
    },
        footer: (context) {
        return pw.Column(children: [
          pw.Divider(),
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
              children: [
                pw.Center(
                  child: pw.Expanded(
                    child: pw.Text(
                        "${"reportDate".tr()}/${DateFormat("dd-MM-yyyy").format(DateTime.now())}",
                        style: pw.TextStyle(font: font)),
                  ),
                ),
                pw.Center(
                  child: pw.Expanded(
                    child: pw.Text(
                        "${"page".tr()} ${context.pageNumber} ${"from".tr()} ${context.pagesCount}",
                        style: pw.TextStyle(font: font)),
                  ),
                ),
                pw.Center(
                  child: pw.Expanded(
                    child: pw.Text(
                        "${"printedBy".tr()}/${StaticValue.userData!.userName!.getTitle}",
                        style: pw.TextStyle(font: font)),
                  ),
                )
              ])
        ]);
      }
  ));
  return pdf.save();
}
