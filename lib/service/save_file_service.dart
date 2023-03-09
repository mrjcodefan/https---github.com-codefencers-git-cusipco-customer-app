import 'dart:io';
import 'dart:io' as io;
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SaveFileService {
  Future<File> createFolder(String path) async {
    String url = path;
    String fileName = url.substring(url.lastIndexOf("/") + 1);

    var savePath = await getFilePath(fileName);

    if (await io.File(savePath).exists()) {
      print("=======already exists");
      return File(savePath);
    } else {
      print("======= notexists");
      final file = File(savePath);
      final response = await Dio().get(url,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: 0,
          ));

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file;
    }
  }

  Future getFilePath(uniqueFileName) async {
    await Permission.manageExternalStorage.request();

    final status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      Directory root = await getApplicationDocumentsDirectory();

      return root.path + "/" + uniqueFileName;
    } else {
      print("Denyed");
    }
  }
}
