import 'package:its_system/models/qr_style_model.dart';
import 'package:its_system/models/user_model.dart';

class StaticValue{
  static UserModel? userData;
  static QRStyleModel? qrStyle;
  static String? serverPath= 'http://Ahmed:801/its_api/';
  static String? serverName = '';
  static String? userName;
  static String? password;
  static String? deviceName = '';
  static String? deviceIp = '';
  static String? restaurantName;
  static bool? system1 = false;
  static int? systemType = 1;
  static bool? system2 = false;
  static bool? system3 = false;
  static Map? systemInfo;
  // static Map? system2Info;
  static String? key;
  // static String? key2;
  static String? productKey;
  // static String? productKey2;
  static int pageCount = 1;
  // static int lastNotification = 0;
  // static int lastNotificationReserved = 0;
}
