import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

class PDFApi {
  //static const String pdf_URL = 'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf';

  // static Future<Future<File>> loadpdf(Uri url) async {

  //   var response = await http.get(url);

  //   //var dir = await getTemporaryDirectory();
  //   final bytes = response.bodyBytes;
  //   return _storeFile(url,bytes);
  // //   File file = File('${dir.path}/data.pdf');
  // //  await file.writeAsBytes(response.bodyBytes,flush: true);
  // //  return file.path;
  // }
  static Future<File> loadasset(String path) async {
    final data = await rootBundle.load(path);
    final bytes = data.buffer.asUint8List();
//Uri path = Uri.parse(path);
    return _storeFile(path, bytes);
  }
// static Future<File> loadFirebase(Uri url) async {

//   final refpdf = FirebaseStorage.instance.ref().child(url.toString());
//   final bytes = await refpdf.getData();
//   return _storeFile(url, bytes!);
// }
  static Future<File> _storeFile(String url, Uint8List bytes) async {
    final filename = basename(url);

    final dir = await getApplicationDocumentsDirectory();
    print('//////////////////////----------' + dir.path);
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}
