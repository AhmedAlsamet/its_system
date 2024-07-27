import 'dart:io';

// import 'package:device_information/device_information.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_device_identifier/flutter_device_identifier.dart';
// import 'package:get_mac/get_mac.dart';
import 'package:device_info_plus/device_info_plus.dart';



class DeviceInformationHelper{


  static getAllDataForWindows()async{
    // final deviceInfoPlugin = DeviceInfoPlugin();
    // final deviceInfo = await deviceInfoPlugin.deviceInfo;
    // final allInfo = deviceInfo.data;
    // print(allInfo);
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
WindowsDeviceInfo androidInfo = await deviceInfo.windowsInfo;
print('Running on ${androidInfo.data}');  // e.g.
//  numberOfCores,installDate,deviceId
  }
  static getDeviceIdForWindows()async{
    // final deviceInfoPlugin = DeviceInfoPlugin();
    // final deviceInfo = await deviceInfoPlugin.deviceInfo;
    // final allInfo = deviceInfo.data;
    // print(allInfo);
  try{
       if(Platform.isWindows){
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  WindowsDeviceInfo androidInfo = await deviceInfo.windowsInfo;
  return androidInfo.data["deviceId"]; 
    }
    else{
      // bool isSunmi =  (await SunmiPrinter.bindingPrinter()) ?? false;
      //   if(isSunmi){
      //     return await SunmiPrinter.serialNumber();
      //   }
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.data["id"]; 
    }
  }catch(e){
    return "null";
  }

  // e.g.
//  numberOfCores,installDate,deviceId
  }
  static getDeviceNameForWindows()async{
    // final deviceInfoPlugin = DeviceInfoPlugin();
    // final deviceInfo = await deviceInfoPlugin.deviceInfo;
    // final allInfo = deviceInfo.data;
    // print(allInfo);
    try{
          if(Platform.isWindows){
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  WindowsDeviceInfo androidInfo = await deviceInfo.windowsInfo;
  return androidInfo.data["computerName"]; // e.g.
    }
    else{
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  // print(androidInfo.systemFeatures);
  // print(androidInfo.model);
  // print(androidInfo.citizen);
  // print(androidInfo.device);
  // print(androidInfo.id);
  // print(androidInfo.product);
  // print(androidInfo.serialNumber);
  return androidInfo.model; //.data["device"]; // e.g
    }
  //       BaseDeviceInfo deviceInfo = DeviceInfoPlugin().deviceInfo;
  // BaseDeviceInfo androidInfo = await deviceInfo.;
  // return androidInfo.data["computerName"]; // e.g
    
//  numberOfCores,installDate,deviceId
    }catch(e){
      return "";
    }
  }
  static getAndroidVersion()async{

  try {
        AndroidDeviceInfo deviceInfo = await DeviceInfoPlugin().androidInfo;
        return deviceInfo.version.sdkInt;
  } catch (exception) {
    /// Handle the exception.
    return "";
  }
}
  static getDeviceIpForWindows()async{

  try {
    List<NetworkInterface> list = await NetworkInterface.list(includeLoopback: false,type: InternetAddressType.IPv4);
    // for (var i = 0; i < list.length; i++) {
    //   print(list[i].name);
    //   print(list[i].addresses[0].address);
    // }
    return list[0].addresses[0].address;
  } catch (exception) {
    /// Handle the exception.
    return "";
  }
}

  // static getHardInfo()async{
  //   List<Drive> drives = WindowsHDSN().getDrives();
  //   for(Drive drive in drives){
  //       print(drive.model);
  //       print(drive.serial);
  //   }
  // }

}