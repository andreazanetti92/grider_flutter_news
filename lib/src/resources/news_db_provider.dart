import 'package:grider_flutter_news/src/Models/top_ids_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import '../Models/item_model.dart';
import 'repository.dart' show Source, Cache;

class NewsDbProvider implements Source, Cache {
  // late Database db;

  // NewsDbProvider() {
  //   init();
  // }

  // init() async {
  //   Directory documentsDirectory = await getApplicationDocumentsDirectory();
  //   final path = join(documentsDirectory.path, "db_news.db");

  //   // create or open the db
  //   db = await openDatabase(
  //     path,
  //     version: 2,
  //     onCreate: (Database newDb, int version) async {
  //       await createTables(newDb);
  //     },
  //   );
  // }

  static Future<Database> init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "db_news.db");

    // create or open the db
    return await openDatabase(
      path,
      version: 2,
      onCreate: (Database newDb, int version) async {
        await createTables(newDb);
      },
    );
  }

  static Future<void> createTables(Database database) async {
    await database.execute("""
      CREATE TABLE IF NOT EXISTS top_ids
      (
        id INTEGER PRIMARY KEY,
        datetimeCreated INTEGER,
        listIds BLOB
      );
    """);

    await database.execute("""
      CREATE TABLE IF NOT EXISTS items
      (
        id INTEGER PRIMARY KEY,
        deleted INTEGER CHECK(deleted = 0 OR deleted = 1),
        type TEXT,
        by TEXT,
        time INTEGER,
        text TEXT,
        dead INTEGER CHECK(deleted = 0 OR deleted = 1),
        parent INTEGER,
        kids BLOB,
        url TEXT,
        score INTEGER,
        title TEXT,
        descendants INTEGER
      );
    """);
  }

  @override
  Future<ItemModel?> fetchItem(int? id) async {
    final db = await NewsDbProvider.init();
    final maps = await db.query('items',
        where: "id = ?", // avoid sql injection
        whereArgs: [id],
        columns: null);

    if (maps.isNotEmpty) {
      return ItemModel.fromDB(maps.first);
    }
    return null;
  }

  @override
  Future<int> addItem(ItemModel? item) async {
    final db = await NewsDbProvider.init();

    // Another way to avoid to try to insert the same item
    // final fetchedItem = await fetchItem(item!.id);

    // if (fetchedItem != null) {
    //   return 1;
    // }

    return db.insert(
      'items',
      item!.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  @override
  Future<TopIdsModel?> fetchTopIDs() async {
    final db = await NewsDbProvider.init();
    final maps = await db.query(
      "top_ids",
      columns: null,
      orderBy: 'datetimeCreated DESC',
      limit: 1,
    );

    if (maps.isNotEmpty) {
      final model = TopIdsModel.fromDB(maps.first);
      return model;
    }

    return null;
  }

  @override
  Future<int> addTopIds(TopIdsModel item) async {
    final db = await NewsDbProvider.init();
    return db.insert(
      "top_ids",
      item.toMap(),
    );
  }

  @override
  Future<int> clear() async {
    final db = await NewsDbProvider.init();
    int rowsDeletedItems = await db.delete('items');
    int rowsDeletedTopIds = await db.delete('top_ids');
    return rowsDeletedTopIds + rowsDeletedItems;
  }
}

final newsDbProvider =
    NewsDbProvider(); // for using single instance and avoid opening multiple db connection

  // static const _dbName = "news.db";
  // static const _dbVersion = 1;
  // static const _tableNameStories = "stories";
  // static const _tableNameTopIds = "top_ids";

  // NewsDbProvider();

  // NewsDbProvider._privateContructor();
  // static final NewsDbProvider instance = NewsDbProvider._privateContructor();

  // static Database? _db;

  // Future<Database> get database async => _db ??= await _init();

  // Future<Database> _init() async {
  //   Directory docsDir = await getApplicationDocumentsDirectory();
  //   String path = join(docsDir.path, _dbName);
  //   print("################## HELLO _INIT ##################");
  //   return await openDatabase(
  //     path,
  //     version: _dbVersion,
  //     onCreate: (db, version) async {
  //       await db.execute("""
  //             CREATE TABLE IF NOT EXISTS $_tableNameTopIds
  //             (
  //               id INTEGER PRIMARY KEY,
  //               datetimeCreated INTEGER,
  //               listIds BLOB
  //             );

  //             // CREATE TABLE IF NOT EXISTS $_tableNameStories
  //             // (
  //             //   id INTEGER PRIMARY KEY,
  //             //   deleted INTEGER CHECK(deleted = 0 OR deleted = 1),
  //             //   type TEXT,
  //             //   by TEXT,
  //             //   time INTEGER,
  //             //   text TEXT,
  //             //   dead INTEGER CHECK(deleted = 0 OR deleted = 1),
  //             //   parent INTEGER,
  //             //   kids BLOB,
  //             //   url TEXT,
  //             //   score INTEGER,
  //             //   title TEXT,
  //             //   descendants INTEGER
  //             // );
  //             // """);
  //     },
  //   );
  // }

  // // Future _onCreate(Database db, int version) async {
  // //   print("################## HELLO _ONCREATE ##################");
  // //   return await db.execute("""
  // //             CREATE TABLE IF NOT EXISTS $_tableNameTopIds
  // //             (
  // //               id INTEGER PRIMARY KEY,
  // //               datetimeCreated INTEGER,
  // //               listIds BLOB
  // //             );

  // //             CREATE TABLE IF NOT EXISTS $_tableNameStories
  // //             (
  // //               id INTEGER PRIMARY KEY,
  // //               deleted INTEGER CHECK(deleted = 0 OR deleted = 1),
  // //               type TEXT,
  // //               by TEXT,
  // //               time INTEGER,
  // //               text TEXT,
  // //               dead INTEGER CHECK(deleted = 0 OR deleted = 1),
  // //               parent INTEGER,
  // //               kids BLOB,
  // //               url TEXT,
  // //               score INTEGER,
  // //               title TEXT,
  // //               descendants INTEGER
  // //             );
  // //             """);
  // // }

  // @override
  // Future<ItemModel?> fetchItem(int id) async {
  //   Database db = await instance.database;
  //   final maps = await db.query(
  //     _tableNameStories,
  //     columns: null,
  //     where: "id = ?",
  //     whereArgs: [id],
  //   );

  //   if (maps.isNotEmpty) {
  //     ItemModel.fromDB(maps.first);
  //   }

  //   return null;
  // }

  // @override
  // Future<List<int>?> fetchTopIDs() async {
  //   Database db = await instance.database;
  //   print("################## HELLO WORLD ##################");
  //   print(db);
  //   final maps = await db.query(
  //     _tableNameTopIds,
  //     columns: null,
  //     orderBy: 'datetime DESC',
  //     limit: 1,
  //   );

  //   if (maps.isNotEmpty) {
  //     final model = TopIdsModel.fromDB(maps.first);
  //     return model.topIds;
  //   }

  //   return null;
  // }

  // @override
  // Future<int> addTopIds(TopIdsModel item) async {
  //   Database db = await instance.database;
  //   return db.insert(
  //     _tableNameTopIds,
  //     item.toMap(),
  //   );
  // }

  // @override
  // Future<int> addItem(ItemModel? item) async {
  //   Database db = await instance.database;
  //   return db.insert(
  //     _tableNameStories,
  //     item!.toMap(),
  //   );
  // }
// }

// final newsDbProvider = NewsDbProvider();
