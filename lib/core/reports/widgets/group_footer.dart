import 'package:its_system/core/models/report_helper_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

// pw.Widget GroupFooter(font,List<ReportHelperModel> items) {
//   return pw.Table(
//       children: [
//         pw.TableRow(
//       decoration: pw.BoxDecoration(color:PdfColors.blueGrey100,border: pw.Border.all(color: PdfColors.black)),
          
//           children: items.map((e) => 

//         pw.Expanded(
//           flex: e.columnSize!,
//           child: pw.Padding(
//             padding: const pw.EdgeInsets.all(5.0),
//             child: pw.Container(
//               alignment: e.isCenter!? pw.Alignment.center : pw.Alignment.centerRight,
//               child:  pw.Text(e.text!,
//                     style: pw.TextStyle(font: font).copyWith(fontSize: e.fontSize!,color: e.fontColor)
//               ),
//             ),
//           ),
//         ),
       
//   ).toList())]);
// }




// pw.Widget GroupFooter(font,List<ReportHelperModel> items) {
//   return pw.Container(
//       decoration: pw.BoxDecoration(color:PdfColors.blueGrey100,border: pw.Border.all(color: PdfColors.black)),
//       child: pw.Row(children: items.map((e) => 

//         pw.Expanded(
//           flex: e.columnSize!,
//           child: pw.Padding(
//             padding: const pw.EdgeInsets.all(5.0),
//             child: pw.Container(
//               alignment: e.isCenter!? pw.Alignment.center : pw.Alignment.centerRight,
//               child:  pw.Text(e.text!,
//                     style: pw.TextStyle(font: font).copyWith(fontSize: e.fontSize!,color: e.fontColor)
//               ),
//             ),
//           ),
//         ),
       
//   ).toList()));
// }

pw.Widget GroupFooter(font,List<ReportHelperModel> items) {
  return pw.Table(
    border: pw.TableBorder.all(color: PdfColors.black),

      children: [
        pw.TableRow(
      decoration: pw.BoxDecoration(color:PdfColors.blueGrey100,border: pw.Border.all(color: PdfColors.black)),
          
          children: items.map((e) => 

        pw.Expanded(
          flex: e.columnSize!,
          child: pw.Padding(
            padding: const pw.EdgeInsets.all(5.0),
            child: pw.Container(
              alignment: e.isCenter!? pw.Alignment.center : pw.Alignment.centerRight,
              child:  pw.Text(e.text!,
                    style: pw.TextStyle(font: font).copyWith(fontSize: e.fontSize!,color: e.fontColor)
              ),
            ),
          ),
        ),
       
  ).toList())]);
}

