
// ignore_for_file: public_member_api_docs, must_be_immutable

import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:iconsax/iconsax.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:its_system/core/models/dropdown_button_model.dart';
import 'package:its_system/core/widgets/dropdown_button.dart';

import 'package:its_system/core/widgets/nav_bar_icon.dart';
import 'package:its_system/responsive.dart';

class ReportPage extends StatefulWidget {
  String reportTitle;
  Map<String,PdfPageFormat> pageFormats;
  FutureOr<Uint8List> Function(PdfPageFormat) widget;
  Function() exportExcel;
  bool canChangeOrientation;
  ReportPage({Key? key,required this.reportTitle,required this.widget,required this.pageFormats,required this.canChangeOrientation,required this.exportExcel}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {

  late PdfPageFormat format;
  @override
  void initState() {
    super.initState();
    widget.pageFormats.forEach((key, value) {
      format = value;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      margin = (MediaQuery.of(context).size.width - format.width)/2;
      setState(() {});
    });
  }
  double margin = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        onPressed: widget.exportExcel, label: Text("تصدير",style: Theme.of(context).textTheme.displaySmall,),icon: const Icon(Iconsax.export)),
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        // backgroundColor: headColor,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NavBarIcon(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  foregroundColor: Theme.of(context).primaryColor,
                  shadowColor: Theme.of(context).shadowColor,
                  icon: Icons.arrow_back,
                  iconEvent: () {
                    Get.back();
                  },
                ),
                Text(
                  widget.reportTitle,
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(fontWeight: FontWeight.bold,color: Colors.white),
                ),
                SizedBox(width: 150,child:(margin == 0)? SizedBox() : DropdownButtonWidget(
                  selectedItem: margin,
                  onChanged: (v){
                    margin = v!;
                    setState(() {});
                  },
                  node: FocusNode(), items: [
                  DropdownButtonModel(
                    dropName: "50%",
                    dropValue: (format.width),
                    dropOrder: 0,
                  ),
                  DropdownButtonModel(
                    dropName: "100%",
                    dropValue: (MediaQuery.of(context).size.width - format.width)/2,
                    dropOrder: 0,
                  ),
                  DropdownButtonModel(
                    dropName: "150%",
                    dropValue: ( format.width) / 2,
                    dropOrder: 0,
                  ),
                  DropdownButtonModel(
                    dropName: "200%",
                    dropValue:  (format.width) / 6,
                    dropOrder: 0,
                  ),
                ], title: ""),)
              ],
            ),
          ),
        ),
      ),
      body: PdfPreview(
        enableScrollToPage: true,
        shouldRepaint: true,
        previewPageMargin: EdgeInsets.symmetric(horizontal:Responsive.isDesktop(context) ? margin : 10 ,vertical: 10 ),
        
        // pagesBuilder: (context, pages) {
        //   return Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: PageView(
        //       scrollDirection: Axis.vertical,
        //       children: [
        //         ...pages.map((e) => Container(
        //           color: Colors.white,
        //           height: e.height.toDouble(),
        //           width: e.width.toDouble(),
        //           child: InteractiveViewer(
                    
        //             child: Image(image: e.image,fit: BoxFit.fitHeight,)),
        //         ),)
        //       ],
        //     ),
        //   );
        // },
        // enableScrollToPage: true,
        // shouldRepaint: true,
        
        // dynamicLayout: false,
        // shouldRepaint: true,

        // canChangePageFormat: false,
        // allowPrinting: false,
        // actions: [
        //   IconButton(onPressed: ()async{
        //     print(format.toString());
        //     print("format.toString()");
        //     await Printing.layoutPdf(
        //         onLayout: (PdfPageFormat f) async => generateQRCode(
        //             format: format,data: widget.codeData));
        //   }, icon: Icon(Icons.print,color: Colors.white,)),
        //   DropdownButton<PdfPageFormat>(
        //     dropdownColor: headColor,
        //     value: format,
        //       items:[
        //         DropdownMenuItem(child: Text("Roll 57"),value: PdfPageFormat.roll57,),
        //         DropdownMenuItem(child: Text("Roll 80"),value: PdfPageFormat.roll80,),
        //       ], onChanged: (v){
        //         format = v!;
        //         setState(() {});
        //   })
        // ],
        initialPageFormat: format,
          pageFormats :  widget.pageFormats,
        onPageFormatChanged: (newFormat){
          setState(() {
          format = newFormat;
          });        },
        onPrinted: (context)async{
          Get.back();
        },
        
        canDebug: false,
        canChangeOrientation: widget.canChangeOrientation,
        pdfFileName: "Mostashar.pdf",
        build: (format){
          // if(report == "qrcode")
            return widget.widget(format);
        },
      ),
    );
  }
}
