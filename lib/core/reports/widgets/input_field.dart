import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:pdf/widgets.dart';

class InputField extends pw.StatelessWidget {
  
   InputField({
    required this.font,
    this.maxLines,
    this.controller,
    required this.fontSize,
    required this.paddingSize,
    required this.fontColor,
  });

  final String? controller;
  final int? maxLines;
  TtfFont font;
  double fontSize;
  double paddingSize;
  PdfColor fontColor;
  
  @override
  pw.Widget build(pw.Context context) {
    // TODO: implement build
    return
    //  pw.Container(
    //   padding: pw.EdgeInsets.all(paddingSize),
    //   decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColor.fromHex("#101010"))),
    //   child:
       pw.Padding(padding:const pw.EdgeInsets.only(right: 5),
    
    child: pw.Text(
      controller!,
      maxLines: maxLines,
      style: pw.TextStyle(font: font).copyWith(
                    fontSize: fontSize,
                    color: fontColor
                )
            )
            // )
            );
  }
}