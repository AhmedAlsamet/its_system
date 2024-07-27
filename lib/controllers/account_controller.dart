import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:its_system/constants.dart';
import 'package:its_system/core/utils/snakbar_dialog.dart';
import 'package:its_system/helper/db/general_helper.dart';
import 'package:its_system/models/user_model.dart';
import 'package:its_system/statics_values.dart';

class AccountController extends GetxController {

  GlobalKey<FormState> formKey = GlobalKey();
  RxList<Rx<UserModel>> friends = <Rx<UserModel>>[].obs;
  GeneralHelper db = GeneralHelper();

  Rx<UserModel> friend = UserModel().initialize().obs;
  int? userLedId;


 RxBool froFriends = false.obs;
 AccountController(this.froFriends,[this.userLedId]);
  @override
  void onInit() {
    super.onInit();
    fetchAllFreinds();
  }

  fetchAllFreinds() async {
    friends.clear();
    String query = froFriends.value ?
    "SELECT *,uf.USR_FRIEND_ID as USR_ID FROM users as u INNER JOIN user_friends as uf "
      " ON uf.USR_FRIEND_ID = u.USR_ID "
      " WHERE USR_STATE != 'DELETED' AND uf.USR_ID = ${userLedId ?? StaticValue.userData!.userId}"
    : "SELECT * FROM users WHERE USR_LED_ID = ${userLedId ?? StaticValue.userData!.userId};";
      await db.getAllAsMap(query
      ).then((value) {
        for (var i = 0; i < value!.length; i++) {
          friends.add(UserModel.fromMap(value[i]).obs);
        }
        friends.refresh();
      });
  }


   
Future<bool> getAllUsersDialog() async {

    List<UserModel> users =[];
      int userId = StaticValue.userData!.userId!;
        await db.getAllAsMap("SELECT * FROM users where USR_ID != $userId AND USR_UNIQUE_KEY = '${friend.value.userNumber!.text}'").then((value) {
          for (var i = 0; i < value!.length; i++) {
            users.add(UserModel.fromMap(value[i]));
          }
        });
    if (users.isNotEmpty) {
        friend.value = users[0];
        return true;
    } else {
      snakbarDialog(title: 'thisAccountIsNotExist'.tr(), content: 'pleaseMakeSureOfUserNumber'.tr(),
       durationSecound: 10, color: redColor, icon: const Icon(Icons.cancel_rounded, color: Colors.white, size: 30));
       return false;
    }
  }
}