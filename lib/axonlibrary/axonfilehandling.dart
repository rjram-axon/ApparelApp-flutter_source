import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ConfigurationStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/axonconfiguration.txt');
  }

  Future<String> readCounter() async {
    try {
      final file = await _localFile;
      // Read the file
      //file.delete();
      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return "";
    }
  }

  Future<String> deletefile() async {
    final file = await _localFile;
    file.delete();
    return " File Deleted ...!";
  }

  Future<File> writeCounter(String counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(counter);
  }
}
