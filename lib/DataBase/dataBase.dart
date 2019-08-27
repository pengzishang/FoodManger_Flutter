import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as Path;
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class DBSharedInstance {
  // 单例公开访问点
  factory DBSharedInstance() => _sharedInstance();

  // 静态私有成员，没有初始化
  static DBSharedInstance _instance;

  // 私有构造函数
  DBSharedInstance._() {
    // 具体初始化代码
  }

  // 静态、同步、私有访问点
  static DBSharedInstance _sharedInstance() {
    if (_instance == null) {
      _instance = DBSharedInstance._();
    }
    return _instance;
  }

  Future<String> get _dbPath async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    print(documentsDirectory.absolute);
    String path = Path.join(documentsDirectory.path, "db.db");
    return path;
  }

  Future<Database> get _dbFile async {
    final path = await _dbPath;
    if (File(path).existsSync()) {
      Database database = await openDatabase(path, version: 2);
      return database;
    } else {
      Database database = await openDatabase(path, version: 2,
          onCreate: (Database db, int version) async {
        await db.execute(
            "CREATE TABLE IF NOT EXISTS \"FoodDateBase\" (\"foodId\" integer PRIMARY KEY AUTOINCREMENT NOT NULL,\"expireDate\" double(128),\"initDate\" double(128) NOT NULL,\"name\" char(128),\"position\" char(128),\"duration\" double(128) NOT NULL,\"productDate\" char(128));");
      });
      return database;
    }
  }

  Future<Database> insertList() async {
    final db = await _dbFile;
    var nowTime = DateTime.now().millisecondsSinceEpoch.toString();

    // db.transaction((trx) {
    //   db.insert("FoodDateBase", {
    //     "duration":duration,
    //     "initDate":nowTime,

    //   });

    // });

    return db;
  }
}

class FoodDateModel {
  int foodId;
  DateTime expireDate;
  DateTime initDate;
  DateTime productDate;
  String name;
  String position;
  int duration;
  int freshTimeDuration;
  bool isValid;

  FoodDateModel(int initDate,
      {this.position,
      this.foodId,
      this.name,
      int expireDate,
      int productDate,
      this.duration,
      this.freshTimeDuration})
      : assert(duration > 0) {
    this.initDate = DateTime.fromMillisecondsSinceEpoch(initDate);
    //三种方式
    //duration
    //expireDate
    //productDate,freshTimeDuration

    if (duration == null) {
      if (expireDate != null) {
        //expireDate
        this.duration = expireDate - initDate;
        isValid = true;
      } else {
        if (productDate != null && freshTimeDuration != null) {
          this.duration = productDate + freshTimeDuration - initDate;
          this.expireDate =
              DateTime.fromMillisecondsSinceEpoch(initDate + this.duration);
          isValid = true;
          //productDate,freshTimeDuration
        } else {
          isValid = false;
          print("object数据错误");
        }
      }
    } else {
      this.duration = duration;
      this.expireDate =
          DateTime.fromMillisecondsSinceEpoch(initDate + duration);
      isValid = true;
      //duration
    }
  }
}
