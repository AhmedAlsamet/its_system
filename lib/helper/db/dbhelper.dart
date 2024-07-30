import 'package:mysql_utils/mysql_utils.dart';
import 'package:its_system/helper/db/dbhelper2.dart';

class DbHelper extends DbHelper2 {
  static final DbHelper _instance = DbHelper.internal();
  factory DbHelper() => _instance;
  DbHelper.internal():super.internal();

// connection configration
  static MysqlUtils db = MysqlUtils(
    settings: {
      // 'host': "51.20.87.43",
      'host': "192.168.0.200",//"srv1049.hstgr.io",//"193.203.168.54",
      'port': 3306,
      'user': "administrator",//"u490706815_admin",//"administrator",//"u689838604_smartmate",//"u490706815_administrator",
      // 'password': 'mEro@mriam#medo1',
      'password': "mero@mriam#medo",//"c=nil4ZvuY2",//"mero@mriam#medo",//"!2ZsB]M?[p",//"a;SQ2MPb#3y2",
      'db': 'its_db',//'u490706815_its_db',//'its_db',
      'maxConnections': 10,
      // 'secure': false,
      'prefix': '',
      'pool': true,
      'collation': 'utf8mb4_general_ci',
      'sqlEscape': true,
    },
  );
//  static initDb(){
//   db = MysqlUtils(
//   settings: {
//     'citizen': StaticValue.serverName!.toUpperCase(),
//     'port': 3306,
//     'user': 'administrator',
//     'password': 'mero@mriam#medo',
//     'db': 'restaurant',
//     'maxConnections': 10,
//     // 'secure': false,
//     'prefix': '',
//     'pool': true,
//     'collation': 'utf8mb4_general_ci',
//     'sqlEscape':true,
//   },
// );
//  }
  closeDatabase() async {
    await db.close();
  }

  flushcitizen() async {
    try {
      await db.query("FLUSH CITIZENS;");
      print("DONE FLUSH");
    } catch (e) {
      print(e);
    }
  }

  /*
     SELECT table_schema, table_name, column_name, ordinal_position, data_type, 
       numeric_precision, column_type, column_default, is_nullable, column_comment 
  FROM information_schema.columns 
  WHERE (table_schema='restaurant' and table_name = 'employees')
  order by ordinal_position;
     */

    // this function for backup
  Future<String> getTableColumnWithPutSearchValue(String tableName,
      String tableShort,
      List<String> expectedColumns,
      List<String> additionalColumns,
      String searchValue) async{
    // if(StaticValue.systemType == 1){
      return await getTableColumnWithPutSearchValueForWindows(tableName, tableShort, expectedColumns,additionalColumns, searchValue);
//     }
// return await getTableColumnWithPutSearchValueForAndroid(tableName, tableShort, expectedColumns, searchValue);
   }
   Future<String> getTableColumnWithPutSearchValueForWindows(
      String tableName,
      String tableShort,
      List<String> expectedColumns,
      List<String> additionalColumns,
      String searchValue) async {
    // Database db = await createDatabase();
    String result = "(";
    ResultFormat maps = await db.query("SELECT column_name as name "
        "  FROM information_schema.columns "
        "  WHERE (table_schema='its_db' and table_name = '$tableName')"
        "  order by ordinal_position;");
    for (int i = 0; i < maps.rows.length; i++) {
      if (!expectedColumns.contains(maps.rows[i]["name"])) {
        if (maps.rows.length - 1 == i) {
          result +=
              " $tableShort.${maps.rows[i]["name"]} LIKE '%$searchValue%' ";
        } else {
          result +=
              " $tableShort.${maps.rows[i]["name"]} LIKE '%$searchValue%' OR";
        }
      }
    }
    if(result.endsWith(" OR")){
      result = result.substring(0,result.length-3);
    }
    if(additionalColumns.isNotEmpty){
      result += " OR ";
    }
    for (int i = 0; i < additionalColumns.length; i++) {
        if (additionalColumns.length - 1 == i) {
          result += " ${additionalColumns[i]} LIKE '%$searchValue%' ";
        } else {
          result += " ${additionalColumns[i]} LIKE '%$searchValue%' OR";
        }
    }
    result += ")";

    if (result.trim() == "()") {
      result = "";
    }
    return result;
  }
   Future<String> getTableColumnAsSelectStatement(
      String tableName,
      String tableShort,
      List<String> expectedColumns,
      List<String> additionalColumns) async {
    // Database db = await createDatabase();
    String result = "";
    ResultFormat maps = await db.query("SELECT column_name as name "
        "  FROM information_schema.columns "
        "  WHERE (table_schema='its_db' and table_name = '$tableName')"
        "  order by ordinal_position;");
    for (int i = 0; i < maps.rows.length; i++) {
      if (!expectedColumns.contains(maps.rows[i]["name"])) {
        if (maps.rows.length - 1 == i) {
          result +=
              " $tableShort.${maps.rows[i]["name"]} AS ${tableShort}_${maps.rows[i]["name"]} ";
        } else {
          result +=
              " $tableShort.${maps.rows[i]["name"]} AS ${tableShort}_${maps.rows[i]["name"]} ,";
        }
      }
    }
    if(result.endsWith(" ,")){
      result = result.substring(0,result.length-2);
    }
    if(additionalColumns.isNotEmpty){
      result += " , ";
    }
    for (int i = 0; i < additionalColumns.length; i++) {
        if (additionalColumns.length - 1 == i) {
            " ${additionalColumns[i]} AS ${tableShort}_${maps.rows[i]["name"]} ";
        } else {
            " ${additionalColumns[i]} AS ${tableShort}_${maps.rows[i]["name"]} ,";
        }
    }

    if (result.trim() == "()") {
      result = "";
    }
    return result;
  }
}
