import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:its_system/core/models/report_helper_model.dart';
import 'package:its_system/core/reports/widgets/input_field.dart';


pw.Widget GroupDetails ({font,required PdfColor backgroundColor,required List<ReportHelperModel> items}) {
  return pw.Table(
    border: pw.TableBorder.all(color: PdfColors.black),
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: backgroundColor),
          children: items.map((e) => 

        pw.Expanded(
          flex: e.columnSize!,
          child: 
          pw.Container(
              alignment: e.isCenter!? pw.Alignment.center : pw.Alignment.centerRight,child: 
          InputField(
                      fontColor: e.fontColor!,
            font: font,
            fontSize: e.fontSize!,
            controller: e.text,
            paddingSize: e.paddingSize!,
          ),
        ),),
       
  ).toList())
  ]);
}



// pw.Widget GroupDetails ({font,required PdfColor backgroundColor,required List<ReportHelperModel> items}) {
//   return pw.Container(
//       decoration: pw.BoxDecoration(color: backgroundColor,border: pw.Border.all(color: PdfColors.black)),
//       child: pw.Row(children: items.map((e) => 

//         pw.Expanded(
//           flex: e.columnSize!,
//           child: 
//           pw.Container(
//               alignment: e.isCenter!? pw.Alignment.center : pw.Alignment.centerRight,child: 
//           InputField(
//                       fontColor: e.fontColor!,
//             font: font,
//             fontSize: e.fontSize!,
//             controller: e.text,
//             paddingSize: e.paddingSize!,
//           ),
//         ),),
       
//   ).toList()));
// }
