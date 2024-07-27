import 'package:its_system/core/models/report_helper_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:pdf/widgets.dart';


pw.Widget GroupHeader(font,List<ReportHelperModel> items,{PdfColor color =PdfColors.blueGrey100}) {
  return pw.Table(
    border: pw.TableBorder.all(color: PdfColors.black),
    children: [
    pw.TableRow(
      decoration: pw.BoxDecoration(color: color,),
      children: items.map((e) => 
        pw.Expanded(
          flex: e.columnSize!,
          child: pw.Padding(
            padding: const pw.EdgeInsets.only(top:5.0),
            child: pw.Column(children: [
              pw.Container(
              alignment: e.isCenter!? pw.Alignment.center : pw.Alignment.centerRight,
              child: pw.FittedBox(
                child: pw.Text(e.text!,
                textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(font: font).copyWith(fontSize: e.fontSize!,color: e.fontColor)
                    // style: Theme.of(context)
                    //     .textTheme
                    //     .labelLarge!
                    //     .copyWith(
                    //         fontWeight: FontWeight.bold),
                    ),
              ),
            ),
            if(e.subTexts!.isNotEmpty)
              pw.Divider(height: 0),
            if(e.subTexts!.isNotEmpty)
              pw.SizedBox(
                height: 20,
                child: 
                Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                mainAxisSize: pw.MainAxisSize.max,
                children: [...e.subTexts!.map((se) {
                                  if(se == "")return pw.Container(width: 1,height: double.infinity,color: PdfColors.black);

                  return pw.Container(
              alignment:  pw.Alignment.center,
              child: pw.FittedBox(
                child: pw.Text(se,
                    style: pw.TextStyle(font: font).copyWith()
                    // style: Theme.of(context)
                    //     .textTheme
                    //     .labelLarge!
                    //     .copyWith(
                    //         fontWeight: FontWeight.bold),
                    ),
              ),
            );
                }

            ).toList(),
            ]
              )
              )
            ])
          ),
        )).toList())
  ]);
}



// pw.Widget GroupHeader(font,List<ReportHelperModel> items) {
//   return pw.Table(
//     border: pw.TableBorder.all(color: PdfColors.black),
//     children: [
//     pw.TableRow(
//       decoration: pw.BoxDecoration(color: PdfColors.blueGrey100,),
//       children: items.map((e) => 
        
//         pw.Expanded(
//           flex: e.columnSize!,
//           child: pw.Padding(
//             padding: const pw.EdgeInsets.all(5.0),
//             child: pw.Container(
//               alignment: e.isCenter!? pw.Alignment.center : pw.Alignment.centerRight,
//               child: pw.FittedBox(
//                 child: pw.Text(e.text!,
//                     style: pw.TextStyle(font: font).copyWith(fontSize: e.fontSize!,color: e.fontColor)
//                     // style: Theme.of(context)
//                     //     .textTheme
//                     //     .labelLarge!
//                     //     .copyWith(
//                     //         fontWeight: FontWeight.bold),
//                     ),
//               ),
//             ),
//           ),
//         )).toList())
//   ]);
// }






// pw.Widget GroupHeader(font,List<ReportHelperModel> items) {
//   return pw.Container(
//       decoration: pw.BoxDecoration(color: PdfColors.greenAccent100,border: pw.Border.all(color: PdfColors.black)),
//       child: pw.Row(children: items.map((e) => 

//         pw.Expanded(
//           flex: e.columnSize!,
//           child: pw.Padding(
//             padding: const pw.EdgeInsets.all(5.0),
//             child: pw.Container(
//               alignment: e.isCenter!? pw.Alignment.center : pw.Alignment.centerRight,
//               child: pw.FittedBox(
//                 child: pw.Text(e.text!,
//                     style: pw.TextStyle(font: font).copyWith(fontSize: e.fontSize!,color: e.fontColor)
//                     // style: Theme.of(context)
//                     //     .textTheme
//                     //     .labelLarge!
//                     //     .copyWith(
//                     //         fontWeight: FontWeight.bold),
//                     ),
//               ),
//             ),
//           ),
//         ),
       
//   ).toList()));
// }
