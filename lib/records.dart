// Copyright 2023 Simon Rowe (simon@wiremoons.com).
// https://github.com/wiremoons/damt
//
// Disable some specific linting rules in this file only
// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_string_interpolations

import 'dart:io';
import 'package:path/path.dart' as p;

// local source code imports
import 'package:damt/sys_utils.dart';

class Damt {
  String dbFullPath;
  String dbFileName;
  String? dbSize;
  String? dbLastAccess;
  // final String dbSqliteVersion?;
  // var String dbRecordCount?;
  // var String dbNewestAcronym?;

  // Initial constructor - sets [dbFileName] to an empty value.
  Damt()
      : dbFullPath = "",
        dbFileName = "";

  create() async {
    // check the [create()] method has not already be run
    if (dbFileName.isNotEmpty) {
      stdout.writeln("ERROR:  [!] 'Damt.create()' method already run.");
      return;
    }
    // find a database file to be used, else throw an error.
    String dbPath = "";
    bool exists = false;
    (dbPath, exists) = await _findDbPath();
    if (!exists) {
      stderr.writeln("ABORT: No SQlite database file available.");
      exit(1);
    }
    // Populate the Damt class fields with SQLite database info:
    dbFullPath = dbPath;
    dbFileName = dbPath;
    dbSize = await fileSizeAsString(dbFullPath, 2);
    dbLastAccess = await fileLastModified(dbFullPath);
  }

  /////////////////////////////////////////////////////////////////////////////
  //    PRIVATE METHODS BELOW
  /////////////////////////////////////////////////////////////////////////////

  // Check for a file to be used for the SQlite database.
  Future<(String, bool)> _findDbPath() async {
    String dbPath = "";
    bool exists = false;
    (dbPath, exists) = await _envHasDb();
    if (exists) return (dbPath, true);
    (dbPath, exists) = await _localHasDb();
    if (exists) return (dbPath, true);
    return ("", false);
  }

  Future<(String, bool)> _envHasDb() async {
    final envDb = Platform.environment["ACRODB"];
    if (envDb == null || envDb.isEmpty) return ("", false);
    if (await File(envDb).exists()) {
      return (envDb, true);
    }
    return ("", false);
  }

  Future<(String, bool)> _localHasDb() async {
    final fullAppPath = Platform.resolvedExecutable;
    // remove execuable name from fill path
    String onlyAppPath = "";
    bool exists = false;
    (onlyAppPath, exists) = await directoryNameOnly(fullAppPath);
    if (!exists) {
      return ("", false);
    }
    final localDb = p.join(onlyAppPath, "acronyms.db");
    if (await File(localDb).exists()) {
      return (localDb, true);
    }
    return ("", false);
  }
}
