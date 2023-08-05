// Copyright 2023 Simon Rowe (simon@wiremoons.com).
// https://github.com/wiremoons/damt
//
// Disable some specific linting rules in this file only
// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_string_interpolations

// LAST ACRONYM:
//     select acronym from acronyms order by rowid desc limit 1;

// SQLIte Version:
//     select sqlite_version();

// RECORD COUNT:
//     select count(*) from acronyms;

// LAST 5 NEW RECORDS:
//     "select rowid,ifnull(Acronym,''),ifnull(Definition,''),ifnull(Source,''),ifnull(Description,''),ifnull(Changed,'') from ACRONYMS Order by rowid DESC LIMIT 5;",

// SEARCH:
//       "select rowid,ifnull(Acronym,''),ifnull(Definition,''),ifnull(Source,''),ifnull(Description,''),ifnull(Changed,'') from ACRONYMS where Acronym like ? collate nocase order by Source;",

import 'dart:io';

import 'package:sqlite3/sqlite3.dart';
import 'package:intl/intl.dart';

void sqliteVersion() {
  print('Using sqlite3 ${sqlite3.version}');
}

class DbManage {
  static late final String dbPath;
  static late final Database db;

  DbManage(String dBPath) {
    dbPath = dBPath;
    db = sqlite3.open(dbPath);
  }

  // Search for the provided acronym in the SQLite database and output any records found.
  // Search the SQLite database for [findValue] and return `true` if any records are found.
  bool acronymSearch(String findValue) {
    // fail immediatly of no search valoue if provided
    if (findValue.isEmpty) return false;
    ResultSet searchResult = db.select(
        "select rowid, ifnull(Acronym,'') as acronym, ifnull(Definition,'') as definition, ifnull(Source,'') as source,ifnull(Description,'') as description, ifnull(Changed,'') as changed from ACRONYMS where Acronym like ? collate nocase order by Source;",
        [findValue]);
    // output any results found
    for (final Row row in searchResult) {
      stdout.writeln("""
ID: '${row['rowid']}'
ACRONYM:     '${row['acronym']}' is '${row['definition']}'
SOURCE:      '${row['source']}'
LAST CHANGED: '${row['changed']}'
DESCRIPTION:  ${row['description']}
        '""");
      // stdout.writeln("${row}");
    }
    return true;
  }

  // Obtain the SQLite database version
  String sqliteVersion() {
    ResultSet versionResult = db.select("select sqlite_version();");
    if (versionResult.isEmpty) return "";
    // extract from:  [{sqlite_version(): 3.39.5}]
    return versionResult[0]["sqlite_version()"];
  }

  // Obtain the number of acronyms in the database
  String recordCount() {
    ResultSet countResult = db.select("select count(*) from acronyms;");
    if (countResult.isEmpty) return "";
    // extract from:  [{count(*): 18188}]
    int count = countResult[0]["count(*)"];
    // configure the number formatter to add thousands seperator and no decimal places.
    NumberFormat formatter = NumberFormat.decimalPatternDigits(
      locale: 'en_uk',
      decimalDigits: 0,
    );
    return count.isFinite ? formatter.format(count).toString() : "";
  }

  // Obtain the last acronym entered into the database
  String lastAcronym() {
    ResultSet lastAcronymResult =
        db.select("select acronym from acronyms order by rowid desc limit 1;");
    if (lastAcronymResult.isEmpty) return "";
    // extract from:  [{Acronym: IV}]
    return lastAcronymResult[0]["Acronym"];
  }

  // Close the database connection
  void closeDatabase() {
    db.dispose();
  }
}
