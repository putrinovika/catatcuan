import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:mycashbook/models/user.dart';
import 'package:mycashbook/models/finance.dart';
import 'package:mycashbook/constant/finance_type_constants.dart';

class DbHelper {
  static DbHelper? _dbHelper;
  static Database? _database;
  DbHelper._createObject();

  Future<Database> initDb() async {
    //untuk menentukan nama database dan lokasi yg dibuat
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}finplan.db';

    //create, read databases
    var itemDatabase = openDatabase(path, version: 1, onCreate: _createDb);

    return itemDatabase;
  }

  void _createDb(Database db, int version) async {
    await db.execute('''
    CREATE TABLE user (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT,
    password TEXT
  )''');

    await db.execute('''
    CREATE TABLE finance (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date TEXT,
    amount TEXT,
    description TEXT,
    type TEXT
  )''');

    // insert to table user
    await db
        .insert("user", {'email': 'user@mail.com', 'password': 'password'});
  }

  //* User
  //create databases user
  Future<int> insertUser(User object) async {
    Database db = await this.database;
    int count = await db.insert('user', object.toMap());
    return count;
  }

  // create login user return true or false
  Future<bool> loginUser(String email, String password) async {
    Database db = await this.database;

    List<Map<String, dynamic>> result = await db.query('user',
        where: 'email = ? AND password = ?', whereArgs: [email, password]);
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  // create change password
  Future<int> changePassword(String email, String password) async {
    Database db = await this.database;

    int result = await db.rawUpdate(
        'UPDATE user SET password = ? WHERE email = ?', [password, email]);
    return result;
  }

  // get user login data
  Future<List<User>> getUserLogin(String email) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result =
        await db.query('user', where: 'email = ?', whereArgs: [email]);

    List<User> users = [];
    for (var i = 0; i < result.length; i++) {
      users.add(User.fromMap(result[i]));
    }
    return users;
  }

  // Add this method to DbHelper
  Future<User?> getUserByEmail(String email) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result =
        await db.query('user', where: 'email = ?', whereArgs: [email]);

    if (result.isNotEmpty) {
      return User.fromMap(result[0]);
    } else {
      return null;
    }
  }

  //* Finance
  //create databases finance
  Future<int> insertFinance(Finance object) async {
    Database db = await this.database;
    int count = await db.insert('finance', object.toMap());
    return count;
  }

  Future<int> insertIncome(
      String date, String amount, String description) async {
    Database db = await this.database;

    // Create a Finance object with the income data
    Finance incomeData = Finance(date, amount, description, incomeType);
    print(incomeData.toMap());
    int count = await db.insert('finance', incomeData.toMap());
    return count;
  }

  Future<int> insertExpense(
      String date, String amount, String description) async {
    Database db = await this.database;

    // Create a Finance object with the expense data
    Finance expenseData = Finance(date, amount, description, expenseType);

    int count = await db.insert('finance', expenseData.toMap());
    return count;
  }

// get total from income
  Future<int> getTotalIncome() async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT SUM(amount) as total FROM finance where type = "income"');

    if (result.isNotEmpty && result[0]['total'] != null) {
      int total = result[0]['total'];
      return total;
    } else {
      // Handle the case where there is no data or 'total' is null
      return 0; // You can return a default value or an appropriate error value
    }
  }

  // get total from expense
  Future<int> getTotalExpense() async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM finance where type = "expense"',
    );

    if (result.isNotEmpty && result[0]['total'] != null) {
      int total = result[0]['total'];
      return total;
    } else {
      // Handle the case where there is no data or 'total' is null
      return 0; // You can return a default value or an appropriate error value
    }
  }

  // get data from finance
  Future<List<Finance>> getFinance() async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db.query('finance');

    List<Finance> finance = [];
    for (var i = 0; i < result.length; i++) {
      finance.add(Finance.fromMap(result[i]));
    }
    return finance;
  }

  // create data finance
  Future<int> insertDataFinance(Finance object) async {
    Database db = await this.database;
    int count = await db.insert('finance', object.toMap());
    return count;
  }

  // delete data finance
  Future<int> deleteDataFinance(int id) async {
    Database db = await this.database;
    int count = await db.delete('finance', where: 'id=?', whereArgs: [id]);
    return count;
  }

  factory DbHelper() {
    if (_dbHelper == null) {
      _dbHelper = DbHelper._createObject();
    }
    return _dbHelper!;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database!;
  }
}
