
import 'package:pdf/pdf.dart';

class ReportHelperModel{
  bool? isCenter;
  String? text;
  int? columnSize;
  double? fontSize;
  double? paddingSize;
  PdfColor? fontColor;
  List<String>? subTexts;

  ReportHelperModel({this.isCenter,this.fontColor,this.fontSize,this.columnSize,this.text,this.paddingSize, this.subTexts});

}