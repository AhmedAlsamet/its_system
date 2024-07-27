import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:its_system/controllers/home_controller.dart';
import 'package:its_system/core/widgets/nav_bar_icon.dart';
import 'package:its_system/core/widgets/popup_menu.dart';
import 'package:its_system/models/order_model.dart';
import 'package:its_system/pages/mobile/service_screen.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class OrdersForMobile extends StatefulWidget {
  const OrdersForMobile({super.key});

  @override
  State<OrdersForMobile> createState() => _OrdersForMobileState();
}

class _OrdersForMobileState extends State<OrdersForMobile> {
  @override
  Widget build(BuildContext context) {
    return GetX(
        init: HomeController(),
        builder: (controller) {
          return Scaffold(
              appBar: AppBar(
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "myOrders".tr(),
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge!
                          .copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                    ),
                  ),
                ),
                // backgroundColor: headColor,
                centerTitle: true,
                automaticallyImplyLeading: false,
              ),
              body: RefreshIndicator(
                onRefresh: ()async{
                  await controller.fetchAllOrders();
                },
                child: ListView(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ...controller.orders.map((element) => OrderCard(
                            order: element.value,
                            controller: controller,
                          ))
                    ]),
              ));
        });
  }
}

// ignore: must_be_immutable
class OrderCard extends StatefulWidget {
  final OrderModel order;
  HomeController controller;
  OrderCard(
      {super.key,
      required this.order,
      required this.controller});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            widget.order.institution!.institutionName!.getTitle,
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
        subtitle: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            widget.order.service!.serviceName!.getTitle,
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
        trailing: orderAction(),
        leading: Container(
          width: 80,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(20)),
          child: FittedBox(
            child: Text(
              widget.order.orderState!.name.tr(),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget orderAction() {
    return Container(
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: PopupMenuButton(
        surfaceTintColor: Colors.transparent,
        icon: Icon(
          Icons.more_vert,
          color: Theme.of(context).iconTheme.color,
        ),
        onSelected: (v) async {
          if(v==0){
            widget.controller.isEdit = true;
            await widget.controller.refreshOrderWithValues(widget.order, widget.order.service!, widget.order.institution!);
            Get.to(()=>ShowOrderOrEditIt(title: "editData".tr(),forRead: false));
          }
          if(v==1){
            widget.controller.isEdit = true;
            await widget.controller.refreshOrderWithValues(widget.order, widget.order.service!, widget.order.institution!);
            Get.to(()=>ShowOrderOrEditIt(title: "showData".tr(),forRead: true,));
          }
        },
        itemBuilder: (context) {
          return [
            if(widget.order.orderState == OrderState.FOR_EDIT)
            PopupMenuItem(
              value: 0,
              child: MyPopupMenuItem(
                icon: Icons.edit,
                text: "editData".tr(),
              ),
            ),
            PopupMenuItem(
              value: 1,
              child: MyPopupMenuItem(
                icon: Icons.remove_red_eye_sharp,
                text: "showData".tr(),
              ),
            ),
          ];
        },
      ),
    );
  }
}


class ShowOrderOrEditIt extends StatelessWidget {
  final String title;
  final bool forRead;
  const ShowOrderOrEditIt({super.key,required this.title, required this.forRead});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(
              flexibleSpace: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SafeArea(
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      const SizedBox()
                    ],
                  ),
                ),
              ),
              // backgroundColor: headColor,
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),
      body: NewOrder(forRead: forRead,)
    );
  }
}