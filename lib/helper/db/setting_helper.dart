import 'package:flutter/material.dart';
import 'package:mysql_utils/mysql_utils.dart';
import 'package:its_system/helper/db/dbhelper.dart';
import 'package:its_system/models/setting_model.dart';
import 'package:its_system/statics_values.dart';
import 'package:sqflite/sqflite.dart';

class SettingHelper extends DbHelper {
  static final SettingHelper _instance = SettingHelper.internal();
  factory SettingHelper() => _instance;
  SettingHelper.internal():super.internal();

        // await db.execute(
        //   "CREATE TABLE (SM_ID INTEGER PRIMARY KEY AUTOINCREMENT, SM_DATE_TIME DATE,SM_TYPE VARCHAR(10),SM_NOTE VARCHAR(255) DEFAULT('NULL'));"
        //   );
        // await db.execute(
        //   "CREATE TABLE STORE_MOVEMENT_SELLS(SMS_ID INTEGER PRIMARY KEY, SM_ID INTEGER,C_ID INTEGER,FOREIGN KEY (C_ID) REFERENCES CUSTOMERS(C_ID),FOREIGN KEY (SM_ID) REFERENCES STORE_MOVEMENT(SM_ID));"
        //   );
        // await db.execute(
        //   "CREATE TABLE SELL_DETAILS(SM_ID INTEGER ,CAT_COUNT NUMBER,UN_ID INTEGER ,CAT_ID INTEGER ,CAN_UN_PRICE NUMBER ,FOREIGN KEY (CAT_ID) REFERENCES Accounts(CAT_ID),FOREIGN KEY (UN_ID) REFERENCES UNITS(UN_ID),FOREIGN KEY (SM_ID) REFERENCES STORE_MOVEMENT(SM_ID));"
        //   );
  Future<int> createSetting(SettingModel item)async {
    try{
      if (StaticValue.systemType == 1) {

      MysqlUtils db = DbHelper.db;
    await db.insert(
      table:'settings',
      insertData:item.toMap(),
      );

    return 1;
              } else {
        Database db = await createDatabase();
    await db.insert(
      'settings',
      item.toMap(),
      );

    return 1;
      }
    }
    catch(e){
      print("error $e");
      return 0;
    }
  }
  Future<int> updateSetting(SettingModel item)async {
    try{
      if (StaticValue.systemType == 1) {

      MysqlUtils db = DbHelper.db;
      
     await db.update(
            table:'settings',
      updateData:item.toMap(),
      where: {
        'SET_ID':item.settingId!,
        'INST_ID':item.institutionId!,
        });
        return 1;
                      } else {
        Database db = await createDatabase();
     await db.update(
            'settings',
      item.toMap(),
      where:         'SET_ID = ? AND INST_ID = ? ' ,whereArgs:[item.settingId!,item.institutionId],
        );
        return 1;
      }
        }
    catch(e){
      print(e);
      return 0;
    }
  }
    Future<int> updateOrInsert(SettingModel item) async {
    try {
      if (StaticValue.systemType == 1) {
        MysqlUtils db = DbHelper.db;
        int count = await db.update(
            table: "settings",
            updateData: item.toMap(),
            where: {
              'SET_ID':item.settingId!,
              'INST_ID':item.institutionId!,
            });
        if(count > 0) {
          return 1;
        }
        await db.insert(
          table: "settings",
          insertData: item.toMap(),
        );
        return 1;
      } else {
        Database db = await createDatabase();
        int count = await db.update(
          "settings",
          item.toMap(),
      where: 'SET_ID = ? AND INST_ID = ? ' ,whereArgs:[item.settingId!,item.institutionId],
        );
        if(count > 0) {
          return 1;
        }
        await db.insert(
           "settings",
           item.toMap(),
        );
        return 1;
      }
    } catch (e) {
      debugPrint("error $e");
      return 0;
    }
  }
    Future<List<SettingModel>> getAllSettings(String additionalCondition)async {
    try{
    List<SettingModel> result = [];

      if (StaticValue.systemType == 1) {

    MysqlUtils db = DbHelper.db;
    ResultFormat settings = await db.query(
      'SELECT * FROM settings $additionalCondition;');
    for (var c in settings.rows) {
      result.add(SettingModel.fromMap(c));
    }
    return result;
                              } else {
        Database db = await createDatabase();
     List settings = await db.rawQuery(
      'SELECT * FROM settings $additionalCondition;');
    for (var c in settings) {
      result.add(SettingModel.fromMap(c));
    }
    return result;
      }
        }
    catch(e){
      print(" Error $e");
      return [];
    }
  }
}
