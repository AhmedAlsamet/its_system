import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';


pw.Widget Header(font,logo,Map<String,String> settings) {
  return pw.Container(
      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black)),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Expanded(child: 
          pw.Column(children: [
          if(settings["HEAD_RIGHT1"]!= "")
            Text(settings["HEAD_RIGHT1"].toString(),
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold,font: font)
          ),
            if(settings["HEAD_RIGHT2"] != "")
            Text(settings["HEAD_RIGHT2"].toString(),
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(font: font)
          ),
          if(settings["HEAD_RIGHT3"] != "")
            Text(settings["HEAD_RIGHT3"].toString(),
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(font: font)
          ),
          ])),
          logo,
          pw.Expanded(child: 
          pw.Column(children: [
            if(settings["HEAD_LEFT1"] != "")
            Text(settings["HEAD_LEFT1"].toString(),
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 14,font: font)
          ),
            if(settings["HEAD_LEFT2"] != "")
            Text(settings["HEAD_LEFT2"].toString(),
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(font: font)
          ),
            if(settings["HEAD_LEFT3"] != "")
            Text(settings["HEAD_LEFT3"].toString(),
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(font: font)
          ),
          ])),
        ]
      )
      );
}
