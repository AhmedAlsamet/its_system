import 'package:sqflite/sqflite.dart';

class DbHelper2 {
  static final DbHelper2 _instance = DbHelper2.internal();
  factory DbHelper2() => _instance;
  DbHelper2.internal();

  static Database? db;

   createDatabase() async {
    try {
    
    } catch (e) {
      return null!;
    }
  }

}
