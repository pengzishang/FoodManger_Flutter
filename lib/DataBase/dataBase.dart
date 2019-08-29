import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as Path;
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

typedef bool FilterBlock(Map item);

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

  Future<Database> insertList(FoodDataModel model) async {
    final db = await _dbFile;

    db.transaction((trx) {
      db.insert("FoodDateBase", {
        "duration": model.duration,
        "initDate": model.initDate.millisecondsSinceEpoch,
        "expireDate": model.expireDate.millisecondsSinceEpoch,
        "name": model.name,
        "productDate": (model.productDate == null)
            ? null
            : model.productDate.millisecondsSinceEpoch
      });
    });

    return db;
  }

  Future<List<FoodDataModel>> getAllData() async {
    final db = await _dbFile;
    List list = await db.query("FoodDateBase", orderBy: "expireDate", columns: [
      "foodId",
      "expireDate",
      "initDate",
      "name",
      "position",
      "duration",
      "productDate"
    ]);
    return list.map((item) {
      return FoodDataModel(item["initDate"],
          foodId: item["foodId"],
          expireDate: item["expireDate"],
          name: item["name"],
          position: item["position"],
          duration: item["duration"],
          productDate: item["productDate"]);
    }).toList();
  }

  Future<List<FoodDataModel>> getData(int from, int to) async {
    return this.filter((item) {
      if (item["expireDate"] > from && item["expireDate"] < to) {
        return true;
      }
      return false;
    });
  }

  Future<List<FoodDataModel>> getHalfData() async {
    return this.filter((item) {
      if (item["expireDate"] - item["initDate"] < item["duration"] / 2) {
        return true;
      }
      return false;
    });
  }

  Future<List<FoodDataModel>> filter(FilterBlock by) async {
    final db = await _dbFile;
    List list = await db.query("FoodDateBase", orderBy: "expireDate", columns: [
      "foodId",
      "expireDate",
      "initDate",
      "name",
      "position",
      "duration",
      "productDate"
    ]);

    List filter = list.where(by);
    return filter.map((item) {
      return FoodDataModel(item["initDate"],
          foodId: item["foodId"],
          expireDate: item["expireDate"],
          name: item["name"],
          position: item["position"],
          duration: item["duration"],
          productDate: item["productDate"]);
    }).toList();
  }

  //最近三天 //全部 //一个月内 //过了一半保质期
}

class FoodDataModel {
  int foodId;
  DateTime expireDate;
  DateTime initDate;
  DateTime productDate;
  String name;
  String position;
  double duration; //剩余保质期
  double freshTimeDuration; //标明保质期
  bool isValid;

  FoodDataModel(double initDate,
      {this.position,
      this.foodId,
      this.name,
      double expireDate,
      double productDate,
      this.duration,
      this.freshTimeDuration})
      : assert(duration > 0) {
    //三种方式
    //duration
    //expireDate
    //productDate,freshTimeDuration
    this.initDate = DateTime.fromMillisecondsSinceEpoch(initDate.toInt());

    if (name == null) {
      this.name = "食物";
    }
    if (duration == null) {
      if (expireDate != null) {
        //expireDate
        this.duration = expireDate - this.initDate.millisecondsSinceEpoch;
        isValid = true;
      } else {
        if (productDate != null && freshTimeDuration != null) {
          this.duration = productDate +
              freshTimeDuration -
              this.initDate.millisecondsSinceEpoch;
          this.expireDate = DateTime.fromMillisecondsSinceEpoch(
              (this.initDate.millisecondsSinceEpoch + this.duration).toInt());
          isValid = true;
          //productDate,freshTimeDuration
        } else {
          isValid = false;
          print("object数据错误");
        }
      }
    } else {
      this.duration = duration;
      this.expireDate = DateTime.fromMillisecondsSinceEpoch(
          (this.initDate.millisecondsSinceEpoch + duration).toInt());
      isValid = true;
      //duration
    }
  }
}
