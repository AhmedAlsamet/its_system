import 'package:get/get.dart';
import 'package:its_system/constants.dart';
import 'package:its_system/controllers/controller_panel_controller.dart';
import 'package:its_system/pages/dashboard/components/mini_information_widget.dart';
import 'package:its_system/responsive.dart';
import 'package:flutter/material.dart';

class MiniInformation extends StatelessWidget {
  const MiniInformation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        const SizedBox(height: defaultPadding),
        Responsive(
          mobile: InformationCard(
            crossAxisCount: _size.width < 400  ? 1 :_size.width < 650 ? 2 : 3,
            childAspectRatio: _size.width < 650 ? 1.2 : 1,
          ),
          tablet: InformationCard(
            crossAxisCount: _size.width < 1000 ? 4 : 5,
          ),
          desktop: InformationCard(
            crossAxisCount: _size.width < 1200 ? 4 : 5,
            childAspectRatio: _size.width < 1400 ? 1.2 : 1.4,
          ),
        ),
      ],
    );
  }
}

class InformationCard extends StatelessWidget {
  const InformationCard({
    Key? key,
    this.crossAxisCount = 5,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GetX(
      init: ControllerPanelController(),
      builder: (controller) {
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: controller.chartsData.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: defaultPadding,
            mainAxisSpacing: defaultPadding,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) =>
              MiniInformationWidget(dailyData: controller.chartsData[index].value,controller: controller,),
        );
      }
    );
  }
}
