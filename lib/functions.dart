import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:its_system/helper/device_information.dart';
import 'package:its_system/statics_values.dart';

// this works with API
getRequest(String url) async{
  try{
    var response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      var responsebody = jsonDecode(response.body);
      print(responsebody);
      return responsebody;
    }else{
      print('Error ${response.statusCode}');
      return null;
    }
  }catch(e){
    print('Error catch $e');
    return null;
  }
}
reomoveImageRequest(String image) async{
  try{
    var response = await http.post(Uri.parse("${StaticValue.serverPath!}delete_image.php"),body:{"image":image});
    if(response.statusCode == 200){
      var responsebody = jsonDecode(response.body);
      return responsebody;
    }else{
      return null;
    }
  }catch(e){
    return null;
  }
}
postRequest(String url,Map data) async{
  try{
    var response = await http.post(Uri.parse(url),body:data);
    if(response.statusCode == 200){
      var responsebody = jsonDecode(response.body);
      return responsebody;
    }else{
      return null;
    }
  }catch(e){
    return null;
  }
}
Future postRequestWithoutBody(String url) async{
  try{
    var response = await http.post(Uri.parse(url));
    if(response.statusCode == 200){
      var responsebody = jsonDecode(response.body);
      print(responsebody);
      return responsebody;
    }else{
      print('Error ${response.statusCode}');
      return null;
    }
  }catch(e){
    print('Error catch $e');
    return null;
  }
}
requestPermission()async{
  var status = await Permission.camera.status;
  if(!status.isGranted){
    await Permission.camera.request();
  }

  var status1 = await Permission.storage.status;
  if(!status1.isGranted){
    await Permission.storage.request();
  }

  var status3 = await Permission.manageExternalStorage.status;
  if(!status3.isGranted){
    await Permission.manageExternalStorage.request();
  }
}
requestStoragePermission()async{
  // var status1 = await Permission.storage.status;
  // if(!status1.isGranted){
  //   await Permission.storage.request();
  // }

  var status2 = await Permission.manageExternalStorage.status;
  if(status2.isGranted){
    await Permission.manageExternalStorage.request();
  }
  var status3 = await Permission.storage.status;
  if(!status3.isGranted){
    // await Permission.manageExternalStorage.request();
    await Permission.storage.request();
  }
}
requestCameraPermission()async{
  var status = await Permission.camera.status;
  if(!status.isGranted){
    await Permission.camera.request();
  }
}
checkPermission() async{
  if(Platform.isAndroid){

  var status = await Permission.camera.status;

  var status1 = await Permission.storage.status;

  // var status2 = await Permission.manageExternalStorage.status;

  return status.isGranted && status1.isGranted ;//&& status2.isGranted;
  } return true;
}
checkCameraPermission() async{
  var status = await Permission.camera.status;
  return status.isGranted;
}
Future<bool> checkStoragePermission() async{
  if(await DeviceInformationHelper.getAndroidVersion() > 32){
    return true;
  }
  var status = await Permission.storage.status;
  var status2 = await Permission.manageExternalStorage.status;
  return status.isGranted || status2.isGranted;
}

  String _basicAuth = 'Basic ' +
    base64Encode(utf8.encode(
        'hamod:mero@ahmed'));

    Map<String, String> myheaders = {
          'authorization': _basicAuth
        };

Future<String> postRequestWithFile(String type,int id, File file,[String? lastImageName]) async {
  try{
    if (file.path != '') {
    var request =
        http.MultipartRequest("POST", Uri.parse("${StaticValue.serverPath!}upload_image.php"));

    var length = await file.length();
    var stream = http.ByteStream(file.openRead());
    // String fileName = basename(file.path) + DateFormat("yyyy-MM-ddHH:mm:ss").format(DateTime.now());
    String fileName = "$id${extension(file.path)}";
    var multiPartFile = http.MultipartFile("image", stream, length,
        filename: fileName);
    request.files.add(multiPartFile);

    // data.forEach((key,value){
    //   request.fields[key] = value;
    // });
      request.fields["type"] = type;
      request.fields["last_image"] = lastImageName ?? fileName;
    var myRequest = await request.send();

    var response = await http.Response.fromStream(myRequest);
    if (myRequest.statusCode == 200 && jsonDecode(response.body)["operator"]!="FAILED") {
      // print(response.body);
      // return jsonDecode(response.body);
      return "$type/$fileName";
    } else {
      print(response.body);
      return "";
    }
  }
    return "";
  }
  catch(e){
    print(e);
    return "";
  }
}

getFromBoolOrInt(value) {
  if (value is int) {
    return value == 1;
  }
  if (value is bool) {
    return value;
  }
  return value == "1" || value == "true";
}

convertBoolToInt(value) {
  if (value is bool) {
    return value ? "1" : "0";
  }
}
