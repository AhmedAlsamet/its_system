import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:ionicons/ionicons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/controllers/setting_controller.dart';
import 'package:its_system/core/utils/color_picker.dart';
import 'package:its_system/core/widgets/bottom_sheet_handel.dart';
import 'package:its_system/helper/open_camera_gallery.dart';
import 'package:its_system/models/qr_style_model.dart';
import 'package:its_system/pages/settings/components/io_save_image.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:its_system/responsive.dart';
import 'package:its_system/statics_values.dart';

class QrStyleScreen extends StatefulWidget {
  const QrStyleScreen({
    super.key,
  });

  @override
  State<QrStyleScreen> createState() => _QrStyleScreenState();
}

class _QrStyleScreenState extends State<QrStyleScreen> {
  @protected
  late QrCode qrCode;

  @protected
  late QrImage qrImage;

  // @protected
  // late PrettyQrDecoration decoration;

  @override
  void initState() {
    super.initState();

    qrCode = QrCode.fromData(
      data: 'https://yourfreesoft.com',
      errorCorrectLevel: QrErrorCorrectLevel.H,
    );

    qrImage = QrImage(qrCode);

    // decoration = const PrettyQrDecoration(
    //   shape: PrettyQrSmoothSymbol(
    //     color: Color(0xFF74565F),
    //   ),
    //   image: PrettyQrSettings.kDefaultPrettyQrDecorationImage,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
          initialChildSize: Responsive.isDesktop(context) ?1:0.8,
          maxChildSize: 1,
          minChildSize: 0.4,
          expand: Responsive.isDesktop(context) ?false:true,
      builder: (context,c) {
        return GetX(
          init: SettingController(),
          builder: (controller) {
            return Container(
                    color:Colors.transparent, //Theme.of(context).primaryColor,
                    width: Responsive.isDesktop(context) ? 500 : null,
                    child: Column(children: [
                      BottomSheetHandel(
                          cancelIcon: Ionicons.close,
                          cancelTooltip: "cancel".tr(),
                          saveIcon: Ionicons.save,
                          saveTooltip: "save".tr(),
                          controller: c,
                          onSave: () async{
                              await controller.addUpdateQrStyle();
                          },
                          onCancel: () {
                            Get.back(result: "Ahmed");
                          }),
                      Expanded(
                        child: Form(
                                            child: Scaffold(
                        // floatingActionButton: Responsive.isMobile(context) ? FloatingActionButton(
                        //   backgroundColor: Theme.of(context).primaryColor,
                        //   child: const Icon(Icons.qr_code_sharp,color: Colors.white,size: 40,),
                        //   onPressed: (){
                        //   showDialog(context: context, builder: (context)=>AlertDialog(content:Padding(
                        //                     padding: const EdgeInsets.symmetric(horizontal:10),
                        //                     child: _PrettyQrAnimatedView(
                        //                       qrImage: qrImage,
                        //                       decoration: decoration,
                        //                     ),
                        //                   ),));
                        // }):null,
                        body: Align(
                          alignment: Alignment.topCenter,
                          child: Column(
                            children: [
                                Expanded(
                                  flex: 2,
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.all(10),
                                  child: PrettyQrSettings(
                                    decoration: controller.decoration.value,
                                    onChanged: (value) {
                                      controller.decoration.value = value;
                                      controller.style.update((val) {
                                        var shape = value.shape;
                                          val!.qrColor =  (shape is PrettyQrSmoothSymbol)?  shape.color :
                                          (shape is PrettyQrRoundedSymbol) ? shape.color:Colors.black;
                                              if (shape is PrettyQrSmoothSymbol) {
                                            val.qrStyle = QRStyle.Smooth;
                                          } else if (shape is PrettyQrRoundedSymbol) {
                                            val.qrStyle = QRStyle.Rounded_rectangle;
                                          }
                                          if(controller.decoration.value.image!=null) {
                                            val.qrImagePosition = controller.decoration.value.image!.position;
                                            // val.qrImagePath = controller.decoration.value.image!.position;
                                          }
                                          else{
                                            val.qrImageFile = File("");
                                            val.qrImagePath = "";
                                          }
                                          if (shape is PrettyQrSmoothSymbol) {
                                            val.qrStyleIsRounded = shape.roundFactor > 0;
                                          } else if (shape is PrettyQrRoundedSymbol) {
                                            val.qrStyleIsRounded = shape.borderRadius != BorderRadius.zero;
                                          }
                                          // const defaultImage = PrettyQrSettings.kDefaultPrettyQrDecorationImage;
                                          // val.qrImagePath = widget.decoration.image != null ? null : defaultImage;
                                          // val.qrImagePath = widget.decoration.image != null ? null : defaultImage;
                                                            
                                      });
                                    },
                                    changeImage: (path){
                                      controller.style.update((val) {
                                              val!.qrImagePath = path;
                                              val.qrImageFile = File(path);
                                            });
                                            PrettyQrDecoration newDecoration =
                                                controller.decoration.value
                                                    .copyWith(
                                              image: PrettyQrDecorationImage(
                                                image: controller.style.value.qrImageFile!.path != "" ? 
                                                Image.file(
                                                      controller.style.value.qrImageFile!,errorBuilder: (context, error, stackTrace) {
                                                        return SizedBox(
                                                          child: Image.asset(
                                                      "assets/logo.png"),
                                                        );
                                                      },).image:
                                                NetworkImage(StaticValue.serverPath! + path),
                                              ),
                                            );
                                            controller.decoration.value = newDecoration;
                                          },
                                    onExportPressed: (size) {
                                      return qrImage.exportAsImage(context,
                                          size: size, decoration: controller.decoration.value);
                                    },
                                    onSharePressed: (size) {
                                      return qrImage.shareAsImage(context,
                                      
                                          size: size,massage: "", decoration: controller.decoration.value);
                                    }
                                  ),
                                ),
                              ),
                              Divider(),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal:10),
                                  child: _PrettyQrAnimatedView(
                                    qrImage: qrImage,
                                    decoration: controller.decoration.value
                                  ),
                                ),
                              ),
                                          // if(Responsive.isMobile(context))
                                          // Padding(
                                          //   padding: const EdgeInsets.symmetric(horizontal:10),
                                          //   child: _PrettyQrAnimatedView(
                                          //     qrImage: qrImage,
                                          //     decoration: decoration,
                                          //   ),
                                          // ),
                            ],
                          ),
                        ),
                          ),
                        ),
                      ),
                ],
              ),
            );
          }
        );
      }
    );
  }
}

class _PrettyQrAnimatedView extends StatefulWidget {
  @protected
  final QrImage qrImage;

  @protected
  final PrettyQrDecoration decoration;

  const _PrettyQrAnimatedView({
    required this.qrImage,
    required this.decoration,
  });

  @override
  State<_PrettyQrAnimatedView> createState() => _PrettyQrAnimatedViewState();
}

class _PrettyQrAnimatedViewState extends State<_PrettyQrAnimatedView> {
  @protected
  late PrettyQrDecoration previosDecoration;

  @override
  void initState() {
    super.initState();

    previosDecoration = widget.decoration;
  }

  @override
  void didUpdateWidget(
    covariant _PrettyQrAnimatedView oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (widget.decoration != oldWidget.decoration) {
      previosDecoration = oldWidget.decoration;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TweenAnimationBuilder<PrettyQrDecoration>(
        tween: PrettyQrDecorationTween(
          begin: previosDecoration,
          end: widget.decoration,
        ),
        curve: Curves.ease,
        duration: const Duration(
          milliseconds: 240,
        ),
        builder: (context, decoration, child) {
          return PrettyQrView(
            qrImage: widget.qrImage,
            decoration: decoration
          );
        },
      ),
    );
  }
}

class PrettyQrSettings extends StatefulWidget {
  @protected
  final PrettyQrDecoration decoration;

  @protected
  final Future<String?> Function(int)? onExportPressed;
  @protected
  final Future<String?> Function(int)? onSharePressed;

  @protected
  final ValueChanged<PrettyQrDecoration>? onChanged;

  @protected
  final Function(String newImagePath)? changeImage;

  static const kDefaultPrettyQrDecorationImage = PrettyQrDecorationImage(
    image: AssetImage('assets/logo.png'),
    position: PrettyQrDecorationImagePosition.embedded,
  );

  const PrettyQrSettings({
    required this.decoration,
    this.onChanged,
    this.onExportPressed,
    this.onSharePressed,
    this.changeImage,
  });

  @override
  State<PrettyQrSettings> createState() => _PrettyQrSettingsState();
}

class _PrettyQrSettingsState extends State<PrettyQrSettings> {
  Color currentColor = Colors.amber;
  @protected
  late final TextEditingController imageSizeEditingController;

  @override
  void initState() {
    super.initState();
    imageSizeEditingController = TextEditingController(
      text: ' 512w',
    );
  }

  @protected
  int get imageSize {
    final rawValue = imageSizeEditingController.text;
    return int.parse(rawValue.replaceAll('w', '').replaceAll(' ', ''));
  }

  @protected
  Color get shapeColor {
    var shape = widget.decoration.shape;
    if (shape is PrettyQrSmoothSymbol) return shape.color;
    if (shape is PrettyQrRoundedSymbol) return shape.color;
    return Colors.black;
  }

  @protected
  bool get isRoundedBorders {
    var shape = widget.decoration.shape;
    if (shape is PrettyQrSmoothSymbol) {
      return shape.roundFactor > 0;
    } else if (shape is PrettyQrRoundedSymbol) {
      return shape.borderRadius != BorderRadius.zero;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return PopupMenuButton(
              onSelected: changeShape,
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
              ),
              initialValue: widget.decoration.shape.runtimeType,
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    value: PrettyQrSmoothSymbol,
                    child: Text('Smooth'),
                  ),
                  const PopupMenuItem(
                    value: PrettyQrRoundedSymbol,
                    child: Text('Rounded rectangle'),
                  ),
                ];
              },
              child: ListTile(
                leading: const Icon(Icons.format_paint_outlined),
                title: const Text('Style'),
                trailing: Text(
                  widget.decoration.shape is PrettyQrSmoothSymbol
                      ? 'Smooth'
                      : 'Rounded rectangle',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            );
          },
        ),
        SwitchListTile.adaptive(
          value: shapeColor != Colors.black,
          onChanged: (value) => toggleColor(),
          secondary: const Icon(Icons.color_lens_outlined),
          title: const Text('Colored'),
        ),
        if(shapeColor != Colors.black)
          ListTile(
          leading: const Icon(Icons.color_lens_outlined),
            onTap: ()async{
            currentColor =  await selectColor(context: context, currentColor: currentColor);
            currentColor = Color(currentColor.value);
            changeColor();
          },title: const Text("Color"),),
        SwitchListTile.adaptive(
          value: isRoundedBorders,
          onChanged: (value) => toggleRoundedCorners(),
          secondary: const Icon(Icons.rounded_corner),
          title: const Text('Rounded corners'),
        ),
        const Divider(),
        SwitchListTile.adaptive(
          value: widget.decoration.image != null,
          onChanged: (value) => toggleImage(),
          secondary: Icon(
            widget.decoration.image != null
                ? Icons.image_outlined
                : Icons.hide_image_outlined,
          ),
          title: const Text('Logo'),
        ),
        if (widget.decoration.image != null)
        ...[
           ListTile(
            enabled: widget.decoration.image != null,
            leading: const Icon(Icons.image_outlined),
            title: const Text('Compound Logo'),
            onTap: ()async{
              String path = await openGallery();
              widget.changeImage!(path);
            },
          ),
           ListTile(
            enabled: widget.decoration.image != null,
            leading: const Icon(Icons.layers_outlined),
            title: const Text('Logo position'),
            trailing: PopupMenuButton(
              onSelected: changeImagePosition,
              initialValue: widget.decoration.image?.position,
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    value: PrettyQrDecorationImagePosition.embedded,
                    child: Text('Embedded'),
                  ),
                  const PopupMenuItem(
                    value: PrettyQrDecorationImagePosition.foreground,
                    child: Text('Foreground'),
                  ),
                  const PopupMenuItem(
                    value: PrettyQrDecorationImagePosition.background,
                    child: Text('Background'),
                  ),
                ];
              },
            ),
          ),
        ],
        ],
    );
  }

  @protected
  void changeShape(
    final Type type,
  ) {
    var shape = widget.decoration.shape;
    if (shape.runtimeType == type) return;

    if (shape is PrettyQrSmoothSymbol) {
      shape = PrettyQrRoundedSymbol(color: shapeColor);
    } else if (shape is PrettyQrRoundedSymbol) {
      shape = PrettyQrSmoothSymbol(color: shapeColor);
    }

    widget.onChanged?.call(widget.decoration.copyWith(shape: shape));
  }

  @protected
  void toggleColor() {
    var shape = widget.decoration.shape;
    var color = shapeColor != Colors.black
        ? Colors.black
        : currentColor;

    if (shape is PrettyQrSmoothSymbol) {
      shape = PrettyQrSmoothSymbol(
        color: color,
        roundFactor: shape.roundFactor,
      );
    } else if (shape is PrettyQrRoundedSymbol) {
      shape = PrettyQrRoundedSymbol(
        color: color,
        borderRadius: shape.borderRadius,
      );
    }

    widget.onChanged?.call(widget.decoration.copyWith(shape: shape));
  }
  @protected
  void changeColor() {
    var shape = widget.decoration.shape;
    var color = shapeColor == Colors.black
        ? Colors.black
        : currentColor;

    if (shape is PrettyQrSmoothSymbol) {
      shape = PrettyQrSmoothSymbol(
        color: color,
        roundFactor: shape.roundFactor,
      );
    } else if (shape is PrettyQrRoundedSymbol) {
      shape = PrettyQrRoundedSymbol(
        color: color,
        borderRadius: shape.borderRadius,
      );
    }

    widget.onChanged?.call(widget.decoration.copyWith(shape: shape));
  }

  @protected
  void toggleRoundedCorners() {
    var shape = widget.decoration.shape;

    if (shape is PrettyQrSmoothSymbol) {
      shape = PrettyQrSmoothSymbol(
        color: shape.color,
        roundFactor: isRoundedBorders ? 0 : 1,
      );
    } else if (shape is PrettyQrRoundedSymbol) {
      shape = PrettyQrRoundedSymbol(
        color: shape.color,
        borderRadius: isRoundedBorders
            ? BorderRadius.zero
            : const BorderRadius.all(Radius.circular(10)),
      );
    }

    widget.onChanged?.call(widget.decoration.copyWith(shape: shape));
  }

  @protected
  void toggleImage() {
    const defaultImage = PrettyQrSettings.kDefaultPrettyQrDecorationImage;
    final image = widget.decoration.image != null ? null : defaultImage;

    widget.onChanged?.call(
        PrettyQrDecoration(image: image, shape: widget.decoration.shape));
  }

  @protected
  void changeImagePosition(
    final PrettyQrDecorationImagePosition value,
  ) {
    final image = widget.decoration.image?.copyWith(position: value);
    widget.onChanged?.call(widget.decoration.copyWith(image: image));
  }

  @override
  void dispose() {
    imageSizeEditingController.dispose();

    super.dispose();
  }
}







/**
           ListTile(
            leading: const Icon(Icons.save_alt_outlined),
            title: const Text('Share'),
            onTap: () async {
              final path = await widget.onSharePressed?.call(imageSize);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(path == null ? 'Saved' : 'Saved to $path'),
                ),
              );
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PopupMenuButton(
                  initialValue: imageSize,
                  onSelected: (value) {
                    imageSizeEditingController.text = ' ${value}w';
                    setState(() {});
                  },
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        value: 256,
                        child: Text('256w'),
                      ),
                      const PopupMenuItem(
                        value: 512,
                        child: Text('512w'),
                      ),
                      const PopupMenuItem(
                        value: 1024,
                        child: Text('1024w'),
                      ),
                    ];
                  },
                  child: SizedBox(
                    width: 72,
                    height: 36,
                    child: TextField(
                      enabled: false,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                      controller: imageSizeEditingController,
                      decoration: InputDecoration(
                        filled: true,
                        counterText: '',
                        contentPadding: EdgeInsets.zero,
                        fillColor: Theme.of(context).colorScheme.background,
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
 */









/**
           ListTile(onTap: (){
            showDialog(context: context, builder: (context){
              return Scaffold(
                body:HSVColorPickerExample(
                    pickerColor: currentColor,
                    onColorChanged: changeColor,
                    colorHistory: colorHistory,
                    onHistoryChanged: (List<Color> colors) => colorHistory = colors,
                  ),
              );
            });
                // MaterialColorPickerExample(pickerColor: currentColor, onColorChanged: changeColor),
                
                // HSVColorPickerExample(
                //     pickerColor: currentColor,
                //     onColorChanged: changeColor,
                //     colorHistory: colorHistory,
                //     onHistoryChanged: (List<Color> colors) => colorHistory = colors,
                //   ),

                //  BlockColorPickerExample(
                //   pickerColor: currentColor,
                //   onColorChanged: changeColor,
                //   pickerColors: currentColors,
                //   onColorsChanged: changeColors,
                //   colorHistory: colorHistory,
                // )
          },title: Text("Color"),),
 */

/*
 ListTile(
            leading: const Icon(Icons.save_alt_outlined),
            title: const Text('Export'),
            onTap: () async {
              final path = await widget.onExportPressed?.call(imageSize);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(path == null ? 'Saved' : 'Saved to $path'),
                ),
              );
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PopupMenuButton(
                  initialValue: imageSize,
                  onSelected: (value) {
                    imageSizeEditingController.text = ' ${value}w';
                    setState(() {});
                  },
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        value: 256,
                        child: Text('256w'),
                      ),
                      const PopupMenuItem(
                        value: 512,
                        child: Text('512w'),
                      ),
                      const PopupMenuItem(
                        value: 1024,
                        child: Text('1024w'),
                      ),
                    ];
                  },
                  child: SizedBox(
                    width: 72,
                    height: 36,
                    child: TextField(
                      enabled: false,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                      controller: imageSizeEditingController,
                      decoration: InputDecoration(
                        filled: true,
                        counterText: '',
                        contentPadding: EdgeInsets.zero,
                        fillColor: Theme.of(context).colorScheme.background,
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
 */