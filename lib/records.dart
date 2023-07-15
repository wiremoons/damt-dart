// Copyright 2023 Simon Rowe (simon@wiremoons.com).
// https://github.com/wiremoons/damt
//
// Disable some specific linting rules in this file only
// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_string_interpolations

import 'dart:io';

class Damt {
  String dbFileName;
  // final String dbFullPath;
  // final String dbSize?;
  // final String dbLastAccess?;
  // final String dbSqliteVersion?;
  // var String dbRecordCount?;
  // var String dbNewestAcronym?;

  // Initial constructor - sets dbFileName.
  Damt() : dbFileName = "";

  // [_dbName] used to ensure only one database instance of this class can exist.
  // The [_dbName] is set in the [create()] method below.
  // static late final String _dbName;

  // Private constructor.
  // Use class with: Damt damt = await Damt.create();
  // Damt._internal(this.dbFileName);

  // Contructor public factory.
  // Actual class 'factory' not used as unable to call as an async method, access attributes and other
  // limitations of 'factory' use in Dart. Also need to make this 'static' but then I can't access
  // the 'instance member' either... Dart is very frustrating and confussing...
  create() async {
    // check the [create()] method has not already be run
    // if (_dbName.isNotEmpty) {
    //   return;
    // }
    // find a file to be used and return a new class object if found, else throw an error.
    String dbPath = await _findDbPath();
    stdout.writeln("DEBUG: using DB path: '${dbPath}'");
    if (dbPath.isEmpty) throw "ERROR: No SQlite database file available";
    // _dbName = dbPath.toString();
    dbFileName = dbPath;
  }

  /////////////////////////////////////////////////////////////////////////////
  //    PRIVATE METHODS BELOW
  /////////////////////////////////////////////////////////////////////////////

  // Check for a file to be used for the SQlite database.
  Future<String> _findDbPath() async {
    String dbPath = "";
    bool exists = false;
    (dbPath, exists) = await _envHasDb();
    if (exists) return dbPath;
    (dbPath, exists) = await _localHasDb();
    if (exists) return dbPath;
    return "";
  }

  Future<(String, bool)> _envHasDb() async {
    final envDb = Platform.environment["ACRODB"];
    stdout.writeln("DEBUG: envDB is: '${envDb}'");
    if (envDb == null || envDb.isEmpty) return ("", false);
    if (await File(envDb).exists()) {
      stdout.writeln("DEBUG: ${envDb} exists!");
      return (envDb, true);
    }
    return ("", false);
  }

  Future<(String, bool)> _localHasDb() async {
    // final envDb = Platform.environment["ACRODB"];
    // stdout.writeln("envDB is: '${envDb}'");
    // if (envDb == null || envDb.isEmpty) return ("", false);
    // if (await Directory(envDb).exists()) {
    //   return (envDb, true);
    // }
    stdout.writeln("DEBUG: Should not run...");
    return ("", false);
  }
}
