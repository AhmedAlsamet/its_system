import 'package:get/get.dart' hide Trans;
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/constants.dart';
import 'package:its_system/controllers/controller_panel_controller.dart';
import 'package:its_system/controllers/general_controller.dart';
import 'package:its_system/core/models/daily_info_model.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:its_system/core/models/menu.dart';
import 'package:its_system/core/utils/rive_utils.dart';

class MiniInformationWidget extends StatefulWidget {
  MiniInformationWidget({
    Key? key,
    required this.dailyData,
    required this.controller,
  }) : super(key: key);
  final DailyInfoModel dailyData;
  ControllerPanelController controller;

  @override
  _MiniInformationWidgetState createState() => _MiniInformationWidgetState();
}

class _MiniInformationWidgetState extends State<MiniInformationWidget> {
  late GeneralController controller;
  @override
  void initState() {
    super.initState();
    controller = Get.put(GeneralController());
  }

  @override
  Widget build(BuildContext context) {
    List<String> titles = [     
           "systemManagement".tr(),
     "servicesManagement".tr(),
     'controlPanel'.tr(),
     "employees".tr(),
     "citizens".tr(),
     "orders".tr(),
     "settings".tr(),
          "notifications".tr(),
     ];
    return InkWell(
      onTap: () async{
        int index = widget.dailyData.id! == 1
            ? 3
            : 5;
        Menu item = controller.menuItems[index];
        RiveUtils.chnageSMIBoolState(item.rive.status!,
            controller.selecteditem.value.rive.status!, item.index);
        controller.updateSelectedItem(item);
        await controller.changePage(
            item.index,
            widget.dailyData.id!,
            widget.dailyData.selectedBy == SelectedBy.ALL
                ? DateTime(2024)
                : DateTime.now().subtract(Duration(
                    days: widget.dailyData.selectedBy == SelectedBy.DAY
                        ? 1
                        : widget.dailyData.selectedBy == SelectedBy.MONTH
                            ? 30
                            : 365)),
            DateTime.now());
        controller.appBarTitle.value = titles[index];
      },
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: widget.dailyData.withBorder != null &&
                    widget.dailyData.withBorder!
                ? Border(
                    bottom:
                        BorderSide(color: widget.dailyData.color!, width: 5))
                : null),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(defaultPadding * 0.75),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: widget.dailyData.color!.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Icon(
                    widget.dailyData.icon,
                    color: widget.dailyData.color,
                    size: 18,
                  ),
                ),
                if (widget.dailyData.multiChoise!)
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: DropdownButton(
                      dropdownColor: Theme.of(context).cardColor,
                      icon: const Icon(Icons.more_vert, size: 18),
                      alignment: Alignment.center,
                      underline: const SizedBox(),
                      value: widget.dailyData.selectedBy!,
                      items: [
                        ...SelectedBy.values.map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.name.tr()),
                            ))
                      ],
                      onChanged: (value) {
                        widget.controller.chartsData
                            .firstWhere(
                                (c) => c.value.id == widget.dailyData.id)
                            .update((val) {
                          val!.selectedBy = value!;
                        });
                        widget.controller
                            .changeChartData(widget.dailyData.id! - 1);
                      },
                    ),
                  ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.dailyData.title!,
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                LineChartWidget(
                  colors: widget.dailyData.colors,
                  spotsData: widget.dailyData.spots,
                )
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            ProgressLine(
              color: widget.dailyData.color!,
              percentage: widget.dailyData.percentage!,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${widget.dailyData.volumeData}",
                    style: Theme.of(context).textTheme.displaySmall),
                Text(widget.dailyData.totalStorage!,
                    style: Theme.of(context).textTheme.displaySmall),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class LineChartWidget extends StatelessWidget {
  const LineChartWidget({
    Key? key,
    required this.colors,
    required this.spotsData,
  }) : super(key: key);
  final List<Color>? colors;
  final List<FlSpot>? spotsData;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 30,
          child: LineChart(
            LineChartData(
                lineBarsData: [
                  LineChartBarData(
                      spots: spotsData,
                      belowBarData: BarAreaData(show: false),
                      aboveBarData: BarAreaData(show: false),
                      isCurved: true,
                      dotData: FlDotData(show: false),
                      colors: colors,
                      barWidth: 3),
                ],
                lineTouchData: LineTouchData(enabled: false),
                titlesData: FlTitlesData(show: false),
                axisTitleData: FlAxisTitleData(show: false),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false)),
          ),
        ),
      ],
    );
  }
}

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    this.color = primaryColor,
    required this.percentage,
  }) : super(key: key);

  final Color color;
  final int percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage / 100),
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
