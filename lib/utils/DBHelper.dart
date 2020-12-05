import 'transaction.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseProvider {
  static const String TABLE = "personrecords";
  static const String COLUMN_ID = "id";
  static const String COLUMN_NAME = "name";
  static const String COLUMN_AMOUNT = "amount";

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
          "$COLUMN_AMOUNT INTEGER"
          ")",
        );
      },
    );
  }

  Future<List<OTransaction>> gettransactions() async {
    final db = await database;

    var trans = await db.query(TABLE, columns: [COLUMN_ID ,COLUMN_NAME, COLUMN_AMOUNT]);

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
}