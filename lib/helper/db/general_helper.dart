import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:its_system/core/utils/snakbar_dialog.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mysql_utils/mysql_utils.dart';
import 'package:its_system/helper/db/dbhelper.dart';
import 'package:its_system/statics_values.dart';
import 'package:sqflite/sqflite.dart';

class GeneralHelper extends DbHelper {
  static final GeneralHelper _instance = GeneralHelper.internal();
  factory GeneralHelper() => _instance;
  GeneralHelper.internal() : super.internal();

  // await db.execute(
  //   "CREATE TABLE (SM_ID INTEGER PRIMARY KEY AUTOINCREMENT, SM_DATE_TIME DATE,SM_TYPE VARCHAR(10),SM_NOTE VARCHAR(255) DEFAULT('NULL'));"
  //   );
  // await db.execute(
  //   "CREATE TABLE STORE_MOVEMENT_SELLS(SMS_ID INTEGER PRIMARY KEY, SM_ID INTEGER,C_ID INTEGER,FOREIGN KEY (C_ID) REFERENCES CUSTOMERS(C_ID),FOREIGN KEY (SM_ID) REFERENCES STORE_MOVEMENT(SM_ID));"
  //   );
  // await db.execute(
  //   "CREATE TABLE SELL_DETAILS(SM_ID INTEGER ,CAT_COUNT NUMBER,UN_ID INTEGER ,CAT_ID INTEGER ,CAN_UN_PRICE NUMBER ,FOREIGN KEY (CAT_ID) REFERENCES Accounts(CAT_ID),FOREIGN KEY (UN_ID) REFERENCES UNITS(UN_ID),FOREIGN KEY (SM_ID) REFERENCES STORE_MOVEMENT(SM_ID));"
  //   );
  Future<int> createNew(String tableName, Map<String,dynamic> items) async {
    try {
      Get.defaultDialog(
        onWillPop: () async => false,
        title: "pleaseWait".tr(),
        titleStyle: const TextStyle(fontSize: 18),
        content: const Center(child: CircularProgressIndicator()),
      );
      if (StaticValue.systemType == 1) {
        MysqlUtils db = DbHelper.db;
        int id = await db.insert(
          table: tableName,
          insertData: items,
        );
        Get.back();
        return id;
      } else {
        Database db = await createDatabase();
        int id = await db.insert(tableName, items);
        Get.back();
        return id;
      }
    } catch (e) {
      debugPrint("error $e");
      Get.back();
      snakbarDialog(title: "errorTitle".tr(), content: e.toString(), durationSecound: 10);
      return 0;
    }
  }
  Future<int> createMulti<T>(String tableName, List<Map<String,dynamic>> items) async {
    try {
      Get.defaultDialog(
        onWillPop: () async => false,
        title: "pleaseWait".tr(),
        titleStyle: const TextStyle(fontSize: 18),
        content: const Center(child: CircularProgressIndicator()),
      );
      if (StaticValue.systemType == 1) {
        MysqlUtils db = DbHelper.db;
        await db.insertAll(
          table: tableName,
          insertData: items,
        );
        Get.back();
        return 1;
      } else {
        Database db = await createDatabase();
        for (var i = 0; i < items.length; i++) {
          await db.insert(tableName, items[i]);
        }
        Get.back();
        return 1;
      }
    } catch (e) {
      debugPrint("error $e");
      Get.back();
      snakbarDialog(title: "errorTitle".tr(), content: e.toString(), durationSecound: 10);
      return 0;
    }
  }

  Future<int> update({required String tableName, required String primaryKey,
      required dynamic primaryKeyValue, required Map<String,dynamic> items,bool withMassage = true}) async {
    try {
      if(withMassage) {
        Get.defaultDialog(
        onWillPop: () async => false,
        title: "pleaseWait".tr(),
        titleStyle: const TextStyle(fontSize: 18),
        content: const Center(child: CircularProgressIndicator()),
      );
      }
      if (StaticValue.systemType == 1) {
        MysqlUtils db = DbHelper.db;
        await db.update(
            table: tableName,
            updateData: items,
            where: {primaryKey: primaryKeyValue});
      if(withMassage) {
        Get.back();
      }
        return 1;
      } else {
        Database db = await createDatabase();
      if(withMassage) {
        Get.back();
      }
        return await db.update(
          tableName,
          items,
          where: "$primaryKey = $primaryKeyValue",
        );
      }
    } catch (e) {
      debugPrint("error $e");
      if(withMassage) {
        Get.back();
      }
      snakbarDialog(title: "errorTitle".tr(), content: e.toString(), durationSecound: 10);
      return 0;
    }
  }
  Future<int> delete({required String tableName, required String where}) async {
    try {
      Get.defaultDialog(
        onWillPop: () async => false,
        title: "pleaseWait".tr(),
        titleStyle: const TextStyle(fontSize: 18),
        content: const Center(child: CircularProgressIndicator()),
      );
      if (StaticValue.systemType == 1) {
        MysqlUtils db = DbHelper.db;
        await db.delete(
            table: tableName,
            where: where);
        Get.back();
        return 1;
      } else {
        Database db = await createDatabase();
        Get.back();
        return await db.delete(
          tableName,
          where: where,
        );
      }
    } catch (e) {
      debugPrint("error $e");
      Get.back();
      snakbarDialog(title: "errorTitle".tr(), content: e.toString(), durationSecound: 10);
      return 0;
    }
  }

  Future<int> updateOrInsert({required String tableName, required String primaryKey,
      required dynamic primaryKeyValue, required Map<String,dynamic> items}) async {
    try {
      Get.defaultDialog(
        onWillPop: () async => false,
        title: "pleaseWait".tr(),
        titleStyle: const TextStyle(fontSize: 18),
        content: const Center(child: CircularProgressIndicator()),
      );
      if (StaticValue.systemType == 1) {
        MysqlUtils db = DbHelper.db;
        int count = await db.update(
            table: tableName,
            updateData: items,
            where: {primaryKey: primaryKeyValue});
        if(count > 0) {
          return 1;
        }
        await db.insert(
          table: tableName,
          insertData: items.remove(primaryKey),
        );
        Get.back();
        return 1;
      } else {
        Database db = await createDatabase();
        int count = await db.update(
          tableName,
          items,
          where: "$primaryKey = $primaryKeyValue",
        );
        if(count > 0) {
          return 1;
        }
        await db.insert(
           tableName,
           items.remove(primaryKey),
        );
        Get.back();
        return 1;
      }
    } catch (e) {
      debugPrint("error $e");
      Get.back();
      snakbarDialog(title: "errorTitle".tr(), content: e.toString(), durationSecound: 10);
      return 0;
    }
  }

  Future<dynamic> getById<T>(String query) async {
    try {
      if (StaticValue.systemType == 1) {
        MysqlUtils db = DbHelper.db;
        ResultFormat row = await db.query(query);
        if (row.rows.isEmpty) {
          return "NO ITEM";
        }
        dynamic objetc = T;
        return objetc.fromMap(row.rows[0]);
      } else {
        Database db = await createDatabase();
        List row = await db.rawQuery(query);
        if (row.isEmpty) {
          return "NO ITEM";
        }
        dynamic objetc = T;
        return objetc.fromMap(row[0]);
      }
    } catch (e) {
      debugPrint("error $e");
      return null;
    }
  }
    Future<dynamic> getByIdAsMap(String query) async {
    try {
      if (StaticValue.systemType == 1) {
        MysqlUtils db = DbHelper.db;
        ResultFormat rows = await db.query(query);
        if (rows.rows.isEmpty) {
          return "NO ITEM";
        }
        return rows.rows.firstOrNull;
      } else {
        Database db = await createDatabase();
        List rows = await db.rawQuery(query);
        if (rows.isEmpty) {
          return "NO ITEM";
        }
        return rows.firstOrNull;
      }
    } catch (e) {
      debugPrint("error $e");
      return null;
    }
  }

  Future<List<dynamic>?> getAll(String query,dynamic object) async {
    try {
      List<dynamic> result = [];
      if (StaticValue.systemType == 1) {
        MysqlUtils db = DbHelper.db;
        ResultFormat rows = await db.query(query);
        if (rows.rows.isEmpty) {
          return [];
        }
        for (var i = 0; i < rows.rows.length; i++) {
          result.add(object.fromMap(rows.rows[i]));
        }
        return result;
      } else {
        Database db = await createDatabase();
        List rows = await db.rawQuery(query);
        if (rows.isEmpty) {
          return [];
        }
        for (var i = 0; i < rows.length; i++) {
          result.add(object.fromMap(rows[i]));
        }
        return result;
      }
    } catch (e) {
      debugPrint("error $e");
      return null;
    }
  }
  Future<List<dynamic>?> getAllAsMap(String query) async {
    try {
      if (StaticValue.systemType == 1) {
        MysqlUtils db = DbHelper.db;
        ResultFormat rows = await db.query(query);
        return rows.rows;
      } else {
        Database db = await createDatabase();
        List rows = await db.rawQuery(query);
        return rows;
      }
    } catch (e) {
      debugPrint("error $e");
      return null;
    }
  }
}
