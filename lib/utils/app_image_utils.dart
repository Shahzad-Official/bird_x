import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class AppImageUtils {
  static Future<File> compressImage({required File file, int quality = 50}) async {
    final tempDir = await getTemporaryDirectory();
    // var list = tempDir.listSync();
    // for (final file in list) {
    //   if (file is File) {
    //     try {
    //       await file.delete();
    //     } catch (e) {
    //       debugPrint('Error deleting file ${file.path}: $e');
    //     }
    //   }
    // }
    var va = await FlutterImageCompress.compressWithFile(
      file.path,
      quality: quality,
    );

    File result = await File('${tempDir.path}/${file.path.split("/").last}').create();
    result.writeAsBytesSync(va!);

    return result;
  }

  static Future<double> fileSize(File file) async {
    int fileSizeInBytes = await file.length();
    double fileSizeInKB = fileSizeInBytes / 1024;
    double fileSizeInMB = fileSizeInKB / 1024;
    return fileSizeInMB;
  }
}
