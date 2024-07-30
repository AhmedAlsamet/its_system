import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:its_system/controllers/general_controller.dart';
import 'package:its_system/main.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  late GeneralController controller;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: AppBar().preferredSize.height),
              SizedBox(
                height: 250,
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    height:250,
                    decoration: const BoxDecoration(
                        image:  DecorationImage(
                            fit: BoxFit.contain,
                            image: AssetImage(
                                "assets/logo.png"))),
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              const Icon(Icons.wifi_off_outlined,size: 80,),
              const SizedBox(height: 10,),
              Text(
                "لا يوجد اتصال بالانترنت".tr(),
                style: Theme.of(context)
                    .textTheme
                    .displayLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 50,),
              ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(0, 0),
              padding: const EdgeInsets.all(10),
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
              onPressed: () {
                  Get.offAll(()=>const SplashScreen());
                },
              child: Text(
                "refersh".tr(),
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(color: Colors.white),
              ))
            ],
          ),
        ),
    );
  }
}
