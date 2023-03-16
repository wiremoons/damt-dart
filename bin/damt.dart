//
// Copyright 2023 Simon Rowe (simon@wiremoons.com).
//
// Build exe with:
//   dart compile exe -DDART_BUILD="Built on: $(date)" ./bin/damt.dart -o ./build/damt.exe
// Run with:
//   dart run

import 'dart:io';
import 'package:args/args.dart';
import 'package:dav/dav.dart';

// import local code
// import 'package:damt/yesno.dart';

const String applicationVersion = "0.1.2";

void main(List<String> arguments) async {
  var parser = ArgParser();
  late ArgResults cliResults;

  parser.addFlag('search',
      abbr: 's',
      negatable: false,
      defaultsTo: false,
      help: 'Search database for provided acronym.');
  parser.addFlag('delete',
      abbr: 'd',
      negatable: false,
      defaultsTo: false,
      help: 'Delete an acronym record for provided id.');
  parser.addFlag('version',
      abbr: 'v',
      negatable: false,
      defaultsTo: false,
      help: 'Display the applications version.');
  parser.addFlag('help',
      abbr: 'h',
      negatable: false,
      help: 'Display additional help information.', callback: (help) {
    if (help) {
      stdout.writeln(
          "\nCommand-line application to manage a database of acronyms.\n");
      stdout.writeln("Usage:\n${parser.usage}\n");
      stdout.writeln("Copyright © 2023 Simon Rowe <simon@wiremoons.com>");
      stdout.writeln("https://github.com/wiremoons/damt");
      exit(0);
    }
  });

  try {
    cliResults = parser.parse(arguments);
  } catch (e) {
    stderr.writeln("\nERROR: unknown exception '${e}'");
    stderr.writeln("\nValid options are:\n${parser.usage}");
    exit(1);
  }

  // display application version information if requested on the command line
  if (cliResults.wasParsed('version')) {
    final version = Dav(appVersion: applicationVersion);
    version.display();
    exit(0);
  }

  // search the database for the value provided on the command line
  if (cliResults.wasParsed('search')) {
    stdout.writeln("search - not implemented yet....");
    exit(0);
  }

  // delete the database acronym record provided on the command line
  if (cliResults.wasParsed('delete')) {
    stdout.writeln("delete - not implemented yet....");
    exit(0);
  }

  // managed any unexpected additional arguments
  if (cliResults.rest.isNotEmpty) {
    stderr.writeln(
        "\nERROR: no command matches input: '${cliResults.rest.toString()}'");
    stderr.writeln("\nValid options are:\n${parser.usage}");
    exit(2);
  }

  // no command line options selected so just exit the application
  stderr.writeln("\nValid options are:\n${parser.usage}");
  exit(0);
}
