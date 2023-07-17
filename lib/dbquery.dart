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

// import 'dart:io';
import 'package:sqlite3/sqlite3.dart';

void sqliteVersion() {
  print('Using sqlite3 ${sqlite3.version}');
}
