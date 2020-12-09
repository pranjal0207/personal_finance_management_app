import 'transaction.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseProvider {
  static const String TABLE = "personrecords";
  static const String COLUMN_ID = "id";
  static const String COLUMN_NAME = "name";
  static const String COLUMN_AMOUNT = "amount";
  static const String COLUMN_DATE = "date";

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  Database _database;

  Future<Database> get database async {
    print("database getter called");

    if (_database != null) {
      return _database;
    }

    _database = await createDatabase();

    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'userDB.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        print("Creating Transaction table");

        await database.execute(
          "CREATE TABLE $TABLE ("
          "$COLUMN_ID INTEGER PRIMARY KEY,"
          "$COLUMN_NAME TEXT,"
          "$COLUMN_AMOUNT INTEGER,"
          "$COLUMN_DATE TEXT"
          ")",
        );
      },
    );
  }

  Future<List<OTransaction>> gettransactions() async {
    final db = await database;

    var trans = await db.query(TABLE, columns: [COLUMN_ID ,COLUMN_NAME, COLUMN_AMOUNT, COLUMN_DATE], orderBy : "date DESC");

    List<OTransaction> transactionList = List<OTransaction>();

    trans.forEach((currenttrans) {
      OTransaction trans = OTransaction.fromMap(currenttrans);
      transactionList.add(trans);
    });
    return transactionList;
  }

  Future<List<OTransaction>> getfilters(int f, int l, String d) async {
    final db = await database;
    if (d == null){
      d = " ";
    }

    print (d);    
    String date = "%"+d+"%";
    var trans = await db.query(TABLE, columns: [COLUMN_ID ,COLUMN_NAME, COLUMN_AMOUNT, COLUMN_DATE], where: "$COLUMN_AMOUNT between $f and $l and $COLUMN_DATE LIKE '$date'");

    List<OTransaction> transactionList = List<OTransaction>();

    trans.forEach((currenttrans) {
      OTransaction trans = OTransaction.fromMap(currenttrans);
      transactionList.add(trans);
    });
    return transactionList;
  }

  Future<OTransaction> insert(OTransaction trans) async {
    final db = await database;
    trans.id = await db.insert(TABLE, trans.toMap());
    return trans;
  }

  Future<int> delete(int id) async {
    final db = await database;

    //db.rawQuery("DELETE FROM $TABLE WHERE $COLUMN_ID = $id");
    return await db.delete(
      TABLE,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> update(OTransaction trans) async {
    final db = await database;
    return await db.update(
      TABLE,
      trans.toMap(),
      where: "id = ?",
      whereArgs: [trans.id],
    );
  }

  Future calculateTotal() async {
    final db  = await database;
    var result = await db.rawQuery("SELECT SUM($COLUMN_AMOUNT) as Total FROM $TABLE");
    int value = result[0]["Total"]; // value = 220

    print ("db");
    print ("sum = ");
    print (value);
    return value;
  }
}