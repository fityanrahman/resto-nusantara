import 'package:sqflite/sqflite.dart';
import 'package:submission_resto/data/model/restaurant/restaurant_short_model.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();
  static const String _tblFavorites = 'favorites';

  /// Menyiapkan database
  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/restoapp.db',
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tblFavorites (
          id TEXT PRIMARY KEY,
          name TEXT,
          description TEXT,
          pictureId TEXT,
          city TEXT,
          rating REAL
          )
          ''');
      },
      version: 1,
    );

    return db;
  }

  Future<Database?> get database async {
    if (_database == null) {
      _database = await _initializeDb();
    }

    return _database;
  }

  /// Menyimpan data
  Future<void> insertFavorite(RestaurantsShort resto) async {
    final db = await database;
    await db!.insert(_tblFavorites, resto.toJson());
  }

  /// Mendapatkan seluruh data favorites yang tersimpan
  Future<List<RestaurantsShort>> getFavorites() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(_tblFavorites);

    return results.map((res) => RestaurantsShort.fromJson(res)).toList();
  }

  /// Mencari favorite yang disimpan berdasarkan id
  Future<Map> getFavoriteById(String id) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db!.query(
      _tblFavorites,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  /// Menghapus data favorite berdasarkan id
  Future<void> removeFavorite(String id) async {
    final db = await database;

    await db!.delete(
      _tblFavorites,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
